// path: api/controllers/productController.js
import { pool } from '../config/db.js'; // <-- Tambah .js
import xlsx from 'xlsx';
import fs from 'fs';

// Helper untuk parsing Tanggal Excel
const parseExcelDate = (excelDate) => {
  if (!excelDate) return null;
  let date;
  if (typeof excelDate === 'number') {
    date = new Date(Math.round((excelDate - 25569) * 86400 * 1000));
  } else {
    date = new Date(excelDate);
  }
  if (isNaN(date.getTime())) {
    return null;
  }
  return date.toISOString().split('T')[0]; // Format YYYY-MM-DD
};

// Helper untuk membaca file dan data master (Divisi, Rak)
const readExcelData = async (filePath, connection) => {
  const workbook = xlsx.readFile(filePath);
  const sheetName = workbook.SheetNames[0];
  const sheet = workbook.Sheets[sheetName];
  const data = xlsx.utils.sheet_to_json(sheet, { header: 1 });

  if (data.length <= 1) throw new Error('File Excel kosong.');

  const headers = data[0].map(h => h.toString().toLowerCase().trim());
  
  const [divisiRows] = await connection.query('SELECT divisi_id, kode_divisi FROM divisi');
  const divisiMap = new Map(divisiRows.map(d => [String(d.kode_divisi).toUpperCase(), d.divisi_id]));

  const [rakRows] = await connection.query('SELECT rak_id, nomor_rak FROM rak');
  const rakMap = new Map(rakRows.map(r => [String(r.nomor_rak).toUpperCase(), r.rak_id]));

  return { data, headers, divisiMap, rakMap };
};

// --- [PERBAIKAN] Ganti 'exports.' menjadi 'export const' ---
export const createProduct = async (req, res) => {
  const { 
    pcode, nama_barang, barcode, divisi_id, warehouse,
    sistem_karton, sistem_tengah, sistem_pieces, expired_date, rak_id,
    sistem_total_pcs_bs, sistem_total_pcs_promo
  } = req.body;

  if (!pcode || !nama_barang || !divisi_id || !warehouse) {
    return res.status(400).json({ msg: 'PCode, Nama Barang, Divisi ID, dan Warehouse wajib diisi.' });
  }

  const connection = await pool.getConnection();
  
  try {
    await connection.beginTransaction();

    const [existing] = await connection.query('SELECT pcode FROM produk WHERE pcode = ?', [pcode]);
    if (existing.length > 0) {
      throw new Error('PCode sudah ada, tidak boleh duplikat.');
    }

    const [result] = await connection.query(
      `INSERT INTO produk (pcode, nama_barang, barcode, divisi_id) VALUES (?, ?, ?, ?)`,
      [pcode, nama_barang, barcode || null, divisi_id]
    );
    
    const newProductId = result.insertId;

    // Buat entry stok HANYA untuk warehouse yang dipilih
    if (warehouse === 'wh01') {
      await connection.query(
        `INSERT INTO stok_wh01 (produk_id, sistem_karton, sistem_tengah, sistem_pieces, expired_date, rak_id, is_active) 
         VALUES (?, ?, ?, ?, ?, ?, 1)`,
        [newProductId, sistem_karton || 0, sistem_tengah || 0, sistem_pieces || 0, expired_date || null, rak_id || null]
      );
      // Buat entry is_active=0 untuk warehouse lain
      await connection.query(
        'INSERT INTO stok_wh02 (produk_id, sistem_total_pcs, is_active) VALUES (?, 0, 0)', 
        [newProductId]
      );
      await connection.query(
        'INSERT INTO stok_wh03 (produk_id, sistem_total_pcs, is_active) VALUES (?, 0, 0)', 
        [newProductId]
      );
    } else if (warehouse === 'wh02') {
      await connection.query(
        'INSERT INTO stok_wh02 (produk_id, sistem_total_pcs, is_active) VALUES (?, ?, 1)', 
        [newProductId, sistem_total_pcs_bs || 0]
      );
      // Buat entry is_active=0 untuk warehouse lain
      await connection.query(
        `INSERT INTO stok_wh01 (produk_id, sistem_karton, sistem_tengah, sistem_pieces, expired_date, rak_id, is_active) 
         VALUES (?, 0, 0, 0, NULL, NULL, 0)`,
        [newProductId]
      );
      await connection.query(
        'INSERT INTO stok_wh03 (produk_id, sistem_total_pcs, is_active) VALUES (?, 0, 0)', 
        [newProductId]
      );
    } else if (warehouse === 'wh03') {
      await connection.query(
        'INSERT INTO stok_wh03 (produk_id, sistem_total_pcs, is_active) VALUES (?, ?, 1)', 
        [newProductId, sistem_total_pcs_promo || 0]
      );
      // Buat entry is_active=0 untuk warehouse lain
      await connection.query(
        `INSERT INTO stok_wh01 (produk_id, sistem_karton, sistem_tengah, sistem_pieces, expired_date, rak_id, is_active) 
         VALUES (?, 0, 0, 0, NULL, NULL, 0)`,
        [newProductId]
      );
      await connection.query(
        'INSERT INTO stok_wh02 (produk_id, sistem_total_pcs, is_active) VALUES (?, 0, 0)', 
        [newProductId]
      );
    }

    await connection.commit();
    res.status(201).json({ msg: 'Produk master berhasil dibuat', produkId: newProductId });

  } catch (error) {
    await connection.rollback();
    console.error(error.message);
    res.status(500).send(error.message || 'Server Error');
  } finally {
    connection.release();
  }
};

export const getAllProducts = async (req, res) => {
  try {
    const [products] = await pool.query(
      `SELECT 
         p.produk_id, 
         p.pcode, 
         p.nama_barang, 
         p.barcode,
         d.divisi_id,
         d.nama_divisi, 
         d.kode_divisi as nama_divisi_sales, 
         s01.sistem_karton, 
         s01.sistem_tengah, 
         s01.sistem_pieces, 
         s01.expired_date, 
         r.nomor_rak,
         s02.sistem_total_pcs as sistem_total_pcs_bs,
         s03.sistem_total_pcs as sistem_total_pcs_promo,
         s01.is_active as is_active_wh01, 
         s02.is_active as is_active_wh02, 
         s03.is_active as is_active_wh03  
       FROM produk p
       LEFT JOIN divisi d ON p.divisi_id = d.divisi_id
       LEFT JOIN stok_wh01 s01 ON p.produk_id = s01.produk_id
       LEFT JOIN rak r ON s01.rak_id = r.rak_id
       LEFT JOIN stok_wh02 s02 ON p.produk_id = s02.produk_id
       LEFT JOIN stok_wh03 s03 ON p.produk_id = s03.produk_id
       ORDER BY p.nama_barang ASC`
    );
    
    res.json(products);

  } catch (error) {
    console.error(error.message);
    res.status(500).send('Server Error');
  }
};

export const getSingleProduct = async (req, res) => {
  const { id } = req.params;
  try {
    const [products] = await pool.query(
      `SELECT 
         p.produk_id, 
         p.pcode, 
         p.nama_barang, 
         p.barcode,
         d.divisi_id,
         d.nama_divisi, 
         d.kode_divisi as nama_divisi_sales, 
         s01.sistem_karton, 
         s01.sistem_tengah, 
         s01.sistem_pieces, 
         s01.expired_date, 
         s01.rak_id,
         s02.sistem_total_pcs as sistem_total_pcs_bs,
         s03.sistem_total_pcs as sistem_total_pcs_promo,
         s01.is_active as is_active_wh01, 
         s02.is_active as is_active_wh02, 
         s03.is_active as is_active_wh03  
       FROM produk p
       LEFT JOIN divisi d ON p.divisi_id = d.divisi_id
       LEFT JOIN stok_wh01 s01 ON p.produk_id = s01.produk_id
       LEFT JOIN rak r ON s01.rak_id = r.rak_id
       LEFT JOIN stok_wh02 s02 ON p.produk_id = s02.produk_id
       LEFT JOIN stok_wh03 s03 ON p.produk_id = s03.produk_id
       WHERE p.produk_id = ?`,
      [id]
    );

    if (products.length === 0) {
      return res.status(404).json({ msg: 'Produk tidak ditemukan' });
    }
    
    res.json(products[0]);

  } catch (error) {
    console.error(error.message);
    res.status(500).send('Server Error');
  }
};


export const updateProduct = async (req, res) => {
  const { id } = req.params;
  const { 
    nama_barang, barcode, divisi_id,
    sistem_karton, sistem_tengah, sistem_pieces, expired_date, rak_id,
    sistem_total_pcs_bs, sistem_total_pcs_promo
  } = req.body;

  if (!nama_barang || !divisi_id) {
    return res.status(400).json({ msg: 'Nama Barang dan Divisi ID wajib diisi.' });
  }

  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    // 1. Update master produk
    await connection.query(
      `UPDATE produk SET 
        nama_barang = ?, barcode = ?, divisi_id = ?
       WHERE produk_id = ?`,
      [nama_barang, barcode || null, divisi_id, id]
    );

    // 2. Update stok WH01 (UPSERT)
    await connection.query(
      `INSERT INTO stok_wh01 (produk_id, sistem_karton, sistem_tengah, sistem_pieces, expired_date, rak_id) 
       VALUES (?, ?, ?, ?, ?, ?) 
       ON DUPLICATE KEY UPDATE 
         sistem_karton = VALUES(sistem_karton), 
         sistem_tengah = VALUES(sistem_tengah), 
         sistem_pieces = VALUES(sistem_pieces), 
         expired_date = VALUES(expired_date), 
         rak_id = VALUES(rak_id)`,
      [id, sistem_karton || 0, sistem_tengah || 0, sistem_pieces || 0, expired_date || null, rak_id || null]
    );

    // 3. Update stok WH02 (UPSERT)
    await connection.query(
      `INSERT INTO stok_wh02 (produk_id, sistem_total_pcs) VALUES (?, ?) 
       ON DUPLICATE KEY UPDATE sistem_total_pcs = VALUES(sistem_total_pcs)`,
      [id, sistem_total_pcs_bs || 0]
    );

    // 4. Update stok WH03 (UPSERT)
     await connection.query(
      `INSERT INTO stok_wh03 (produk_id, sistem_total_pcs) VALUES (?, ?) 
       ON DUPLICATE KEY UPDATE sistem_total_pcs = VALUES(sistem_total_pcs)`,
      [id, sistem_total_pcs_promo || 0]
    );

    await connection.commit();
    res.json({ msg: 'Produk berhasil diupdate' });

  } catch (error) {
    await connection.rollback();
    console.error(error.message);
    res.status(500).send('Server Error');
  } finally {
    connection.release();
  }
};

export const deleteProduct = async (req, res) => {
  const { id } = req.params;
  const connection = await pool.getConnection();
  
  try {
    await connection.beginTransaction();

    // Cek apakah produk ada di opname details
    const [opnameCheck] = await connection.query(
      `SELECT COUNT(*) as count FROM (
        SELECT produk_id FROM opname_details_wh01 WHERE produk_id = ?
        UNION ALL
        SELECT produk_id FROM opname_details_wh02 WHERE produk_id = ?
        UNION ALL
        SELECT produk_id FROM opname_details_wh03 WHERE produk_id = ?
      ) as combined`,
      [id, id, id]
    );

    if (opnameCheck[0].count > 0) {
      return res.status(400).json({ 
        msg: 'Produk tidak bisa dihapus karena sudah ada di riwayat opname.' 
      });
    }

    // Hapus stok terlebih dahulu (manual cascade)
    await connection.query('DELETE FROM stok_wh01 WHERE produk_id = ?', [id]);
    await connection.query('DELETE FROM stok_wh02 WHERE produk_id = ?', [id]);
    await connection.query('DELETE FROM stok_wh03 WHERE produk_id = ?', [id]);

    // Baru hapus produk
    const [result] = await connection.query('DELETE FROM produk WHERE produk_id = ?', [id]);

    if (result.affectedRows === 0) {
      await connection.rollback();
      return res.status(404).json({ msg: 'Produk tidak ditemukan' });
    }

    await connection.commit();
    res.json({ msg: 'Produk berhasil dihapus (termasuk semua data stoknya)' });

  } catch (error) {
    await connection.rollback();
    console.error('Delete product error:', error);
    
    if (error.code === 'ER_ROW_IS_REFERENCED_2') {
      return res.status(400).json({ 
        msg: 'Produk tidak bisa dihapus karena masih digunakan di data lain.' 
      });
    }
    
    res.status(500).json({ msg: 'Server Error: ' + error.message });
  } finally {
    connection.release();
  }
};

export const uploadProductsWH01 = async (req, res) => {
  if (!req.file) return res.status(400).json({ msg: 'Tidak ada file.' });

  const filePath = req.file.path;
  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();
    const { data, headers, divisiMap, rakMap } = await readExcelData(filePath, connection);

    const headerMap = {
      'pcode': 'pcode',
      'nama barang': 'nama_barang',
      'kode divisi': 'kode_divisi',
      'karton': 'sistem_karton',
      'tengah': 'sistem_tengah',
      'pieces': 'sistem_pieces',
      'expired date': 'expired_date',
      'barcode': 'barcode',
      'rak': 'nomor_rak'
    };
    
    // --- [LOGIKA OTOMATIS] Langkah A: Non-aktifkan semua stok WH01 ---
    await connection.query('UPDATE stok_wh01 SET is_active = 0');
    
    let processedCount = 0;
    for (let i = 1; i < data.length; i++) {
      const rowData = data[i];
      if (rowData.length === 0) continue;

      let row = {};
      headers.forEach((header, index) => {
        if (headerMap[header]) row[headerMap[header]] = rowData[index];
      });

      if (!row.pcode || !row.nama_barang || !row.kode_divisi) {
        console.warn(`Melewati baris ${i+1}: pcode, nama barang, atau kode divisi kosong.`);
        continue;
      }

      const divisiId = divisiMap.get(String(row.kode_divisi).toUpperCase());
      if (!divisiId) {
        console.warn(`Melewati baris ${i+1}: Kode Divisi "${row.kode_divisi}" tidak ditemukan.`);
        continue;
      }
      
      const rakId = row.nomor_rak ? rakMap.get(String(row.nomor_rak).toUpperCase()) : null;

      // 1. Buat/Update master produk
      await connection.query(
        `INSERT INTO produk (pcode, nama_barang, divisi_id, barcode) 
         VALUES (?, ?, ?, ?) 
         ON DUPLICATE KEY UPDATE 
           nama_barang = VALUES(nama_barang), 
           divisi_id = VALUES(divisi_id), 
           barcode = VALUES(barcode)`,
        [row.pcode, row.nama_barang, divisiId, row.barcode || null]
      );

      // 2. Dapatkan produk_id
      const [product] = await connection.query('SELECT produk_id FROM produk WHERE pcode = ?', [row.pcode]);
      const produk_id = product[0].produk_id;

      // 3. Buat/Update stok WH01
      await connection.query(
        `INSERT INTO stok_wh01 (
          produk_id, sistem_karton, sistem_tengah, sistem_pieces, expired_date, rak_id, is_active
         ) VALUES (?, ?, ?, ?, ?, ?, 1) 
         ON DUPLICATE KEY UPDATE 
           sistem_karton = VALUES(sistem_karton), 
           sistem_tengah = VALUES(sistem_tengah), 
           sistem_pieces = VALUES(sistem_pieces), 
           expired_date = VALUES(expired_date), 
           rak_id = VALUES(rak_id),
           is_active = 1`,
        [
          produk_id,
          parseInt(row.sistem_karton) || 0,
          parseInt(row.sistem_tengah) || 0,
          parseInt(row.sistem_pieces) || 0,
          parseExcelDate(row.expired_date),
          rakId
        ]
      );
      processedCount++;
    }

    await connection.commit();
    res.json({ msg: `Upload WH01 sukses! ${processedCount} baris produk berhasil diproses.` });

  } catch (error) {
    await connection.rollback();
    console.error('Error saat upload WH01:', error);
    res.status(500).json({ msg: error.message || 'Server Error.' });
  } finally {
    connection.release();
    fs.unlink(filePath, (err) => { if (err) console.error("Gagal hapus file temp:", err); });
  }
};


export const uploadProductsWH02 = async (req, res) => {
  if (!req.file) return res.status(400).json({ msg: 'Tidak ada file.' });

  const filePath = req.file.path;
  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();
    const { data, headers, divisiMap } = await readExcelData(filePath, connection);

    // Header Wajib WH02
    const headerMap = {
      'pcode': 'pcode',
      'nama barang': 'nama_barang',
      'kode divisi': 'kode_divisi',
      'total pcs': 'sistem_total_pcs_bs', 
      'barcode': 'barcode'
    };
    
    // --- [LOGIKA OTOMATIS] Langkah A: Non-aktifkan semua stok WH02 ---
    await connection.query('UPDATE stok_wh02 SET is_active = 0');
    
    let processedCount = 0;
    for (let i = 1; i < data.length; i++) {
      const rowData = data[i];
      if (rowData.length === 0) continue;

      let row = {};
      headers.forEach((header, index) => {
        if (headerMap[header]) row[headerMap[header]] = rowData[index];
      });

      if (!row.pcode || !row.nama_barang || !row.kode_divisi) {
        console.warn(`Melewati baris ${i+1}: pcode, nama barang, atau kode divisi kosong.`);
        continue;
      }

      const divisiId = divisiMap.get(String(row.kode_divisi).toUpperCase());
      if (!divisiId) {
        console.warn(`Melewati baris ${i+1}: Kode Divisi "${row.kode_divisi}" tidak ditemukan.`);
        continue;
      }

      // 1. Buat/Update master produk
      await connection.query(
        `INSERT INTO produk (pcode, nama_barang, divisi_id, barcode) 
         VALUES (?, ?, ?, ?) 
         ON DUPLICATE KEY UPDATE 
           nama_barang = VALUES(nama_barang), 
           divisi_id = VALUES(divisi_id), 
           barcode = VALUES(barcode)`,
        [row.pcode, row.nama_barang, divisiId, row.barcode || null]
      );

      // 2. Dapatkan produk_id
      const [product] = await connection.query('SELECT produk_id FROM produk WHERE pcode = ?', [row.pcode]);
      const produk_id = product[0].produk_id;

      // 3. Buat/Update stok WH02
      await connection.query(
        `INSERT INTO stok_wh02 (produk_id, sistem_total_pcs, is_active) VALUES (?, ?, 1) 
         ON DUPLICATE KEY UPDATE 
           sistem_total_pcs = VALUES(sistem_total_pcs),
           is_active = 1`,
        [
          produk_id,
          parseInt(row.sistem_total_pcs_bs) || 0
        ]
      );
      processedCount++;
    }

    await connection.commit();
    res.json({ msg: `Upload WH02 sukses! ${processedCount} baris produk berhasil diproses.` });

  } catch (error) {
    await connection.rollback();
    console.error('Error saat upload WH02:', error);
    res.status(500).json({ msg: error.message || 'Server Error.' });
  } finally {
    connection.release();
    fs.unlink(filePath, (err) => { if (err) console.error("Gagal hapus file temp:", err); });
  }
};

export const uploadProductsWH03 = async (req, res) => {
  if (!req.file) return res.status(400).json({ msg: 'Tidak ada file.' });

  const filePath = req.file.path;
  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();
    const { data, headers, divisiMap } = await readExcelData(filePath, connection);

    // Header Wajib WH03
    const headerMap = {
      'pcode': 'pcode',
      'nama barang': 'nama_barang',
      'kode divisi': 'kode_divisi',
      'total pcs': 'sistem_total_pcs_promo', 
      'barcode': 'barcode'
    };
    
    // --- [LOGIKA OTOMATIS] Langkah A: Non-aktifkan semua stok WH03 ---
    await connection.query('UPDATE stok_wh03 SET is_active = 0');
    
    let processedCount = 0;
    for (let i = 1; i < data.length; i++) {
      const rowData = data[i];
      if (rowData.length === 0) continue;

      let row = {};
      headers.forEach((header, index) => {
        if (headerMap[header]) row[headerMap[header]] = rowData[index];
      });

      if (!row.pcode || !row.nama_barang || !row.kode_divisi) {
        console.warn(`Melewati baris ${i+1}: pcode, nama barang, atau kode divisi kosong.`);
        continue;
      }

      const divisiId = divisiMap.get(String(row.kode_divisi).toUpperCase());
      if (!divisiId) {
        console.warn(`Melewati baris ${i+1}: Kode Divisi "${row.kode_divisi}" tidak ditemukan.`);
        continue;
      }

      // 1. Buat/Update master produk
      await connection.query(
        `INSERT INTO produk (pcode, nama_barang, divisi_id, barcode) 
         VALUES (?, ?, ?, ?) 
         ON DUPLICATE KEY UPDATE 
           nama_barang = VALUES(nama_barang), 
           divisi_id = VALUES(divisi_id), 
           barcode = VALUES(barcode)`,
        [row.pcode, row.nama_barang, divisiId, row.barcode || null]
      );

      // 2. Dapatkan produk_id
      const [product] = await connection.query('SELECT produk_id FROM produk WHERE pcode = ?', [row.pcode]);
      const produk_id = product[0].produk_id;

      // 3. Buat/Update stok WH03
      await connection.query(
        `INSERT INTO stok_wh03 (produk_id, sistem_total_pcs, is_active) VALUES (?, ?, 1) 
         ON DUPLICATE KEY UPDATE 
           sistem_total_pcs = VALUES(sistem_total_pcs),
           is_active = 1`,
        [
          produk_id,
          parseInt(row.sistem_total_pcs_promo) || 0
        ]
      );
      processedCount++;
    }

    await connection.commit();
    res.json({ msg: `Upload WH03 sukses! ${processedCount} baris produk berhasil diproses.` });

  } catch (error) {
    await connection.rollback();
    console.error('Error saat upload WH03:', error);
    res.status(500).json({ msg: error.message || 'Server Error.' });
  } finally {
    connection.release();
    fs.unlink(filePath, (err) => { if (err) console.error("Gagal hapus file temp:", err); });
  }
};

