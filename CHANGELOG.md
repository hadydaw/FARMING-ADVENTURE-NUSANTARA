# Changelog

Format mengikuti [Keep a Changelog](https://keepachangelog.com/id-ID/1.1.0/); versi mengikuti SemVer.

## [Belum dirilis]

### Ditambahkan
- Pencapaian dan petunjuk tutorial dasar (sementara): 6 pencapaian dan 3 petunjuk berbasis statistik, diumumkan sekali, tersimpan; 31 uji tambahan.
- Dungeon dasar + bos (sementara): gua uji di kawasan kuno, 3 ruangan dibangkitkan deterministik dari seed+hari, bos di ruang akhir, hadiah dan penutupan beberapa hari, pingsan/keluar, simpan/muat run berjalan; 23 uji tambahan.
- Quest dan guild dasar (sementara): papan guild uji, 4 quest (kumpul/kalahkan), batas quest aktif, peringkat dari poin, hadiah uang/EXP/item semua-atau-tidak, simpan/muat dengan rollback; 44 uji tambahan.
- Pertarungan dasar + EXP/level (sementara): 2 monster uji dengan drop deterministik, 4 titik spawn di hutan/kawasan kuno, serangan tukar-pukul bertarif stamina, pingsan (uang -10%, HP pulih separuh, kembali ke desa), pedang uji menambah serangan, simpan/muat; 40 uji tambahan.
- Crafting/memasak/ramuan dan pengumpulan (sementara): 3 stasiun uji, 5 resep, node herbal/batu per wilayah dengan respawn harian, pakai item dari Tas (makanan/ramuan memulihkan meter), menu daftar serbaguna di HUD; 45 uji tambahan.
- Peta dan wilayah (sementara): 3 wilayah uji dengan gerbang, penguncian wilayah, minimap + peta penuh, wilayah ditemukan, simpan membawa wilayah/posisi; 129 uji tambahan.
- Ekonomi dan toko dasar (sementara): uang, harga musiman dengan penurunan permintaan, beli/jual, kios uji dengan panel Beli/Jual, simpan/muat uang; 151 uji tambahan.
- Memancing dasar (deterministik, umpan, kolam uji) dan peternakan dasar (pakan harian, pertumbuhan, hasil ternak); data generik sementara; 227 uji tambahan.
- Fondasi NPC (sementara): jadwal harian menurut jam/cuaca, dialog bersyarat dan bercabang dengan UI, hubungan (friendship), 2 NPC uji generik, simpan/muat sosial; 150 uji tambahan.
- Tidur dan pergantian hari bertahap, vitalitas dasar (HP/Stamina/Mana) dengan biaya stamina aksi pertanian, tempat tidur uji, HUD vitalitas; data sementara, 102 uji tambahan.
- Cuaca dasar (sementara): cuaca harian deterministik per seed/hari/musim, hujan menyiram tanaman, HUD cuaca, 58 uji tambahan.
- HUD sementara: tombol Simpan/Muat (slot 0: waktu + pertanian) dan panel Tas berkisi 24 slot; 45 uji tambahan.
- Milestone 3 teknis (sementara): inventaris slot, petak lahan, olah/tanam/siram/tumbuh/panen per hari permainan, simpan/muat status pertanian, 12 petak uji di dunia awal dengan penanda berlabel, data uji bertanda provisional, 230 uji tambahan.
- Dunia awal uji (Milestone 2, sementara): menu "Mulai (uji dunia awal)", dunia 60x60 m dari data, 64 props pilot, PlayerController (gerak relatif kamera, tabrakan), kamera mengikuti, interaksi "Periksa", HUD teks (waktu, musim, fase, prompt). Aset visual sementara dan berlabel; 77 uji tambahan.
- Pilot mesh Opsi A (O-011): MeshBuilder (mesh kustom lewat kode, ekspor .glb), 7 props pilot B-003 (bukan aset final), layar Pilot Mesh, 98 uji tambahan, laporan `docs/assets/PILOT_MESH_OPSI_A.md`.
- Milestone 2 (sebagian, teknis): GameClock/GameTime (jam, kalender, musim, fase, jeda, simpan/muat, seed harian), CameraRig adaptif (3 profil konteks, zoom/rotasi berbatas), MovementMath, Interactable/InteractionSensor, tabel data waktu/kamera/interaksi, layar Uji Sistem, 207 uji tambahan. Menunggu aset visual dari ChatGPT.
- Spesifikasi aset M2 (B-001..B-007) untuk 3D Stylized dan analisis workflow 3D (O-010).
- Bahasa bawaan Inggris.
- Milestone 1 (0.2.0): data registry JSON, pengaturan skema + simpan atomik, input Android (joystick, tombol aksi, area aman), SceneManager, menu utama, layar Pengaturan, layar diagnostik, tema UI, bus audio, lokalisasi id/en, 383 uji unit otomatis.
- Dokumen workflow produksi (O-009), rencana implementasi, dan dokumen aset di `docs/assets/`.
- Fondasi proyek: repo, struktur direktori, dokumentasi (GDD, Technical Architecture, Backend Design, Build & Release, Roadmap, Development Rules).
- Proyek Godot 4.7.2: renderer Compatibility, landscape, lokalisasi id/en, layar boot 3D.
- Inti: `SaveService` (simpan lokal ber-checksum), `BackendClient` (antarmuka), `AppInfo`.
- Pipeline GitHub Actions: uji fondasi, build APK dev, pre-release `dev-latest`, rilis bertanda tangan via tag.
