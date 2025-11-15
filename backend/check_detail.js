import mysql from 'mysql2/promise';

(async () => {
  const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'ciptastok_db'
  });

  const [rows] = await pool.query(`
    SELECT d.pcode, d.nama_barang,
           d.sistem_karton, d.sistem_tengah, d.sistem_pieces,
           d.fisik_karton, d.fisik_tengah, d.fisik_pieces
    FROM opname_details_wh01 d
    WHERE d.assignment_id = 5
    LIMIT 5
  `);

  console.log('\n📦 Data Opname Details (Assignment 5):\n');
  rows.forEach(r => {
    console.log(`PCode: ${r.pcode} | ${r.nama_barang}`);
    console.log(`  Sistem: ${r.sistem_karton} karton, ${r.sistem_tengah} tengah, ${r.sistem_pieces} pcs`);
    console.log(`  Fisik:  ${r.fisik_karton} karton, ${r.fisik_tengah} tengah, ${r.fisik_pieces} pcs`);
    console.log('');
  });

  await pool.end();
})();
