# Game Design Document (GDD) — Farming Adventure Nusantara

> **Versi dokumen:** 0.18 (+ D-013 Pertarungan, D-014 Single-Player Online, D-015 Sistem Kehidupan, D-016 Dungeon, D-017 Guild, D-018 Perkembangan Karakter, D-019 Companion, D-020 Equipment & Crafting, D-021 Ekonomi, D-022 NPC & Sosial, D-023 Pertanian, D-024 Peternakan, D-025 Memancing, D-026 Memasak & Alkimia, D-027 Rumah & Bangunan, D-028 Eksplorasi) · **Status:** Draf awal. Hanya memuat keputusan yang sudah ditetapkan pemilik proyek.
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

Dirinci di 6.18 (D-028).
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

Perincian pertanian dan pertumbuhan tanaman: lihat 6.13 (D-023); peternakan dan hewan: lihat 6.14 (D-024). Untuk bagian 6.3 dan 6.4 di bawah, rujuk 6.2.

### 6.3 Memancing dan Memasak
- **Memancing:** ditetapkan lewat D-015 dan dirinci di 6.15 (D-025).
- **Memasak:** ditetapkan lewat D-015 dan dirinci di 6.16 (D-026, Memasak dan Alkimia).

### 6.4 Rumah
Ditetapkan lewat D-015 (pengembangan rumah dan ladang; lihat 6.2) dan dirinci di 6.17 (D-027, Rumah, Lahan, dan Bangunan).

### 6.5 NPC dan Kehidupan Sosial — D-022, LOCKED (Kombinasi Semua Sistem)
**Ditetapkan:**
- NPC memiliki **jadwal harian dan rutinitas**.
- NPC punya **pekerjaan dan aktivitas mandiri**.
- **Hubungan pertemanan dan kepercayaan.**
- **Cerita pribadi NPC dan quest bercabang.**
- NPC **bereaksi terhadap tindakan pemain.**
- **Interaksi sosial dan event desa.**
- **Perilaku NPC berubah** sesuai perkembangan dunia.
- Ketentuan: NPC punya identitas, pekerjaan, karakter, dan rutinitas yang **konsisten**; aktivitas mempertimbangkan **waktu dan kondisi dunia**; hubungan berkembang dari **interaksi pemain**; dialog, quest, dan event dapat berubah sesuai **hubungan dan perkembangan cerita**; sistem harus mampu mengelola **jumlah NPC yang besar**.
- Terkait: kalender/musim/festival (D-015), NPC guild (D-017), merchant (D-021), wilayah (D-009), NPC sebagai progres pribadi (D-014).

**[BELUM DITETAPKAN]:** daftar NPC dan karakter, jumlah NPC target, tingkat/tahap hubungan dan cara mengukurnya, bentuk reaksi terhadap tindakan pemain, struktur quest bercabang dan cerita pribadi, bentuk dialog, jenis event sosial, bagaimana NPC "bekerja" saat pemain jauh.
**Tetap BELUM ditetapkan (D-015):** hubungan romantis, pernikahan, membangun keluarga, dan memiliki anak. D-022 hanya mencakup pertemanan dan kepercayaan. **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

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

Perkembangan kemampuan karakter: lihat 6.10 (D-018).

**[BELUM DITETAPKAN]:** aturan damage dan stat, daftar elemen dan interaksinya, daftar jenis senjata, sumber daya skill (mana/stamina), jendela waktu parry/dodge, struktur skill tree, kontrol sentuh untuk semua aksi di atas, penargetan/kamera saat bertarung, bentuk AI musuh, keseimbangan dengan kehidupan bertani. **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.8 Dungeon dan Boss — D-016, LOCKED (Kombinasi Dungeon Tetap dan Acak)
**Ditetapkan:**
- **Story Dungeon:** desain dan tata letak ruangan tetap; terhubung dengan cerita atau quest; memiliki monster dan boss khusus; memiliki hadiah penyelesaian.
- **Exploration Dungeon:** tata letak ruangan dibuat acak; penempatan monster dan tantangan dapat bervariasi; menyediakan material dan harta karun; dapat dijelajahi berulang kali.
- **Fitur tambahan:** dungeon rahasia, boss spesial, hadiah unik.
- Berlaku sejak sebelumnya (D-003, D-009): dungeon exploration dan boss ada; setiap wilayah dapat punya dungeon.

**[BELUM DITETAPKAN]:** jumlah lantai/ruangan, aturan dan seed pembuatan acak, tabel loot dan drop, tingkat kesulitan dan penskalaan, batas masuk (rank/level/stamina), cara membuka dungeon rahasia, daftar boss dan boss spesial, jenis hadiah unik, hubungan dungeon dengan Progressive World Unlock dan rank petualang, keseimbangan dengan sistem kehidupan (D-015). **Tidak ada implementasi dungeon sebelum seluruh tahap desain selesai.**

### 6.9 Equipment dan Crafting — D-020, LOCKED (Kombinasi Semua Sistem)
**Ditetapkan:**
- **Crafting senjata dan armor.**
- **Equipment Upgrade.**
- **Enchant dan atribut tambahan.**
- **Mining dan Gathering.**
- **Profesi Blacksmith dan Alchemist.**
- **Pembuatan potion dan makanan.**
- **Material langka dari dungeon.**
- **Material legendaris dari Boss.**
- **Sistem kualitas dan rarity item.**
- Crafting harus **terhubung** dengan pertanian, gathering, pertambangan, perburuan monster, dan eksplorasi dungeon.
- Terkait: pertarungan (D-013), penguasaan senjata (D-018), dungeon dan boss (D-016), Sistem Kehidupan/memasak (D-015). Berlaku sejak sebelumnya: mengumpulkan material dan membuat equipment (D-010).

**[BELUM DITETAPKAN]:** daftar jenis equipment, slot, dan tier; resep dan bahan; stat; jenis enchant dan atribut tambahan; rumus kualitas dan daftar tingkat rarity; cara kerja profesi (apakah Blacksmith/Alchemist berupa NPC, keterampilan pemain, atau keduanya) dan hubungannya dengan Class/Job (D-018) dan spesialisasi guild (D-017); batas antara memasak (D-015) dan pembuatan makanan di sini; titik dan alat mining/gathering; sumber material per wilayah; upgrade (biaya, batas, risiko gagal); ekonomi bahan dan harga. **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.10 Perkembangan Karakter — D-018, LOCKED (Kombinasi Semua Sistem)
**Ditetapkan:**
- **Level dan atribut karakter.**
- **Skill Tree bercabang.**
- **Skill aktif dan pasif.**
- **Sistem Class dan Job.**
- **Perubahan spesialisasi karakter.**
- **Perkembangan penguasaan senjata.**
- **Kemampuan sihir dan elemen.**
- **Perkembangan karakter jangka panjang.**
- Pemain dapat mengembangkan karakter lewat berbagai jalur kemampuan dan kombinasi spesialisasi.
- Memperluas D-013 (skill tree, magic/elemen); level karakter menjadi salah satu syarat pembukaan wilayah (D-009); terkait spesialisasi dan training di guild (D-017).

**[BELUM DITETAPKAN]:** rumus level dan pertumbuhan atribut, daftar atribut, daftar Class dan Job (dan beda keduanya), aturan dan biaya mengganti spesialisasi, batas level/"jangka panjang" (prestise/reset?), struktur dan jumlah cabang skill tree, daftar skill aktif/pasif, aturan penguasaan senjata, daftar elemen, sumber XP (apakah kegiatan non-tempur, seperti bertani, ikut menaikkan level), keseimbangan dengan sistem kehidupan (D-015). **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.11 Companion dan Monster Taming — D-019, LOCKED (Kombinasi Semua Sistem)
**Ditetapkan:**
- **Pet** untuk kehidupan sehari-hari.
- **Combat Companion** untuk membantu pertarungan.
- **Monster Taming:** menjinakkan monster dungeon.
- **Koleksi monster langka.**
- **Level dan evolusi monster.**
- **Skill dan kemampuan khusus monster.**
- **Hubungan dan loyalitas** companion.
- **Monster dapat membantu aktivitas tertentu.**
- Companion berfungsi berbeda sesuai jenis, kemampuan, dan karakteristiknya.
- Terkait: sumber monster adalah dungeon (D-016), bantuan tempur mengikuti sistem pertarungan (D-013), bantuan aktivitas berkaitan dengan Sistem Kehidupan (D-015). Pemeliharaan hewan ternak (D-015) dan pet/companion adalah hal yang berbeda; batas keduanya belum ditetapkan.

**[BELUM DITETAPKAN]:** daftar pet, monster, dan monster langka; cara dan syarat menjinakkan; batas jumlah companion yang dibawa/disimpan; rumus level dan syarat evolusi; daftar skill monster; mekanik hubungan/loyalitas (naik-turun, efeknya); jenis aktivitas yang dapat dibantu monster (mis. bertani, kerja ladang, penambangan) dan batasnya; tempat tinggal/perawatan companion; kontrol companion saat combat (otomatis atau diperintah); keseimbangan dengan perkembangan karakter (D-018) dan ekonomi. **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.12 Ekonomi dan Perdagangan — D-021, LOCKED (Kombinasi Semua Sistem)
**Ditetapkan:**
- **Jual beli hasil pertanian.**
- **Merchant dan toko khusus.**
- **Perdagangan material monster.**
- **Ekonomi dinamis.**
- **Harga dipengaruhi musim dan wilayah.**
- **Permintaan, penawaran, dan kelangkaan** barang.
- **Perdagangan antarwilayah.**
- **Perkembangan kekayaan dan usaha pemain.**
- Hasil pertanian dapat **dijual atau diproses** menjadi barang bernilai lebih tinggi; material tambang dan monster dapat **diperdagangkan atau dipakai crafting**; merchant memiliki **spesialisasi barang**; musim, wilayah, ketersediaan, dan permintaan **memengaruhi harga**.
- Terkait: butir ekonomi D-015, material/crafting D-020, wilayah D-009, monster/dungeon D-013 dan D-016.

**[BELUM DITETAPKAN]:** daftar barang dan harga dasar, mata uang, rumus permintaan/penawaran/kelangkaan, daftar merchant dan spesialisasinya, aturan dan biaya perdagangan antarwilayah (termasuk apakah butuh transportasi/waktu), bentuk "usaha" pemain (toko, bisnis, properti?), batas inflasi dan keseimbangan, penjualan/pembelian oleh companion (D-019).
**Dan terbuka:** karena D-014 (dunia pribadi, tanpa multiplayer), ekonomi dinamis dicatat sebagai **pribadi per pemain**; lokasi perhitungan harga (klien/server) dan kemungkinan ekonomi bersama belum ditetapkan. **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.13 Pertanian dan Pertumbuhan Tanaman — D-023, LOCKED (Kombinasi Semua Sistem)
**Ditetapkan:**
- **Mekanisme bertani lengkap:** mengolah tanah, menanam, merawat, memanen.
- **Banyak jenis tanaman, bibit, dan varietas.**
- **Kualitas tanah, pupuk, dan sistem pengairan.**
- **Musim dan cuaca** memengaruhi pertumbuhan.
- **Tanaman spiritual dan tanaman langka.**
- **Integrasi** dengan crafting, alkimia, dan ekonomi.
- **Pengembangan lahan dan teknologi pertanian.**
- Ketentuan: tiap tanaman punya karakteristik dan **tahapan pertumbuhan**; kebutuhan air, pupuk, musim, dan kondisi tanah **berbeda antarjenis**; tanaman spiritual dan langka punya **mekanisme dan kegunaan khusus**; hasil panen untuk perdagangan, crafting, alkimia, dan kebutuhan petualangan; sistem **mudah diperluas** dengan tanaman dan wilayah baru.
- Terkait: farming dan pengembangan ladang (D-015), musim/cuaca (D-015), crafting dan Alchemist (D-020), ekonomi (D-021), wilayah (D-009).

**[BELUM DITETAPKAN]:** daftar tanaman, bibit, varietas; lama dan jumlah tahap tumbuh; jenis cuaca dan pengaruhnya; jenis pupuk dan kualitas tanah; mekanik pengairan; jenis teknologi pertanian dan tahap pengembangan lahan; **arti dan mekanisme "tanaman spiritual"** (belum didefinisikan); kriteria tanaman langka; batas antara "alkimia" di sini dan profesi Alchemist (D-020); keterlibatan companion (D-019) dan NPC pekerja (D-022) dalam bertani.
**Catatan:** cuaca, yang di 6.2 masih tercantum belum ditetapkan, kini dinyatakan **ada** (memengaruhi tanaman); rinciannya tetap belum ditetapkan. **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.14 Peternakan dan Hewan — D-024, LOCKED (Kombinasi Semua Sistem)
**Ditetapkan:**
- **Hewan ternak biasa dan hewan langka.**
- **Kesehatan dan kebutuhan makanan** hewan.
- **Pertumbuhan dan perkembangbiakan.**
- **Kualitas produk ternak.**
- **Hewan spiritual** dengan kemampuan khusus.
- **Integrasi** dengan crafting, ekonomi, dan petualangan.
- **Pengembangan kandang dan fasilitas peternakan.**
- Ketentuan: tiap spesies punya kebutuhan, karakteristik, dan produk berbeda; **kesehatan dan kualitas perawatan memengaruhi produktivitas**; hewan **tumbuh dan berkembang biak** sesuai aturan spesies; hewan spiritual punya karakter dan kemampuan unik; sistem **mendukung penambahan spesies dan fasilitas baru**.
- Terkait: peternakan dan pengembangan ladang (D-015), crafting (D-020), ekonomi (D-021), pakan dari pertanian (D-023), companion/monster (D-019), loot/material (D-016).

**[BELUM DITETAPKAN]:** daftar spesies, hewan langka, dan hewan spiritual; produk tiap spesies; kebutuhan pakan; aturan kesehatan dan penyakit; aturan kawin, kelahiran, dan pertumbuhan; jenis kandang dan fasilitas serta upgrade-nya; **arti dan kemampuan "hewan spiritual"**; **batas antara hewan ternak (D-024) dan pet/companion (D-019)**; apakah hewan ternak dapat dibawa ke petualangan.
**Catatan:** "perkembangbiakan" berlaku untuk hewan, bukan keluarga/anak pemain (tetap belum ditetapkan, D-015). **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.15 Memancing dan Kehidupan Perairan — D-025, LOCKED (Kombinasi Semua Sistem)
**Ditetapkan:**
- **Memancing** di sungai, danau, laut, dan lokasi khusus.
- **Beragam spesies ikan** dengan tingkat kelangkaan.
- **Pengaruh lokasi, musim, cuaca, dan waktu** terhadap ketersediaan.
- **Umpan, alat pancing,** dan **kualitas hasil tangkapan.**
- **Ikan spiritual dan makhluk air fantasi.**
- **Koleksi, perdagangan, memasak, dan crafting.**
- **Tantangan menangkap ikan legendaris.**
- Ketentuan: tiap spesies punya habitat dan karakteristik; ketersediaan dipengaruhi lokasi, musim, cuaca, waktu; peralatan dan umpan memengaruhi peluang dan kualitas; makhluk spiritual/legendaris punya karakter khusus; hasil dimanfaatkan untuk koleksi, ekonomi, memasak, crafting.
- Terkait: memancing (D-015), musim/cuaca (D-015, D-023), perdagangan (D-021), crafting dan item (D-020), wilayah (D-009), guild/prestasi (D-017).

**[BELUM DITETAPKAN]:** daftar spesies, habitat, dan lokasi memancing; mekanik memancing (kontrol sentuh, minigame); jenis alat pancing dan umpan; tingkat kelangkaan dan rumus kualitas; **arti "ikan spiritual" dan "makhluk air fantasi"**; daftar ikan legendaris dan caranya ditangkap; format koleksi (buku koleksi/prestasi); apakah makhluk air dapat menjadi companion/monster (D-019) atau menjadi musuh (D-013); hubungan dengan quest/prestasi guild (D-017). **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.16 Memasak dan Alkimia — D-026, LOCKED (Kombinasi Semua Sistem)
**Ditetapkan:**
- **Memasak lengkap** dengan banyak resep.
- **Kualitas bahan** dan **kemampuan memasak.**
- **Makanan** dengan efek **pemulihan dan buff.**
- **Alkimia** dan pembuatan **ramuan.**
- **Herbal, tanaman spiritual, dan material monster** sebagai bahan.
- **Resep langka** dan **penemuan resep baru.**
- **Pengembangan dapur dan laboratorium alkimia.**
- **Integrasi** dengan pertanian, peternakan, memancing, dungeon, dan ekonomi.
- Ketentuan: bahan punya kualitas dan kegunaan berbeda; resep dapat **ditemukan, dipelajari, dan dikembangkan**; makanan dan ramuan punya **efek yang jelas**; material dari berbagai aktivitas dunia dapat menjadi bahan masakan atau alkimia; dapur dan laboratorium **berkembang seiring progres**.
- Terkait: memasak (D-015), pembuatan potion/makanan dan Alchemist (D-020), pertanian (D-023), peternakan (D-024), memancing (D-025), dungeon/monster (D-016, D-013), buff dan karakter (D-013, D-018), ekonomi (D-021), rumah (D-015).

**[BELUM DITETAPKAN]:** daftar resep dan ramuan; jenis dan besar efek (pemulihan, buff) serta durasi/penumpukan; rumus kualitas bahan dan pengaruh kemampuan memasak; cara resep ditemukan, dipelajari, dan dikembangkan (dari NPC, buku, dungeon, eksperimen?); jenis dan tahap upgrade dapur dan laboratorium; apakah memasak/alkimia keterampilan pemain, profesi NPC, atau keduanya; **batas dengan profesi Alchemist dan crafting equipment (D-020)**; arti **"tanaman spiritual"** (D-023); mekanik memasak (minigame atau otomatis). **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.17 Rumah, Lahan, dan Bangunan — D-027, LOCKED (Kombinasi Semua Sistem)
**Ditetapkan:**
- **Rumah utama** dengan upgrade bertingkat.
- **Gudang, kandang, greenhouse, dan workshop.**
- **Bangunan produksi** dan **fasilitas peternakan.**
- **Paviliun** dan **bangunan spiritual.**
- **Dekorasi** dan **penataan lahan bebas.**
- **Ekspansi lahan dan fasilitas.**
- **Bangunan dengan fungsi khusus** sesuai progres pemain.
- Ketentuan: bangunan punya **fungsi gameplay yang jelas**; rumah dan fasilitas dikembangkan **bertahap**; **tata letak dan dekorasi dapat disesuaikan** pemain; fasilitas produksi **terintegrasi** dengan pertanian, peternakan, memasak, dan alkimia; bangunan spiritual **dapat dibuka lewat progres**; sistem **mendukung jenis bangunan baru**.
- Terkait: rumah dan ladang (D-015), pertanian (D-023), peternakan (D-024), memasak/alkimia (D-026), crafting (D-020), ekonomi (D-021), progres/wilayah (D-009, D-017).

**[BELUM DITETAPKAN]:** daftar bangunan dan fungsinya; tahap upgrade rumah; ukuran dan tahap ekspansi lahan; metode penataan (grid atau penempatan bebas, rotasi, batas); daftar dekorasi dan apakah dekorasi punya efek gameplay; **arti "bangunan spiritual" dan fungsi "paviliun"**; syarat membuka bangunan spiritual; biaya dan material; kapasitas penyimpanan; apakah bangunan dapat rusak/perlu perawatan.
**Tetap BELUM ditetapkan (D-015):** hubungan romantis, pernikahan, keluarga, dan anak. D-027 tidak mencakupnya. **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.18 Eksplorasi Dunia dan Perjalanan — D-028, LOCKED (Kombinasi Semua Sistem)
**Ditetapkan:**
- **Dunia luas** dengan wilayah yang **dibuka bertahap.**
- **Desa, kota, hutan, gunung, gua, dan lautan.**
- **Wilayah spiritual, reruntuhan, dan pulau tersembunyi.**
- **Sumber daya, monster, rahasia, dan lokasi unik.**
- **Perjalanan darat, air, dan transportasi khusus.**
- **Peta dunia, penanda lokasi, dan fast travel.**
- **Eksplorasi terintegrasi** dengan quest, dungeon, dan progres pemain.
- Ketentuan: tiap wilayah punya **identitas visual, sumber daya, dan tantangan**; pembukaan wilayah **mengikuti progres dan kebutuhan cerita**; perjalanan dan transportasi **sesuai geografi**; peta menunjukkan **lokasi, penanda, dan tempat yang telah ditemukan**; fast travel dibuka dengan **aturan progres yang jelas**; eksplorasi **terhubung** dengan pertanian, petualangan, quest, dan dungeon.
- Terkait: Progressive World Unlock (D-009, 6.1), dungeon (D-016), guild/rank/quest (D-017), level (D-018), monster (D-013), sumber daya (D-020, D-023, D-025), progres dunia pribadi (D-014).

**[BELUM DITETAPKAN]:** daftar dan jumlah wilayah, ukuran dunia, peta dunia; syarat buka tiap wilayah; **arti "wilayah spiritual"**; jenis transportasi khusus (kendaraan/tunggangan/kapal) dan hubungannya dengan companion (D-019); aturan fast travel (syarat, biaya, batas); apakah perjalanan memakan waktu kalender; cara penandaan peta (otomatis atau manual); isi tiap wilayah (monster, sumber daya, lokasi unik, rahasia); cara perpindahan antarwilayah (loading/streaming). **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

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
7. ~~NPC dan hubungan~~ (D-022 terkunci); sisanya: daftar NPC, romansa/keluarga (belum ditetapkan).
8. Art direction 3D Stylized dan sumber aset.
9. Monetisasi (belum disebut; default: tidak ada sampai diputuskan).

Setiap keputusan baru wajib dicatat di `DESIGN_DECISIONS.md` sebelum implementasi.
