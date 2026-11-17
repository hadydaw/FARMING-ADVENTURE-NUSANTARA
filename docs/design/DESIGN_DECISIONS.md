# Catatan Keputusan Desain dan Teknis

Seri ID: **D-xxx** = keputusan desain game (nomor sesuai tahap desain bersama ChatGPT); **O-xxx** = persetujuan pemilik atas hal teknis/operasional; **T-xxx** = keputusan teknis rutin; **P-xxx** = menunggu pemilik.
Catatan 2026-11-17: entri yang sebelumnya bernomor D-013…D-019 (engine, package ID, backend, kunci rilis, lisensi, uji HP, larangan fitur) dinomori ulang menjadi **O-001…O-007** agar ID **D-013** dipakai untuk sistem pertarungan sesuai instruksi pemilik. Isinya tidak berubah.

Aturan: keputusan berstatus **Ditetapkan pemilik** tidak boleh diubah tanpa persetujuan eksplisit pemilik proyek.
Keputusan **Teknis (rutin)** dibuat Claude secara mandiri dan boleh ditinjau/diganti dengan alasan tercatat (tambahkan entri baru yang menggantikan, jangan menghapus riwayat).

## A. Keputusan yang ditetapkan pemilik proyek

| ID | Keputusan | Tanggal |
|---|---|---|
| D-001 | Proyek **baru dari nol**; bukan lanjutan/pengembangan proyek lama. Tidak memakai kode, aset, atau dokumentasi proyek lama. | 2026-11-17 |
| D-002 | Judul resmi: **Farming Adventure Nusantara** (tidak diganti). | 2026-11-17 |
| D-003 | Genre: Farming Simulation, Life Simulation, Adventure RPG, Action RPG, Dungeon Exploration. | 2026-11-17 |
| D-004 | Platform utama: **Android**. Orientasi **landscape**. | 2026-11-17 |
| D-005 | Distribusi: APK Android; source di repository GitHub; APK publik lewat **GitHub Releases**; build lewat **GitHub Actions**. | 2026-11-17 |
| D-006 | Koneksi: **online**. Backend **terpisah** dari GitHub (GitHub bukan server game). | 2026-11-17 |
| D-007 | Bahasa: **Indonesia** utama, **Inggris** kedua. | 2026-11-17 |
| D-008 | Gaya visual: **3D Stylized** untuk seluruh dunia, lingkungan, karakter, monster, bangunan, tanaman, dan objek. **Dikonfirmasi pemilik sebagai keputusan Tahap 1 (Visual Game), 2026-11-17.** | 2026-11-17 |
| D-009 | Sistem dunia **Progressive World Unlock**: mulai di satu desa awal; banyak wilayah terbuka bertahap; syarat bisa berupa level karakter, rank petualang, quest, progres cerita; tiap wilayah dapat punya desa, kota, sumber daya, monster, dan dungeon. **Dikonfirmasi pemilik sebagai keputusan Tahap 2 (Sistem Dunia): pemain mulai dari satu desa; wilayah baru terbuka bertahap berdasarkan perkembangan permainan.** | 2026-11-17 |
| D-010 | Konsep: kehidupan bertani ala Story of Seasons + petualangan RPG (cakupan aktivitas pemain lengkap di GDD bagian 3). | 2026-11-17 |
| D-011 | Rank petualang direncanakan: F, E, D, C, B, A, S, SS, SSS. | 2026-11-17 |
| D-012 | Tahap pertama hanya fondasi (repo, struktur, dokumen, Android, pipeline). **Belum ada implementasi gameplay.** Sistem pertarungan, multiplayer, dungeon, farming, NPC, dll. ditentukan dulu lewat tahap desain bersama ChatGPT. | 2026-11-17 |

| O-001 | Engine **Godot 4.7.2 + GDScript** disetujui. "Android Native" = aplikasi APK sungguhan yang dipasang langsung di HP; **bukan** WebView, game browser, atau PWA. | 2026-11-17 |
| O-002 | Package ID resmi **`com.hadydaw.farmingadventurenusantara`**; tidak diubah tanpa persetujuan pemilik. | 2026-11-17 |
| O-003 | **Supabase** disetujui sebagai pilihan awal backend: registrasi/login, akun, Cloud Save, sinkron progres, database pemain. **Nakama tidak diimplementasikan**; dievaluasi hanya bila multiplayer real-time diputuskan. Tidak ada implementasi backend/gameplay online sebelum desain sistem online disepakati. | 2026-11-17 |
| O-004 | Rilis resmi memakai signing key production khusus. Private keystore tidak boleh di repo publik; tanpa password/kredensial di source; kunci dicadangkan aman; key dev dan production dipisah; tidak ada rilis publik bertanda production sebelum konfigurasi keamanan selesai dan pemilik mengizinkan. | 2026-11-17 |
| O-005 | Lisensi: **proprietary / All Rights Reserved**. Source boleh dilihat, tidak boleh disalin/diubah/didistribusikan tanpa izin (berkas `LICENSE`). | 2026-11-17 |
| O-006 | Pengujian APK di HP dilakukan pemilik; status "lulus di HP" hanya dicatat setelah pemilik melapor. | 2026-11-17 |
| O-007 | Larangan sampai desain disepakati bersama ChatGPT: gameplay, pertarungan, farming, dungeon, multiplayer, dan fitur lain yang belum disepakati. | 2026-11-17 |

## A2. Keputusan desain resmi dari tahap desain (LOCKED)

Hanya keputusan yang sudah diberikan pemilik kepada Claude yang tercatat di sini. Keputusan Tahap 1 (Visual) dan Tahap 2 (Dunia) sudah tercatat sebagai D-008 dan D-009 (bagian A); D-010 s.d. D-012 adalah konsep, rank, dan batas tahap awal. Bila ada keputusan Tahap 3 dan seterusnya selain D-013/D-014, kirim agar dicatat.

### D-013 — Sistem Pertarungan *(APPROVED / LOCKED, 2026-11-17)*
Pilihan: **D. Kombinasi Semua Sistem**. Sistem pertarungan resmi mencakup:
1. Real-time Action Combat
2. Normal Attack dan Combo Attack
3. Active Skills dengan sistem Cooldown
4. Magic dan Elemental Skills
5. Berbagai jenis senjata
6. Dodge dan Evasion
7. Block dan Defense
8. Parry dan Counter Attack
9. Skill Tree dan perkembangan kemampuan karakter

Status implementasi: **belum dimulai** (menunggu seluruh tahap desain selesai). Detail angka/aturan tiap komponen (damage, elemen, daftar senjata, jendela parry, struktur skill tree, kontrol sentuh) **belum ditetapkan**.

### D-014 — Sistem Multiplayer *(APPROVED / LOCKED, 2026-11-17, Tahap 4)*
Pilihan: **A. Single-Player Online.**
- Game dimainkan sendiri; koneksi internet **wajib**.
- Setiap pemain punya akun; registrasi dan login.
- Cloud Save dan sinkronisasi progres pemain.
- Dunia dan NPC adalah bagian dari **progres pribadi** pemain.
- **Tidak ada** multiplayer real-time.
- **Tidak ada** kunjungan ladang pemain lain.
- **Tidak ada** co-op dungeon.

Dampak: syarat "evaluasi Nakama bila multiplayer real-time" pada O-003 tidak terpicu; Nakama tidak diperlukan. Isi O-003 tidak diubah. Implementasi backend dan gameplay belum dimulai.

### D-015 — Sistem Kehidupan *(APPROVED / LOCKED, 2026-11-17, Tahap 5)*
Pilihan: **B. Kehidupan Lengkap ala Story of Seasons.** Fitur yang ditetapkan:
1. Farming dan pertanian
2. Peternakan dan pemeliharaan hewan
3. Memancing
4. Memasak
5. Pergantian musim
6. Festival dan acara desa
7. Ekonomi dan perdagangan
8. Pengembangan rumah
9. Pengembangan dan perluasan ladang

**Batasan — BELUM ditetapkan (jangan dianggap disetujui):** hubungan romantis, pernikahan, membangun keluarga, memiliki anak.

Catatan: ID D-015 tersedia saat dicatat (tidak ada bentrokan). Detail aturan tiap fitur (daftar tanaman/hewan, panjang musim, resep, harga, jadwal festival, tahap upgrade) belum ditetapkan. Implementasi belum dimulai.

### D-016 — Sistem Dungeon *(APPROVED / LOCKED, 2026-11-17, Tahap 6)*
Pilihan: **D. Kombinasi Dungeon Tetap dan Acak.**

1. **Story Dungeon:** desain dan tata letak ruangan **tetap**; terhubung dengan cerita atau quest; monster dan boss khusus; hadiah penyelesaian.
2. **Exploration Dungeon:** tata letak ruangan **acak**; penempatan monster dan tantangan dapat bervariasi; menyediakan material dan harta karun; dapat dijelajahi berulang kali.
3. **Fitur tambahan:** dungeon rahasia, boss spesial, hadiah unik.

Detail (jumlah lantai/ruangan, algoritma acak, tabel loot, kesulitan, syarat dungeon rahasia, daftar boss) belum ditetapkan. Implementasi belum dimulai. ID D-016 tersedia saat dicatat (tanpa bentrokan).

## B. Keputusan teknis rutin (diputuskan Claude, dapat ditinjau)

| ID | Keputusan | Alasan singkat | Dokumen |
|---|---|---|---|
| T-001 | Engine: **Godot 4.7.2 (stable)**, bahasa **GDScript**. | Gratis/open source (MIT), ekspor APK native arm64, build CI mudah tanpa lisensi, ringan untuk 3D stylized di HP. | TECHNICAL_ARCHITECTURE §2 |
| T-002 | Renderer: **GL Compatibility** (OpenGL ES 3.0). | Jangkauan perangkat terluas dan perilaku stabil di GPU HP menengah; cukup untuk 3D stylized. Bisa ditinjau ke renderer Mobile (Vulkan) bila ada kebutuhan visual. | TECHNICAL_ARCHITECTURE §3 |
| T-003 | Ekspor Android memakai **template prebuilt (tanpa Gradle)**, arsitektur **arm64-v8a** saja. | Build CI lebih cepat dan sederhana; arm64 mencakup hampir semua HP modern. Gradle build dipakai nanti bila perlu plugin native. | BUILD_AND_RELEASE §2 |
| T-004 | Package ID: `com.hadydaw.farmingadventurenusantara`. | Harus unik dan **tidak bisa diganti** setelah rilis publik pertama. Disetujui pemilik (O-002). | BUILD_AND_RELEASE §3 |
| T-005 | Build dev memakai paket `.dev` dan **kunci dev publik** yang di-commit; rilis memakai **kunci rilis rahasia** dari GitHub Secrets. | APK dev tetap bisa saling meng-update tanpa rahasia; kunci publik tidak boleh dipakai untuk rilis. | BUILD_AND_RELEASE §4 |
| T-006 | Penyimpanan lokal: JSON ber-checksum, slot, tulis atomik + cadangan, dengan `revision` untuk sinkronisasi. | Tahan crash, siap sinkron ke backend. | TECHNICAL_ARCHITECTURE §5 |
| T-007 | Backend: terpisah; **usulan** Supabase (Postgres + Auth + Edge Functions) untuk fase online pertama; akses lewat antarmuka `BackendClient` agar bisa diganti (mis. Nakama bila multiplayer real-time dipilih). | Tanpa server sendiri di awal; migrasi mudah. **Disetujui pemilik (O-003); akun dibuat saat fase online.** | BACKEND_DESIGN |
| T-008 | Struktur repo: proyek Godot di root; konten game di `res://game/`; dokumen di `docs/`; skrip CI di `tools/ci/`; backend di `backend/`. | Pipeline sederhana; pemisahan jelas. | README |
| T-009 | Teks game via kunci terjemahan CSV (`id`, `en`); fallback `id`. | D-007. | TECHNICAL_ARCHITECTURE §6 |

## C. Keputusan yang masih menunggu pemilik

| ID | Pertanyaan | Dibutuhkan untuk | Status |
|---|---|---|---|
| P-001 | Package ID | Rilis publik | **Selesai** (O-002) |
| P-002 | Buat keystore production dan isi 3 GitHub Secrets (`docs/technical/SIGNING_GUIDE.md`); beri izin sebelum rilis production pertama | Rilis bertanda tangan | Menunggu |
| P-003 | Penyedia backend | Fase online | **Selesai** (O-003, diperkuat D-014); akun Supabase dibuat saat fase online dimulai |
| P-004 | Lisensi | Publikasi source | **Selesai** (O-005) |
| P-005 | Hasil uji APK dev di HP (`docs/project/TESTING_APK.md`) | Menutup Fase 0 | Menunggu |
