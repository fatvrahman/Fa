# PANDUAN PERUBAHAN ROUTING DAN AUTENTIKASI

## Tanggal: 14 November 2025

## PERUBAHAN YANG DILAKUKAN:

### 1. ROUTING
- ✅ **Root URL (`/`)**: Sekarang redirect ke `/login` (jika belum login) atau `/dashboard` (jika sudah login)
- ✅ **Dashboard**: Dipindahkan dari `/` ke `/dashboard`
- ✅ **Login**: Tetap di `/login`, setelah login redirect ke `/dashboard`

### 2. FILE YANG DIUBAH:

#### Frontend:
1. **`frontend/src/app/page.tsx`** (BARU)
   - Root page yang check auth dan redirect

2. **`frontend/src/app/dashboard/`** (BARU)
   - Copy dari `(home)` folder
   - Berisi page.tsx, fetch.ts, dan _components/

3. **`frontend/src/middleware.ts`**
   - Redirect dari `/` ke `/dashboard` setelah login

4. **`frontend/src/app/login/page.tsx`**
   - Redirect ke `/dashboard` setelah login sukses

5. **`frontend/src/components/Layouts/sidebar/data/index.ts`**
   - Dashboard URL diubah dari `/` ke `/dashboard`

6. **`frontend/src/components/Layouts/sidebar/index.tsx`**
   - Logo link diubah dari `/` ke `/dashboard`

#### Backend:
7. **`backend/controllers/authController.js`**
   - Response login mengirim data lengkap user:
     ```javascript
     {
       id: user.user_id,
       nama_lengkap: user.nama_lengkap,
       username: user.username,
       email: user.email,
       nama_role: user.nama_role,
       role_id: user.role_id,
       divisi_id: user.divisi_id
     }
     ```

#### Database Migration:
8. **`backend/migrations/add_email_to_users.sql`** (BARU)
   - Menambahkan kolom `email` ke table `users`

---

## LANGKAH-LANGKAH YANG HARUS DILAKUKAN:

### STEP 1: Database Migration
**SANGAT PENTING! LAKUKAN INI DULU!**

1. Buka **phpMyAdmin** di browser (http://localhost/phpmyadmin)
2. Login dengan username/password MySQL Anda
3. Pilih database **`ciptastok_db`** di panel kiri
4. Klik tab **"SQL"** di bagian atas
5. Copy-paste query berikut:

```sql
-- Add email column
ALTER TABLE `users` 
ADD COLUMN `email` VARCHAR(255) NULL AFTER `username`;

-- Update existing users with email addresses
UPDATE `users` SET `email` = 'herdi@ciptastok.com' WHERE `user_id` = 1;
UPDATE `users` SET `email` = 'yopi@ciptastok.com' WHERE `user_id` = 2;
UPDATE `users` SET `email` = 'adi@ciptastok.com' WHERE `user_id` = 3;
UPDATE `users` SET `email` = 'joko@ciptastok.com' WHERE `user_id` = 4;

-- Add index for email
CREATE INDEX idx_users_email ON `users` (`email`);
```

6. Klik tombol **"Go"** atau **"Kirim"**
7. Pastikan muncul pesan sukses (hijau)

### STEP 2: Restart Backend Server
1. Stop backend server (Ctrl+C di terminal backend)
2. Start ulang backend:
   ```bash
   cd d:\Semester_5\Project_KP\ciptastok_project\backend
   npm run dev
   ```

### STEP 3: Restart Frontend Server
1. Stop frontend server (Ctrl+C di terminal frontend)
2. Clear cache browser:
   - Tekan `Ctrl+Shift+Delete`
   - Pilih "Cached images and files"
   - Klik "Clear data"
3. Start ulang frontend:
   ```bash
   cd d:\Semester_5\Project_KP\ciptastok_project\frontend
   npm run dev
   ```

### STEP 4: Clear Browser Data
1. Buka **DevTools** (F12 atau Ctrl+Shift+I)
2. Klik tab **"Application"** (Chrome) atau **"Storage"** (Firefox)
3. Klik **"Local Storage"** → `http://localhost:3000`
4. Klik tombol **"Clear All"** atau delete manual:
   - Delete key: `token`
   - Delete key: `user`
5. Tutup dan buka ulang browser

### STEP 5: Testing
1. Buka browser baru (atau incognito/private window)
2. Akses: **`http://localhost:3000/`**
   - ✅ Harus redirect otomatis ke **`http://localhost:3000/login`**

3. Login dengan user Herdi:
   - Username: `herdi`
   - Password: `admin123` (atau password yang sudah di-set)
   
4. Setelah login:
   - ✅ Harus redirect ke **`http://localhost:3000/dashboard`**
   - ✅ Navbar harus menampilkan **"HM"** (inisial Herdi Mismuri) bukan "U"
   - ✅ Dropdown user harus menampilkan:
     - Nama: **Herdi Mismuri**
     - Role: **Admin** (atau role yang sesuai)
     - Email: **herdi@ciptastok.com**

5. Klik logo/Dashboard di sidebar:
   - ✅ Harus tetap di **`http://localhost:3000/dashboard`**

6. Manual akses **`http://localhost:3000/`** saat sudah login:
   - ✅ Harus redirect otomatis ke **`http://localhost:3000/dashboard`**

7. Logout:
   - Klik dropdown user → Log out
   - ✅ Harus redirect ke **`http://localhost:3000/login`**

---

## TROUBLESHOOTING:

### Masalah 1: Masih menampilkan "User" di navbar
**Solusi:**
1. Pastikan migration database sudah dijalankan
2. Clear localStorage dan login ulang
3. Check Network tab di DevTools, pastikan response login berisi:
   ```json
   {
     "token": "...",
     "user": {
       "nama_lengkap": "Herdi Mismuri",
       "email": "herdi@ciptastok.com",
       ...
     }
   }
   ```

### Masalah 2: Tidak bisa login / error 500
**Solusi:**
1. Check console backend, pastikan tidak ada error
2. Pastikan kolom `email` sudah ada di table `users`
3. Jalankan query di phpMyAdmin:
   ```sql
   DESCRIBE users;
   ```
   Pastikan ada kolom `email`

### Masalah 3: Redirect loop (terus redirect bolak-balik)
**Solusi:**
1. Clear localStorage
2. Clear browser cache
3. Restart browser
4. Login ulang

### Masalah 4: Folder (home) masih digunakan
**Solusi:**
1. Stop frontend server
2. Rename folder `(home)` menjadi `(home-backup)`:
   ```powershell
   cd d:\Semester_5\Project_KP\ciptastok_project\frontend\src\app
   Rename-Item -Path "(home)" -NewName "(home-backup)"
   ```
3. Start ulang frontend

---

## VERIFIKASI AKHIR:

Checklist yang harus dipenuhi:
- [ ] Database memiliki kolom `email` di table `users`
- [ ] Semua user memiliki email yang terisi
- [ ] Backend mengirim data lengkap saat login (nama_lengkap, email, dll)
- [ ] Frontend menerima dan menyimpan data user ke localStorage
- [ ] Navbar menampilkan inisial nama (HM untuk Herdi Mismuri)
- [ ] Dropdown menampilkan nama lengkap, role, dan email
- [ ] URL `/` redirect ke `/login` (jika belum login)
- [ ] URL `/` redirect ke `/dashboard` (jika sudah login)
- [ ] Setelah login, redirect ke `/dashboard`
- [ ] Dashboard bisa diakses di `/dashboard`
- [ ] Sidebar dan logo link ke `/dashboard`

---

## CATATAN TAMBAHAN:

1. **Folder `(home)` lama**: Bisa dihapus setelah semua berjalan normal
2. **Migration SQL**: Sudah tersimpan di `backend/migrations/` untuk dokumentasi
3. **Inisial Nama**: Otomatis diambil dari `nama_lengkap` user yang login
4. **Data User**: Semua data diambil dari database, bukan hardcoded

---

## KONTAK:
Jika ada masalah atau error, screenshot dan kirimkan:
1. Error message di console browser (F12)
2. Error message di console backend
3. Screenshot Network tab saat login
4. Screenshot hasil query `SELECT * FROM users;`

---

**PENTING:** Jalankan STEP 1 (Database Migration) terlebih dahulu sebelum testing!
