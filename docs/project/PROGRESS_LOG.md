# Progress Log

Format: tanggal · apa yang selesai · **bukti** · kendala · langkah berikut. Hal yang belum terbukti ditulis "belum terbukti".

## 2026-11-17 — Fase 0: Fondasi proyek

**Selesai**
- Repo `hadydaw/FARMING-ADVENTURE-NUSANTARA` (sudah dibuat pemilik, berisi README awal) diisi dari nol: struktur direktori, dokumentasi lengkap, proyek Godot, pipeline build.
- Keputusan teknis T-001…T-009 dicatat; keputusan pemilik D-001…D-012 dicatat.

**Bukti (diuji di lingkungan kerja)**
- Godot 4.7.2 headless: `--import` sukses (translasi id/en terbentuk).
- `tools/ci/smoke_test.gd`: LULUS (simpan/muat, revision, pemulihan file rusak, backend default, terjemahan, scene utama dapat dimuat).
- Scene utama berjalan 90 frame headless tanpa error.
- `export_presets.cfg` terbaca Godot (preset "Android" dikenali; error yang muncul hanya karena SDK/template tidak ada di lingkungan ini, bukan karena preset).
- Skrip `prepare_version.sh` diuji mode dev dan rilis (termasuk penolakan tag tidak cocok); semua skrip lolos `bash -n`; workflow lolos parse YAML.
- Nama berkas export template Android diverifikasi dari isi arsip rilis Godot 4.7.2.

**Belum terbukti**
- Build APK penuh di GitHub Actions (SDK Android tidak bisa diunduh dari lingkungan kerja ini). Dibuktikan setelah push pertama; hasil dicatat di bawah.
- Layar boot di HP nyata.

**Menunggu pemilik:** P-001…P-004 (lihat `DESIGN_DECISIONS.md` bagian C).
