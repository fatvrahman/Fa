import mysql from 'mysql2/promise';

(async () => {
  const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'ciptastok_db'
  });

  const [rows] = await pool.query(`
    SELECT a.assignment_id, a.batch_id, a.user_id, a.divisi_id, 
           a.status_assignment, b.nama_batch, u.nama_lengkap
    FROM opname_assignment a
    LEFT JOIN opname_batch b ON a.batch_id = b.batch_id
    LEFT JOIN users u ON a.user_id = u.user_id
    ORDER BY a.assignment_id
  `);

  console.log('\n📋 Assignment IDs yang tersedia di database:\n');
  rows.forEach(r => {
    console.log(`  ID: ${r.assignment_id} | Batch: ${r.nama_batch} | User: ${r.nama_lengkap} | Status: ${r.status_assignment}`);
  });
  console.log('\n');

  await pool.end();
})();
