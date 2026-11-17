# Changelog

Format mengikuti [Keep a Changelog](https://keepachangelog.com/id-ID/1.1.0/); versi mengikuti SemVer.

## [Belum dirilis]

### Ditambahkan
- Milestone 1 (0.2.0): data registry JSON, pengaturan skema + simpan atomik, input Android (joystick, tombol aksi, area aman), SceneManager, menu utama, layar Pengaturan, layar diagnostik, tema UI, bus audio, lokalisasi id/en, 383 uji unit otomatis.
- Dokumen workflow produksi (O-009), rencana implementasi, dan dokumen aset di `docs/assets/`.
- Fondasi proyek: repo, struktur direktori, dokumentasi (GDD, Technical Architecture, Backend Design, Build & Release, Roadmap, Development Rules).
- Proyek Godot 4.7.2: renderer Compatibility, landscape, lokalisasi id/en, layar boot 3D.
- Inti: `SaveService` (simpan lokal ber-checksum), `BackendClient` (antarmuka), `AppInfo`.
- Pipeline GitHub Actions: uji fondasi, build APK dev, pre-release `dev-latest`, rilis bertanda tangan via tag.
