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

## 2026-11-17 (11) — D-021 Sistem Ekonomi dan Perdagangan dicatat

- D-021 (Kombinasi Semua Sistem, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.12 baru (v0.11); Technical Architecture §4h ditambahkan (catatan saja). Hubungan dengan D-009, D-013, D-015, D-016, D-019, D-020 dicatat tanpa mengubah isinya.
- Catatan konsistensi dengan D-014: ekonomi dinamis dicatat sebagai ekonomi pribadi; lokasi perhitungan harga dan kemungkinan ekonomi bersama ditandai belum ditetapkan.
- Pemeriksaan otomatis: ID keputusan tanpa duplikat; semua rujukan ID di dokumen menunjuk entri yang ada.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 12.

## 2026-11-17 (12) — D-022 Sistem NPC dan Kehidupan Sosial dicatat

- D-022 (Kombinasi Semua Sistem, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.5 diganti menjadi "NPC dan Kehidupan Sosial" (v0.12); Technical Architecture §4i ditambahkan (catatan saja; fokus skala NPC besar). Hubungan dengan D-009, D-014, D-015, D-017, D-021 dicatat tanpa mengubah isinya.
- Batasan D-015 ditegaskan ulang: romansa, pernikahan, keluarga, anak tetap belum ditetapkan (D-022 hanya pertemanan dan kepercayaan).
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 13.

## 2026-11-17 (13) — D-023 Sistem Pertanian dan Pertumbuhan Tanaman dicatat

- D-023 (Kombinasi Semua Sistem, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.13 baru (v0.13) dan tautan dari §6.2; Technical Architecture §4j ditambahkan (catatan saja; fokus kemudahan perluasan tanaman dan wilayah). Hubungan dengan D-009, D-015, D-019, D-020, D-021, D-022 dicatat tanpa mengubah isinya.
- Ditandai terbuka: arti "tanaman spiritual" belum didefinisikan; batas "alkimia" vs profesi Alchemist (D-020).
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 14.

## 2026-11-17 (14) — D-024 Sistem Peternakan dan Hewan dicatat

- D-024 (Kombinasi Semua Sistem, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.14 baru (v0.14) dan tautan dari §6.2; Technical Architecture §4k ditambahkan (catatan saja). Hubungan dengan D-015, D-016, D-019, D-020, D-021, D-023 dicatat tanpa mengubah isinya.
- Ditandai terbuka: arti "hewan spiritual"; batas hewan ternak vs pet/companion (D-019). "Perkembangbiakan" dicatat berlaku untuk hewan saja; keluarga/anak pemain tetap belum ditetapkan.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 15.

## 2026-11-17 (15) — D-025 Sistem Memancing dan Kehidupan Perairan dicatat

- D-025 (Kombinasi Semua Sistem, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.3 diarahkan ke §6.15 baru (v0.15); Technical Architecture §4l ditambahkan (catatan saja). Hubungan dengan D-009, D-013, D-015, D-017, D-019, D-020, D-021, D-023 dicatat tanpa mengubah isinya.
- Ditandai terbuka: arti "ikan spiritual" dan "makhluk air fantasi"; apakah makhluk air dapat menjadi companion/monster atau musuh.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 16.

## 2026-11-17 (16) — D-026 Sistem Memasak dan Alkimia dicatat

- D-026 (Kombinasi Semua Sistem, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.3 diarahkan ke §6.16 baru (v0.16); Technical Architecture §4m ditambahkan (catatan saja). Hubungan dengan D-013, D-015, D-016, D-018, D-020, D-021, D-023, D-024, D-025 dicatat tanpa mengubah isinya.
- Ditandai terbuka: batas dengan profesi Alchemist/crafting equipment (D-020); arti "tanaman spiritual"; keterampilan pemain vs profesi NPC.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 17.

## 2026-11-17 (17) — D-027 Sistem Rumah, Lahan, dan Bangunan dicatat

- D-027 (Kombinasi Semua Sistem, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.4 diarahkan ke §6.17 baru (v0.17); Technical Architecture §4n ditambahkan (catatan saja). Hubungan dengan D-009, D-015, D-017, D-020, D-021, D-023, D-024, D-026 dicatat tanpa mengubah isinya.
- Ditandai terbuka: arti "bangunan spiritual" dan "paviliun"; metode penataan lahan (grid/bebas). Romansa, pernikahan, keluarga, anak tetap belum ditetapkan.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 18.

## 2026-11-17 (18) — D-028 Sistem Eksplorasi Dunia dan Perjalanan dicatat

- D-028 (Kombinasi Semua Sistem, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.18 baru (v0.18) dan tautan dari §6.1; Technical Architecture §4o ditambahkan (catatan saja; fokus dunia luas di HP dan kemudahan menambah wilayah). Hubungan dengan D-009, D-013, D-014, D-016, D-017, D-018, D-019, D-020, D-023, D-025 dicatat tanpa mengubah isinya.
- Ditandai terbuka: arti "wilayah spiritual"; jenis transportasi khusus dan hubungannya dengan companion; aturan fast travel; apakah perjalanan memakan waktu kalender.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 19.

## 2026-11-17 (19) — D-029 Sistem Event Dunia dan Kejadian Dinamis dicatat

- D-029 (Kombinasi Semua Sistem, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.19 baru (v0.19); Technical Architecture §4p ditambahkan (catatan saja; fokus determinisme event dan anti save-scumming untuk single-player online). Hubungan dengan D-009, D-013, D-014, D-015, D-016, D-017, D-020, D-021, D-022, D-023, D-024, D-025, D-027, D-028 dicatat tanpa mengubah isinya.
- Ditandai terbuka: arti "fenomena spiritual"; event saat offline; aturan waktu perangkat/muat ulang save; tingkat konsekuensi. World boss/invasi dicatat sebagai pengalaman pemain tunggal (konsisten D-014).
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 20.

## 2026-11-17 (20) — D-030 Sistem Musim, Cuaca, dan Lingkungan dicatat

- D-030 (Kombinasi Semua Sistem, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.20 baru (v0.20); daftar belum ditetapkan di §6.2 diperbarui (jumlah musim = empat). Technical Architecture §4q ditambahkan (catatan saja; fokus satu sumber kebenaran lingkungan, cuaca deterministik dari seed + tanggal, sinkron dengan cloud save). Hubungan dengan D-009, D-013, D-014, D-015, D-021 sampai D-025, D-027 sampai D-029 dicatat tanpa mengubah isinya.
- Ditandai terbuka: arti "fenomena spiritual"; panjang musim; daftar cuaca dan iklim; aturan waktu perangkat.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 21.

## 2026-11-17 (21) — D-031 Sistem UI, HUD, dan Antarmuka Pemain dicatat

- D-031 (Kombinasi Semua Sistem, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.21 baru dan catatan kontrol di §4 diperbarui (v0.21); Technical Architecture §4r ditambahkan (catatan saja; fokus pemisahan UI-logika, konteks UI adaptif, kontrol sebagai Input Action, tata letak tombol yang dapat disesuaikan). Hubungan dengan D-004, D-007, D-008, D-013 sampai D-030 dicatat tanpa mengubah isinya.
- Layar boot uji fondasi tidak diubah dan bukan UI game.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 22.

## 2026-11-17 (22) — D-032 Sistem Audio, Musik, dan Efek Suara dicatat

- D-032 (Kombinasi Semua Sistem, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.22 baru (v0.22); Technical Architecture §4s ditambahkan (v0.22; catatan saja: bus musik/SFX/ambience terpisah, musik adaptif berbasis konteks, ambience dari cuaca/musim/wilayah, SFX data-driven). Hubungan dengan D-009, D-013, D-016, D-019, D-022 sampai D-031 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 23.

## 2026-11-17 (23) — D-033 Sistem Kamera dan Kontrol Karakter dicatat

- D-033 (Kamera Adaptif, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.23 baru dan bagian kamera di §4 diperbarui (v0.23); Technical Architecture §4t ditambahkan dan §7 diberi rujukan (v0.23; catatan saja: camera rig berbasis profil per konteks, transisi halus, zoom/rotasi terbatas sebagai pengaturan pemain, batas performa GL Compatibility). Hubungan dengan D-004, D-008, D-013, D-016, D-023, D-027 sampai D-032 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 24.

## 2026-11-17 (24) — D-034 Metode Kontrol Karakter Android dicatat

- D-034 (Kontrol Hybrid, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.24 baru dan bagian kontrol di §4 diperbarui (v0.24); Technical Architecture §4u ditambahkan dan §7 diperbarui (v0.24; catatan saja: lapisan input terpadu, kepemilikan sentuhan multi-touch, pembatalan tap-to-move oleh joystick, tombol kontekstual per konteks, integrasi kamera). Hubungan dengan D-004, D-013, D-023, D-028, D-031, D-033 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 25.

## 2026-11-17 (25) — D-035 Sistem Interaksi dengan Dunia dan Objek dicatat

- D-035 (Interaksi Hybrid, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.25 baru (v0.25); Technical Architecture §4v ditambahkan (v0.25; catatan saja: komponen Interactable, pemilihan target dan skor, prioritas input, validasi aksi, konfirmasi aksi penting). Hubungan dengan D-007, D-013, D-016, D-022 sampai D-024, D-027, D-028, D-031 sampai D-034 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 26.

## 2026-11-17 (26) — D-036 Sistem Inventory dan Pengelolaan Item dicatat

- D-036 (Inventory Hybrid Lengkap, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.26 baru (v0.26); Technical Architecture §4w ditambahkan (v0.26; catatan saja: definisi item dari data, wadah slot yang dipakai ulang, kapasitas sebagai strategi yang dapat diganti, operasi atomik dengan hasil sisa, penyimpanan di payload save). Hubungan dengan D-007, D-013, D-016, D-018, D-020, D-021, D-023 sampai D-027, D-031, D-034, D-035 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 27.

## 2026-11-17 (27) — D-037 Sistem Quest dan Misi dicatat

- D-037 (Quest Hybrid Lengkap, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.27 baru (v0.27); Technical Architecture §4x ditambahkan (v0.27; catatan saja: quest dari data, mesin status, objektif berbasis event bus, kondisi/cabang bersama sistem lain, quest harian deterministik, validasi anti-buntu, penyimpanan dan sinkronisasi cloud). Hubungan dengan D-007, D-009, D-013 sampai D-018, D-021 sampai D-023, D-028 sampai D-031, D-036 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 28.

## 2026-11-17 (28) — D-038 Sistem Dialog dan Percakapan NPC dicatat

- D-038 (Dialog Hybrid Lengkap, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.28 baru (v0.28); Technical Architecture §4y ditambahkan (v0.28; catatan saja: dialog sebagai graf data, pemilih dialog berprioritas, mesin kondisi/efek bersama quest, pencegah pengulangan, lokalisasi tanpa teks di aset visual, penyimpanan dan cloud save). Hubungan dengan D-007, D-014, D-015, D-017, D-021 sampai D-023, D-029 sampai D-033, D-035, D-037 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 29.


## 2026-11-17 (29) — D-039 Sistem Hubungan Sosial dan Persahabatan dicatat

- D-039 (Social System Hybrid Lengkap, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.29 baru (v0.29); Technical Architecture §4z ditambahkan (v0.29; catatan saja: hubungan individu dipisah dari reputasi per cakupan, perubahan lewat event dengan batas harian dan diminishing returns, pemicu event berbasis kondisi, API kueri tunggal, penyimpanan dan cloud save). Hubungan dengan D-007, D-014, D-015, D-017, D-021, D-022, D-029, D-031, D-035, D-037, D-038 dicatat tanpa mengubah isinya. Romansa/pernikahan/keluarga/anak tetap belum diputuskan.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 30.


## 2026-11-17 (30) — D-040 Sistem NPC dan Kehidupan Desa dicatat

- D-040 (NPC Living World Hybrid, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.30 baru (v0.30); Technical Architecture §4aa ditambahkan (v0.30; catatan saja: tiga tingkat simulasi LOD, jadwal + perilaku berjenjang dengan time-slicing, penanganan terjebak dan fallback, respons event, konsistensi saat muat ulang tanpa menyimpan jalur). Hubungan dengan D-007, D-009, D-014, D-015, D-017, D-021 sampai D-024, D-026 sampai D-030, D-032, D-035, D-037 sampai D-039 dicatat tanpa mengubah isinya. Romansa/pernikahan/keluarga/anak tetap belum diputuskan.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 31.


## 2026-11-17 (31) — D-041 Sistem Kustomisasi Karakter Pemain dicatat

- D-041 (Character Customization Hybrid Lengkap, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.31 baru (v0.31); Technical Architecture §4ab ditambahkan (v0.31; catatan saja: karakter modular pada satu rangka, pemisahan equipment dan kosmetik, katalog kosmetik dari data, penggabungan mesh untuk performa Android, penyimpanan dan cloud save). Hubungan dengan D-007, D-008, D-013, D-014, D-018 sampai D-021, D-029, D-031, D-033, D-036, D-037 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 32.


## 2026-11-17 (32) — D-042 Sistem Mount dan Kendaraan dicatat

- D-042 (Mount System Hybrid Lengkap, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.32 baru (v0.32); Technical Architecture §4ac ditambahkan (v0.32; catatan saja: profil kendaraan berbasis data, model makhluk bersama untuk mount hidup, tag medan untuk aturan akses, mesin keadaan dan aturan pemanggilan, integrasi gerak/kamera, penyimpanan dan cloud save). Hubungan dengan D-007, D-009, D-013, D-014, D-016, D-018, D-019, D-024, D-025, D-027, D-028, D-031 sampai D-037, D-041 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 33.


## 2026-11-17 (33) — D-043 Sistem Tutorial dan Panduan Pemain dicatat

- D-043 (Tutorial Hybrid Adaptif, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.33 baru (v0.33); Technical Architecture §4ad ditambahkan (v0.33; catatan saja: tutorial sebagai data, pemicu kontekstual berbasis event bus, penyelesaian otomatis dan throttle, sorotan UI berbasis identitas elemen, buku bantuan, penyimpanan status dan cloud save). Hubungan dengan D-007, D-013, D-014, D-016, D-017, D-019 sampai D-026, D-028, D-031, D-033 sampai D-038, D-040 sampai D-042 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 34.


## 2026-11-17 (34) — D-044 Sistem Save, Load, dan Cloud Synchronization dicatat

- D-044 (Cloud Save Hybrid Lengkap, LOCKED) dicatat; ID tersedia, tanpa bentrokan.
- GDD §6.34 baru (v0.34); Technical Architecture §5a ditambahkan (v0.34; catatan saja: alur cache lokal ke Supabase, auto-save berbasis event, skema modular berversi, validasi, pemulihan berlapis, retry terbatas, resolusi konflik tanpa penimpaan diam-diam, ID transaksi idempoten, keamanan RLS tanpa rahasia di klien/repo); `BACKEND_DESIGN.md` §5a ditambahkan dan frasa "offline-first" diperjelas agar tidak dibaca sebagai mode offline (konsisten dengan D-014 online-only). Hubungan dengan D-007, D-014, D-031, D-036, D-037, D-039, D-040, D-042, D-043, O-003 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI; fondasi lokal `SaveService` tidak diubah. Menunggu keputusan Tahap 35.


## 2026-11-17 (35) — D-045 Sistem Pengaturan dan Aksesibilitas dicatat

- D-045 (Settings Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 36**; ID tersedia, tanpa bentrokan.
- **Status Tahap 35 (Sistem Akun dan Login Pemain): PENDING**, atas instruksi pemilik; dibahas saat persiapan publikasi Google Play Store; dicatat sebagai P-006 tanpa keputusan apa pun. Catatan pada entri (34) yang menulis "Menunggu keputusan Tahap 35" kini digantikan oleh status ini.
- GDD §6.35 baru (v0.35); Technical Architecture §6a ditambahkan (v0.35; catatan saja: layanan pengaturan berbasis skema dengan cakupan per pengaturan, penyimpanan terpisah dari progres, profil konfigurasi, preset grafis GL Compatibility, editor tata letak kontrol/HUD, aksesibilitas lewat Theme). Hubungan dengan D-004, D-007, D-008, D-014, D-031 sampai D-034, D-043, D-044 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 37 (Tahap 35 tetap PENDING).


## 2026-11-17 (36) — D-046 Sistem Achievement, Title, dan Koleksi dicatat

- D-046 (Achievement Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 37**; ID tersedia, tanpa bentrokan.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006); tidak diubah.
- GDD §6.36 baru (v0.36); Technical Architecture §4ae ditambahkan (v0.36; catatan saja: definisi dari data, pelacakan berbasis event bus dengan pencacah unik anti-pengulangan, penyelesaian idempoten dan hadiah tertahan saat inventory penuh, Collection Book sebagai sumber kebenaran penemuan, Journey Record berbatas ukuran, penyimpanan dan cloud save). Hubungan dengan D-007, D-013 sampai D-029, D-031, D-032, D-036, D-037, D-039 sampai D-045, D-014 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 38 (Tahap 35 tetap PENDING).


## 2026-11-17 (37) — D-047 Sistem Monetisasi dan Transaksi Dalam Game dicatat

- D-047 (Cosmetic Only, LOCKED) dicatat sebagai **Tahap 38**; ID tersedia, tanpa bentrokan.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006); tidak diubah dan tidak dipaksakan.
- GDD §6.37 baru (v0.37) dan butir "Monetisasi" di daftar usulan ditandai terjawab; Technical Architecture §4af ditambahkan (v0.37; catatan saja: pemisahan struktural kosmetik dari atribut gameplay dengan validasi konten, dekorasi murni visual, katalog dari data dengan sumber perolehan ganda, kepemilikan tambah-saja dan idempoten, `StoreService` abstrak nonaktif, rancangan verifikasi tanda terima di sisi server tanpa rahasia di klien/repo, tanpa premium currency/season pass). Hubungan dengan D-008, D-013, D-016, D-018, D-020, D-021, D-027, D-031, D-036, D-037, D-041, D-042, D-044 sampai D-046, D-014 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI; tidak ada SDK pembayaran atau kredensial ditambahkan. Menunggu keputusan Tahap 39 (Tahap 35 tetap PENDING).


## 2026-11-17 (38) — D-048 Sistem Update Konten dan Live Operations dicatat

- D-048 (Live Operations Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 39**; ID tersedia, tanpa bentrokan.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006); tidak diubah.
- GDD §6.38 baru beserta ringkasan arah Post-Launch (v0.38); Technical Architecture §4ag ditambahkan (v0.38; catatan saja: ID konten stabil dan aturan deprecated, versi berlapis dan pemeriksaan kompatibilitas, migrasi aditif idempoten dan pola expand-contract, event live dengan acuan waktu server dan perlindungan progres permanen, jalur penyampaian konten dan pembatasan kode yang diunduh, anggaran unduhan, uji fixture save tiap versi di CI, jalur dev→staging→prod dengan rollback dan feature flag). Hubungan dengan D-009, D-013, D-014, D-016, D-017, D-019 sampai D-030, D-040, D-043 sampai D-047, O-001, O-002, O-004 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 40 (Tahap 35 tetap PENDING).


## 2026-11-17 (39) — D-049 Sistem Quality Assurance dan Pengujian Game dicatat

- D-049 (QA Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 40**; ID tersedia, tanpa bentrokan.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). **P-005 (uji APK dev di HP) tetap menunggu laporan pengguna**; tidak dianggap lulus.
- GDD §6.39 baru (v0.39); Technical Architecture §10a ditambahkan (v0.39; catatan saja: struktur uji headless, desain agar dapat diuji, uji otomatis dan integrasi per sistem, regresi, profiling CI dan perangkat fisik, pembedaan sumber bukti CI/emulator/perangkat fisik, format test case dan bug dengan tingkat keparahan, rancangan release gate, rencana integrasi GitHub Actions). Hubungan dengan O-001, O-004, P-005, D-013 sampai D-048 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 41 (Tahap 35 tetap PENDING).


## 2026-11-17 (40) — D-050 Sistem Keamanan dan Perlindungan Data Pemain dicatat

- D-050 (Security Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 41**; ID tersedia, tanpa bentrokan.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna.
- GDD §6.40 baru (v0.40); Technical Architecture §5b ditambahkan (v0.40) dan `BACKEND_DESIGN.md` §6a (v0.5); catatan saja: model ancaman, validasi server berlapis (struktur/rentang, invarian dan kewajaran, operasi bernilai tinggi otoritatif lewat fungsi server), deteksi anti-cheat tanpa hukuman otomatis dengan jalur pemulihan dan banding, perlindungan database (RLS, hak minimum, lingkungan terpisah, enkripsi, cadangan, tanpa rahasia di repo), audit log append-only minim data pribadi, monitoring dan peringatan, pendekatan hemat biaya. Keamanan tanpa biaya bagi pemain; biaya operasional ditanggung pengelola. D-047 dan D-014 tidak diubah.
- Tidak ada perubahan kode/gameplay/CI; tidak ada implementasi keamanan, akun, atau proyek Supabase. Menunggu keputusan Tahap 42 (Tahap 35 tetap PENDING).


## 2026-11-17 (41) — D-052 Sistem Performa dan Optimasi Perangkat Android dicatat

- D-052 (Adaptive Performance Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 43**, sesuai ID yang dituju pemilik; ID tersedia, tanpa bentrokan.
- **D-051 (Tahap 42) belum diterima**: ID dicadangkan dan dibiarkan kosong, tidak diisi dan tidak dipakai ulang sampai keputusan Tahap 42 dikirim.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. **Tidak ada hasil performa atau uji perangkat fisik yang diklaim**; semua angka berstatus usulan belum diukur.
- GDD §6.41 baru (v0.41); Technical Architecture §4ai ditambahkan dan §3 diberi rujukan (v0.41); catatan saja: PerfService dengan kelas perangkat dan preset grafis, penyesuaian dinamis dengan histeresis dan UI tetap resolusi asli, frame pacing dan anggaran milidetik per sistem, optimasi CPU/GPU/RAM untuk GL Compatibility, pemuatan aset per wilayah, LOD NPC/animasi, kesadaran baterai dan termal, degradasi bertahap lintas perangkat, instrumentasi, serta aturan bukti performa (D-049). Hubungan dengan O-001, D-004, D-008, D-009, D-022, D-028, D-031 sampai D-034, D-040 sampai D-042, D-044, D-045, D-048 sampai D-050 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan) dan berikutnya.


## 2026-11-17 (42) — D-053 Sistem Loading dan Transisi Antarwilayah dicatat

- D-053 (Hybrid Loading & World Streaming, LOCKED) dicatat sebagai **Tahap 44**; ID tersedia, tanpa bentrokan. **D-051 (Tahap 42) tetap dicadangkan**, belum diterima.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. Tidak ada klaim performa atau uji perangkat fisik; semua angka berstatus usulan belum diukur.
- GDD §6.42 baru (v0.42); Technical Architecture §4aj ditambahkan (v0.42); catatan saja: dua jenis transisi sebagai data (Streaming dan Loading, dapat diturunkan oleh PerfService), World Streamer dengan cincin aktif/penyangga, pemuatan asinkron time-sliced dengan gerbang kesiapan, loading screen tanpa teks tertanam dengan tips kontekstual dan progres nyata, kesinambungan kamera/audio, ResourceManager dengan pelepasan otomatis dan cache LRU, keadaan dunia terpisah dari node, penanganan dungeon/interior, keselamatan dan pemulihan, penanganan kegagalan dengan batas waktu. Hubungan dengan O-001, D-004, D-008, D-009, D-016, D-023, D-027, D-028, D-031 sampai D-033, D-040, D-042 sampai D-045, D-048 sampai D-050, D-052 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan) dan berikutnya.


## 2026-11-17 (43) — D-054 Sistem Peta Dunia dan Navigasi dicatat

- D-054 (World Map & Navigation Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 45**; ID tersedia, tanpa bentrokan. **D-051 (Tahap 42) tetap dicadangkan**, belum diterima.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. Tidak ada klaim performa atau uji perangkat fisik.
- GDD §6.43 baru (v0.43); Technical Architecture §4ak ditambahkan (v0.43); catatan saja: data dunia tunggal untuk peta/minimap/kompas/quest, status penemuan monoton tanpa kebocoran wilayah terkunci, peta interaktif dengan LOD ikon dan sentuhan tanpa bentrok kontrol, minimap dari tekstur (bukan render ulang adegan), kompas, antarmuka penanda quest/objektif, pelacakan posisi pribadi, penemuan wilayah tersembunyi, fast travel berbasis data sebagai transisi Loading dengan waktu kalender dan validasi, tap-to-move dari peta (bila diputuskan), aksesibilitas, performa GL Compatibility, serta uji. Hubungan dengan D-009, D-016, D-017, D-019, D-028 sampai D-035, D-037, D-040, D-042 sampai D-046, D-052, D-053 dicatat tanpa mengubah isinya.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan) dan berikutnya.

## 2026-11-17 (44) — D-055 Sistem Waktu, Kalender, dan Jam Permainan dicatat

- D-055 (Dynamic Time & Calendar Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 46**; ID tersedia, tanpa bentrokan. **D-051 (Tahap 42) tetap dicadangkan**; pemilik menyebutnya "Connection Resilience" tetapi isinya belum diterima, jadi keselarasan penuh ditunda dan tidak ada isi yang dikarang.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. Tidak ada klaim performa atau uji perangkat fisik.
- GDD §6.44 baru (v0.44); Technical Architecture §4al ditambahkan (v0.44); catatan saja: waktu internal (`GameClock`) di save sebagai sumber kebenaran, bukan jam perangkat; kalender sebagai data; simulasi hari-selisih deterministik (seed+tanggal); sinyal waktu hemat; jadwal NPC, event, dan aktivitas monster berbasis data; aturan konsistensi untuk perpindahan wilayah, loading, dan fast travel; gangguan koneksi tidak memajukan/memundurkan waktu (lanjutan menunggu D-051).
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan) dan berikutnya.

## 2026-11-17 (45) — D-056 Sistem Tidur, Istirahat, dan Pergantian Hari dicatat

- D-056 (Rest & Sleep Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 47**; ID tersedia, tanpa bentrokan. **D-051 (Tahap 42) tetap dicadangkan**, isinya belum diterima; keselarasan penuh ditunda dan tidak ada isi yang dikarang.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. Tidak ada klaim performa atau uji perangkat fisik.
- GDD §6.45 baru (v0.45); Technical Architecture §4am ditambahkan (v0.45); catatan saja: satu jalur `advance_day`, pipeline berbasis data berurutan, pemrosesan terpotong antar frame, deterministik (seed+tanggal), komit atomik idempoten aman terhadap interupsi dan koneksi, pemulihan sebagai data. Efek pemulihan, batas dan jam tidur sengaja tidak ditetapkan.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan) dan berikutnya.

## 2026-11-17 (46) — D-057 Sistem Energi, Stamina, dan Kebutuhan Karakter dicatat

- D-057 (Character Vitality Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 48**; ID tersedia, tanpa bentrokan. **D-051 (Tahap 42) tetap dicadangkan**, isinya belum diterima; tidak ada isi yang dikarang.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. Tidak ada klaim performa atau uji perangkat fisik.
- GDD §6.46 baru (v0.46); Technical Architecture §4an ditambahkan (v0.46); catatan saja: `VitalityComponent` berbasis data (Health, Stamina, Mana, Hunger, Thirst, Fatigue), biaya aksi dan efek pemulihan sebagai data, tick berfrekuensi rendah dari `GameClock`, profil kebutuhan yang dapat disetel agar tidak memberatkan, transaksi item idempoten, event bus untuk UI. Semua angka, efek saat habis, dan balance sengaja tidak ditetapkan.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan) dan berikutnya.

## 2026-11-17 (47) — D-058 Sistem Kematian, Pingsan, dan Kebangkitan dicatat

- D-058 (Defeat & Recovery Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 49**; ID tersedia, tanpa bentrokan. **D-051 (Tahap 42) tetap dicadangkan**, isinya belum diterima; tidak ada isi yang dikarang. Pesan Stage 47 yang terkirim dua kali tidak dicatat ulang (D-056 sudah ada).
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. Tidak ada klaim performa atau uji perangkat fisik.
- GDD §6.47 baru (v0.47); Technical Architecture §4ao ditambahkan (v0.47); catatan saja: `DefeatService` tunggal dengan mesin keadaan, profil kekalahan per konteks sebagai data, penyelamatan NPC dengan jalur cadangan, klinik/checkpoint/titik kebangkitan berbasis data dan divalidasi, transaksi atomik idempoten, tanpa penggandaan hadiah. Semua penalti, durasi, dan aturan checkpoint final sengaja tidak ditetapkan.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan) dan berikutnya.

## 2026-11-17 (48) — D-059 Sistem Status Effect, Buff, dan Debuff dicatat

- D-059 (Status Effect Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 50**; ID tersedia, tanpa bentrokan. **D-051 (Tahap 42) tetap dicadangkan**, isinya belum diterima; tidak ada isi yang dikarang. Kategori "spiritual" dicatat sebagai disebut pemilik tetapi **tetap tidak didefinisikan**.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. Tidak ada klaim performa atau uji perangkat fisik.
- GDD §6.48 baru (v0.48); Technical Architecture §4ap ditambahkan (v0.48); catatan saja: satu sistem efek bersama (`StatusEffectDef` berdata dengan lima bagian wajib: definisi, sumber, target, durasi, aturan penghapusan), komponen per entitas, penerapan lewat satu pintu, kategori sebagai tag, durasi dari `GameClock`, probabilitas deterministik, validator kelengkapan, tampilan atas event bus. Katalog, durasi, stacking, probabilitas, dan angka sengaja tidak ditetapkan.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan) dan berikutnya.

## 2026-11-17 (49) — D-060 Sistem Ras, Suku, dan Asal-Usul Karakter dicatat

- D-060 (Racial World Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 51**; ID tersedia, tanpa bentrokan. **D-051 (Tahap 42) tetap dicadangkan**, isinya belum diterima; tidak ada isi yang dikarang. "Garis keturunan spiritual" dicatat sebagai disebut pemilik; arti "spiritual" **tetap tidak didefinisikan**.
- Tidak ada dokumen worldbuilding terpisah di `docs/`; dunia dicatat di GDD (bagian dunia D-009 dan §6.49 baru). Tidak dibuat dokumen baru.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. Tidak ada klaim performa atau uji perangkat fisik.
- GDD §6.49 baru (v0.49); Technical Architecture §4aq ditambahkan (v0.49); catatan saja: kelompok/ras/suku sebagai data ber-ID, referensi bukan salinan, perlakuan berbeda hanya lewat aturan data eksplisit (anti diskriminasi tersembunyi) dengan audit validator, lokalisasi dua bahasa. Daftar ras, lore, kemampuan, populasi, dan hubungan antarbangsa sengaja tidak ditetapkan.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan) dan berikutnya.
