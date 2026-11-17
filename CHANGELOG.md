# Changelog

Format mengikuti [Keep a Changelog](https://keepachangelog.com/id-ID/1.1.0/); versi mengikuti SemVer.

## [Belum dirilis]

### Ditambahkan
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
