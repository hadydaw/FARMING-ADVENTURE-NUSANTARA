# Technical Architecture — Farming Adventure Nusantara

> **Versi:** 0.34 (+ D-014 Single-Player Online) · Engine dan arsitektur disetujui pemilik (O-001) · Berlaku untuk keputusan teknis T-001 s.d. T-009 di `DESIGN_DECISIONS.md`.

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
- **Audio 3D/posisional** untuk suara dunia (NPC, hewan, monster) dengan jarak dan LOD, selaras simulasi LOD NPC (§4i).
- **Aset:** streaming untuk musik panjang, pemuatan per wilayah, format terkompresi (mis. Ogg Vorbis) agar ukuran APK terkendali (§3); sumber/lisensi aset dicatat.
- **Bahasa:** kunci audio terpisah dari terjemahan bila nanti ada suara pengisi (§6).
- **Pengujian:** uji headless untuk kelengkapan pemetaan ID ke aset dan keberadaan bus; fokus waktu loading, bukan kualitas dengar.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4t. Implikasi Arsitektur dari D-033 (hanya catatan; belum diimplementasikan)

- **Camera Rig terpusat** (satu `Camera3D` di bawah rig pengontrol) yang mengikuti pemain; perilaku diatur oleh **profil kamera berbasis data** (jarak, sudut, FOV, offset, kecepatan peredaman) per konteks: jelajah, farming, interaksi, combat, dungeon, bangunan, cerita/boss.
- **Pemilih profil** membaca konteks aktivitas dari event bus dan konteks UI (§4r); peralihan dengan interpolasi/peredaman (ease) dan prioritas konteks agar tidak bolak-balik (histeresis/penundaan kecil), sehingga orientasi tidak hilang. Arah hadap dipertahankan saat transisi.
- **Zoom dan rotasi pemain** sebagai offset terbatas (clamp) di atas profil; nilai disimpan sebagai pengaturan pemain (seperti D-031/D-032), bukan save game; dapat di-reset ke bawaan. Dipetakan ke Input Action (§7).
- **Tabrakan kamera:** pemeriksaan sederhana (satu raycast/spring-arm ringan) agar tidak menembus dinding; dirancang murah untuk perangkat Android.
- **Performa (GL Compatibility):** FOV/jarak far dan jarak lihat disetel per profil agar mengurangi objek yang dirender; tidak ada efek pascapemrosesan berat yang bergantung kamera; kamera diperbarui di proses fisika/akhir frame tanpa alokasi per frame; selaras anggaran §3 dan LOD (§4i).
- **Hook efek:** guncangan dan sinematik cerita/boss disediakan sebagai lapisan terpisah di atas rig, dengan opsi mengurangi guncangan (aksesibilitas).
- **Hubungan:** audio posisional mengikuti posisi pendengar/kamera (D-032); penargetan combat (D-013) dan lock-on menunggu desain.
- **Pengujian:** uji headless untuk batas clamp zoom/rotasi dan kelengkapan profil per konteks; uji perangkat nyata untuk kenyamanan dan FPS dilakukan nanti.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4u. Implikasi Arsitektur dari D-034 (hanya catatan; belum diimplementasikan)

- **Satu lapisan input terpadu:** joystick virtual, tombol aksi, dan tap-to-move semuanya menghasilkan **Input Action / perintah gerak** yang sama (§7) ke pengontrol karakter; logika game tidak tahu sumber input. Ini juga mendasari dukungan kontroler/keyboard dan uji otomatis.
- **Pemisahan area sentuh:** tiap sentuhan dilacak per *touch index* dan dimiliki satu kontrol sejak awal sampai lepas (joystick, tombol, atau dunia/tap-to-move), sehingga multi-touch tidak saling mengganggu; zona joystick/tombol menjadi prioritas di atas area tap dunia, dan ketukan dibedakan dari seretan kamera dengan ambang jarak/waktu.
- **Tap-to-move:** ketukan di dunia memicu pencarian jalur ke titik (navigasi/NavigationServer, ringan); input joystick langsung **membatalkan** gerak otomatis; hanya aktif pada konteks yang mengizinkan (data per konteks).
- **Tombol aksi kontekstual:** set tombol per konteks (jelajah, farming, interaksi, combat, dll.) sebagai data, memakai manajer konteks UI (§4r); aksi yang ditampilkan mengikuti objek/target terdekat. Tata letak default per konteks dengan pengaturan ukuran/posisi/transparansi dan sensitivitas sebagai **pengaturan pemain**, bukan save game (selaras D-031, D-032, D-033).
- **Integrasi kamera:** input kamera (zoom/rotasi) memakai Input Action terpisah dan tidak bentrok dengan joystick; arah gerak joystick relatif terhadap kamera adaptif (§4t) dan tetap konsisten saat kamera beralih agar orientasi tidak hilang.
- **Performa:** pemrosesan input ringan, tanpa alokasi per frame; kontrol digambar sebagai Control sederhana (sedikit draw call, §3); *dead zone* dan kurva sensitivitas dapat diatur.
- **Pengujian:** uji headless untuk pemetaan Input Action, pembatalan tap-to-move oleh joystick, dan kepemilikan sentuhan multi-touch; kenyamanan diuji di perangkat nyata nanti.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4v. Implikasi Arsitektur dari D-035 (hanya catatan; belum diimplementasikan)

- **Komponen Interactable:** objek dunia (tanaman, hewan, NPC, fasilitas, item, peti, pintu, objek dungeon) mengekspos komponen/antarmuka yang sama: ID aksi yang didukung, titik fokus, dan **validasi** (`can_interact(aktor, aksi)`) dari data dan kondisi (alat, stamina, waktu, cuaca, status quest). Jenis objek dan aksi dari data (§4g), bukan kode per objek.
- **Pemilihan target (target selection):** pengumpul kandidat memakai area deteksi di sekitar pemain (Area3D/query fisika berkala, bukan per frame penuh) plus hasil raycast untuk ketukan langsung. Kandidat diberi skor (jarak, arah hadap/kamera, kesesuaian dengan aktivitas) dan dipilih satu **target aktif**.
- **Prioritas input:** (1) target yang **dipilih pemain** (ketukan langsung/penguncian) menang dan bertahan sampai dilepas atau di luar jangkauan; (2) tombol UI di atas ketukan dunia (sejalan §4u); (3) target proximity terbaik; histeresis kecil agar target tidak berkedip saat objek berdekatan. Satu aksi diproses sekali (cegah dobel dari tap + tombol).
- **Aksi valid saja:** daftar aksi dibangun dari validasi; tombol aksi kontekstual (§4u) menampilkan aksi utama target aktif, aksi tambahan lewat menu kecil. Alasan penolakan memakai kunci terjemahan (id/en, §6).
- **Aksi penting:** tindakan yang ditandai di data (mis. menjual, membuang, tindakan tak dapat dibatalkan) memerlukan konfirmasi/tahan; aksi rutin tidak otomatis tanpa niat pemain. Definisi menunggu desain.
- **Eksekusi aksi:** perintah aksi → sistem terkait (pertanian, peternakan, crafting, dll.) lewat event bus (§4); interaksi menyetel konteks aktivitas untuk UI (§4r) dan kamera (§4t).
- **Performa:** deteksi berkala dan jumlah kandidat dibatasi; tanpa alokasi per frame; penanda target ringan (GL Compatibility, §3). Objek jauh tidak diperiksa (LOD, §4i).
- **Pengujian:** uji headless untuk pemilihan target pada objek berdekatan, prioritas pilihan pemain, validasi aksi, dan tidak adanya aksi ganda.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4w. Implikasi Arsitektur dari D-036 (hanya catatan; belum diimplementasikan)

- **Definisi item dari data** (sistem item terpusat, §4g): ID, kategori, batas stack, flag (unik, tak bisa ditumpuk, item quest, bisa dijual/dibuang), berat, nilai, kunci terjemahan nama/deskripsi (id/en, §6). Kategori D-036 adalah data, sehingga mudah diperluas.
- **Model inventory:** wadah (`Inventory`) berisi slot; tiap slot menyimpan `{item_id, jumlah, atribut/instans}`. Item stackable hanya menyimpan ID + jumlah; item berinstans (senjata, armor, kualitas) menyimpan data per instans. Wadah yang sama dipakai untuk tas pemain, peti, penyimpanan rumah, dan toko, sehingga logika pindah/gabung satu tempat.
- **Kapasitas:** parameter wadah (jumlah slot dan/atau batas berat) dihitung dari sumber modifikator (tas, equipment, perkembangan karakter, sistem stat §4g) dan dapat berubah tanpa mengubah data item; model slot/berat belum diputuskan sehingga logika kapasitas dibuat sebagai strategi yang dapat diganti.
- **Operasi atomik:** tambah, ambil, pindah, gabung/pisah stack, dan tukar dilakukan lewat satu API yang mengembalikan hasil (berhasil, sisa, penyebab gagal); inventory penuh ditangani dengan hasil sisa, sehingga pemanggil (panen, loot, crafting, hadiah, toko) menentukan perilaku (tolak/jatuhkan/kirim ke penyimpanan) sesuai desain nanti. Tidak ada item hilang saat gagal.
- **Integrasi:** sistem lain memakai API yang sama lewat event bus (§4): pertanian, peternakan, memancing, crafting/alkimia, dungeon, equipment, ekonomi. Hotbar/akses cepat adalah referensi ke slot, bukan salinan.
- **Penyimpanan:** isi inventory masuk payload save (§5) sebagai daftar kompak (ID, jumlah, atribut); mengacu ke ID item, sehingga item yang dihapus/diubah di versi baru ditangani lewat migrasi skema. Susunan slot dan pilihan sortir/filter terakhir disimpan; pengaturan tampilan dapat dipisah sebagai pengaturan pemain.
- **Pencarian, sortir, filter:** pada indeks/turunan tampilan (tidak mengubah susunan data kecuali pemain memilih "urutkan"); mendukung kunci terjemahan agar pencarian sesuai bahasa aktif.
- **UI/kontrol:** panel inventory memakai manajer konteks UI (§4r) dan aksi sentuh (§4u): ketuk untuk pilih, seret untuk pindah, tombol aksi untuk pakai/simpan; daftar panjang memakai virtualisasi.
- **Performa:** operasi O(jumlah slot) kecil, tanpa alokasi per frame, sinyal perubahan hanya untuk slot yang berubah (§3).
- **Pengujian:** uji headless untuk stack/gabung/pisah, kapasitas penuh tanpa kehilangan item, pemindahan antarwadah, serialisasi-deserialisasi, dan migrasi.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4x. Implikasi Arsitektur dari D-037 (hanya catatan; belum diimplementasikan)

- **Definisi quest dari data** (resource/JSON terjadwal, bukan kode): ID unik stabil, jenis, pemberi, prasyarat, daftar objektif, cabang, hadiah, aturan ulang. Teks memakai kunci terjemahan (id/en, §6); teks naratif panjang boleh dipisah per berkas.
- **Mesin keadaan quest:** status (terkunci, tersedia, aktif, selesai, gagal, dibatalkan, kedaluwarsa) dan transisi yang jelas; objektif adalah komponen data dengan tipe (kumpulkan, bunuh, antar, bicara, capai lokasi, bangun, dll.), progres, dan syarat; mendukung objektif berurutan dan paralel, serta objektif opsional.
- **Pelacakan berbasis event:** objektif berlangganan **event bus** (§4) yang sudah ada (panen, loot, bunuh, interaksi §4v, inventory §4w, transaksi, masuk wilayah), bukan polling per frame; hanya quest aktif yang mendengarkan.
- **Kondisi dan cabang:** syarat dan konsekuensi dinyatakan lewat bahasa kondisi/efek sederhana berbasis data (membaca flag cerita, hubungan NPC §4i, reputasi/rank Guild, wilayah, item, waktu) dan sistem kondisi/efek yang sama dengan sistem lain, sehingga satu mesin dipakai bersama; pilihan dan hasil tercatat sebagai flag cerita.
- **Quest harian/berulang:** dihasilkan dari kalender game dan penyemaian deterministik (seed + tanggal, §4b) sehingga konsisten dan tak dapat dimanipulasi dengan save-scumming; reset mengikuti waktu dunia, bukan jam perangkat.
- **Cegah quest buntu:** validasi saat pembuatan konten (alat/uji headless memeriksa semua quest dapat diselesaikan: prasyarat tidak saling mengunci, item quest tak dapat hilang atau dapat diperoleh ulang, urutan tak bergantung satu jalur); saat runtime, quest dengan syarat tak lagi terpenuhi ditandai dan dipulihkan/diganti sesuai aturan desain nanti.
- **Penyimpanan dan cloud:** status dan progres tiap quest, flag cerita, dan riwayat masuk payload save (§5) sebagai data kompak dengan versi skema dan migrasi saat definisi quest berubah (ID tetap, quest yang dihapus ditangani). Sinkronisasi cloud Supabase memakai mekanisme save yang sama (D-014); resolusi konflik mengikuti desain online, dan progres cerita dan hadiah tidak boleh terduplikasi atau hilang.
- **Hadiah:** diberikan lewat API inventory (§4w) dan sistem ekonomi/pengalaman; inventory penuh tidak boleh menghilangkan hadiah quest (ditunda atau dikirim ke penyimpanan sesuai desain nanti).
- **UI:** journal, pelacak objektif aktif di HUD, penanda lokasi di peta/dunia, notifikasi, riwayat; memakai manajer konteks UI (§4r) dan daftar tervirtualisasi.
- **Performa:** hanya quest aktif dan terdekat diproses; indeks prasyarat untuk pembukaan quest; tanpa alokasi per frame (§3).
- **Pengujian:** uji headless untuk transisi status, objektif paralel/berurutan, cabang, reset harian, serialisasi-migrasi, dan validasi keterselesaian semua quest.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4y. Implikasi Arsitektur dari D-038 (hanya catatan; belum diimplementasikan)

Memperluas catatan dialog di §4i dan memakai mesin kondisi/efek yang sama dengan quest (§4x).
- **Dialog sebagai graf data:** tiap percakapan adalah resource berisi *node* (ucapan, pilihan, cabang, aksi/efek, akhir) dan *edge* bersyarat; ID stabil per node. Dipisah per NPC/topik agar mudah dikelola.
- **Pemilih dialog:** saat interaksi (§4v), pemilih mengevaluasi dialog kandidat NPC (cerita, quest, harian, khusus) dan memilih satu berdasarkan **prioritas dan syarat** yang deterministik; kandidat tak memenuhi syarat disaring (kondisi pembuka). Pilihan terkunci dapat ditampilkan abu-abu dengan alasan (belum diputuskan) atau disembunyikan.
- **Kondisi dan efek:** memakai bahasa kondisi/efek bersama (§4x): hubungan/kepercayaan NPC (§4i), reputasi/rank Guild (§4d), flag cerita, status quest, waktu/musim/cuaca (§4b, §4q), lokasi/wilayah (§4o), event dunia (§4p), item (§4w). Efek: ubah hubungan, mulai/majukan quest, beri item/uang, set flag, buka toko, pindah adegan.
- **Hindari pengulangan:** penyimpan keadaan percakapan per NPC (node/topik yang sudah dilihat, pencacah, waktu terakhir bicara dalam hari game) dibaca pemilih; ucapan harian memakai kumpulan variasi dengan pemilihan deterministik (seed + tanggal, §4b) dan penanda "sudah dibicarakan" per topik.
- **Lokalisasi:** semua teks lewat kunci terjemahan (id/en, §6); tidak ada teks di kode maupun tertanam di gambar/aset visual (potret, balon, ikon tanpa teks); teks panjang dipisah per berkas dialog; placeholder (nama pemain, angka, item) memakai format bernama agar urutan kata bebas per bahasa; layout menoleransi teks panjang; skrip uji headless memeriksa kunci id dan en lengkap dan placeholder sama.
- **Persistence:** keadaan dialog (flag, hubungan, topik terlihat, pilihan yang diambil) masuk payload save (§5) dengan versi skema; ID node stabil agar migrasi dapat memetakan ulang; cloud save Supabase lewat mekanisme save yang sama (D-014).
- **UI dialog:** panel di manajer konteks UI (§4r): kotak teks, nama dan potret, daftar pilihan berukuran target sentuh nyaman, lewati/percepat, riwayat; kontrol lewat Input Action (§4u); transisi kamera lewat profil percakapan (§4t); audio dialog lewat bus Efek/Musik (§4s).
- **Performa:** hanya graf NPC yang sedang dibicarakan dimuat; evaluasi kondisi per interaksi, bukan per frame (§3).
- **Validasi konten:** alat/uji headless memeriksa graf tanpa node mati, semua pilihan dapat dicapai atau punya jalan keluar, rujukan ke quest/flag/NPC valid, dan tidak ada dialog yang tak mungkin dipicu.
- **Cakupan hubungan:** hanya pertemanan/kepercayaan; romansa/keluarga tidak dimodelkan sampai diputuskan.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4z. Implikasi Arsitektur dari D-039 (hanya catatan; belum diimplementasikan)

Memperluas penyimpan hubungan di §4i; dibaca dialog (§4y) dan quest (§4x).
- **Dua lapisan terpisah:** (1) **hubungan individu** per NPC (friendship, trust, flag personal story, daftar friendship event yang sudah terjadi, hadiah/interaksi terakhir) dan (2) **reputasi per cakupan** (scope: desa, kota, Guild, komunitas lain) sebagai ruang nama terpisah `reputasi[scope_id]`. Keduanya tidak otomatis saling menambah; hubungan dengan NPC hanya memengaruhi reputasi lewat aturan efek yang ditulis eksplisit dalam data. Reputasi/rank Guild memakai penyimpan yang sama dengan §4d.
- **Data per NPC:** preferensi (hadiah, topik), ambang trust, kepribadian/reaksi sebagai data templat dan override per NPC (§4i); tingkat hubungan didefinisikan sebagai ambang data sehingga skala dan nama dapat diubah tanpa mengubah kode.
- **Perubahan lewat event bus (§4):** tindakan pemain (bantuan, hadiah, quest, percakapan, kejahatan, event dunia) dipancarkan sebagai event; aturan data menerjemahkannya menjadi delta hubungan/reputasi dengan **batas harian, penurunan hasil (diminishing returns), dan pembatas laju** agar tidak naik tak masuk akal atau dapat dieksploitasi (mis. spam hadiah); aturan memakai tanggal game (§4b), bukan jam perangkat.
- **Konsekuensi konsisten:** satu penanganan efek (mesin kondisi/efek bersama §4x) menerapkan perubahan dan mencatat penyebab (log ringkas) sehingga dapat diaudit dan diuji; pemulihan/perbaikan hubungan sebagai aturan data nanti.
- **Pemicu:** friendship event dan personal story dipicu oleh kondisi (ambang hubungan, waktu, lokasi, musim/cuaca §4q, event §4p, status quest) lewat pengevaluasi yang sama dengan quest/dialog, dijalankan saat peristiwa relevan, bukan polling per frame; jadwal NPC (§4i) menentukan kapan/di mana NPC tersedia.
- **Dampak ke sistem lain:** akses layanan/toko (§4h), harga, kesempatan quest (§4x), dan opsi dialog (§4y) membaca nilai lewat API kueri tunggal (`get_relationship`, `get_reputation(scope)`), tanpa menyalin angka.
- **Indikator UI:** UI membaca tingkat/ambang (bukan angka mentah) untuk tampilan yang mudah dipahami; panel di manajer konteks UI (§4r); teks lewat kunci terjemahan id/en (§6).
- **Persistence:** hubungan, reputasi per scope, flag dan event yang telah terjadi masuk payload save (§5) berversi; ID NPC dan scope stabil, dengan migrasi saat NPC/komunitas diubah; cloud save Supabase lewat mekanisme save yang sama (D-014), sebagai progres pribadi tanpa sinkronisasi real-time; konflik ditangani sesuai desain online.
- **Performa:** hanya NPC aktif/terdekat dievaluasi; nilai disimpan dalam tabel kompak, evaluasi per event (§3).
- **Pengujian:** uji headless untuk batas harian dan diminishing returns, pemisahan hubungan vs reputasi, penerapan efek konsisten, pemicu event, serialisasi-migrasi.
- **Cakupan:** hanya pertemanan/kepercayaan/reputasi; model dapat diperluas, tetapi romansa/pernikahan/keluarga/anak tidak dimodelkan sampai diputuskan.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4aa. Implikasi Arsitektur dari D-040 (hanya catatan; belum diimplementasikan)

Memperdalam simulasi NPC di §4i (LOD, jadwal) dan memakai penyimpan hubungan §4z.
- **Tiga tingkat simulasi (LOD):** (1) **penuh** (dekat pemain): bergerak, animasi, AI perilaku, interaksi; (2) **ringan** (sedang): hanya posisi/aktivitas dari jadwal, tanpa navigasi detail; (3) **berbasis waktu** (jauh/wilayah lain): tidak disimulasikan, posisi dan aktivitas **diturunkan dari jadwal + waktu game** saat dibutuhkan (stateless dari kalender, §4b). Batas jumlah NPC tingkat penuh dan jarak transisi adalah data yang dapat disetel (anggaran §3); perpindahan tingkat mulus (NPC "muncul" di titik yang konsisten dengan jadwal).
- **Perilaku hybrid:** lapisan atas **jadwal** (data: waktu/hari/musim/cuaca → aktivitas dan lokasi); lapisan bawah **perilaku** berupa FSM/behavior tree/utilitas ringan untuk tiap aktivitas (bekerja, berdagang, bertani, memasak, jalan, istirahat, sosialisasi, event). Keputusan dievaluasi **berkala dan berbasis event** (ganti jam, cuaca berubah, event dunia, pemain mendekat), bukan tiap frame; evaluasi disebar antar-frame (time-slicing) agar tidak lonjakan.
- **Kebutuhan dan kondisi:** model ringan (mis. energi, lapar, suasana) sebagai nilai terhitung dari selisih waktu, memengaruhi pilihan aktivitas; tingkat kerincian menunggu desain; memakai sistem kondisi/efek bersama (§4x).
- **Pekerjaan dan ekonomi:** aktivitas kerja NPC terhubung ke stasiun/fasilitas (§4n) dan sistem ekonomi (§4h) lewat pesan/event; efek besar ke harga/pasokan dihitung agregat per hari, bukan per aksi; deterministik dengan seed + tanggal (§4b).
- **Interaksi antar-NPC:** pasangan/kelompok NPC dekat dengan "slot sosial" pada titik minat (pasar, sumur, kedai); hanya dihitung bila ada di tingkat penuh/ringan; hasilnya dapat tercatat sebagai fakta dunia ringkas (flag), bukan simulasi percakapan penuh.
- **Navigasi dan terjebak:** navigation mesh per area (§4o) dan agen navigasi terbatas jumlahnya; deteksi terjebak (tak ada progres dalam waktu/jarak tertentu atau jalur gagal berulang) memicu **eskalasi tetap**: hitung ulang jalur → titik alternatif → teleport senyap ke titik jadwal valid saat di luar pandangan; pencegahan perulangan dengan penanda jalur gagal sementara (cooldown).
- **Fallback:** setiap aktivitas jadwal punya daftar lokasi/aktivitas cadangan (mis. di dalam ruangan saat hujan atau lokasi rusak/terkunci/terblokir); bila semua gagal, NPC ke "titik aman" (rumah/tempat tidur) dan kejadian dicatat untuk uji.
- **Respons event:** NPC mendengarkan event bus (§4): cuaca ekstrem, event dunia (§4p), serangan, festival; **daftar respons data** (kumpul, berlindung, lari, ikut event) dengan prioritas di atas jadwal normal dan kembali ke jadwal setelah selesai.
- **Perkembangan desa:** variabel dunia (§4i/§4x) yang berubah oleh quest, event, dan tindakan pemain; NPC/fasilitas/jadwal bereaksi lewat kondisi data, sehingga perubahan tidak butuh kode khusus.
- **Konsistensi saat pindah wilayah/muat ulang:** keadaan NPC dasar = (jadwal, waktu game, seed, flag) sehingga posisi dapat dihitung ulang tanpa menyimpan jalur; hanya keadaan yang tak dapat diturunkan (kebutuhan, interupsi, hasil keputusan, hubungan, flag) disimpan di payload save (§5) berversi; muat ulang menempatkan NPC pada titik jadwal yang sah.
- **Online/cloud:** NPC adalah progres pribadi (D-014); tidak ada sinkronisasi real-time; cloud save lewat mekanisme save yang sama.
- **Lokalisasi:** nama NPC, peran, dan teks aktivitas lewat kunci terjemahan id/en (§6).
- **Pengujian:** uji headless simulasi jadwal 1 musim untuk semua NPC (tak ada yang terjebak atau tanpa lokasi valid), konsistensi posisi saat transisi LOD dan muat ulang, fallback, serta anggaran waktu CPU per frame di perangkat target nanti.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4ab. Implikasi Arsitektur dari D-041 (hanya catatan; belum diimplementasikan)

- **Karakter modular:** satu rangka (skeleton) bersama dengan **slot** bagian (kepala/wajah, rambut, badan, tangan, kaki, punggung, aksesori, senjata); tiap bagian adalah resource data (mesh, material, titik pasang/atachment) yang dirancang terhadap rangka yang sama, sehingga animasi tunggal berlaku untuk semua kombinasi dan tidak ada animasi per pakaian. Warna (rambut, kulit, pakaian) lewat parameter material/palet, bukan mesh/tekstur baru.
- **Dua lapisan data:** **equipment (fungsi)** menentukan atribut (§4g, §4e); **tampilan (cosmetic)** menentukan apa yang digambar. Tampilan akhir = kosmetik terpilih per slot, atau bila kosong/tidak diganti, visual bawaan equipment. Mengganti kosmetik tidak mengubah atribut; mengganti equipment tidak harus mengubah kosmetik. Aturan per aktivitas (mis. profil pakaian untuk farming/petualangan) sebagai data.
- **Katalog kosmetik dari data:** ID stabil, slot, kunci terjemahan nama/deskripsi (id/en, §6), syarat pembukaan sebagai kondisi (quest §4x, pencapaian, event §4p, dungeon, eksplorasi) memakai mesin kondisi/efek bersama; item kosmetik yang terbuka dicatat sebagai koleksi pemain (wardrobe), bukan item yang memakan slot inventory (§4w) kecuali diputuskan lain; perolehan lewat crafting/toko memakai sistem item yang sama (§4g, §4h).
- **Konsistensi 3D dan animasi:** bagian dibuat pada rangka dan skala acuan; aturan penutup (bagian yang menyembunyikan bagian lain, mis. topi menyembunyikan rambut) sebagai data per bagian (mask/hide-flags) untuk mencegah tembus mesh; senjata dan perlengkapan memakai titik pasang bernama dan pose tersimpan (di tangan/punggung); pembaruan tampilan hanya saat berubah, bukan tiap frame.
- **Performa (Android, GL Compatibility):** anggaran poligon/tulang per karakter dan jumlah material (draw call) per karakter; **penggabungan mesh** (merge/atlas tekstur bersama) setelah perubahan tampilan untuk menekan draw call; tekstur atlas dan kompresi sesuai target (§3); LOD karakter dan penyederhanaan untuk NPC jauh; pemuatan bagian sesuai kebutuhan (lazy load) dan pooling resource; batas variasi ditetapkan dalam desain konten.
- **UI:** character creator dan wardrobe memakai manajer konteks UI (§4r), pratinjau 3D kecil dengan kamera khusus (§4t) dan kontrol sentuh (§4u), kategori/filter seperti inventory; semua label lewat kunci terjemahan dan tidak ada teks pada tekstur/aset visual.
- **Persistence:** keadaan tampilan (pilihan wajah/rambut/warna, kosmetik terpilih per slot, aturan per aktivitas) dan koleksi yang terbuka masuk payload save (§5) berversi dengan ID stabil; bagian yang dihapus/diubah di versi baru ditangani migrasi (jatuh ke bawaan); cloud save Supabase lewat mekanisme save yang sama (D-014). Pengaturan tampilan murni UI (mis. urutan filter) dapat berupa pengaturan pemain.
- **Konsumen lain:** NPC dan companion dapat memakai sistem karakter modular yang sama (belum diputuskan); event dan cerita dapat memaksa kosmetik sementara lewat efek data.
- **Pengujian:** uji headless untuk keterpenuhan slot dan titik pasang, aturan penutup, perhitungan tampilan akhir (kosmetik vs equipment), serialisasi-migrasi, tidak adanya teks pada aset, dan anggaran draw call/material per karakter; uji visual dan FPS di perangkat nyata nanti.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4ac. Implikasi Arsitektur dari D-042 (hanya catatan; belum diimplementasikan)

- **Satu model "kendaraan/tunggangan" berbasis data:** jenis (hewan, monster, darat, air, spiritual) hanyalah profil data: kecepatan, percepatan, stamina/energi, kapasitas, **tag medan yang diizinkan**, kemampuan, titik duduk/kendali, dan kebutuhan (perawatan/pakan). Mount hewan dan monster memakai **model makhluk bersama** (§4f, §4k) sehingga atribut, level, ikatan, dan kebutuhan berasal dari sistem yang sama dengan companion/ternak; kendaraan non-hidup (kereta, perahu) memakai profil yang sama tanpa komponen makhluk.
- **Mesin keadaan mount:** tidak dipanggil → dipanggil/tiba → dinaiki → diturunkan → disimpan/diistirahatkan (+ terluka/tidak tersedia). Transisi (naik/turun/ganti) memakai kondisi valid (tempat, medan, status, combat) dengan interaksi §4v dan tombol kontekstual §4u; satu aksi diproses sekali.
- **Integrasi gerak:** saat dinaiki, kendali karakter berpindah ke kontroler mount (joystick/tap-to-move tetap, §4u); perhitungan gerak memakai profil mount (kecepatan, belok, percepatan), stamina berkurang sesuai aksi dan pulih saat istirahat. Pemain dan mount dipasang sebagai satu rig (pemain sebagai anak dari titik duduk) untuk menghindari selisih posisi; tabrakan memakai satu kapsul/bentuk gabungan.
- **Medan dan akses:** setiap area/permukaan memiliki **tag medan** (§4o: darat, air dangkal/dalam, hutan lebat, pegunungan, dungeon sempit, dll.); kendaraan hanya sah jika tag medan masuk daftar izin, dan wilayah/dungeon dapat melarang atau membatasi mount lewat data (§4c, §4o). Perpindahan medan (mis. darat ke air) memicu pengecekan: berhenti, berganti kendaraan, atau ditolak dengan pesan terjemahan (§6). Akses mengikuti progres lewat kondisi bersama (§4x).
- **Pemanggilan:** aturan data per jenis (lokasi yang boleh, cooldown, biaya, jarak, apakah mount "datang" atau muncul). Mount yang dipanggil muncul pada titik valid dekat pemain (NavMesh) dan tidak tersangkut; mount yang tidak sedang dipakai tidak disimulasikan penuh (LOD makhluk, §4i/§4aa): posisi dihitung dari keadaan tersimpan atau berada di istal/kandang.
- **Navigasi:** mount dan pengikut memakai navigation mesh dan tag medan yang sama dengan NPC (§4aa), termasuk penanganan terjebak (kembali ke pemain/titik aman), serta jalur khusus air untuk perahu; tap-to-move dihitung terhadap kemampuan mount.
- **Animasi dan collision:** animasi gabungan (pemain duduk/berkendara + mount) melalui titik pasang dan layer animasi terpisah; transisi naik/turun diselaraskan dengan rig dan collider; senjata dan kosmetik karakter (§4ab) tetap konsisten saat berkendara; penyesuaian tinggi/orientasi di lereng sederhana (tanpa IK berat).
- **Kamera:** profil kamera khusus untuk berkendara (jarak lebih jauh, FOV/lead sesuai kecepatan) dengan transisi halus dari/ke profil jelajah (§4t); batas zoom/rotasi pemain tetap berlaku.
- **Inventory dan muatan:** kapasitas muatan kendaraan sebagai wadah inventory (§4w) bila diputuskan, atau pengubah kapasitas pemain; item kendaraan/mount yang dapat dibeli, dibuat, atau didapat memakai sistem item/ekonomi (§4g, §4h).
- **Perkembangan:** level, ikatan, dan kemampuan memakai sistem stat dan perkembangan yang sama (§4e, §4f); kemampuan spiritual/langka sebagai data efek (konsep "spiritual" belum didefinisikan, tidak diasumsikan).
- **Persistence:** keadaan mount (ID, atribut, level, ikatan, stamina, lokasi/penyimpanan, status, kosmetik) masuk payload save (§5) berversi dengan ID stabil; saat muat ulang mount ditempatkan pada titik valid (tidak menyimpan jalur) dan pemain yang sedang berkendara dipulihkan dalam keadaan konsisten (naik atau diturunkan di titik aman bila medan berubah); cloud save Supabase lewat mekanisme save yang sama (D-014).
- **Audio:** langkah/mesin/air dan suara makhluk lewat sistem audio (§4s) menurut medan.
- **Performa:** satu mount aktif penuh dalam satu waktu; mount lain LOD/tidak disimulasikan; hindari alokasi per frame; selaras anggaran §3.
- **Pengujian:** uji headless untuk transisi keadaan, aturan medan dan akses, pemanggilan pada titik valid, stamina, serialisasi-migrasi, dan tidak adanya mount tersangkut (simulasi jalur uji); uji perangkat nyata nanti.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

### 4ad. Implikasi Arsitektur dari D-043 (hanya catatan; belum diimplementasikan)

- **Tutorial sebagai data:** tiap panduan adalah resource (ID stabil, topik/aktivitas, pemicu, syarat, langkah, penanda wajib/opsional, tampilan, rujukan ke entri buku bantuan). Teks lewat kunci terjemahan id/en (§6) dan tidak ada teks pada gambar/aset visual; ikon kontrol mengikuti pengaturan tombol pemain (§4r, §4u) sehingga petunjuk tetap benar setelah tata letak diubah.
- **Pemicu kontekstual berbasis event:** manajer tutorial berlangganan **event bus** (§4): pertama kali pemain bertemu objek/aktivitas (interaksi §4v, panen, memancing, crafting, combat, dungeon, taming, masuk wilayah, Guild, transaksi), membuka menu (inventory §4w), atau mencapai progres tertentu; pemicu memakai mesin kondisi/efek bersama (§4x) dan tidak polling per frame. Panduan tampil hanya bila syarat terpenuhi dan belum pernah dilihat.
- **Tidak memaksa dan adaptif:** bila pemain sudah melakukan aksi yang diajarkan sebelum panduan muncul, panduan ditandai selesai otomatis; panduan dapat ditutup/dilewati, kecuali yang bertanda wajib (diperlukan untuk melanjutkan; dijaga seminimal mungkin dan harus dapat diselesaikan). Antrean dan **penahan (throttle/cooldown)** mencegah banyak panduan muncul bersamaan atau saat combat/dialog; prioritas dan penundaan sebagai data.
- **Integrasi quest dan dialog:** langkah tutorial dapat dibungkus sebagai quest (§4x) atau disampaikan lewat dialog NPC (§4y, §4aa) dengan efek yang menandai topik selesai; satu sumber kebenaran status agar tidak ada duplikasi antara quest dan panduan.
- **Sorotan UI:** lapisan *overlay* ringan menandai kontrol/area (HUD, tombol aksi, slot inventory) memakai identitas elemen UI (bukan koordinat tetap) agar tahan terhadap tata letak yang diubah dan ukuran layar; tidak memblokir input yang tidak relevan, kecuali langkah wajib.
- **Buku bantuan:** daftar entri dari data yang sama, dibuka kembali kapan saja dari menu (§4r); entri terbuka bertambah saat topik ditemukan; pencarian/filter seperti inventory; teks berbahasa aktif.
- **Persistence:** status per panduan (belum/terlihat/selesai/dilewati), topik buku bantuan yang terbuka, dan pengaturan petunjuk (aktif/nonaktif) masuk payload save (§5) berversi dengan ID stabil; panduan baru di versi berikut muncul sesuai syarat tanpa mengulang yang lama; cloud save Supabase lewat mekanisme save yang sama (D-014) sehingga pindah perangkat tidak mengulang tutorial. Pengaturan tampilan petunjuk murni dapat menjadi pengaturan pemain.
- **Performa:** hanya pemicu panduan yang belum selesai yang aktif; konten tutorial dimuat sesuai kebutuhan; overlay tanpa alokasi per frame (§3).
- **Pengujian:** uji headless untuk pemicu dan status (tidak muncul ulang), penyelesaian otomatis, throttle, kelengkapan kunci id/en, rujukan UI/kontrol valid, panduan wajib selalu dapat diselesaikan, dan serialisasi-migrasi.
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

### 5a. Implikasi Arsitektur dari D-044 (hanya catatan; belum diimplementasikan)

Memperluas §5 (fondasi lokal yang sudah ada tetap berlaku sebagai cache lokal). Detail server ada di `BACKEND_DESIGN.md` §5a.
- **Aliran data:** *state game → penulis save (event-driven) → cache lokal atomik (§5) → antrean sinkronisasi → Supabase.* Game selalu membaca dan menulis ke cache lokal; sinkronisasi berjalan di latar belakang. Bila tidak ada sesi akun/koneksi, game mengikuti desain online-only (D-014): cache menampung perubahan terbatas dan menunggu koneksi; **tidak** menjadi mode bermain offline penuh. Perilaku pada gangguan lama menunggu desain.
- **Pemicu auto-save:** penerbit event bus (§4) untuk peristiwa penting (quest §4x, inventory §4w, karakter §4e, hubungan §4z, farming §4j, dungeon §4c, mount §4ac, dll.) menandai **dirty**; penulis menggabungkan (debounce/coalescing) agar tidak menulis berlebihan, dengan **simpan paksa** saat aplikasi masuk latar belakang (`NOTIFICATION_APPLICATION_PAUSED`/focus out), saat transisi wilayah, dan saat keluar. Penulisan di luar jalur kritis (thread/ditunda ke frame lega) agar tidak mengganggu FPS; hindari hitch pada GL Compatibility (§3).
- **Skema save modular:** payload berisi **bagian per sistem** (karakter, inventory, quest, NPC/hubungan, farming/ternak, bangunan, mount, dunia/waktu, tutorial, pengaturan progres), masing-masing dengan `section_version` selain `schema_version` global; tiap sistem mendaftarkan serializer dan migrator sendiri. Amplop tetap (§5): `schema_version, game_version, revision, updated_at, checksum, payload`, ditambah `device_id`, `base_revision`, `section_revisions`. Pengaturan murni UI (tata letak tombol, volume, kamera; D-031 sampai D-034) dipisah sebagai **pengaturan pemain** dengan jalur sinkron sendiri.
- **Versioning dan migrasi:** migrasi berantai dari versi lama ke baru, dapat diuji; save dari versi lebih baru daripada game ditolak dengan pesan jelas dan **tidak ditimpa**; ID stabil (item, quest, NPC, scope) dipakai agar migrasi dapat memetakan ulang.
- **Validasi:** klien memvalidasi struktur, tipe, rentang, ukuran, dan checksum sebelum menerima data (lokal maupun cloud); data tidak valid dikarantina (tidak dimuat dan tidak menimpa data sehat). Server memvalidasi lagi (skema, ukuran maksimum, rate limit); checksum bukan anti-curang (§5), sehingga data yang memengaruhi ekonomi/rank perlu validasi sisi server (desain menunggu).
- **Pemulihan:** rantai pemulihan lokal: file utama → `.bak` → rotasi snapshot terakhir (beberapa generasi) → salinan cloud; pemulihan otomatis diberi tahu ke pemain; sebelum menimpa save apa pun karena migrasi/konflik dibuat cadangan; cadangan cloud berversi dengan batas retensi (belum diputuskan).
- **Sinkronisasi:** `push_save` (kirim perubahan setelah `base_revision`) dan `pull_save`; sinkron saat dimulai, secara berkala/pada peristiwa penting, dan saat kembali ke aplikasi. **Retry dengan exponential backoff + jitter dan batas jumlah percobaan**; status antrean dan kegagalan tampil di indikator; setelah batas wajar, data tetap aman di cache dan menunggu pemicu berikutnya.
- **Konflik:** deteksi lewat `base_revision` dan `device_id` (§BACKEND §5): server menolak bila `base_revision` ≠ revisi server dan mengembalikan snapshot server. Resolusi **tidak pernah diam-diam** dan tidak menimpa progres lebih baru: (1) bila hanya satu sisi berubah → fast-forward; (2) bila keduanya berubah → perbandingan **per bagian** dan, hanya untuk bagian yang aman digabung (mis. penambahan koleksi/riwayat monoton, pengaturan), gabung otomatis; (3) selain itu **pemain memilih** (lokal/cloud) dengan ringkasan perbedaan (waktu bermain, hari game, progres utama) dan cadangan sisi yang tidak dipilih. Data yang tidak kompatibel (versi skema berbeda, ID tak dikenal) tidak digabung. Aturan rinci menunggu desain.
- **Duplikasi transaksi:** tiap operasi yang mengubah nilai penting (hadiah quest, pembelian/penjualan, drop langka) membawa **ID transaksi/idempoten** (UUID dari klien) yang disimpan dalam payload dan dicatat server (jendela waktu), sehingga pengiriman ulang akibat retry atau pemulihan tidak mengganda; penerapan hasil save yang dimuat tidak menjalankan ulang efek (hadiah hanya diberikan sekali).
- **Konsistensi atomik:** satu snapshot konsisten lintas sistem (dibekukan pada satu titik antar-frame, bukan di tengah transaksi seperti jual-beli/crafting); penulisan lokal tetap atomik (.tmp → .bak → ganti); tidak ada save sebagian yang dianggap sah.
- **Keamanan:** akun hanya dapat membaca/menulis datanya sendiri lewat **Row Level Security** (`user_id = auth.uid()`) pada semua tabel save; klien hanya memakai kunci publik (anon) dan token sesi; **kunci service-role/rahasia tidak pernah** ada di aplikasi atau repo (GitHub Secrets/pengaturan penyedia saja, sesuai SIGNING_GUIDE dan BACKEND_DESIGN §6); semua lalu lintas TLS; token sesi disimpan di penyimpanan privat aplikasi; tidak ada kredensial di source code; rate limit dan batas ukuran payload di server; pengujian kebijakan RLS (akses lintas akun harus ditolak) wajib sebelum rilis.
- **Waktu:** tanggal game dan seed bukan jam perangkat (§4b); timestamp sinkronisasi memakai waktu server sebagai acuan urutan, sehingga mengubah jam perangkat tidak memanipulasi revisi/konflik.
- **Indikator UI:** status ringkas (tersimpan, menyimpan, menunggu koneksi, tersinkron, konflik, error) sebagai komponen global (D-031, §4r); pesan lewat kunci terjemahan id/en (§6); konflik dan pemulihan memakai dialog yang jelas dengan target sentuh nyaman.
- **Integrasi:** semua sistem progres mendaftarkan bagian save lewat antarmuka serializer yang sama; tidak ada sistem yang menulis langsung ke file/cloud.
- **Pengujian:** uji headless untuk serialisasi-migrasi tiap bagian, tulis atomik dan pemulihan berlapis, debounce/simpan paksa, idempotensi transaksi, retry dan batas, skenario konflik (satu sisi/dua sisi/tak kompatibel), penolakan save dari versi lebih baru, serta uji kebijakan RLS pada lingkungan uji; tidak ada tes yang membutuhkan rahasia produksi.
Tidak ada perubahan kode atau pipeline akibat keputusan ini.

## 6. Lokalisasi

- `game/i18n/translations.csv` kolom `keys,id,en` → diimpor Godot menjadi `translations.id.translation` dan `translations.en.translation`.
- Bahasa bawaan `id`; fallback `id`. Layar boot memuat tombol ganti bahasa sebagai uji.
- Aturan: tidak ada string UI di kode; teks dialog/quest panjang nanti dapat dipisah per berkas, tetap kunci → teks.

## 7. Input Sentuh

- `emulate_mouse_from_touch` aktif agar kontrol UI standar berfungsi dengan sentuhan.
- Orientasi: `sensor_landscape` (landscape normal dan terbalik mengikuti sensor).
- Skema kontrol gameplay: **Kontrol Hybrid** sudah diputuskan (D-034, lihat §4u); detail tombol dan gestur kamera menunggu desain (kamera adaptif: D-033, §4t); akan dibangun sebagai scene UI terpisah dan dipetakan ke Input Action, sehingga mendukung kontroler/keyboard untuk uji.

## 8. Backend dan Online

Ringkasan; rincian di [`BACKEND_DESIGN.md`](BACKEND_DESIGN.md).

- Backend awal: **Supabase** (O-003). Nakama tidak diperlukan (D-014: Single-Player Online, tanpa real-time). Tidak ada kode backend sebelum desain sistem online disepakati.
- Backend **terpisah** dari GitHub. GitHub hanya menyimpan kode dan APK.
- Klien memakai antarmuka `BackendClient` (`game/core/backend_client.gd`); default = mode offline (belum ada jaringan).
- Konsekuensi D-014: akun dan koneksi internet **wajib**; dunia dan NPC disimpan sebagai progres pribadi di save; tidak ada jaringan real-time antarpemain.
- Pola: **cache lokal + sinkronisasi** (D-044) — progres ditulis dulu ke cache lokal sebagai penyangga dan dimuat cepat darinya; game tetap online-only (D-014), bukan mode offline penuh; server menjadi sumber kebenaran untuk akun dan data yang butuh validasi (lihat §5a).

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
