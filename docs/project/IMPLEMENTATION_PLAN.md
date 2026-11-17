# Rencana Implementasi (Release Scope O-008)

Status: berlaku sejak keputusan "Mulai Pembuatan Game" (2026-11-17). Tidak mengubah keputusan resmi.

## 1. Milestone

| Milestone | Isi | Status |
|---|---|---|
| M1 Project Foundation | Struktur Godot, konfigurasi Android, landscape, input Android, scene utama + pergantian scene, lokalisasi id/en, pengaturan dasar, arsitektur data | Selesai teknis (uji otomatis); menunggu uji perangkat fisik oleh pemilik |
| M2 Playable Foundation | Pemain, gerak/animasi, kamera, interaksi objek, dunia awal, waktu/kalender (D-055), HUD dasar | **Sebagian**: dunia uji sementara (60x60 m, 64 props pilot, pemain penanda berlabel, tabrakan, interaksi, HUD teks) bisa dimainkan lewat menu "Mulai (uji dunia awal)"; selesai (uji otomatis) GameClock/GameTime, CameraRig, MovementMath, Interactable/InteractionSensor, tabel data, layar Uji Sistem. **Menunggu aset ChatGPT (B-001..B-007)**: model/animasi pemain, dunia awal, HUD visual |
| M3 Core Farming | Petak, mencangkul, menanam, menyiram, pertumbuhan, panen, inventaris/item | Menunggu M2 dan aset C-001..C-006 |
| Lanjut | Sesuai tabel Release Scope O-008 | Belum dimulai |

Setiap milestone: uji otomatis lulus, APK dev dipublikasikan, changelog + cara uji di HP. Uji perangkat fisik tidak diklaim sebelum pemilik menguji.

## 2. Klasifikasi TBD T1 sampai T20

| TBD | Kelas | Tindakan |
|---|---|---|
| T1 | Non-blocker M1-M3 | Antarmuka identitas yang aman dan dapat diperluas (lihat §3); tidak mengimplementasi pemulihan spekulatif |
| T2 | Non-blocker M1-M3 | Idem; tidak membuat identitas baru diam-diam saat sesi hilang |
| T3 | Non-blocker | Perlu perangkat nyata, saat Cloud Save |
| T4 | Non-blocker | Saat Cloud Save |
| T5 | Non-blocker | Saat Cloud Save |
| T6 | Deferred | Transaksi nanti |
| T7 | Deferred | Transaksi kosmetik nanti |
| T8 | Non-blocker M1-M3 | Companion setelah M3 |
| T9 | **Blocker untuk fitur romansa** | Hanya fondasi sistem hubungan; tidak membuat kandidat |
| T10 | **Blocker untuk isi wilayah** | Hanya fondasi sistem wilayah; tidak membuat lore spiritual |
| T11 | Blocker untuk dungeon | Setelah M3 |
| T12 | **Blocker untuk NPC resmi** | Hanya fondasi sistem NPC; tidak membuat daftar NPC resmi |
| T13 | Non-blocker | Validasi 3/2/12 lewat estimasi dan uji; target tidak diubah diam-diam |
| T14 | Non-blocker M1-M3 | Ramuan setelah M3 |
| T15 | Non-blocker M1-M3 | Kustomisasi setelah M3 |
| T16 | Deferred | Cerita |
| T17 | Non-blocker | D-051 saat sistem terkait |
| T18 | Non-blocker | Diukur lewat APK dev nyata |
| T19 | Deferred | P-006 |
| T20 | Blocker untuk isi wilayah | Sama dengan T10 |

## 2b. Nilai teknis sementara (bukan keputusan desain)

Berkas data bertanda `"provisional": true`: `time_config.json` (kecepatan jam, panjang hari/musim, fase), `camera_profiles.json`, `camera_limits.json`, `interaction_types.json`. Panjang hari/musim/fase, kecepatan jam, jarak/sudut kamera, dan batas zoom/rotasi masih **TERBUKA** di D-055/D-030/D-033. Perilaku waktu di latar belakang: sementara berhenti (belum diputuskan).

Bila sebuah blocker menghalangi pekerjaan, Claude menyiapkan sistem generik dan mengajukan pertanyaan terfokus, bukan mengarang konten resmi.

## 3. Desain integrasi identitas (T1/T2)

- Antarmuka `IdentityProvider` (belum ada implementasi nyata) dengan operasi: `current_identity()`, `has_session()`, `link_account()`.
- `BackendClient` tidak membuat identitas baru otomatis ketika sesi hilang; ia melaporkan status `session_lost` ke UI dan menyimpan data lokal.
- Save lokal tidak diikat ke identitas sampai aturan T2 diputuskan.
- Catatan fakta Supabase: pengguna anonim kehilangan akses setelah sign-out/hapus data/perangkat lain; penautan lewat `updateUser` atau `linkIdentity`; RLS memakai `auth.uid()`; sign-in anonim harus diaktifkan dan dibatasi laju (verifikasi saat implementasi).
