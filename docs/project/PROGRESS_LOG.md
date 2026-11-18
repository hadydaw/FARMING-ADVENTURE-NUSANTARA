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

## 2026-11-17 (50) — D-061 Sistem Kerajaan, Wilayah Kekuasaan, dan Organisasi Dunia dicatat

- D-061 (World Civilization Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 52**; ID tersedia, tanpa bentrokan. **D-051 (Tahap 42) tetap dicadangkan**, isinya belum diterima; tidak ada isi yang dikarang. "Sekte spiritual" dicatat sebagai disebut pemilik; arti "spiritual" **tetap tidak didefinisikan**.
- Tidak ada dokumen worldbuilding terpisah di `docs/`; dunia dicatat di GDD (§6.50 baru). Tidak dibuat dokumen baru.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. Tidak ada klaim performa atau uji perangkat fisik.
- GDD §6.50 baru (v0.50); Technical Architecture §4ar ditambahkan (v0.50); catatan saja: `Organization` sebagai data ber-ID, guild D-017 tidak diubah, wilayah pengaruh sebagai relasi data, hubungan antarorganisasi sebagai graf data, keadaan per-save yang deterministik, organisasi rahasia tanpa kebocoran, struktur additive agar berkembang seiring progres. Nama, jumlah, pemimpin, peta politik, sejarah, dan hubungan sengaja tidak ditetapkan.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan) dan berikutnya.

## 2026-11-17 (51) — D-062 Sistem Reputasi, Hubungan Faksi, dan Diplomasi dicatat

- D-062 (Faction Relations Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 53**; ID tersedia, tanpa bentrokan. **D-051 (Tahap 42) tetap dicadangkan**, isinya belum diterima; tidak ada isi yang dikarang. Arti "spiritual" **tetap tidak didefinisikan**.
- Tidak ada dokumen worldbuilding terpisah di `docs/`; dunia dicatat di GDD (§6.51 baru). Tidak dibuat dokumen baru.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. Tidak ada klaim performa atau uji perangkat fisik.
- GDD §6.51 baru (v0.51); Technical Architecture §4as ditambahkan (v0.51); catatan saja: dua lapisan terpisah (`PlayerStanding` dan `OrgRelation`), skala sebagai data, perubahan lewat efek data dengan jejak sebab, deterministik, tanpa keadaan buntu, tanpa kebocoran data tersembunyi. D-039 dan D-017 tidak diubah; kaitan skala masih terbuka. Skala, ambang, daftar faksi, dan hasil politik sengaja tidak ditetapkan.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan) dan berikutnya.

## 2026-11-17 (52) — D-063 Sistem Perang dan Konflik Antarfaksi dicatat

- D-063 (World Conflict Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 54**; ID tersedia, tanpa bentrokan. **D-051 (Tahap 42) tetap dicadangkan**, isinya belum diterima; tidak ada isi yang dikarang. Arti "spiritual" (sekte) **tetap tidak didefinisikan**.
- Tidak ada dokumen worldbuilding terpisah di `docs/`; dunia dicatat di GDD (§6.52 baru). Tidak dibuat dokumen baru.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. Tidak ada klaim performa atau uji perangkat fisik.
- GDD §6.52 baru (v0.52); Technical Architecture §4at ditambahkan (v0.52); catatan saja: `Conflict` sebagai data dan mesin keadaan, konsisten dengan relasi diplomasi, keterlibatan pemain opsional, perlindungan progres utama dan save, dampak lewat efek data yang dapat berakhir, deterministik. Daftar perang, faksi, korban, aturan perebutan, dan hasil sengaja tidak ditetapkan.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan) dan berikutnya.

## 2026-11-17 (53) — D-064 Sistem Hukum, Kejahatan, dan Bounty dicatat

- D-064 (Law & Justice Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 55**; ID tersedia, tanpa bentrokan. **D-051 (Tahap 42) tetap dicadangkan**, isinya belum diterima; tidak ada isi yang dikarang. Arti "spiritual" **tetap tidak didefinisikan**.
- Tidak ada dokumen worldbuilding terpisah di `docs/`; dunia dicatat di GDD (§6.53 baru). Tidak dibuat dokumen baru.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. Tidak ada klaim performa atau uji perangkat fisik.
- GDD §6.53 baru (v0.53); Technical Architecture §4au ditambahkan (v0.53); catatan saja: kode hukum per otoritas/wilayah sebagai data, tiga lapisan reputasi terpisah (sosial, faksi, kriminal), deteksi dan saksi sebagai data, tahap peringatan agar tindakan tidak disengaja tidak langsung berat, mesin keadaan penegakan, bounty selalu punya jalur penyelesaian, perlindungan progres dan save. Kategori kejahatan, hukuman, prosedur, dan formula bounty sengaja tidak ditetapkan.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan) dan berikutnya.

## 2026-11-17 (54) — D-065 Sistem Cuaca Ekstrem, Bencana Alam, dan Fenomena Spiritual dicatat

- D-065 (World Phenomena Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 56**; ID tersedia, tanpa bentrokan. **D-051 (Tahap 42) tetap dicadangkan**, isinya belum diterima; keselarasan penuh ditunda dan tidak ada isi yang dikarang. Arti "spiritual" (fenomena) **tetap tidak didefinisikan** (sudah terbuka di D-029 dan D-030).
- Tidak ada dokumen worldbuilding terpisah di `docs/`; dunia dicatat di GDD (§6.54 baru). Tidak dibuat dokumen baru.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. Tidak ada klaim performa atau uji perangkat fisik.
- GDD §6.54 baru (v0.54); Technical Architecture §4av ditambahkan (v0.54); catatan saja: `Phenomenon` sebagai data memperluas event dan cuaca yang ada, jadwal deterministik dari seed+tanggal dan `GameClock`, tahap peringatan–berlangsung–pemulihan, dampak lewat efek data, perlindungan progres dan save, setiap fenomena wajib dapat berakhir. Katalog, frekuensi, probabilitas, kerusakan, dan durasi sengaja tidak ditetapkan.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan) dan berikutnya.

## 2026-11-17 (55) — D-066 Sistem Romansa, Pernikahan, dan Keluarga dicatat (memperbarui batasan D-015)

- D-066 (Romance & Family Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 57**; ID tersedia, tanpa bentrokan. **D-051 (Tahap 42) tetap dicadangkan**, isinya belum diterima; tidak ada isi yang dikarang. Arti "spiritual" **tetap tidak didefinisikan**.
- **Konflik dengan D-015 diselesaikan eksplisit:** batasan "romansa, pernikahan, keluarga, anak belum ditetapkan" (D-015, Tahap 5) kini **diperbarui oleh D-066**; D-066 adalah keputusan terbaru untuk aspek ini. **Fitur kehidupan lain di D-015 tidak berubah.** Catatan batasan lama di DESIGN_DECISIONS (D-015, D-022, D-027), GDD (§6.x terkait dan daftar sisa), dan Technical Architecture (§4b, §4i, §4z, §4aa) ditandai "diperbarui oleh D-066"; penanda "tidak ada model romansa/keluarga" pada catatan D-055 sampai D-065 diganti rujukan ke D-066. Entri log lama (sebelum ini) tidak diubah karena merupakan riwayat.
- Hanya **cakupan** yang ditetapkan; kandidat pasangan, aturan kelayakan, kecepatan, mekanisme pernikahan, sistem anak, dan detail keluarga sengaja tidak ditetapkan.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. Tidak ada klaim performa atau uji perangkat fisik.
- GDD §6.55 baru (v0.55); Technical Architecture §4aw ditambahkan (v0.55); catatan saja: model hubungan bertahap berdata, `FamilyState` per-save yang additive, integrasi jadwal NPC/rumah/kalender/event, penulisan atomik idempoten, pemisahan dari reputasi komunitas/faksi/kriminal.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan) dan berikutnya.

## 2026-11-17 (56) — D-067 Sistem Cerita Utama dan Alur Narasi Dunia dicatat

- D-067 (Narrative World Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 58**; ID tersedia, tanpa bentrokan. **D-051 (Tahap 42) tetap dicadangkan**, isinya belum diterima; tidak ada isi yang dikarang. Arti "spiritual" **tetap tidak didefinisikan**.
- Tidak ada dokumen story/worldbuilding terpisah di `docs/`; narasi dan dunia dicatat di GDD (§6.56 baru). Tidak dibuat dokumen baru.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. Tidak ada klaim performa atau uji perangkat fisik.
- GDD §6.56 baru (v0.56); Technical Architecture §4ax ditambahkan (v0.56); catatan saja: `NarrativeGraph` sebagai data di atas quest/dialog/sosial yang ada, `StoryState` per-save yang deterministik, pilihan dan konsekuensi tercatat dan konsisten lintas sistem, jalur maju selalu ada, cerita berdampingan dengan kehidupan harian, rahasia tanpa kebocoran. Plot, karakter, bab, ending, dan percabangan sengaja tidak ditetapkan.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan) dan berikutnya.

## 2026-11-17 (57) — D-068 Sistem Endgame dan Aktivitas Setelah Cerita Utama dicatat

- D-068 (Endless Adventure Hybrid Lengkap, LOCKED) dicatat sebagai **Tahap 59**; ID tersedia, tanpa bentrokan. **D-051 (Tahap 42) tetap dicadangkan**, isinya belum diterima; tidak ada isi yang dikarang. Arti "spiritual" **tetap tidak didefinisikan**.
- Tidak ada dokumen desain dunia terpisah di `docs/`; dunia dicatat di GDD (§6.57 baru). Tidak dibuat dokumen baru. Keputusan Tahap 1 sampai 58 tidak diubah.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. Tidak ada klaim performa atau uji perangkat fisik.
- GDD §6.57 baru (v0.57); Technical Architecture §4ay ditambahkan (v0.57); catatan saja: cerita selesai hanya menjadi flag/fase data di save yang sama (tanpa mode terpisah), `EndgameChallenge` berdata di atas dungeon/guild/boss/koleksi yang ada, siklus dan reset dari `GameClock`, hadiah idempoten, tanpa leaderboard antarpemain, selaras monetisasi kosmetik. Hadiah, angka kesulitan, dan daftar tantangan sengaja tidak ditetapkan.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan) dan berikutnya.

## 2026-11-17 (58) — D-069 Prioritas Konten, Versi Rilis, dan Roadmap dicatat

- D-069 (Hybrid Release dan Roadmap Lengkap, LOCKED) dicatat sebagai **Tahap 60**; ID tersedia, tanpa bentrokan. **D-051 (Tahap 42) tetap dicadangkan**, isinya belum diterima; tidak ada isi yang dikarang. Arti "spiritual" **tetap tidak didefinisikan**.
- **Dokumen baru:** `docs/design/RELEASE_SCOPE.md` (prinsip rilis terkunci; isi Rilis Awal sebagai **usulan** menunggu P-007; gerbang kelayakan; aturan pembaruan; tujuh konflik dokumen beserta rekomendasi). `ROADMAP.md` diperbarui dengan bagian roadmap rilis dan konten, serta catatan konflik pada Fase 4, 5, dan 6 (urutan fase lama **tidak dihapus**). `docs/README.md` ditambah indeks.
- **Item pending baru:** P-007 (persetujuan lingkup final Rilis Awal, urutan pembaruan, kanal distribusi). Tidak ada tanggal rilis, target biaya, atau angka performa/ukuran yang ditetapkan.
- **Tahap 35 (Akun dan Login) tetap PENDING** (P-006). P-005 tetap menunggu laporan pengguna. Tidak ada klaim performa atau uji perangkat fisik.
- GDD §6.58 baru (v0.58); Technical Architecture §4az ditambahkan (v0.58); catatan saja: lingkup rilis sebagai penanda fitur data, save aditif untuk sistem yang belum rilis, cerita aditif lintas rilis, anggaran perangkat ditetapkan setelah diukur, uji fixture save tiap rilis.
- Tidak ada perubahan kode/gameplay/CI. Menunggu keputusan Tahap 42 (D-051 dicadangkan), P-007, dan berikutnya.

## 2026-11-17 (59) — D-051 dicatat; koreksi Rilis Awal; DRAFT PROPOSAL P-007

- **D-051 (Connection Resilience Hybrid Lengkap, Tahap 42)** dicatat resmi: sambung ulang otomatis, pemulihan sesi, perlindungan data belum sinkron, penanganan server mati, retry aman dan idempoten, status koneksi/sinkron, tanpa mode offline penuh; tidak bertentangan dengan D-014 dan D-044. Detail angka (interval, batas, tampilan) terbuka. GDD §6.59, TA §4ba, BACKEND_DESIGN §5b.
- **Koreksi pemilik atas D-069:** D-014 tidak otomatis mewajibkan Account/Login di Rilis Awal; **Tahap 35 tetap DEFERRED** (P-006) sampai persiapan Google Play; kanal APK publik = **GitHub Releases (D-005)**; istilah "offline→online" diganti "uji putus koneksi → pemulihan koneksi"; ekspansi setelah Rilis Awal. Keputusan Tahap 1 sampai 60 tidak diubah.
- **Dokumen:** `RELEASE_SCOPE.md` ditulis ulang; `RELEASE_SCOPE_PROPOSAL_P007.md` baru (**DRAFT PROPOSAL**, P-007 **belum dikunci**); `ROADMAP.md` disusun ulang (Fase 4 Online dan Ketahanan Koneksi, Fase 5 Beta dan Rilis Awal, Fase 6 Pembaruan; gerbang G0 s.d. G7+ tanpa tanggal).
- **Terbuka:** Q1 identitas Cloud Save tanpa login (tidak diputuskan); P-002, P-005, P-006 (DEFERRED), P-007 menunggu pemilik; target performa D-052 perlu pengukuran nyata; "spiritual" TBD.
- Tidak ada perubahan kode/gameplay/CI.

## 2026-11-17 (60) — Proposal P-007 rev. 2 (jawaban pemilik Q1 sampai Q6)

- Jawaban pemilik dimasukkan ke `RELEASE_SCOPE_PROPOSAL_P007.md` (**DRAFT PROPOSAL, P-007 belum dikunci**): Q1 identitas anonim Supabase + persiapan account linking + peringatan risiko; Q2 ramuan dasar dan herbal masuk Rilis Awal; Q3 companion dasar masuk; Q4 romansa tahap awal masuk (pertunangan dan seterusnya via pembaruan); Q5 target 3 wilayah, 2 dungeon, 12 NPC inti (target desain, perlu validasi produksi); Q6 kustomisasi dasar masuk, transaksi kosmetik ditunda.
- Tabel per sistem diperbarui (48 baris). Pemeriksaan konsistensi D-014, D-019, D-034, D-041, D-044, D-047, D-066, D-069 dicatat. Teks D-014 tidak diubah; tafsir "akun anonim otomatis" menunggu konfirmasi pemilik.
- Implikasi teknis: identitas anonim hilang bila aplikasi dihapus, data dibersihkan, atau ganti perangkat sebelum ditautkan; pemulihan tidak diasumsikan. Daftar TBD T1 sampai T20 dibuat.
- `RELEASE_SCOPE.md`, `ROADMAP.md`, `BACKEND_DESIGN.md` (§6b) disinkronkan. Tidak ada perubahan kode/gameplay/CI. Tahap 35 tetap DEFERRED; P-002, P-005, P-006, P-007 pending.

## 2026-11-17 (61) — P-007 disetujui pemilik (O-008)

- Pemilik menyetujui proposal P-007 rev. 2 ("Setuju"). Dicatat sebagai **O-008**; P-007 berstatus **Selesai**. Isi: lingkup Rilis Awal sesuai tabel proposal, jawaban Q1 sampai Q6 (identitas anonim Supabase, ramuan dasar, companion dasar, romansa tahap awal, target 3 wilayah/2 dungeon/12 NPC inti sebagai target desain yang perlu divalidasi, kustomisasi dasar, transaksi kosmetik ditunda), dan tafsir D-014 (teks tidak diubah).
- **TBD T1 sampai T20 tetap terbuka**, tidak dianggap diputuskan. Keputusan D-001 sampai D-069 dan D-051 tidak berubah. Tahap 35 tetap DEFERRED; P-002, P-005, P-006 pending.
- Dokumen disinkronkan: DESIGN_DECISIONS, RELEASE_SCOPE, proposal P-007, ROADMAP, GDD, TA, BACKEND_DESIGN, README. Tidak ada perubahan kode/gameplay/CI.

## 2026-11-17 (62) — Milestone 1 Project Foundation + workflow produksi (O-009)

- Pemilik memerintahkan mulai pembuatan game dan menetapkan aturan produksi: ChatGPT membuat semua aset visual, Claude mengerjakan teknis. Dicatat sebagai **O-009**; dokumen: `PRODUCTION_WORKFLOW.md`, `IMPLEMENTATION_PLAN.md`, `docs/assets/*`.
- M1 dibangun: DataRegistry, Events, GameSettings, GameDisplay, InputService, SceneManager, UiTheme, kontrol sentuh, boot/menu/pengaturan/diagnostik, lokalisasi id/en. Bug layout ditemukan lewat screenshot dan diperbaiki (`set_anchors_and_offsets_preset`), dikunci dengan uji tata letak.
- Uji: 8 berkas, 383 pemeriksaan, 0 gagal; smoke test lulus.
- Risiko terbuka: D-008 (3D) vs sprite; sumber model 3D; identitas T1/T2 belum diimplementasi; uji perangkat fisik oleh pemilik.

## 2026-11-17 (63) — Bahasa bawaan Inggris

- Arahan pemilik: game dua bahasa (Indonesia dan Inggris), **Inggris sebagai bahasa bawaan**. Bahasa awal tidak lagi mengikuti bahasa perangkat; pemain dapat ganti ke Indonesia di Pengaturan. Fallback terjemahan: Inggris. Catatan: D-007 di GDD menyebut "Indonesia utama"; teks D-007 tidak diubah, pemilik perlu mengonfirmasi bila ingin dicatat resmi.

## 2026-11-17 (64) — Klarifikasi D-008 (O-010) + Milestone 2 bagian teknis

- Pemilik mengonfirmasi laporan M1 (cc6dbb2, build dev sukses, 383 uji; belum diterima pengguna sebelum uji di HP) dan menegaskan **D-008 3D Stylized tetap**. Dicatat sebagai klarifikasi O-010, bukan keputusan baru.
- Dokumen: `docs/assets/ANALISIS_3D_STYLIZED_WORKFLOW.md`, `docs/assets/ASSET_REQUESTS_M2.md` (B-001..B-007 versi 3D), pembaruan MASTER_LIST, INTEGRATION_GUIDE, ART_DIRECTION, PRODUCTION_WORKFLOW, IMPLEMENTATION_PLAN.
- Kode M2 tanpa aset visual: GameClock/GameTime, CameraRig, MovementMath, Interactable/InteractionSensor, tabel data, layar Uji Sistem. Uji: 12 berkas, 590 pemeriksaan, 0 gagal.
- Nilai waktu/kamera/interaksi bertanda `provisional` (bukan keputusan desain).
- Belum dikerjakan (menunggu aset): model dan animasi pemain, dunia awal, HUD visual.

## 2026-11-17 (65) — Arah Opsi A (O-011) + uji percontohan props

- Pemilik memilih Opsi A (custom mesh lewat kode) sebagai metode yang diuji bertahap; dicatat **O-011**. Aturan: sumber desain hanya acuan ChatGPT, tanpa model eksternal, tanpa primitif placeholder sebagai final.
- Pilot B-003 dibuat: MeshBuilder, 7 props generik (559 sampai 55 segitiga), bake ke .glb, skrip pasca-impor warna vertex, layar Pilot Mesh. Berlabel PILOT TEKNIS karena acuan ChatGPT belum ada.
- Bug ditemukan dan diperbaiki lewat screenshot: urutan sisi depan Godot (searah jarum jam) dan arah normal; kini dikunci oleh uji.
- Uji: 13 berkas, 688 pemeriksaan, 0 gagal. Laporan keterbatasan: `docs/assets/PILOT_MESH_OPSI_A.md`. Menunggu evaluasi visual pemilik sebelum memperluas.

## 2026-11-17 (66) — Dunia awal uji dengan props pilot (O-012)

- Pemilik: "Pengerjaan seperti ini dulu" (mengacu hasil pilot). Dicatat O-012: props pilot dipakai sementara; bukan aset final; acuan ChatGPT tetap diminta (prompt B-003 disusun, acuan pohon A/B sudah dikirim pemilik dan dinilai layak).
- Dibangun: dunia uji 60x60 m dari data (`world_props.json`, `world_start_layout.json`, bertanda provisional), PlayerController, kamera mengikuti, interaksi "Periksa", BasicHud, tombol menu "Mulai (uji dunia awal)". Pemain = penanda berlabel PLACEHOLDER.
- Uji: 14 berkas, 765 pemeriksaan, 0 gagal (termasuk tabrakan pohon, batas dunia, interaksi, tata letak HUD).

## 2026-11-17 (67) — Milestone 3 bagian teknis: inti pertanian

- Pemilik: "Kerjakan". Dibangun tanpa visual final dan tanpa konten resmi: Inventory (slot grid, tumpukan dari data, tambah/kurang semua-atau-tidak), FarmPlot (olah, tanam, siram, tumbuh per hari, panen), FarmGrid, FarmActions (aksi kontekstual sementara), FarmingSession (mendengar pergantian hari GameClock, simpan/muat via SaveService, muat semua-atau-tidak).
- Data uji bertanda `provisional`: 6 item, 2 tanaman uji, 24 slot, 12 petak (`items`, `crops`, `farm_config`, `farm_plots`). BUKAN daftar resmi (D-023/D-036 terbuka). Cuaca/hujan, kualitas tanah, pupuk, irigasi belum diimplementasikan.
- Dunia uji: 12 petak berupa kotak penanda berlabel "UJI", penanda tanaman tumbuh menurut tahap, HUD tas, prompt aksi, terjemahan id/en.
- Uji: 15 berkas, 995 pemeriksaan, 0 gagal. Perilaku tas penuh menahan panen tanpa kehilangan tanaman; save rusak ditolak tanpa mengubah status.
- Belum: menu/tombol simpan di UI, pemilihan alat manual (D-034), visual C-001..C-006.

## 2026-11-17 (68) — Simpan/muat dan panel tas di HUD

- Pemilik: "Kerjakan". HUD kini punya tombol Simpan, Muat, Tas. Simpan slot 0 = waktu permainan + status pertanian (SaveService, ber-checksum); muat semua-atau-tidak (gagal memulihkan keadaan sebelumnya). Panel Tas = kisi 24 slot berteks (ikon item menunggu aset C-00x).
- Uji: 15 berkas, 1040 pemeriksaan, 0 gagal; smoke test lulus. Antarmuka sementara, belum desain UI resmi.

## 2026-11-17 (69) — Cuaca dasar (D-030, teknis)

- Pemilik: "Kerjakan". WeatherModel: cuaca harian deterministik dari (world_seed, hari, musim) via GameClock.daily_seed, tanpa jam perangkat; world_seed ikut tersimpan. Hujan menyiram tanaman (tumbuh pada hari yang baru berakhir), aksi siram ditolak saat hujan. `GameClock.season_id_for_day`.
- Data uji bertanda provisional: 2 cuaca (cerah, hujan) dan bobot per musim. Daftar cuaca, peluang, iklim per wilayah, dampak ke hewan/ikan/NPC belum diputuskan (D-030) dan tidak diimplementasikan.
- HUD menampilkan cuaca; tampilan hujan sementara (langit/cahaya lebih gelap, belum ada partikel/aset).
- Uji: 16 berkas, 1098 pemeriksaan, 0 gagal; smoke test lulus.

## 2026-11-17 (70) — Tidur, pergantian hari, vitalitas dasar (D-056/D-057, teknis)

- Pemilik: "Kerjakan". Vitality (health/stamina/mana, nilai SEMENTARA), SleepCycle (tidur maju bertahap ke jam bangun, jam nyata dijeda, pulih saat bangun, pergantian hari diproses per langkah, bukan satu frame), biaya stamina aksi pertanian (data uji), tempat tidur penanda berlabel di dunia uji, HUD HP/Stamina/Mana.
- Data uji bertanda provisional: `vitality_meters.json`, `rest_config.json`. Tidak dibuat (belum diputuskan): angka konsumsi/regenerasi, hunger/thirst/fatigue, tidur di penginapan/kemah, batas waktu tidur, efek pemulihan final, pingsan/kebangkitan (D-058), status effect (D-059).
- Simpan/muat membawa vitalitas (semua-atau-tidak).
- Uji: 17 berkas, 1200 pemeriksaan, 0 gagal; smoke test lulus.

## 2026-11-17 (71) — Fondasi NPC: jadwal, dialog, hubungan (D-038/D-039/D-040, teknis)

- Pemilik: "Kerjakan dan kasih Pilihan ke aku". Dibangun: ScheduleResolver (lokasi+aktivitas = fungsi murni dari jam dan cuaca; hujan = berteduh), SocialState (friendship per NPC, penanda dialog per hari, simpan/muat semua-atau-tidak), DialogRunner (syarat cuaca/musim/jam/friendship, prioritas, sekali-sehari, pilihan memengaruhi hubungan dan bercabang), UI dialog di HUD, 2 NPC uji generik yang bergerak menurut jadwal, waktu berhenti saat dialog (sementara).
- SEMUA konten generik dan bertanda provisional; BUKAN NPC/dialog resmi (T12 terbuka). Format data dialog dan aturan prioritas bersifat sementara (terbuka di D-038). Belum ada: pencarian jalur/penanganan terjebak, LOD simulasi, interaksi antar-NPC, kebutuhan NPC, ekonomi NPC, romansa (T9).
- Simpan/muat membawa data sosial. Uji: 18 berkas, 1350 pemeriksaan, 0 gagal; smoke test lulus.

## 2026-11-17 (72) — Memancing dan peternakan dasar (D-025/D-024, teknis)

- Pemilik memilih "Memancing dan peternakan dasar" dan "lanjut teknis saja".
- Memancing: FishingModel (spesies tersedia menurut habitat/musim/cuaca/jam; hasil deterministik dari world_seed+hari+nomor lemparan, jadi muat-ulang tidak mengulang undian; umpan menaikkan peluang ikan langka), FishingCast (tunggu -> gigitan -> tarik tepat waktu = dapat / lepas), biaya stamina dan umpan, kolam uji.
- Peternakan: Animal (umur, pakan harian, kemajuan produk, terlantar), LivestockState (beri pakan/ambil hasil), 3 hewan uji di kandang penanda. Hewan hanya tumbuh/berproduksi pada hari diberi pakan; terlantar >= batas menghapus kemajuan (aturan SEMENTARA).
- Semua spesies/hewan/angka generik dan provisional (bukan daftar resmi). Belum ada: kualitas hasil, ikan spiritual/legendaris, alat/umpan beragam, perkembangbiakan, kandang berkembang, pembelian hewan (menunggu ekonomi).
- Simpan/muat membawa ternak dan penghitung lemparan. Uji: 19 berkas, 1577 pemeriksaan, 0 gagal; smoke test lulus.
- Catatan visual: kolam uji berdekatan dengan semak prop pilot sehingga kamera tertutup semak di titik itu; tata letak sementara.

## 2026-11-17 (73) — Ekonomi dan toko dasar (D-021, teknis)

- Pemilik: "Kerjakan kasih pilihan". Economy (uang, harga beli/jual dari data, pengali musim, penurunan harga jual menurut jumlah terjual hari itu, pulih tiap hari, beli/jual semua-atau-tidak), toko uji (kios penanda + panel Beli/Jual), uang di HUD, waktu berhenti saat belanja (sementara). Simpan/muat membawa uang dan penghitung jual harian.
- Data SEMENTARA/provisional: nama mata uang ("Koin (uji)"), harga, stok toko; harga jual tidak pernah melebihi harga beli (tanpa arbitrase, diuji). Belum ada: merchant spesialis, perdagangan antarwilayah, harga monster/tambang, pembelian hewan, ekonomi dinamis berbasis pasokan global, kekayaan/usaha.
- Uji: 20 berkas, 1728 pemeriksaan, 0 gagal; smoke test lulus.
- Catatan UI: baris teks Tas di HUD melebar di bawah panel toko; akan dirapikan saat UI resmi.

## 2026-11-17 (74) — Peta, minimap, wilayah (D-054/D-028/D-009, teknis)

- Pemilik memilih "Peta, minimap, dan wilayah". 3 wilayah uji generik (desa, hutan, kawasan kuno; bukan wilayah resmi) di koordinat dunia terpisah, gerbang dua arah, props wilayah dihasilkan deterministik dari seed (RegionLayout).
- D-054 "tidak membuka semua wilayah sejak awal": RegionRules (always/min_day/has_item; jenis tak dikenal = terkunci); kawasan kuno terkunci sampai punya item syarat SEMENTARA.
- MapState (wilayah ditemukan, simpan/muat), MinimapView (minimap + peta penuh, penanda gerbang/toko/tidur/kolam/hewan/warga), simpan membawa wilayah dan posisi pemain, CameraRig.snap_to.
- Belum: zoom/pan peta, kompas, penanda quest, fast travel, penemuan lokasi tersembunyi.
- Uji: 21 berkas, 1857 pemeriksaan, 0 gagal; smoke test lulus.

## 2026-11-17 (75) — Instruksi pemilik: kerjakan semua tahap sendiri

- Pemilik tidur dan meminta seluruh tahap dikerjakan sampai game siap dites saat bangun. Dikerjakan berurutan dengan data uji sementara; tidak ada konten resmi yang dikarang; klaim uji perangkat fisik tetap tidak dibuat.

## 2026-11-17 (76) — Crafting, memasak, ramuan, pengumpulan (D-020/D-026, teknis)

- Crafting semua-atau-tidak (rollback bila tas penuh), ItemUse (menolak item tak bisa dipakai / meter penuh tanpa mengonsumsi), GatherState (respawn per hari, tersimpan).
- Data SEMENTARA generik: 3 stasiun (dapur, alkimia, bengkel), 5 resep, node kumpul di hutan/desa/kawasan kuno. Bukan resep/bahan resmi.
- HUD: menu daftar serbaguna (dipakai lagi untuk quest/papan guild nanti); slot Tas jadi tombol "Pakai".
- Belum: ikon item, animasi memasak, kualitas/bintang hasil, resep terbuka bertahap, tingkat keahlian.
- Uji: 22 berkas, 2074 pemeriksaan, 0 gagal; smoke test lulus. Uji perangkat fisik belum dilakukan.

## 2026-11-17 (77) — Pertarungan dasar, monster, drop, pingsan, EXP/level (D-013/D-018/D-019/D-058, teknis)

- CombatState: serangan tukar-pukul (pemain lalu balasan monster), biaya stamina, drop deterministik (seed+spawn+hari+jumlah kalahkan), respawn per hari, pingsan (uang -10%, HP pulih 50%, monster pulih, pemain dipindah ke desa), EXP/level dengan bonus serangan.
- Data SEMENTARA generik: 2 monster, 4 spawn, config, pedang uji. Bukan monster/boss/senjata resmi.
- Simpan/muat: kunci "combat" opsional (save lama tetap termuat), rollback bila rusak.
- Belum: animasi/serangan waktu-nyata, AI monster mengejar, status efek (D-059), equip senjata/armor, skill, boss, dungeon.
- Uji: 23 berkas, 2208 pemeriksaan, 0 gagal; smoke test lulus. Uji perangkat fisik belum dilakukan.

## 2026-11-17 (78) — Quest + papan guild + peringkat (D-037/D-017, teknis)

- QuestState: jenis collect/defeat, progres defeat hanya setelah quest diterima, batas aktif, peringkat dari poin, hadiah semua-atau-tidak (tas penuh membatalkan serah), simpan/muat opsional (save lama tetap termuat) + rollback.
- Papan guild uji di desa memakai menu daftar serbaguna di HUD. Data SEMENTARA generik; bukan quest/rank resmi (T-terkait tetap terbuka).
- Belum: quest harian/berulang, penanda quest di peta, quest cerita, pemberi quest NPC, batas waktu.
- Uji: 24 berkas, 2300+ pemeriksaan, 0 gagal; smoke test lulus.

## 2026-11-17 (79) — Dungeon dasar + bos (D-016, teknis)

- DungeonState: ruangan deterministik (seed+hari+id) dari kolam monster data, ruang terakhir bos uji, tukar-serang per ketukan memakai rumus CombatState, pingsan/keluar mengakhiri run, hadiah uang/poin guild + cooldown hari, run berjalan tersimpan (opsional, save lama aman) dengan rollback.
- Gua uji di kawasan kuno (menu Mulai/Serang/Keluar). Data SEMENTARA generik; bukan dungeon/boss resmi.
- Belum: peta ruangan 3D, jebakan/peti, boss berpola/fase, status efek, dungeon bertingkat.
- Uji: 25 berkas, 2450 pemeriksaan, 0 gagal; smoke test lulus.

## 2026-11-17 (80) — Pencapaian dan petunjuk tutorial (D-046/D-043, teknis)

- AchievementState: baris berbasis statistik (kills, level, money, rank, dungeons_cleared, always), dibuka sekali, tersimpan, diumumkan lewat pesan HUD; save lama tanpa kunci direset aman, rollback bila rusak.
- Data SEMENTARA generik; bukan daftar pencapaian/tutorial resmi.
- Belum: layar daftar pencapaian, hadiah, ikon, tutorial interaktif bertahap, koleksi (ensiklopedia).
- Uji: 26 berkas, 2500+ pemeriksaan, 0 gagal; smoke test lulus.

## 2026-11-17 (81) — Event dan festival kalender (D-029, teknis)

- Pemilik memilih "Event & festival kalender". FestivalCalendar: festival menurut musim + hari-dalam-musim, klaim sekali per festival per tahun ("id:tahun"), hadiah item + EXP, tas penuh = hadiah terlewat (tetap tercatat), festival berikutnya dapat dihitung, simpan/muat opsional dengan rollback.
- Diumumkan lewat pesan HUD saat pergantian hari. Data SEMENTARA generik; bukan festival/kalender resmi (D-029 detail tetap terbuka).
- Belum: dekorasi/aktivitas festival, toko khusus, NPC festival, layar kalender, efek khusus (diskon, cuaca).
- Uji: 27 berkas, 2583 pemeriksaan, 0 gagal; smoke test lulus.

## 2026-11-18 (82) — Menu utama Lanjutkan + autosave (teknis)

- Pemilik memilih "Menu utama & autosave". SaveService.latest_slot() (waktu unix terbesar), pending_load_slot, slot manual=0 dan autosave=1; save_game/load_game menerima slot; autosave senyap setiap bangun tidur (pesan "Tersimpan otomatis").
- Menu utama: tombol "Lanjutkan (simpan manual/otomatis)" hanya bila ada simpanan; "Mulai" tetap untuk game baru. Teks MENU_NOTICE diperbarui.
- Belum: layar pilih slot dengan ringkasan (hari/uang), hapus slot, autosave berkala/saat keluar aplikasi, konfirmasi menimpa.
- Uji: 27 berkas, 2609 pemeriksaan, 0 gagal; smoke test lulus.

## 2026-11-18 (83) — Upgrade tas dan meter (D-027, teknis)

- UpgradeState (id dimiliki + efek dihitung dari himpunan), beli semua-atau-tidak, syarat urutan. Inventory.set_slot_count dan Vitality.set_max_bonus. FarmingSession.from_dict kini menerapkan upgrade DULU (ukuran tas/maks meter bergantung padanya) dengan pemulihan penuh bila gagal; save tanpa kunci upgrade = kembali ke dasar.
- Tukang uji di desa memakai menu daftar serbaguna. Data SEMENTARA generik.
- Belum: upgrade rumah/petak lahan baru (butuh node dunia dan desain D-027), tampilan rumah, tingkat alat.
- Uji: 28 berkas, 2720 pemeriksaan, 0 gagal; smoke test lulus.

## 2026-11-18 (84) — Companion dasar (D-019, teknis)

- CompanionState: rekrut dengan uang, satu aktif (ganti/istirahat), bonus serangan + penahan ke CombatState (turunan, tidak disimpan; diterapkan ulang setelah muat/reset), dipakai juga oleh dungeon. Simpan/muat opsional (save lama = direset) dengan rollback utuh.
- Kemah teman uji di desa (menu daftar), pengikut berupa bola berwarna yang mengikuti pemain. Data SEMENTARA generik; bukan companion resmi (kepribadian, cerita, kemampuan khusus belum ada, D-019 detail terbuka).
- Belum: companion bertarung sendiri/AI, tingkat kedekatan, perintah, bantuan pertanian, ikut ke wilayah lain secara fisik saat travel (visual menyusul lewat lerp).
- Uji: 29 berkas, 2805 pemeriksaan, 0 gagal; smoke test lulus.

## 2026-11-18 (85) — Pengaturan aksesibilitas tambahan (D-045, teknis)

- Pengaturan baru kategori Aksesibilitas: high_contrast (UiTheme.build(scale, kontras)), message_duration (pengali durasi pesan HUD; pesan sangat singkat tidak diubah), show_hints (petunjuk tutorial dibisukan tapi tetap tercatat dilihat). text_scale sudah ada sebelumnya. GameDisplay membangun ulang tema saat skala atau kontras berubah.
- Belum: mode buta warna (palet/bentuk penanda peta), target sentuh lebih besar, kurangi gerak kamera, getar, teks-ke-suara, remap kontrol (D-045 detail terbuka).
- Uji: 29 berkas, 2834 pemeriksaan, 0 gagal; smoke test lulus.

## 2026-11-18 (86) — Refactor world_start.gd -> WorldSites

- Pemilik meminta lanjut; dipilih merapikan utang teknis. Semua titik interaksi buatan baru (stasiun crafting, titik kumpul, monster, papan guild, gua, tukang upgrade, kemah teman + pengikut) dipindah ke WorldSites (node anak "Sites"); world_start.gd tetap memegang HUD, sesi, pemain, NPC, wilayah, simpan/muat, dan pengumuman. class_name WorldStart ditambahkan agar akses bertipe.
- Perilaku sama: 29 berkas, 2834 pemeriksaan, 0 gagal; smoke lulus; screenshot papan guild/kemah/tukang diperiksa.
- Masih besar: world_start.gd ~1060 baris (pertanian, NPC, wilayah, memancing/ternak, toko masih di dalamnya) — bisa dipecah lagi bertahap.

## 2026-11-18 (87) — Kustomisasi karakter dasar + perapian posisi (D-041, teknis)

- CharacterState: grup pilihan dari data (warna kulit, warna pakaian), putar/atur, simpan/muat opsional (save lama = bawaan) dengan rollback; diterapkan ke penanda pemain (kapsul = pakaian, kepala+hidung = kulit). Cermin uji di desa (menu daftar, ketuk untuk ganti).
- Perapian: dapur uji digeser (z 0.5 -> 3.0) dan papan guild (z -8 -> -6) agar tidak menumpuk dengan semak/pagar.
- Belum: nama karakter (butuh input teks), rambut/wajah/aksesori, pakaian terbuka lewat progres, pratinjau berputar; semua menunggu model B-001 dan keputusan D-041 yang terbuka.
- Uji: 30 berkas, 2888 pemeriksaan, 0 gagal; smoke test lulus.

## 2026-11-18 (88) — Pertarungan waktu-nyata dasar (D-013, teknis)

- Pemilik memilih "Pertarungan waktu-nyata". RealtimeCombat (jeda serang pemain + keputusan monster idle/chase/wait/attack dari delta waktu), CombatState.retaliate/heal_spawn dan attack(counter=false), FarmingSession.strike_monster/monster_retaliate. WorldSites.update_monsters: monster bergerak mengejar, menyerang berkala, kembali ke "home" dan pulih bila pemain jauh/lewat batas kejar; berhenti saat waktu dijeda atau menu terbuka. Gua tetap tukar-pukul per ketukan.
- Nilai waktu-nyata (jeda 0.5/1.2 dtk, jarak kejar 7, serang 1.9, kecepatan 2.6, batas 16) SEMENTARA di combat_config.json.
- Belum: tombol serang khusus, animasi/efek kena, dodge/blok, knockback, tabrakan monster dengan dunia, pola serangan berbeda, AI selain mengejar (D-013/D-019/D-058 detail terbuka).
- Uji: 31 berkas, 2919 pemeriksaan, 0 gagal; smoke test lulus.

## 2026-11-18 (89) — Perlengkapan + status efek dasar (D-058/D-059, teknis)

- EquipmentState (slot weapon/armor; item dipasang keluar dari Tas, dilepas kembali; tukar mengembalikan item lama; tas penuh = batal). StatusState (poison/regen dot per menit game, weaken pengubah serangan; racun tidak mematikan; penyegaran memperpanjang, tidak menumpuk). Efek turunan ke CombatState (equip_attack/equip_defense/status_attack).
- Monster boar meracuni (35%), bos melemahkan (30%) lewat retaliate waktu-nyata/tukar-pukul; gua belum menimbulkan status. Penawar (menyembuhkan racun) dan ramuan pemulih (memberi regen) dapat dibuat di meja ramuan.
- from_dict FarmingSession dirombak: bagian opsional (karakter/teman/upgrade/perlengkapan/status) dimuat lewat satu loop dengan pemulihan penuh bila gagal; save lama tanpa kunci = bagian direset.
- PERUBAHAN PERILAKU: serangan pemain kini dari senjata TERPASANG, bukan item di Tas; tes lama diperbarui.
- Belum: efek status lain (D-059 daftar resmi), ikon status, durasi tampil, status dari lingkungan/makanan, zirah beragam, tingkat perlengkapan, toko perlengkapan (item punya harga, belum dijual).
- Uji: 32 berkas, 3078 pemeriksaan, 0 gagal; smoke test lulus.
