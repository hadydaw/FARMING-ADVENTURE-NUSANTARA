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

**Bukti build di GitHub Actions** (run 44061366526, commit d26ed37)
- Job "Uji fondasi" dan "Build APK": semua langkah sukses pada percobaan pertama.
- Pre-release `dev-latest` terbit dan dapat diunduh publik: `FarmingAdventureNusantara-dev-1.apk` (±25,3 MiB).
- Isi APK diperiksa: `lib/arm64-v8a/libgodot_android.so`, `AndroidManifest.xml`, tertanda tangan `FAN-DEV` (kunci dev). Verifikasi paket/arm64/apksigner lulus di CI.

**Belum terbukti**
- Layar boot di HP nyata (butuh pemasangan APK dev oleh pemilik).
- Build rilis bertanda tangan kunci rilis (butuh GitHub Secrets, P-002).

**Menunggu pemilik:** P-001…P-004 (lihat `DESIGN_DECISIONS.md` bagian C).

## 2026-11-17 (2) — Keputusan pemilik dicatat

- O-001…O-007 dicatat; GDD, Technical Architecture, Backend Design, Build & Release diperbarui.
- Ditambah: `LICENSE` (All Rights Reserved), `SIGNING_GUIDE.md`, `TESTING_APK.md`.
- CI: build rilis ditolak bila APK bertanda tangan kunci dev; catatan `dev-latest` memuat petunjuk pasang.
- Tidak ada perubahan gameplay/fitur. Uji HP: **belum dilaporkan pemilik**.

## 2026-11-17 (3) — D-013 Sistem Pertarungan dicatat

- D-013 (Kombinasi Semua Sistem, LOCKED) dicatat di Decision Log dan GDD 6.7; catatan implikasi di Technical Architecture §4a.
- Penomoran: entri lama D-013…D-019 (ID lama, tidak berlaku lagi) diubah menjadi O-001…O-007 (isi tetap) agar ID D-013 sesuai instruksi pemilik.
- Tidak ada perubahan kode/gameplay/CI. Implementasi combat belum dimulai.

## 2026-11-17 (4) — D-014 dan konfirmasi keputusan Tahap 1, 2

- D-014 Single-Player Online (LOCKED) dicatat; GDD §7, Backend Design, Technical Architecture, Roadmap diperbarui.
- Visual 3D Stylized dan Progressive World Unlock sudah ada sebagai D-008 dan D-009 (nomor bebas diperiksa: D-001…D-014 terpakai); ditandai dikonfirmasi pemilik sebagai Tahap 1 dan 2. Tidak dibuat ID baru agar tidak ada duplikat.
- Penomoran O-001…O-007 disetujui pemilik; rujukan silang diperiksa otomatis.
- Tidak ada perubahan kode/gameplay. Menunggu keputusan Tahap 5 (Sistem Kehidupan).

## 2026-11-17 (5) — D-015 Sistem Kehidupan dicatat

- D-015 (Kehidupan Lengkap ala Story of Seasons, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.2–6.5 diperbarui (v0.5); Technical Architecture §4b ditambahkan.
- Romansa, pernikahan, keluarga, anak ditandai **belum ditetapkan** di GDD dan Decision Log.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 6 (sistem dungeon).

## 2026-11-17 (6) — D-016 Sistem Dungeon dicatat

- D-016 (Kombinasi Dungeon Tetap dan Acak, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.8 diperbarui (v0.6); Technical Architecture §4c ditambahkan (catatan saja).
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 7.

## 2026-11-17 (7) — D-017 Sistem Adventurer Guild dicatat

- D-017 (Guild Petualang Lengkap, LOCKED) dicatat; ID tersedia, tanpa bentrokan. D-011 diberi catatan dikukuhkan oleh D-017 (isi tidak berubah).
- GDD §6.6 diperbarui (v0.7); Technical Architecture §4d ditambahkan (catatan saja).
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 8.

## 2026-11-17 (8) — D-018 Sistem Perkembangan Karakter dicatat

- D-018 (Kombinasi Semua Sistem, LOCKED) dicatat; ID tersedia, tanpa bentrokan. Hubungan dengan D-009, D-013, D-017 dicatat tanpa mengubah isi keputusan tersebut.
- GDD §6.10 baru (v0.8) dan tautan dari §6.7; Technical Architecture §4e ditambahkan (catatan saja).
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 9.

## 2026-11-17 (9) — D-019 Sistem Companion dan Monster Taming dicatat

- D-019 (Kombinasi Semua Sistem, LOCKED) dicatat; ID tersedia (hanya ada sebagai ID lama pada catatan penomoran ulang, yang diberi penjelasan "tidak berlaku lagi").
- GDD §6.11 baru (v0.9); Technical Architecture §4f ditambahkan (catatan saja). Hubungan dengan D-013, D-015, D-016, D-018 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 10.

## 2026-11-17 (10) — D-020 Sistem Equipment dan Crafting dicatat

- D-020 (Kombinasi Semua Sistem, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.9 diganti menjadi "Equipment dan Crafting" (v0.10); Technical Architecture §4g ditambahkan (catatan saja). Hubungan dengan D-013, D-015, D-016, D-017, D-018 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 11.
