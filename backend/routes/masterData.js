// path: api/routes/masterData.js
import express from 'express';
import {
  getAllDivisi,
  getAllRak,
  getAllKategori,
  getAllRoles
} from '../controllers/masterDataController.js'; // <-- Tambah .js
import { protect, adminOnly } from '../middleware/authMiddleware.js'; // <-- Tambah .js

const router = express.Router();

router.use(protect);
router.use(adminOnly);

router.get('/divisi', getAllDivisi);
router.get('/rak', getAllRak);
router.get('/kategori', getAllKategori);
router.get('/roles', getAllRoles);

export default router; // <-- [PERBAIKAN] Ganti module.exports

