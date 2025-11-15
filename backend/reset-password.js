// Script untuk reset password user
import { pool } from './config/db.js';
import bcrypt from 'bcryptjs';

async function resetPassword() {
  try {
    // Password baru yang akan di-set
    const newPassword = 'admin123';
    const username = 'herdi'; // Admin user
    
    // Hash password baru
    const salt = await bcrypt.genSalt(10);
    const password_hash = await bcrypt.hash(newPassword, salt);
    
    // Update password di database
    const [result] = await pool.query(
      'UPDATE users SET password_hash = ? WHERE username = ?',
      [password_hash, username]
    );
    
    if (result.affectedRows > 0) {
      console.log(`✅ Password berhasil direset untuk user: ${username}`);
      console.log(`📌 Password baru: ${newPassword}`);
      console.log(`\nSilakan login dengan:`);
      console.log(`Username: ${username}`);
      console.log(`Password: ${newPassword}`);
    } else {
      console.log(`❌ User '${username}' tidak ditemukan`);
    }
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

resetPassword();
