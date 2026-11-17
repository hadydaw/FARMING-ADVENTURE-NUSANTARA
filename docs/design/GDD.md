# Game Design Document (GDD) — Farming Adventure Nusantara

> **Versi dokumen:** 0.1 (fondasi) · **Status:** Draf awal. Hanya memuat keputusan yang sudah ditetapkan pemilik proyek.
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
- Skema kontrol (joystick virtual, tap-to-move, tombol aksi, gestur).
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

### 6.2 Farming (ladang, tanaman, hewan)
Ditetapkan: ada pengelolaan ladang, tanam/panen, dan pemeliharaan hewan.
Belum: musim, cuaca, daftar tanaman/hewan, stamina, kalender, waktu tumbuh, ekonomi.

### 6.3 Memancing dan Memasak
Ditetapkan: kedua aktivitas ada.
Belum: mekanik memancing, resep, efek makanan, hubungan dengan RPG (buff/heal).

### 6.4 Rumah
Ditetapkan: membangun dan mengembangkan rumah.
Belum: tahap upgrade, dekorasi, penyimpanan, biaya.

### 6.5 NPC dan Hubungan
Ditetapkan: interaksi dengan NPC.
Belum: sistem hubungan/romansa, jadwal harian, dialog, daftar NPC.

### 6.6 Adventurer Guild, Quest, dan Rank
Ditetapkan: Adventurer Guild, quest, berburu monster, rank **F, E, D, C, B, A, S, SS, SSS** (direncanakan).
Belum: syarat naik rank, jenis quest, hadiah, hubungan rank dengan pembukaan wilayah.

### 6.7 Pertarungan (Action RPG)
Ditetapkan: genre Action RPG; ada monster dan boss.
Belum: seluruh sistem pertarungan (gerak, serangan, skill, pertahanan, pertumbuhan karakter, kelas).

### 6.8 Dungeon dan Boss
Ditetapkan: dungeon exploration, boss, setiap wilayah dapat punya dungeon.
Belum: struktur dungeon (fixed/prosedural), lantai, loot, kesulitan.

### 6.9 Material dan Equipment
Ditetapkan: mengumpulkan material dan membuat equipment.
Belum: jenis equipment, slot, tier, crafting, stat.

## 7. Online dan Multiplayer

**Ditetapkan:** game **online**; ada backend terpisah untuk kebutuhan online dan sinkronisasi data pemain.
GitHub **bukan** server game (hanya kode dan distribusi APK).

**[BELUM DITETAPKAN]:** apakah ada multiplayer, dan bila ada: bentuknya (co-op, sosial, kompetitif), jumlah pemain, sinkron real-time atau asinkron. Akan diputuskan di tahap desain. Arsitektur dibuat agar keputusan ini tidak memaksa penulisan ulang (lihat `docs/technical/BACKEND_DESIGN.md`).

## 8. Lokalisasi

- Bahasa utama **Indonesia**, kedua **Inggris**.
- Seluruh teks game memakai kunci terjemahan (`game/i18n/translations.csv`), tidak ada teks yang ditulis langsung di kode.

## 9. Pertanyaan Terbuka untuk Tahap Desain

Urutan usulan pembahasan bersama ChatGPT (dari yang paling memengaruhi arsitektur):

1. Multiplayer: ada/tidak, bentuknya.
2. Pertarungan dan kamera/kontrol sentuh.
3. Struktur dunia dan wilayah (ukuran, loading, peta).
4. Siklus farming (musim, waktu, stamina, ekonomi).
5. Dungeon (fixed vs prosedural), loot, boss.
6. Rank, quest, dan progres cerita.
7. NPC dan hubungan.
8. Art direction 3D Stylized dan sumber aset.
9. Monetisasi (belum disebut; default: tidak ada sampai diputuskan).

Setiap keputusan baru wajib dicatat di `DESIGN_DECISIONS.md` sebelum implementasi.
