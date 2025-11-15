import mysql from 'mysql2/promise';

(async () => {
  const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'ciptastok_db'
  });

  const [rows] = await pool.query('DESCRIBE produk');
  
  console.log('\n📋 Kolom di tabel produk:\n');
  rows.forEach(c => console.log(`  ${c.Field} (${c.Type})`));

  await pool.end();
})();
