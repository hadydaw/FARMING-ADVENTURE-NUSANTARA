# Game Design Document (GDD) — Farming Adventure Nusantara

> **Versi dokumen:** 0.7 (+ D-013 Pertarungan, D-014 Single-Player Online, D-015 Sistem Kehidupan, D-016 Dungeon, D-017 Guild) · **Status:** Draf awal. Hanya memuat keputusan yang sudah ditetapkan pemilik proyek.
> Setiap bagian yang belum diputuskan ditandai **[BELUM DITETAPKAN]** dan akan diisi melalui tahap desain bersama ChatGPT sebelum implementasi.
> Daftar keputusan resmi: [`DESIGN_DECISIONS.md`](DESIGN_DECISIONS.md).

## 1. Identitas

| Item | Nilai |
|---|---|
| Judul resmi | **Farming Adventure Nusantara** (tidak boleh diubah) |
| Genre | Farming Simulation, Life Simulation, Adventure RPG, Action RPG, Dungeon Exploration |
| Platform utama | Android |
| Orientasi | Landscape |
| Koneksi | Online |
| Bahasa | Indonesia (utama), Inggris (kedua) |
| Gaya visual | 3D Stylized |
| Distribusi | APK Android via GitHub Releases; source code di GitHub |
| Bentuk aplikasi | APK Android sungguhan (bukan WebView/browser/PWA) |
| Lisensi | Proprietary / All Rights Reserved |

Proyek ini **baru dari nol**; tidak memakai kode, aset, atau dokumentasi proyek lama.

## 2. Konsep Utama

Game menggabungkan kehidupan bertani ala *Story of Seasons* dengan petualangan RPG. Pemain memulai di satu desa awal, menjalani kehidupan sehari-hari (bertani, memelihara hewan, memasak, membangun rumah, berinteraksi dengan NPC), lalu bergabung dengan **Adventurer Guild** untuk mengambil quest, berburu monster, menjelajahi dungeon, melawan boss, dan membuat equipment dari material yang dikumpulkan. Kemajuan petualangan tercermin pada **rank petualang**.

## 3. Aktivitas Pemain (cakupan yang ditetapkan)

Pemain dapat:

- Mengelola ladang
- Menanam dan memanen tanaman
- Memelihara hewan
- Memancing dan memasak
- Membangun dan mengembangkan rumah
- Berinteraksi dengan NPC
- Bergabung dengan Adventurer Guild
- Mengambil quest dan berburu monster
- Menjelajahi dungeon
- Melawan boss
- Mengumpulkan material dan membuat equipment
- Meningkatkan rank petualang

Rincian mekanik tiap aktivitas ada di bagian 6 dan **belum ditetapkan**.

## 4. Platform dan Kontrol

**Ditetapkan:** Android, landscape, layar sentuh (touchscreen).

**[BELUM DITETAPKAN]:**
- Skema kontrol (joystick virtual, tap-to-move, tombol aksi, gestur) — harus mampu menampung seluruh aksi pertarungan D-013 (serang/combo, skill, dodge, block, parry).
- Sudut dan perilaku kamera (follow, orbit, tetap).
- Dukungan kontroler eksternal.

## 5. Visual: 3D Stylized

**Ditetapkan:** seluruh dunia, lingkungan, karakter, monster, bangunan, tanaman, dan objek memakai pendekatan **3D Stylized yang konsisten**.

Implikasi teknis awal (lihat Technical Architecture): format model glTF 2.0 (`.glb`), material sederhana/toon, anggaran poligon per kelas objek, pencahayaan sederhana agar ringan di HP menengah.

**[BELUM DITETAPKAN]:** art direction rinci (palet warna, proporsi karakter, tingkat low-poly vs painterly, referensi visual), cara pembuatan/sumber aset.

## 6. Sistem Game

Untuk setiap sistem: **Ditetapkan** = sudah ada keputusan; **Belum** = menunggu tahap desain.

### 6.1 Progressive World Unlock (Ditetapkan)

- Pemain memulai di **satu desa awal**.
- Dunia memiliki **banyak wilayah** yang dapat dijelajahi.
- Wilayah baru **terbuka bertahap**.
- Pembukaan wilayah dapat bergantung pada **level karakter, rank petualang, quest, dan progres cerita**.
- Setiap wilayah dapat memiliki **desa, kota, sumber daya, monster, dan dungeon** tersendiri.

Belum: daftar wilayah, peta dunia, syarat buka tiap wilayah, ukuran wilayah, cara perpindahan antarwilayah (loading/streaming).

### 6.2 Sistem Kehidupan — D-015, LOCKED (Kehidupan Lengkap ala Story of Seasons)
**Ditetapkan:**
- **Farming dan pertanian:** mengelola ladang, menanam, memanen.
- **Peternakan:** memelihara hewan.
- **Memancing.**
- **Memasak.**
- **Pergantian musim.**
- **Festival dan acara desa.**
- **Ekonomi dan perdagangan.**
- **Pengembangan rumah** (membangun dan mengembangkan rumah).
- **Pengembangan dan perluasan ladang.**

**[BELUM DITETAPKAN]:** daftar tanaman dan hewan, jumlah dan panjang musim, kalender dan sistem waktu (termasuk acuan jam: perangkat atau server), cuaca, stamina, mekanik memancing, resep dan efek makanan (termasuk hubungannya dengan RPG/buff), harga dan keseimbangan ekonomi, jadwal dan jenis festival, tahap upgrade rumah dan ladang, dekorasi, penyimpanan, keseimbangan dengan pertarungan dan dungeon.

**Di luar D-015 dan BELUM ditetapkan (jangan dianggap disetujui):** hubungan romantis, pernikahan, membangun keluarga, memiliki anak.

Untuk bagian 6.3 dan 6.4 di bawah, rujuk 6.2.

### 6.3 Memancing dan Memasak
Ditetapkan lewat D-015 (lihat 6.2). Rincian belum ditetapkan.

### 6.4 Rumah
Ditetapkan lewat D-015 (pengembangan rumah dan ladang; lihat 6.2). Rincian belum ditetapkan.

### 6.5 NPC dan Hubungan
Ditetapkan: interaksi dengan NPC.
Belum: jadwal harian, dialog, daftar NPC, tingkat hubungan/persahabatan. **Hubungan romantis, pernikahan, keluarga, dan anak belum ditetapkan** (lihat 6.2).

### 6.6 Adventurer Guild — D-017, LOCKED (Guild Petualang Lengkap)
**Ditetapkan:**
- **Rank petualang:** F, E, D, C, B, A, S, SS, SSS.
- **Quest Board** dan **misi khusus**.
- **Ujian kenaikan rank.**
- **Sistem reputasi dan prestasi.**
- **Spesialisasi petualang.**
- **Training dan pengembangan kemampuan.**
- **Hadiah, gelar, dan penghargaan.**
- **Guild Master dan NPC pengurus.**
- Berlaku sejak sebelumnya: berburu monster lewat quest (D-010); rank dapat memengaruhi pembukaan wilayah (D-009).

**[BELUM DITETAPKAN]:** syarat tiap rank dan isi ujian, jenis dan daftar quest/misi khusus, rumus reputasi, daftar prestasi/gelar/hadiah, jenis spesialisasi (dan hubungannya dengan skill tree D-013), bentuk training, nama dan karakter Guild Master dan NPC pengurus, hubungan rank dengan akses dungeon (D-016) dan wilayah, keseimbangan dengan sistem kehidupan (D-015). **Tidak ada implementasi guild sebelum seluruh tahap desain selesai.**

### 6.7 Pertarungan (Action RPG) — D-013, LOCKED
**Ditetapkan (Kombinasi Semua Sistem):**
- Real-time Action Combat
- Normal Attack dan Combo Attack
- Active Skills dengan Cooldown
- Magic dan Elemental Skills
- Berbagai jenis senjata
- Dodge dan Evasion
- Block dan Defense
- Parry dan Counter Attack
- Skill Tree dan perkembangan kemampuan karakter

Juga berlaku: ada monster dan boss (6.8).

**[BELUM DITETAPKAN]:** aturan damage dan stat, daftar elemen dan interaksinya, daftar jenis senjata, sumber daya skill (mana/stamina), jendela waktu parry/dodge, struktur skill tree, kontrol sentuh untuk semua aksi di atas, penargetan/kamera saat bertarung, bentuk AI musuh, keseimbangan dengan kehidupan bertani. **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.8 Dungeon dan Boss — D-016, LOCKED (Kombinasi Dungeon Tetap dan Acak)
**Ditetapkan:**
- **Story Dungeon:** desain dan tata letak ruangan tetap; terhubung dengan cerita atau quest; memiliki monster dan boss khusus; memiliki hadiah penyelesaian.
- **Exploration Dungeon:** tata letak ruangan dibuat acak; penempatan monster dan tantangan dapat bervariasi; menyediakan material dan harta karun; dapat dijelajahi berulang kali.
- **Fitur tambahan:** dungeon rahasia, boss spesial, hadiah unik.
- Berlaku sejak sebelumnya (D-003, D-009): dungeon exploration dan boss ada; setiap wilayah dapat punya dungeon.

**[BELUM DITETAPKAN]:** jumlah lantai/ruangan, aturan dan seed pembuatan acak, tabel loot dan drop, tingkat kesulitan dan penskalaan, batas masuk (rank/level/stamina), cara membuka dungeon rahasia, daftar boss dan boss spesial, jenis hadiah unik, hubungan dungeon dengan Progressive World Unlock dan rank petualang, keseimbangan dengan sistem kehidupan (D-015). **Tidak ada implementasi dungeon sebelum seluruh tahap desain selesai.**

### 6.9 Material dan Equipment
Ditetapkan: mengumpulkan material dan membuat equipment.
Belum: jenis equipment, slot, tier, crafting, stat.

## 7. Online (Single-Player Online) — D-014, LOCKED

**Ditetapkan (D-014, Single-Player Online):**
- Game dimainkan **sendiri**; koneksi internet **wajib**.
- Setiap pemain memiliki **akun** (registrasi dan login).
- **Cloud Save** dan **sinkronisasi progres** pemain.
- **Dunia dan NPC adalah bagian dari progres pribadi** pemain (bukan dunia bersama).
- **Tidak ada** multiplayer real-time, **tidak ada** kunjungan ladang pemain lain, **tidak ada** co-op dungeon.
- Backend terpisah dari GitHub (GitHub hanya kode dan distribusi APK). Penyedia awal: **Supabase** (O-003) untuk registrasi/login, akun, Cloud Save, sinkron progres, dan database pemain. Nakama tidak diperlukan.
- Tidak ada implementasi backend atau gameplay sebelum seluruh tahap desain selesai.

**[BELUM DITETAPKAN]:** metode login (email, Google, dll.), perilaku saat koneksi putus di tengah permainan, kebijakan multi-perangkat, fitur sosial non-real-time (mis. leaderboard) — tidak termasuk dalam D-014 dan tidak dikerjakan kecuali diputuskan.

## 8. Lokalisasi

- Bahasa utama **Indonesia**, kedua **Inggris**.
- Seluruh teks game memakai kunci terjemahan (`game/i18n/translations.csv`), tidak ada teks yang ditulis langsung di kode.

## 9. Pertanyaan Terbuka untuk Tahap Desain

Urutan usulan pembahasan bersama ChatGPT (dari yang paling memengaruhi arsitektur):

1. ~~Multiplayer~~ (D-014 terkunci: Single-Player Online).
2. ~~Pertarungan~~ (D-013 terkunci); sisanya: detail aturan combat, kamera dan kontrol sentuh.
3. Struktur dunia dan wilayah (ukuran, loading, peta).
4. ~~Sistem kehidupan~~ (D-015 terkunci); sisanya: detail aturan (musim, waktu, stamina, ekonomi, resep, festival).
5. ~~Dungeon~~ (D-016 terkunci: tetap + acak); sisanya: detail loot, boss, kesulitan.
6. ~~Guild, rank, quest~~ (D-017 terkunci); sisanya: progres cerita dan detail quest.
7. NPC dan hubungan.
8. Art direction 3D Stylized dan sumber aset.
9. Monetisasi (belum disebut; default: tidak ada sampai diputuskan).

Setiap keputusan baru wajib dicatat di `DESIGN_DECISIONS.md` sebelum implementasi.
