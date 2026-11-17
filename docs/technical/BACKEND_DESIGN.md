# Rancangan Backend — Farming Adventure Nusantara

> **Versi:** 0.3 (+ D-014 Single-Player Online) · **Status:** RANCANGAN. Supabase disetujui sebagai pilihan awal (O-003); belum ada kode server dan belum ada akun yang dibuat. Nakama ditunda. Implementasi baru setelah desain sistem online disepakati.
> Prinsip tetap (D-006): **GitHub bukan server game.** Backend adalah layanan terpisah.

## 1. Tujuan

1. Akun pemain (identitas).
2. **Sinkronisasi data pemain** (progres tersimpan di server, bisa dipulihkan/pindah HP).
3. Validasi hal yang rawan curang (ekonomi, rank) saat fitur online mulai ada.
4. Dunia dan NPC pemain disimpan sebagai bagian progres pribadi (satu pemain = satu dunia; tidak ada dunia bersama).

Di luar cakupan (D-014): multiplayer real-time, kunjungan ladang pemain lain, co-op dungeon. Juga di luar cakupan: pembayaran, moderasi chat.

## 2. Opsi Penyedia

| Opsi | Cocok untuk | Kelebihan | Kekurangan |
|---|---|---|---|
| **Supabase** (Postgres + Auth + Edge Functions + REST) | Akun, simpan/sinkron data, validasi sederhana | Paket gratis, tanpa mengelola server, SQL standar (portabel), Row Level Security | Bukan server game real-time; batas paket gratis |
| **Nakama** (server game open source, self-host) | Multiplayer, matchmaking, leaderboard, obrolan | Fitur game lengkap, SDK Godot | Perlu VPS (biaya) dan perawatan |
| Server sendiri (Go/Node + Postgres) | Kontrol penuh | Fleksibel | Biaya + perawatan terbesar; dibangun dari nol |

**Usulan (T-007):** mulai dengan **Supabase** untuk fase online pertama (akun + sinkronisasi save). D-014 memutuskan Single-Player Online tanpa real-time, jadi **Nakama tidak diperlukan**; dievaluasi ulang hanya jika keputusan D-014 diubah pemilik. Data inti tetap di Postgres sehingga portabel. **Disetujui pemilik (O-003).** Pembuatan akun dilakukan saat fase online dimulai.

## 3. Batas Klien–Server

```
Game (Godot)  ──►  BackendClient (antarmuka)  ──►  Adapter penyedia  ──►  HTTPS API
     │                                                                   (Supabase/Nakama/…)
     └── SaveService (lokal, offline-first)
```

- Gameplay **tidak** memanggil jaringan langsung; hanya lewat `BackendClient` (`game/core/backend_client.gd`).
- Metode awal: `sign_in()`, `push_save(slot, envelope)`, `pull_save(slot)`.
- Semua komunikasi HTTPS; tidak ada rahasia server di dalam APK (hanya URL publik dan kunci publik/anon).

## 4. Model Data Awal (konseptual)

| Entitas | Kolom utama |
|---|---|
| `players` | `id`, `created_at`, `display_name`, `locale` |
| `saves` | `player_id`, `slot`, `revision`, `schema_version`, `game_version`, `payload` (JSON), `checksum`, `updated_at`, `device_id` |
| `devices` (opsional) | `id`, `player_id`, `last_seen_at` |

Kunci unik `saves(player_id, slot)`. Akses dibatasi per pemain (Row Level Security: pemain hanya melihat/ubah barisnya sendiri).

## 4a. Konsekuensi D-014

- Internet **wajib**: game memerlukan sesi akun aktif. Perilaku saat koneksi terputus saat bermain belum ditetapkan (pertanyaan desain terbuka); penyimpanan lokal tetap dipakai sebagai penyangga.
- Tiap pemain hanya mengakses datanya sendiri (Row Level Security): tidak ada kueri lintas pemain, sehingga model data lebih sederhana (tanpa tabel sosial/sesi multiplayer).
- Payload save mencakup keadaan dunia dan NPC pemain; ukuran payload dipantau (batas server ditentukan saat implementasi).

## 5. Sinkronisasi dan Konflik

- Klien menyimpan lokal dulu (selalu berhasil, offline-first), lalu `push_save` saat online.
- `push_save` menyertakan `base_revision`. Server menerima hanya bila `base_revision == revision server`; jika tidak → **konflik**: server mengembalikan snapshot server, klien menampilkan pilihan (pakai lokal / pakai server). Tidak ada penimpaan diam-diam.
- Data lokal tidak dipercaya untuk fitur kompetitif/ekonomi online; server yang menghitung/memvalidasi (detail menunggu desain).

## 6. Keamanan dan Privasi

- Autentikasi: awalnya login anonim/perangkat dengan opsi menautkan email/akun Google (detail saat implementasi).
- Data pribadi minimum. Perlu kebijakan privasi sebelum rilis publik yang mengumpulkan akun.
- Kunci/rahasia server disimpan di pengaturan penyedia dan GitHub Secrets, **tidak pernah** di repo.
- Pembatasan laju (rate limit) dan validasi ukuran payload di server.

## 7. Lingkungan

| Lingkungan | Dipakai untuk |
|---|---|
| `dev` | Pengembangan dan APK dev (`dev-latest`) |
| `prod` | Rilis publik |

Konfigurasi lingkungan (URL, kunci publik) disuntik saat build; belum diimplementasikan.

## 8. Langkah Implementasi (Fase online, lihat Roadmap)

1. Pemilik menyetujui penyedia dan membuat akun/proyek (P-003).
2. Skema database + kebijakan akses (migrasi SQL di `backend/`).
3. Adapter `BackendClient` untuk penyedia terpilih.
4. UI masuk akun + indikator sinkron + penanganan konflik.
5. Uji sinkron: offline→online, dua perangkat, konflik.
