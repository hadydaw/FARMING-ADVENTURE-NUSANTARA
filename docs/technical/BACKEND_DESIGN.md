# Rancangan Backend — Farming Adventure Nusantara

> **Versi:** 0.4 (+ D-014 Single-Player Online, D-044 Cloud Save) · **Status:** RANCANGAN. Supabase disetujui sebagai pilihan awal (O-003); belum ada kode server dan belum ada akun yang dibuat. Nakama ditunda. Implementasi baru setelah desain sistem online disepakati.
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

- Klien menyimpan lokal dulu sebagai penyangga (selalu berhasil), lalu `push_save` saat online. Ini **bukan** mode bermain offline: game tetap online-only (D-014, D-044).
- `push_save` menyertakan `base_revision`. Server menerima hanya bila `base_revision == revision server`; jika tidak → **konflik**: server mengembalikan snapshot server, klien menampilkan pilihan (pakai lokal / pakai server). Tidak ada penimpaan diam-diam.
- Data lokal tidak dipercaya untuk fitur kompetitif/ekonomi online; server yang menghitung/memvalidasi (detail menunggu desain).

## 5a. Konsekuensi D-044 (Cloud Save Hybrid Lengkap; rancangan saja)

- **Model data (konseptual):** tabel save per akun dengan kolom `user_id`, `slot`, `revision`, `schema_version`, `game_version`, `device_id`, `updated_at` (waktu server), `checksum`, `payload` (JSONB atau berkas terkompresi), serta tabel/arsip cadangan berversi dan tabel ID transaksi idempoten (jendela waktu). Tidak ada tabel lintas pemain (D-014).
- **Push:** `push_save(base_revision, payload, transaction_ids)`; server memvalidasi sesi, skema, ukuran, dan laju; menerima hanya bila `base_revision` = revisi server, lalu menaikkan revisi secara atomik (transaksi database). Bila tidak sama → respons konflik berisi ringkasan dan snapshot server. Pengiriman ulang dengan ID transaksi yang sama tidak berefek ganda.
- **Pull:** `pull_save` mengembalikan snapshot terbaru dan revisinya; klien memvalidasi sebelum menerima.
- **Cadangan dan pemulihan:** server menyimpan beberapa versi terakhir (jumlah dan retensi menunggu keputusan); pemulihan oleh pemain lewat klien, tidak menimpa tanpa konfirmasi.
- **Keamanan:** **Row Level Security** aktif pada semua tabel (`user_id = auth.uid()`; pemilik saja yang dapat membaca/menulis/menghapus datanya); klien memakai kunci publik dan token sesi; kunci service-role hanya di sisi server/pengaturan penyedia dan tidak pernah di repo atau aplikasi; rate limit dan batas payload; validasi dan penolakan data malformed; log audit minimal tanpa data pribadi berlebih; uji kebijakan RLS sebelum rilis. Kebijakan hapus akun dan data serta privasi menunggu desain (§6).
- **Validasi sisi server:** hal yang memengaruhi ekonomi atau rank kompetitif tidak dipercaya dari klien (§5); cakupan validasi menunggu desain.
- Belum ada kode server, akun, atau proyek Supabase yang dibuat; tidak ada rahasia di repositori.

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
