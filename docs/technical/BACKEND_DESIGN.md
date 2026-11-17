# Rancangan Backend — Farming Adventure Nusantara

> **Versi:** 0.5 (+ D-014 Single-Player Online, D-044 Cloud Save, D-050 Keamanan) · **Status:** RANCANGAN. Supabase disetujui sebagai pilihan awal (O-003); belum ada kode server dan belum ada akun yang dibuat. Nakama ditunda. Implementasi baru setelah desain sistem online disepakati.
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
     └── SaveService (cache lokal, bukan mode offline)
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

## 5b. Konsekuensi D-051 (Ketahanan Koneksi; rancangan saja)

- Server mendukung **operasi tulis idempoten** (ID transaksi + revisi), sehingga percobaan ulang klien tidak menggandakan hasil.
- Klien menyimpan **antrean perubahan tertunda** (bukan mode offline penuh) dan mengirimnya saat koneksi pulih; konflik diselesaikan lewat revisi (§5a).
- Kode galat dibedakan antara sementara dan permanen agar klien tahu kapan mencoba ulang; status server (gangguan) dapat dikomunikasikan ke klien.
- Pemulihan sesi bergantung pada identitas pemain; mekanisme identitas (Tahap 35, P-006) **DEFERRED** dan tidak diasumsikan.
- Selang, batas, masa tenggang, dan perilaku gangguan berkepanjangan belum ditetapkan.

## 6. Keamanan dan Privasi

- Autentikasi: awalnya identitas anonim dengan opsi menautkan email/akun Google (arahan pemilik, draft; lihat §6b; metode penautan belum diputuskan).
- Data pribadi minimum. Perlu kebijakan privasi sebelum rilis publik yang mengumpulkan akun.
- Kunci/rahasia server disimpan di pengaturan penyedia dan GitHub Secrets, **tidak pernah** di repo.
- Pembatasan laju (rate limit) dan validasi ukuran payload di server.

## 6b. Identitas anonim untuk Rilis Awal (disetujui pemilik, O-008; rancangan saja)

- Arahan pemilik: identitas anonim otomatis lewat **Supabase Anonymous Auth** saat pertama bermain, tanpa username/kata sandi; siapkan penautan akun untuk login permanen (Tahap 35, DEFERRED).
- Pengguna anonim memakai peran `authenticated`; RLS berbasis `auth.uid()` dan, bila perlu, klaim `is_anonymous`. Penautan (`updateUser` untuk email/telepon, `linkIdentity` untuk OAuth dengan manual linking aktif) mempertahankan ID pengguna sehingga save tetap.
- **Kehilangan akses:** hapus aplikasi, hapus data, atau ganti perangkat sebelum penautan membuat save cloud tidak dapat diakses. Pemulihan tidak boleh diasumsikan. Klien tidak boleh diam-diam membuat identitas baru saat sesi hilang (D-051); perlakuan save lokal (T2), pencadangan token Android (T3), anti-penyalahgunaan dan pembersihan identitas terlantar (T4) belum ditetapkan.
- Perlu peringatan risiko untuk pemain (Indonesia/English). Rincian di `../design/RELEASE_SCOPE_PROPOSAL_P007.md` §5 dan §7.

## 6a. Konsekuensi D-050 (Keamanan dan Perlindungan Data; rancangan saja)

- **Prinsip:** klien tidak dipercaya; validasi, audit, dan pemantauan di server; keamanan adalah fitur dasar untuk semua pemain, **tanpa biaya bagi pemain**; biaya layanan ditanggung pengelola. Tidak mengubah D-014 (single-player online) maupun D-047 (monetisasi kosmetik).
- **Validasi di server:** tiap `push_save` dan permintaan memeriksa skema, ukuran, rentang, ID valid, dan **kewajaran perubahan** terhadap revisi sebelumnya memakai data konten berversi (`content_version`); operasi bernilai tinggi lewat **Edge Function** yang menerima niat dan menghitung hasil di server; penolakan tidak menimpa data sah.
- **Database:** RLS pada semua tabel; peran terpisah (klien/fungsi server/admin) dengan hak minimum; constraint dan fungsi di database; tanpa SQL dinamis dari klien; enkripsi saat disimpan (penyedia) dan TLS saat transit; cadangan dan uji pemulihan; rotasi kunci; lingkungan dev/staging/prod terpisah dan **tanpa data produksi di lingkungan uji**.
- **Audit log:** tabel append-only (waktu server, `user_id` pseudonim, jenis aksi, hasil, ID transaksi, versi, kode alasan) tanpa isi save penuh dan tanpa data pribadi berlebih; akses terbatas peran; klien tidak dapat menulis atau mengubahnya; retensi menunggu keputusan.
- **Anti-cheat dan monitoring:** penanda anomali (invarian, laju, transaksi ganda, versi/tanda tangan ganjil, anomali waktu) disimpan sebagai sinyal untuk ditinjau dengan jalur pemulihan dan banding; metrik dan peringatan (penolakan validasi, lonjakan permintaan, penolakan RLS) ke pengelola; rate limit dan batas payload.
- **Biaya:** validasi ringan di setiap push dan pemeriksaan berat hanya untuk operasi bernilai tinggi atau anomali; estimasi biaya dan batas paket layanan dihitung saat implementasi.
- **Menunggu:** desain akun/login (Tahap 35, P-006, PENDING), kebijakan privasi dan hak data, ambang deteksi, tindakan terhadap pelanggaran, retensi log. Belum ada kode server, akun, atau proyek Supabase; tidak ada rahasia di repositori.

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
4. UI indikator koneksi/sinkron + penanganan konflik. (UI masuk akun termasuk Tahap 35, P-006, **DEFERRED** sampai persiapan publikasi Google Play; bukan syarat Rilis Awal via GitHub Releases.)
5. Uji sinkron: putus koneksi→pemulihan koneksi, dua perangkat, konflik. (Game tetap online; cache lokal bukan mode offline penuh, D-014/D-044/D-051.)
