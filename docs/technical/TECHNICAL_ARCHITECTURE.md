# Technical Architecture — Farming Adventure Nusantara

> **Versi:** 0.22 (+ D-014 Single-Player Online) · Engine dan arsitektur disetujui pemilik (O-001) · Berlaku untuk keputusan teknis T-001 s.d. T-009 di `DESIGN_DECISIONS.md`.

## 1. Kebutuhan yang Menentukan Pilihan

| Kebutuhan | Sumber |
|---|---|
| Game 3D stylized di Android, landscape, layar sentuh | D-004, D-008 |
| APK publik via GitHub Releases, build otomatis GitHub Actions | D-005 |
| Online dengan backend terpisah, sinkronisasi data pemain | D-006 |
| Tanpa lisensi berbayar; biaya sekecil mungkin | Konteks proyek |
| Dunia besar bertahap (banyak wilayah), RPG aksi, banyak sistem data | D-009, GDD |

"Android Native" (dikonfirmasi pemilik, O-001) = **aplikasi APK sungguhan yang dipasang langsung di HP, kode mesin arm64, bukan WebView, game browser, atau PWA.** Godot memenuhi ini.

## 2. Pemilihan Engine

| Opsi | Kelebihan | Kekurangan untuk proyek ini | Keputusan |
|---|---|---|---|
| **Godot 4.7** (GDScript) | Gratis, MIT, tanpa royalti; ekspor APK arm64 langsung; build CLI headless mudah di GitHub Actions; editor ringan; 3D stylized/toon cukup; mendukung plugin Android native (Kotlin) bila perlu | 3D lebih sederhana dibanding Unity/Unreal; ekosistem aset lebih kecil | **Dipilih** |
| Unity | Ekosistem besar, banyak aset | Build CI butuh lisensi/aktivasi; ukuran proyek dan waktu build besar; kebijakan harga berubah-ubah | Tidak |
| Unreal Engine | Grafis terbaik | Terlalu berat untuk HP menengah dan CI gratis; ukuran APK besar | Tidak |
| Native Android (Kotlin + Filament/libGDX) | Kontrol penuh | Harus membangun sendiri editor level, UI, animasi, tooling — terlalu mahal untuk game seluas ini | Tidak |

Alasan utama: **biaya nol, build CI sederhana dan dapat direproduksi, cukup untuk 3D stylized di HP, dan semua alat berjalan tanpa GUI** sehingga seluruh proyek bisa dikerjakan dan diuji lewat repo + CI.

Versi dipatok (`4.7.2`) di `.github/workflows/android-build.yml` dan `project.godot` agar build dapat direproduksi. Pembaruan versi engine = entri keputusan baru.

## 3. Rendering

- Renderer **GL Compatibility** (OpenGL ES 3.0) untuk desktop dan mobile.
- Gaya 3D stylized: material tanpa specular, warna datar/toon, bayangan sederhana; hindari efek berat (SDFGI, SSR, volumetrik tidak tersedia di Compatibility dan tidak dibutuhkan).
- Model: glTF 2.0 `.glb`; tekstur dikompres ETC2/ASTC (diaktifkan di project settings).
- **Anggaran performa awal (usulan, diukur ulang di perangkat nyata):** target 60 FPS, batas bawah 30 FPS di HP kelas menengah; karakter ≤ 5 ribu segitiga, monster umum ≤ 4 ribu, pohon/objek dunia ≤ 1 ribu; draw call ≤ 150 per frame; tekstur ≤ 1024 px untuk objek dunia.
- Ditinjau ulang bila art direction memerlukan Mobile renderer (Vulkan).

## 4. Struktur Kode dan Proyek

```
res://game/
  boot/      layar boot dan uji fondasi (BUKAN gameplay)
  core/      autoload & layanan lintas fitur: AppInfo, SaveService, BackendClient
  i18n/      translations.csv (id, en)
  data/      data game (item, tanaman, monster, ...) - kosong sampai desain selesai
  world/     wilayah, desa, dungeon - kosong
  ui/        antarmuka bersama - kosong
  assets/    models, textures, audio, ui, fonts
```

Prinsip arsitektur (berlaku saat gameplay mulai dibangun):

1. **Data-driven:** item, tanaman, monster, quest, rank, wilayah didefinisikan sebagai data (Resource/JSON), bukan hardcode, agar mudah diseimbangkan dan disinkronkan.
2. **Pemisahan:** logika game (aturan) terpisah dari tampilan; logika dapat diuji headless.
3. **Event bus** untuk komunikasi antarsistem (signal) agar sistem tidak saling mengunci.
4. **Region sebagai unit muat:** tiap wilayah adalah scene/paket sendiri yang dimuat-bongkar, mendukung Progressive World Unlock dan batas memori HP.
5. **Semua akses jaringan lewat `BackendClient`**; gameplay tidak memanggil HTTP langsung.
6. **Semua teks lewat kunci terjemahan.**

### 4a. Implikasi Arsitektur dari D-013 (hanya catatan; belum diimplementasikan)

Sistem pertarungan yang terkunci (real-time, combo, skill+cooldown, magic/elemen, banyak senjata, dodge/block/parry, skill tree) menuntut, saat nanti dibangun:
- **Data-driven:** senjata, skill, elemen, dan skill tree sebagai data (Resource/JSON), bukan hardcode.
- **Logika tick tetap:** perhitungan combat terpisah dari tampilan (deterministik, dapat diuji headless); jendela waktu parry/dodge dihitung dalam waktu, bukan frame.
- **Input sentuh:** skema kontrol harus menampung semua aksi dengan latensi rendah; dipetakan lewat Input Action agar bisa diuji dengan kontroler/keyboard.
- **State machine** karakter/musuh (serang, combo, skill, dodge, block, parry, stagger).
- **Save:** progres skill tree dan perlengkapan masuk payload save (skema berversi).
- **Anggaran performa:** efek skill/magic mengikuti anggaran §3 (batas partikel dan draw call).
- **Online:** validasi hasil combat di server hanya bila fitur online yang rawan curang diputuskan; D-014 menetapkan single-player online, sehingga tidak ada sinkronisasi real-time antarpemain.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4b. Implikasi Arsitektur dari D-015 (hanya catatan; belum diimplementasikan)

Sistem Kehidupan (farming, ternak, memancing, memasak, musim, festival, ekonomi, pengembangan rumah dan ladang) menuntut saat dibangun:
- **Layanan waktu/kalender** tunggal (hari, musim, tahun) yang menjadi sumber kebenaran bagi pertumbuhan tanaman, hewan, festival, dan jadwal; acuan jam (perangkat vs server) **belum diputuskan** dan dicatat sebagai pertanyaan terbuka. Karena akun dan internet wajib (D-014), server dapat dipakai sebagai acuan waktu bila dipilih.
- **Data-driven:** tanaman, hewan, ikan, resep, item, harga, festival, upgrade sebagai data (Resource/JSON), bukan hardcode.
- **Event kalender** (festival, acara desa) sebagai data terjadwal yang memicu scene/quest.
- **Save:** keadaan ladang, hewan, inventori, uang, rumah, dan tanggal masuk payload save (skema berversi, migrasi antarversi); ukuran payload dipantau karena dunia pribadi ikut tersimpan.
- **Ekonomi:** karena single-player online, ekonomi bersifat pribadi; validasi server untuk mencegah manipulasi save baru diputuskan bila diperlukan.
- **Hanya yang ditetapkan:** hubungan romantis/pernikahan/keluarga/anak tidak ada dalam arsitektur sampai diputuskan.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4c. Implikasi Arsitektur dari D-016 (hanya catatan; belum diimplementasikan)

- **Dua jenis dungeon, satu kerangka:** Story Dungeon = scene/level tetap buatan tangan; Exploration Dungeon = dirakit saat runtime dari potongan ruangan (modul) berdasarkan **seed**. Keduanya berbagi sistem monster, loot, dan boss.
- **Generator acak deterministik:** diberi seed → hasil sama; bisa diuji headless dan direproduksi untuk debugging. Seed dapat disimpan di save agar sesi dungeon dapat dilanjutkan.
- **Data-driven:** potongan ruangan, tabel spawn, tabel loot, boss, dungeon rahasia, dan hadiah unik sebagai data.
- **Dungeon sebagai unit muat** (bagian dari region): dimuat dan dibongkar untuk menjaga memori HP; ruangan acak dibatasi anggaran performa §3.
- **Save:** status penyelesaian Story Dungeon, dungeon rahasia yang terbuka, hadiah unik yang sudah didapat, dan seed/lantai aktif masuk payload save (skema berversi).
- **Online (D-014):** progres dungeon bersifat pribadi; tidak ada sinkronisasi real-time. Validasi server atas loot baru dipertimbangkan hanya bila diputuskan.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4d. Implikasi Arsitektur dari D-017 (hanya catatan; belum diimplementasikan)

- **Sistem progres terpusat** (`rank`, `reputasi`, `prestasi`, `gelar`, `spesialisasi`) sebagai satu layanan yang dibaca oleh pembukaan wilayah (D-009), akses dungeon (D-016), dan quest. Hindari menyebar pengecekan rank di banyak tempat.
- **Quest sebagai data:** definisi quest (syarat, tujuan, hadiah) berbasis data dengan sistem *kondisi* dan *efek* yang dapat dipakai ulang (farming, combat, dungeon, kalender). Quest Board = tampilan atas data ini; misi khusus = quest dengan pemicu/syarat tertentu.
- **Ujian kenaikan rank** sebagai jenis quest khusus, berstatus dalam save.
- **Event bus:** pencapaian (monster dikalahkan, item diserahkan, dungeon selesai) dipancarkan sebagai event; reputasi dan prestasi mendengarkannya.
- **Save:** rank, reputasi, prestasi, gelar, spesialisasi, status quest, dan hasil ujian masuk payload save (skema berversi).
- **Online (D-014):** progres guild bersifat pribadi; tidak ada papan peringkat/real-time kecuali diputuskan. Validasi server atas hadiah/rank baru dipertimbangkan hanya bila diputuskan.
- **NPC pengurus:** memakai kerangka NPC umum (belum didesain).
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4e. Implikasi Arsitektur dari D-018 (hanya catatan; belum diimplementasikan)

- **Model karakter berlapis dan data-driven:** atribut dasar (level) + modifier dari class/job, spesialisasi, skill pasif, penguasaan senjata, dan perlengkapan. Stat akhir dihitung dari satu *stat pipeline* yang sama dipakai combat, quest, dan UI; hindari menyimpan stat turunan di save (simpan sumbernya, hitung ulang).
- **Skill tree sebagai graf data** (node, syarat, efek) sehingga cabang baru ditambah tanpa mengubah kode; skill aktif/pasif/sihir/elemen mendaftar ke sistem efek yang sama dengan combat (D-013).
- **Ganti spesialisasi (respec)** memerlukan operasi yang dapat dibatalkan/diulang aman: simpan alokasi poin, bukan hasil akhir, supaya reset dan kombinasi konsisten.
- **Hubungan lintas sistem:** level karakter dibaca oleh pembukaan wilayah (D-009) dan guild (D-017) lewat layanan progres yang sama (§4d); sumber XP diterima lewat event bus.
- **Save:** level, XP, atribut teralokasi, alokasi skill tree, class/job aktif dan riwayatnya, penguasaan senjata, serta ketersediaan elemen masuk payload save (skema berversi; perubahan struktur tree perlu migrasi yang menjaga poin pemain).
- **Online (D-014):** progres karakter pribadi; validasi server atas level/skill baru dipertimbangkan hanya bila diputuskan.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4f. Implikasi Arsitektur dari D-019 (hanya catatan; belum diimplementasikan)

- **Satu model "makhluk" bersama:** monster musuh, companion, pet, dan hewan ternak berbagi definisi data dasar (spesies, stat, skill, model 3D) dengan *komponen* berbeda (peran: musuh, pet, combat companion, pekerja). Menjinakkan = mengubah satu instance monster menjadi companion milik pemain tanpa membuat ulang data.
- **Data-driven:** spesies, kelangkaan, jalur evolusi (graf syarat → bentuk berikut), skill monster, dan tabel peluang taming sebagai data; skill memakai sistem efek yang sama dengan combat (D-013) dan skill pemain (D-018).
- **AI companion:** perilaku (ikut, bertarung, membantu aktivitas) sebagai state machine/perintah yang dapat dipakai ulang; kontrol otomatis vs perintah menunggu desain. Dibatasi anggaran performa §3 (jumlah makhluk aktif).
- **Aktivitas bantuan** (mis. pekerjaan ladang) dijalankan lewat antarmuka tugas dari sistem kehidupan (D-015) dan dihitung ulang lewat layanan kalender saat pemain offline/di dungeon, tanpa simulasi penuh.
- **Save:** koleksi companion (instance: spesies, level, evolusi, loyalitas, skill terpelajar, tugas aktif) dan daftar monster langka yang sudah dikoleksi masuk payload save (skema berversi). Simpan sumber/progres, bukan nilai turunan.
- **Online (D-014):** koleksi bersifat pribadi; tidak ada perdagangan atau pertarungan antarpemain. Validasi server atas hasil taming/evolusi dipertimbangkan hanya bila diputuskan.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4g. Implikasi Arsitektur dari D-020 (hanya catatan; belum diimplementasikan)

- **Sistem item terpusat** (definisi item, instance item, inventori) yang dipakai farming, memasak, gathering, mining, loot dungeon/boss, dan crafting. Beda tegas antara **definisi** (data tetap: nama, tipe, rarity dasar) dan **instance** (kualitas, level upgrade, enchant, atribut tambahan).
- **Crafting sebagai resep data:** bahan, hasil, profesi/level yang dibutuhkan, dan stasiun kerja sebagai data; satu mesin resep melayani senjata, armor, potion, dan makanan sehingga memasak (D-015) dan Alchemist/Blacksmith berbagi kerangka.
- **Kualitas, rarity, enchant, upgrade** sebagai modifier yang masuk *stat pipeline* yang sama dengan perkembangan karakter (§4e); simpan sumber modifier, hitung stat turunan saat dibutuhkan.
- **Tabel loot dan sumber material:** gathering, mining, drop monster, dungeon (D-016), dan boss memakai tabel data yang sama; material langka/legendaris ditandai lewat data (bukan kode).
- **Pengacakan** (kualitas, atribut tambahan, hasil enchant) memakai generator acak ber-seed yang dapat diuji headless; hasil acak yang penting dapat dikunci di save agar tidak dapat dimanipulasi dengan memuat ulang.
- **Save:** inventori (instance item bertipe), kemajuan profesi, resep yang sudah dikuasai, dan status stasiun/antrean crafting masuk payload save (skema berversi; migrasi menjaga item pemain bila data item berubah).
- **Online (D-014):** ekonomi pribadi; tidak ada perdagangan antarpemain. Validasi server atas item langka/legendaris dipertimbangkan hanya bila diputuskan (risiko manipulasi save).
- **Anggaran performa:** banyak varian visual equipment memerlukan sistem pemasangan model/material modular (menunggu art direction).
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4h. Implikasi Arsitektur dari D-021 (hanya catatan; belum diimplementasikan)

- **Layanan ekonomi tunggal:** semua jual/beli lewat satu layanan harga yang dipanggil UI toko, merchant, dan crafting; tidak ada harga hardcode di fitur lain.
- **Harga = fungsi dari data:** harga dasar (data item, D-020) × pengali musim (kalender, §4b) × pengali wilayah (D-009) × pengali permintaan/penawaran/kelangkaan (keadaan pasar). Pengali-pengali ini adalah data dan keadaan yang dapat diuji headless secara deterministik.
- **Keadaan pasar** (persediaan, permintaan per barang per wilayah) diperbarui lewat layanan kalender per hari; saat pemain berada di dungeon atau offline, dihitung ulang dari selisih hari, bukan disimulasikan penuh.
- **Merchant sebagai data:** spesialisasi barang, stok, wilayah, dan jadwal sebagai data; memakai kerangka NPC umum.
- **Perdagangan antarwilayah** mengandalkan wilayah sebagai unit data (§4) dan selisih harga antarwilayah; aturan transportasi menunggu desain.
- **Save:** uang, keadaan pasar (atau seed + riwayat yang cukup untuk merekonstruksinya), stok merchant, dan status usaha pemain masuk payload save (skema berversi). Karena ekonomi dinamis dapat dimanipulasi lewat save lokal, lokasi perhitungan (klien/server) harus diputuskan bersama aturan keadilan sebelum implementasi.
- **Online (D-014):** dengan akun dan internet wajib, server **dapat** menjadi acuan waktu dan penghitung pasar pribadi; ini dicatat sebagai opsi, **bukan keputusan**. Tidak ada ekonomi bersama atau perdagangan antarpemain.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4i. Implikasi Arsitektur dari D-022 (hanya catatan; belum diimplementasikan)

Syarat utama: **jumlah NPC besar tetap terkelola** (kinerja di HP dan beban penulisan konten).
- **NPC sepenuhnya data-driven:** identitas, pekerjaan, kepribadian, jadwal, dan dialog sebagai data (Resource/JSON) dengan **templat** (mis. petani, pedagang, penjaga) agar NPC baru dibuat tanpa kode.
- **Simulasi berjenjang (level of detail):** hanya NPC di dekat pemain yang disimulasikan penuh (bergerak, animasi, AI); NPC jauh atau di wilayah lain cukup dihitung **posisi/aktivitas dari jadwal + waktu** (stateless dari kalender, §4b) dan dihidupkan saat pemain mendekat. Ini kunci skala NPC besar.
- **Jadwal dan aktivitas** sebagai data yang dievaluasi terhadap waktu, musim, cuaca, dan kondisi dunia (kondisi sebagai flag/variabel dunia); perubahan perilaku akibat perkembangan dunia = jadwal/templat alternatif yang dipilih oleh syarat.
- **Variabel dunia dan hubungan:** satu penyimpan keadaan (flag, hubungan per NPC, fakta cerita) yang dibaca dialog, quest, dan event; **quest bercabang dan dialog bersyarat** memakai sistem *kondisi* dan *efek* yang sama dengan quest guild (§4d).
- **Reaksi pemain** lewat event bus (§4): tindakan dipancarkan sebagai event, NPC/hubungan mendengarkan; tidak ada pemanggilan langsung antarsistem.
- **Sistem dialog:** teks lewat kunci terjemahan (id/en, §6), dialog bersyarat per hubungan/cerita; konten yang besar dipisah per NPC agar mudah dikelola dan diuji (validator data otomatis untuk kunci yang hilang, rujukan rusak).
- **Pencarian jalan dan pengaturan beban:** jumlah NPC aktif dibatasi oleh anggaran performa §3; navigasi memakai navigation mesh per area.
- **Save:** hubungan, flag cerita, kemajuan quest NPC, dan keadaan khusus NPC masuk payload save (skema berversi); jadwal tidak disimpan (diturunkan dari data + waktu).
- **Online (D-014):** NPC adalah progres pribadi; tidak ada sinkronisasi real-time.
- **Cakupan:** hanya pertemanan/kepercayaan; model hubungan dibuat dapat diperluas, tetapi romansa/keluarga tidak dimodelkan sampai diputuskan.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4j. Implikasi Arsitektur dari D-023 (hanya catatan; belum diimplementasikan)

Syarat utama: **mudah diperluas** dengan tanaman dan wilayah baru.
- **Tanaman sepenuhnya data:** spesies, varietas, tahap tumbuh (durasi, visual), kebutuhan (air, pupuk, musim, tanah), hasil panen, kualitas, dan flag khusus (spiritual, langka) sebagai data. Menambah tanaman/varietas/wilayah = menambah data, bukan kode.
- **Petak tanah (plot) sebagai unit simulasi:** tiap plot menyimpan kondisi (kualitas tanah, kelembapan, pupuk) dan tanaman; pertumbuhan dihitung dari **selisih hari** lewat layanan kalender (§4b), bukan simulasi per frame, sehingga ladang besar tetap ringan dan tetap tumbuh saat pemain di dungeon atau offline.
- **Faktor pertumbuhan modular:** air, pupuk, musim, cuaca, tanah, dan teknologi sebagai *pengali/syarat* terpisah yang digabung oleh satu fungsi pertumbuhan; faktor baru dapat ditambah tanpa mengubah tanaman yang ada.
- **Cuaca:** sistem cuaca sebagai layanan data-driven per wilayah dan musim (belum didesain); deterministik dari seed + tanggal agar dapat diuji dan konsisten dengan penghitungan ulang selisih hari.
- **Mekanisme khusus** (tanaman spiritual/langka) lewat sistem *efek dan kondisi* yang sama dengan quest/combat (§4d) bukan kode per tanaman; definisinya menunggu desain.
- **Integrasi:** hasil panen adalah item di sistem item (§4g) yang masuk resep crafting/alkimia dan layanan harga (§4h); teknologi pertanian dan pengembangan lahan sebagai upgrade data pada ladang.
- **Save:** keadaan setiap plot (tanah, air, pupuk, tanaman, tahap, waktu tanam), teknologi/upgrade lahan, dan benih yang dimiliki masuk payload save (skema berversi). Ukuran save dipantau karena banyak plot; simpan secara ringkas (hanya plot berisi/berubah).
- **Anggaran performa:** banyak tanaman terlihat sekaligus menuntut batching/instancing dan LOD (§3).
- **Online (D-014):** ladang adalah progres pribadi; tidak ada kunjungan ladang pemain lain.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4k. Implikasi Arsitektur dari D-024 (hanya catatan; belum diimplementasikan)

Syarat utama: **spesies dan fasilitas baru dapat ditambah.**
- **Spesies sebagai data:** kebutuhan pakan, kesehatan, laju pertumbuhan, aturan berkembang biak, produk (dan kualitasnya), kelangkaan, flag spiritual, dan model/animasi sebagai data. Spesies baru = data baru.
- **Memakai model "makhluk" bersama (§4f):** hewan ternak adalah makhluk dengan komponen *ternak*; hewan spiritual dapat berbagi skill/efek dengan sistem yang sama. Batas ternak vs pet/companion (D-019) menunggu desain; model bersama membuat perubahan peran tidak memaksa data ditulis ulang.
- **Simulasi berbasis selisih hari:** kebutuhan, kesehatan, pertumbuhan, dan produksi dihitung per hari lewat layanan kalender (§4b), bukan per frame; berlaku saat pemain jauh/offline, sama seperti tanaman (§4j). Hewan hanya "hidup" (bergerak/animasi) bila dekat pemain (LOD seperti NPC, §4i).
- **Kesehatan dan perawatan** sebagai nilai terpisah yang menjadi pengali produktivitas dan kualitas produk; aturan kesehatan modular agar faktor baru bisa ditambah.
- **Berkembang biak:** aturan per spesies (data) dengan hasil acak ber-seed yang dapat diuji dan dikunci di save agar tidak dimanipulasi dengan memuat ulang (§4g); pewarisan sifat (jika ada) menunggu desain.
- **Fasilitas** (kandang, dll.) sebagai data dengan kapasitas dan upgrade; terhubung ke sistem pengembangan ladang/rumah (D-015).
- **Integrasi:** produk ternak adalah item (§4g) yang masuk resep crafting dan layanan harga (§4h); pakan dapat berupa hasil panen (§4j).
- **Save:** daftar hewan (spesies, umur/tahap, kesehatan, perawatan, status produksi, sifat), fasilitas, dan stok pakan masuk payload save (skema berversi); simpan ringkas untuk kawanan besar.
- **Online (D-014):** peternakan adalah progres pribadi.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4l. Implikasi Arsitektur dari D-025 (hanya catatan; belum diimplementasikan)

- **Ikan dan lokasi sebagai data:** spesies (habitat, kelangkaan, kebutuhan musim/cuaca/waktu, perilaku, hasil item), titik/zona memancing per wilayah, alat pancing, dan umpan sebagai data. Spesies atau lokasi baru = data baru.
- **Tabel tangkapan terkondisi:** hasil memancing = pemilihan acak berbobot dari tabel yang disaring oleh *kondisi* (lokasi, musim, cuaca, jam, umpan, alat) memakai sistem kondisi yang sama dengan quest dan NPC (§4d, §4i); bobot dipengaruhi umpan/alat/kemampuan.
- **Acak ber-seed dan dapat diuji:** hasil tangkapan memakai generator ber-seed yang dapat diuji headless; hasil penting (ikan langka/legendaris) tidak boleh dapat diulang dengan memuat ulang (dikunci di save, §4g).
- **Layanan waktu dan cuaca bersama** (§4b, §4j): ketersediaan ikan dihitung dari kalender dan cuaca yang sama dengan pertanian, bukan sumber terpisah.
- **Mekanik memancing sebagai modul input:** minigame sentuh dipisah dari logika tangkapan (logika deterministik, tampilan terpisah) agar dapat diganti setelah desain kontrol selesai; mengikuti pemetaan Input Action (§7).
- **Ikan sebagai item:** hasil tangkapan adalah item bertipe di sistem item (§4g) dengan kualitas/rarity; masuk resep memasak/crafting dan layanan harga (§4h).
- **Koleksi dan prestasi:** pencatatan spesies yang pernah ditangkap lewat event bus ke sistem prestasi (§4d).
- **Makhluk air fantasi/spiritual:** dapat memakai model makhluk bersama (§4f) bila nanti ditetapkan sebagai companion/monster; sampai diputuskan, tidak dimodelkan secara khusus.
- **Save:** koleksi ikan (spesies, rekor/kualitas terbaik), alat dan umpan, serta progres tantangan legendaris masuk payload save (skema berversi).
- **Anggaran performa:** air dan efek perairan menggunakan shader sederhana sesuai §3 (renderer Compatibility).
- **Online (D-014):** progres pribadi; tidak ada peringkat antarpemain.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4m. Implikasi Arsitektur dari D-026 (hanya catatan; belum diimplementasikan)

- **Satu mesin resep** (§4g) melayani makanan, ramuan, dan crafting lain: resep = data (bahan, syarat bahan/kualitas, stasiun, profesi/level, hasil); dapur dan laboratorium adalah *stasiun* dengan tingkat upgrade (data).
- **Bahan dari semua aktivitas:** hasil panen/herbal (§4j), produk ternak (§4k), ikan (§4l), dan material monster/dungeon (§4g) adalah item di satu sistem item; bahan dicocokkan lewat **tag/kategori** ("sayur", "herbal", "daging") selain item spesifik, sehingga resep fleksibel dan konten baru otomatis kompatibel.
- **Kualitas:** kualitas hasil = fungsi dari kualitas bahan dan kemampuan pemain (modifier, bukan hardcode); modifier masuk ke instance item (§4g).
- **Efek makanan dan ramuan** memakai sistem *efek* yang sama dengan combat dan perkembangan karakter (D-013, D-018, §4e): pemulihan sesaat dan buff berdurasi sebagai data (jenis, besar, durasi, aturan penumpukan); stat akhir tetap lewat satu *stat pipeline*. Efek buff berdurasi dan sisa waktunya masuk save.
- **Penemuan dan pembelajaran resep:** keadaan resep (belum dikenal, dikenal, dikuasai/dikembangkan) sebagai data di save; sumber penemuan (NPC, buku, dungeon, eksperimen) memakai sistem kondisi/efek yang sama (§4d); versi resep yang dikembangkan disimpan sebagai sumber pengubah, bukan salinan resep.
- **Acak ber-seed** untuk hasil kualitas/eksperimen yang dapat diuji dan dikunci di save (§4g).
- **Ekonomi:** resep langka dan hasil olahan masuk layanan harga (§4h).
- **Save:** resep yang dikenal beserta tingkat penguasaan, tingkat dapur/laboratorium, efek aktif, dan stok bahan masuk payload save (skema berversi).
- **Online (D-014):** progres pribadi.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4n. Implikasi Arsitektur dari D-027 (hanya catatan; belum diimplementasikan)

Syarat utama: **mendukung penambahan jenis bangunan baru** dan tata letak bebas buatan pemain.
- **Bangunan sebagai data + komponen fungsi:** definisi bangunan (model, ukuran/footprint, biaya, syarat buka, tahap upgrade) dengan *komponen fungsi* yang dapat dipasang (penyimpanan, kandang D-024, produksi, stasiun crafting D-020, dapur/laboratorium D-026, greenhouse D-023, spiritual). Jenis baru = data + kombinasi komponen yang ada.
- **Fasilitas = stasiun pada mesin yang sudah ada:** produksi, memasak, alkimia, dan crafting memakai mesin resep (§4g, §4m); kandang memakai simulasi hewan (§4k); greenhouse memakai petak tanaman (§4j). Bangunan hanya menyediakan *tempat dan tingkat* bagi sistem tersebut, bukan logika sendiri.
- **Penataan lahan:** penempatan lewat satu *sistem penempatan* (validasi tabrakan, area boleh bangun, rotasi); metode grid atau bebas menunggu desain, dirancang agar dapat berganti tanpa mengubah data bangunan. Navigasi NPC/hewan/companion diperbarui saat tata letak berubah (rebake navigation mesh bertahap, §4i).
- **Dekorasi** berukuran banyak: pakai instancing/batching dan batas jumlah per lahan sesuai anggaran performa (§3); efek gameplay dekorasi (jika ada) sebagai data.
- **Ekspansi lahan** sebagai perluasan area ber-ID (bagian wilayah/region, §4); keadaan tiap area dimuat bersama region.
- **Pembukaan bangunan** (termasuk spiritual) memakai sistem kondisi/efek (§4d) terhadap rank, quest, dan progres.
- **Save:** daftar bangunan (jenis, posisi, rotasi, tingkat, isi/penyimpanan), area terbuka, dan dekorasi masuk payload save (skema berversi; migrasi menjaga tata letak bila definisi bangunan berubah). Simpan ringkas (hanya perbedaan dari keadaan awal) agar ukuran save terkendali.
- **Online (D-014):** lahan adalah progres pribadi; tidak ada kunjungan lahan pemain lain.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4o. Implikasi Arsitektur dari D-028 (hanya catatan; belum diimplementasikan)

Syarat utama: **dunia luas di HP** tanpa melampaui memori, dan **wilayah/lokasi baru mudah ditambah**.
- **Dunia = daftar wilayah (region) berbasis data:** tiap wilayah punya ID, scene/paket, syarat buka, daftar lokasi, tabel sumber daya dan monster. Wilayah baru = paket baru + data. Region adalah unit muat/bongkar (§4); hanya region aktif (+ tetangga yang dipra-muat) berada di memori.
- **Streaming di dalam wilayah besar:** area dibagi menjadi *chunk*/zona yang dimuat sesuai jarak; LOD dan occlusion sederhana sesuai anggaran §3 (renderer Compatibility). Batas wilayah/zona ditandai transisi (pintu, gerbang, layar muat) sesuai desain nanti.
- **Pembukaan wilayah dan fast travel = kondisi data** (§4d): level, rank, quest, flag cerita; aturan fast travel (titik yang sudah ditemukan, syarat, biaya, waktu) sebagai data, bukan hardcode.
- **Peta:** data lokasi (koordinat, tipe, ikon) terpisah dari render; keadaan "ditemukan/dikunjungi" per lokasi dan wilayah disimpan di save; penanda pemain disimpan sebagai data ringan. Peta dunia dapat dirender dari gambar statis + overlay data.
- **Transportasi:** tunggangan/kendaraan/kapal sebagai jenis *pergerakan* (profil gerak, area yang bisa dilalui) yang dipasang pada pemain; memakai model makhluk bersama (§4f) bila berupa tunggangan hidup; sampai diputuskan, tidak dimodelkan khusus. Navigasi memakai navigation mesh per area/air.
- **Waktu perjalanan:** bila perjalanan memakan waktu kalender, dihitung lewat layanan kalender (§4b) sehingga musim, cuaca, jadwal NPC, dan pertumbuhan tanaman ikut konsisten.
- **Lokasi unik, rahasia, reruntuhan, pulau tersembunyi:** sebagai *objek dunia* berbasis data dengan syarat penemuan (kondisi/efek, §4d) dan hadiah; dungeon (D-016) terhubung lewat titik masuk di data wilayah.
- **Sumber daya dan monster per wilayah:** tabel spawn/gathering per wilayah (data) memakai sistem loot dan acak ber-seed yang sama (§4g, §4l).
- **Save:** wilayah terbuka, lokasi ditemukan, penanda peta, titik fast travel terbuka, dan keadaan objek dunia unik (sudah diambil/dibuka) masuk payload save (skema berversi). Simpan sebagai perbedaan dari keadaan awal untuk menjaga ukuran.
- **Online (D-014):** dunia dan progres penjelajahan adalah pribadi; tidak ada sinkronisasi real-time.
- **Pengujian:** validator data otomatis untuk rujukan wilayah/lokasi yang rusak dan wilayah yang tidak dapat dicapai.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4p. Implikasi Arsitektur dari D-029 (hanya catatan; belum diimplementasikan)

Syarat utama: event harus **konsisten dan adil** pada game **single-player online dengan progres di cloud** (D-014).
- **Event sebagai data:** definisi event (pemicu, kondisi awal, durasi, tahap, dampak, penyelesaian, konsekuensi, hadiah) berbasis data memakai sistem *kondisi/efek* yang sama dengan quest dan NPC (§4d, §4i). Event baru = data baru.
- **Penjadwal event** (satu layanan) yang mendengarkan kalender (§4b), kondisi wilayah, progres pemain (event bus, §4), dan peluang. Event terjadwal diturunkan dari kalender (stateless); event acak/dinamis dari generator ber-seed.
- **Determinisme dan anti-curang (kunci):** karena save dapat dimuat ulang dan waktu perangkat dapat diubah, hasil acak event (apa, kapan, di mana) diturunkan dari **seed tersimpan + tanggal permainan**, sehingga memuat ulang tidak mengubah hasil (cegah *save-scumming*). Acuan waktu (perangkat vs server) harus diputuskan bersama aturan keadilan; karena akun/internet wajib (D-014), server **dapat** menjadi acuan waktu dan perekam event bila dipilih (opsi, bukan keputusan).
- **Event saat pemain jauh/offline:** dihitung ulang dari selisih hari (seperti §4j, §4k), bukan disimulasikan; aturan apakah event berjalan tanpa pemain menunggu desain.
- **Dampak melalui "variabel dunia"** (§4i): event mengubah flag/pengali yang dibaca layanan lain (harga §4h, stok, spawn/keamanan wilayah §4o, jadwal NPC §4i, pertumbuhan §4j) alih-alih memanggil sistem lain secara langsung; dampak punya durasi dan dikembalikan otomatis saat event selesai.
- **Invasi dan world boss:** memakai spawn monster per wilayah (§4o), sistem combat (D-013) dan boss (D-016); world boss adalah encounter pemain tunggal, tanpa jaringan real-time.
- **Pemberitahuan/persiapan:** event besar memancarkan sinyal peringatan sebelum mulai (data: jeda, bentuk), ditampilkan UI/NPC; mendukung notifikasi di dalam game (tanpa push notifikasi sampai diputuskan).
- **Pedagang misterius/penemuan langka:** merchant/lokasi sementara berbasis data (§4h, §4o) dengan masa tampil; hasil langka dikunci di save (§4g).
- **Save:** event aktif (tahap, sisa durasi), riwayat event yang sudah terjadi, seed event, dan dampak yang sedang berlaku masuk payload save (skema berversi); simpan ringkas.
- **Pengujian:** simulasi headless deterministik (seed + kalender → urutan event) dan validator data event.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4q. Implikasi Arsitektur dari D-030 (hanya catatan; belum diimplementasikan)

Syarat utama: musim/cuaca **konsisten dengan kalender dunia** dan **tersinkron dengan single-player online + cloud save**.
- **Satu sumber kebenaran lingkungan:** kalender (§4b) memberi tanggal/musim/jam; **layanan cuaca/iklim** (satu layanan) menjawab "cuaca di wilayah X pada waktu T". Tanaman (§4j), hewan (§4k), ikan (§4l), monster/spawn (§4o), NPC (§4i), harga (§4h), dan event (§4p) membaca layanan yang sama; tidak ada sumber cuaca terpisah.
- **Cuaca deterministik:** cuaca = fungsi dari *seed dunia + wilayah/iklim + tanggal* (dan peluang berbobot dari tabel data iklim), sehingga (1) sama di semua perangkat dan setelah memuat ulang save, (2) dapat dihitung untuk hari lampau/selisih hari tanpa menyimpan riwayat, (3) dapat diuji headless. Perubahan akibat event (D-029) disimpan sebagai *override* berdurasi.
- **Sinkron dengan cloud save:** karena yang tersimpan adalah seed + tanggal permainan (bukan keadaan cuaca per frame), pemuatan di perangkat lain menghasilkan lingkungan yang identik; tidak ada sinkronisasi real-time. Acuan jam (perangkat vs server) dan perlindungan dari manipulasi jam perangkat dipilih bersama D-029 (server dapat menjadi acuan waktu bila diputuskan).
- **Iklim sebagai data per wilayah:** profil iklim (suhu/curah/peluang tiap cuaca per musim), pengali ke sistem lain, dan aturan fenomena sebagai data; wilayah baru = profil iklim baru.
- **Fenomena ekstrem/spiritual/langka** sebagai jenis cuaca/kondisi data dengan syarat kemunculan dan dampak (kondisi/efek, §4d); isi fenomena spiritual menunggu desain.
- **Dampak ke gameplay lewat pengali dan flag** yang dibaca sistem lain (bukan pemanggilan langsung), seperti dampak event (§4p).
- **Rendering/performa:** siang-malam, hujan, kabut, salju, badai diimplementasikan hemat untuk renderer Compatibility (§3): partikel terbatas, pencahayaan sederhana, transisi lingkungan lewat parameter Environment; anggaran partikel dan draw call dipatuhi; kualitas dapat diturunkan di perangkat lemah.
- **Audio:** ambience per musim/cuaca/waktu sebagai data (menunggu desain audio).
- **Save:** seed dunia, tanggal/jam permainan, override cuaca aktif, dan keadaan perubahan lingkungan berkelanjutan (bila ada) masuk payload save (skema berversi).
- **Pengujian:** simulasi headless deterministik (seed + tanggal → cuaca) dan validator profil iklim.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4r. Implikasi Arsitektur dari D-031 (hanya catatan; belum diimplementasikan)

Syarat utama: **nyaman di layar sentuh landscape**, **adaptif terhadap aktivitas**, dan **tombol dapat disesuaikan**.
- **Lapisan UI terpisah dari logika:** UI hanya membaca *state* dari sistem game (lewat sinyal/event bus, §4) dan mengirim *perintah/Input Action*; tidak berisi aturan game. Sistem baru menambah panel baru tanpa mengubah logika.
- **Konteks UI (UI mode):** satu *manajer konteks* menentukan HUD aktif berdasarkan aktivitas (jelajah, farming, combat, dungeon, memancing, crafting, dialog, menu); tiap konteks = set widget + peta kontrol sebagai data/scene. Transisi antarkonteks dianimasikan ringan.
- **Kontrol sentuh sebagai Input Action** (§7): tombol virtual, joystick, dan gestur memicu Input Action yang sama dengan kontroler/keyboard; ini mendasari uji, dukungan kontroler nanti, dan penyesuaian tombol.
- **Tata letak dapat disesuaikan:** posisi, ukuran, dan transparansi tiap kontrol disimpan sebagai **pengaturan pemain** (data tata letak per konteks), dengan *tata letak bawaan* yang dapat dipulihkan; pengaturan ini disimpan lokal dan ikut cloud (akun) agar konsisten antarperangkat — bukan bagian progres game, jadi dipisah dari payload save game.
- **Layar aman dan ukuran:** memakai Control/anchor dan safe area (notch/gesture bar), `canvas_items` + aspect `expand` (project.godot) untuk beragam rasio; target sentuh minimum dan skala UI dapat diatur; diuji pada beberapa rasio.
- **Tema terpusat:** satu *Theme* resource (warna, font, 9-slice, ikon) agar UI konsisten dengan 3D Stylized dan mudah diganti; ikon/teks memakai kunci terjemahan (id/en, §6); layout menoleransi teks panjang.
- **Performa UI:** HUD ringan (sedikit draw call, tanpa pembaruan per-frame yang tidak perlu), daftar panjang (inventory, quest) memakai virtualisasi/pooling; mematuhi anggaran §3.
- **Daftar dan item:** tampilan inventory/equipment/crafting membaca sistem item terpusat (§4g); peta membaca data lokasi (§4o); kalender/cuaca membaca layanan waktu dan cuaca (§4b, §4q).
- **Status online:** indikator koneksi/sinkron cloud sebagai komponen global (D-014); perilaku saat koneksi putus menunggu desain.
- **Aksesibilitas:** skala teks, kontras, opsi bantu warna sebagai pengaturan (menunggu desain).
- **Pengujian:** uji headless untuk tata letak default pada beberapa ukuran layar (tidak ada kontrol keluar layar/tumpang tindih) dan kelengkapan kunci terjemahan UI.
- **Layar boot** saat ini (`game/boot`) hanya uji fondasi dan bukan bagian UI game.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4s. Implikasi Arsitektur dari D-032 (hanya catatan; belum diimplementasikan)

- **Audio Manager terpusat** (autoload) dengan **tiga bus terpisah: Musik, Efek (SFX), Ambience** (+ Master), memakai AudioBus Godot; volume tiap bus disimpan sebagai pengaturan pemain (sama seperti tata letak UI, D-031), bukan bagian save game.
- **Musik adaptif berbasis konteks:** pemilih musik membaca wilayah (§4o), aktivitas/konteks UI (§4r), dan situasi (combat, boss, event) lewat event bus; transisi memakai crossfade/layer (stem) agar halus, dengan prioritas (boss/event > combat > wilayah).
- **Ambience dari data:** lapisan ambience dipilih dari wilayah + musim + cuaca + waktu (§4q) secara data-driven; berganti halus saat cuaca/musim berubah.
- **SFX data-driven:** efek dipetakan lewat ID (aksi, item, skill, makhluk, §4g) ke aset/varian; variasi pitch/pilihan acak agar tidak monoton; batas suara bersamaan (polyphony) dan prioritas.
- **Audio 3D/posisional** untuk suara dunia (NPC, hewan, monster) dengan jarak dan LOD, selaras simulasi LOD NPC (§4m).
- **Aset:** streaming untuk musik panjang, pemuatan per wilayah, format terkompresi (mis. Ogg Vorbis) agar ukuran APK terkendali (§3); sumber/lisensi aset dicatat.
- **Bahasa:** kunci audio terpisah dari terjemahan bila nanti ada suara pengisi (§6).
- **Pengujian:** uji headless untuk kelengkapan pemetaan ID ke aset dan keberadaan bus; fokus waktu loading, bukan kualitas dengar.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

## 5. Penyimpanan Progres

Implementasi awal: `game/core/save_service.gd` (autoload `SaveService`).

- Lokasi: `user://saves/slot_N.json` (penyimpanan privat aplikasi di Android), 3 slot.
- Format: amplop JSON `{schema_version, game_version, revision, updated_at_unix, checksum(SHA-256), payload_json}`.
- Tulis atomik: tulis `.tmp` → pindahkan file lama ke `.bak` → ganti. Bila file utama rusak, `load_slot` memulihkan dari `.bak`.
- `revision` naik tiap simpan → dasar deteksi konflik saat sinkronisasi.
- `schema_version` disiapkan untuk migrasi data antarversi game.
- Checksum hanya mendeteksi kerusakan, **bukan anti-curang**. Fitur online yang butuh kejujuran (ekonomi, rank) harus divalidasi server.
- Teruji otomatis di `tools/ci/smoke_test.gd` (simpan, muat, revision, pemulihan dari kerusakan).

## 6. Lokalisasi

- `game/i18n/translations.csv` kolom `keys,id,en` → diimpor Godot menjadi `translations.id.translation` dan `translations.en.translation`.
- Bahasa bawaan `id`; fallback `id`. Layar boot memuat tombol ganti bahasa sebagai uji.
- Aturan: tidak ada string UI di kode; teks dialog/quest panjang nanti dapat dipisah per berkas, tetap kunci → teks.

## 7. Input Sentuh

- `emulate_mouse_from_touch` aktif agar kontrol UI standar berfungsi dengan sentuhan.
- Orientasi: `sensor_landscape` (landscape normal dan terbalik mengikuti sensor).
- Skema kontrol gameplay (joystick virtual, aksi, kamera) **menunggu keputusan desain**; akan dibangun sebagai scene UI terpisah dan dipetakan ke Input Action, sehingga mendukung kontroler/keyboard untuk uji.

## 8. Backend dan Online

Ringkasan; rincian di [`BACKEND_DESIGN.md`](BACKEND_DESIGN.md).

- Backend awal: **Supabase** (O-003). Nakama tidak diperlukan (D-014: Single-Player Online, tanpa real-time). Tidak ada kode backend sebelum desain sistem online disepakati.
- Backend **terpisah** dari GitHub. GitHub hanya menyimpan kode dan APK.
- Klien memakai antarmuka `BackendClient` (`game/core/backend_client.gd`); default = mode offline (belum ada jaringan).
- Konsekuensi D-014: akun dan koneksi internet **wajib**; dunia dan NPC disimpan sebagai progres pribadi di save; tidak ada jaringan real-time antarpemain.
- Pola: **offline-first dengan sinkronisasi** — pemain tetap bisa memuat progres lokal, server menjadi sumber kebenaran untuk akun dan data yang butuh validasi.

## 9. Pipeline Build dan Rilis

Ringkasan; rincian di [`BUILD_AND_RELEASE.md`](BUILD_AND_RELEASE.md).

`push/PR` → uji fondasi headless → build APK dev → artefak; `main` → pre-release `dev-latest`; tag `vX.Y.Z` → build rilis bertanda tangan kunci rahasia → GitHub Release.

## 10. Pengujian

- Smoke test headless (`tools/ci/smoke_test.gd`) dan pemuatan scene utama dijalankan di CI sebelum build; CI gagal bila ada `SCRIPT ERROR`/`Parse Error`.
- Verifikasi APK di CI: nama paket, arsitektur arm64, tanda tangan (`apksigner`).
- Pengujian di perangkat nyata dilakukan manual lewat APK dev; hasil dicatat di `PROGRESS_LOG.md`.

## 11. Risiko Teknis

| Risiko | Mitigasi |
|---|---|
| Performa 3D di HP menengah | Anggaran performa §3; uji perangkat nyata sejak vertical slice |
| Ukuran APK/memori untuk dunia besar | Region sebagai unit muat; kompresi tekstur; pantau ukuran tiap rilis |
| Kehilangan/bocor kunci rilis | Panduan `SIGNING_GUIDE.md`; cadangan di luar repo; CI menolak rilis bertanda kunci dev |
| Backend terkunci pada satu vendor | Antarmuka `BackendClient`; data inti portabel (Postgres/JSON) |
| Layar boot di HP nyata belum teruji | Menunggu laporan pemilik (TESTING_APK.md) |
