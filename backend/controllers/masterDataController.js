// path: api/controllers/masterDataController.js
import { pool } from '../config/db.js'; // <-- Tambah .js

// Helper function untuk mengambil semua data dari tabel
const getAll = (tableName) => async (req, res) => {
  try {
    const [results] = await pool.query(`SELECT * FROM ${tableName} ORDER BY 1`);
    res.json(results);
  } catch (error) {
    console.error(error.message);
    res.status(500).send('Server Error');
  }
};

// --- [PERBAIKAN] Ganti 'exports.' menjadi 'export const' ---
export const getAllDivisi = getAll('divisi');
export const getAllRak = getAll('rak');
export const getAllKategori = getAll('kategori');
export const getAllRoles = getAll('roles');

