# Game Design Document (GDD) — Farming Adventure Nusantara

> **Versi dokumen:** 0.45 (+ D-013 Pertarungan, D-014 Single-Player Online, D-015 Sistem Kehidupan, D-016 Dungeon, D-017 Guild, D-018 Perkembangan Karakter, D-019 Companion, D-020 Equipment & Crafting, D-021 Ekonomi, D-022 NPC & Sosial, D-023 Pertanian, D-024 Peternakan, D-025 Memancing, D-026 Memasak & Alkimia, D-027 Rumah & Bangunan, D-028 Eksplorasi, D-029 Event Dunia, D-030 Musim & Cuaca, D-031 UI & HUD, D-032 Audio, D-033 Kamera, D-034 Kontrol, D-035 Interaksi, D-036 Inventory, D-037 Quest, D-038 Dialog, D-039 Sosial, D-040 NPC Hidup, D-041 Kustomisasi, D-042 Mount, D-043 Tutorial, D-044 Cloud Save, D-045 Pengaturan, D-046 Achievement, D-047 Monetisasi, D-048 Live Ops, D-049 QA, D-050 Keamanan, D-052 Performa, D-053 Loading, D-054 Peta, D-055 Waktu, D-056 Tidur) · **Status:** Draf awal. Hanya memuat keputusan yang sudah ditetapkan pemilik proyek.
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
- Kontrol: arah sudah ditetapkan **Kontrol Hybrid** (D-034, lihat 6.24); jumlah/jenis tombol, gestur kamera, lock-on, dan dukungan kontroler belum. Harus memenuhi standar UI D-031 dan menampung seluruh aksi pertarungan D-013 (serang/combo, skill, dodge, block, parry).
- Kamera: arah sudah ditetapkan **Kamera Adaptif** (D-033, lihat 6.23); sudut, jarak, batas, dan skema kontrol kamera rinci belum.
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

**[BELUM DITETAPKAN]:** daftar tanaman dan hewan, panjang musim (jumlah musim: empat, D-030), kalender dan sistem waktu (termasuk acuan jam: perangkat atau server), cuaca, stamina, mekanik memancing, resep dan efek makanan (termasuk hubungannya dengan RPG/buff), harga dan keseimbangan ekonomi, jadwal dan jenis festival, tahap upgrade rumah dan ladang, dekorasi, penyimpanan, keseimbangan dengan pertarungan dan dungeon.

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

### 6.19 Event Dunia dan Kejadian Dinamis — D-029, LOCKED (Kombinasi Semua Sistem)
**Ditetapkan:**
- **Event terjadwal** berdasarkan kalender permainan.
- **Kejadian acak dan dinamis.**
- **Serangan monster dan invasi wilayah.**
- **World boss dan monster legendaris.**
- **Bencana alam dan fenomena spiritual.**
- **Pedagang misterius** dan **penemuan langka.**
- **Dampak event** terhadap NPC, ekonomi, dan wilayah.
- **Hadiah, quest khusus, dan perubahan dunia.**
- Ketentuan: event dipicu oleh **kalender, kondisi wilayah, progres pemain, atau peluang**; punya **kondisi awal, durasi, dampak, penyelesaian, dan konsekuensi** yang jelas; memengaruhi **NPC, perdagangan, sumber daya, dan keamanan wilayah**; event besar dan langka punya **pemberitahuan dan waktu persiapan**; sistem memperhitungkan game **single-player online dengan progres di cloud**.
- Berlaku bersama D-014: world boss dan invasi adalah pengalaman **pemain tunggal dalam dunia pribadi**, bukan multiplayer.
- Terkait: kalender/festival (D-015), NPC (D-022), ekonomi (D-021), wilayah (D-009, D-028), monster/boss/dungeon (D-013, D-016), quest (D-017), pertanian/peternakan/memancing (D-023, D-024, D-025), bangunan (D-027).

**[BELUM DITETAPKAN]:** daftar event dan jadwalnya; bobot dan syarat peluang kejadian acak; bentuk dan bobot dampak (harga, stok, keamanan, perilaku NPC); daftar world boss dan monster legendaris; **arti "fenomena spiritual"**; bentuk pemberitahuan dan persiapan; apakah event berjalan saat pemain offline; aturan bila pemain mengubah waktu perangkat atau memuat ulang save; tingkat konsekuensi (apakah ada kerugian permanen); cara event dapat dilewatkan atau gagal. **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.20 Musim, Cuaca, dan Lingkungan — D-030, LOCKED (Kombinasi Semua Sistem)
**Ditetapkan:**
- **Empat musim** dengan perubahan lingkungan.
- **Cuaca dinamis** dan **pergantian siang-malam.**
- **Hujan, badai, salju, kabut, dan fenomena ekstrem.**
- **Iklim berbeda** di setiap wilayah.
- **Fenomena spiritual** dan **kondisi alam langka.**
- **Pengaruh** terhadap tanaman, hewan, ikan, dan monster; serta NPC, eksplorasi, dan perdagangan.
- **Kalender dunia** dan **perubahan lingkungan berkelanjutan.**
- Ketentuan: tiap wilayah dapat berkarakter iklim berbeda; musim dan cuaca **konsisten dengan kalender dunia**; kondisi lingkungan **memengaruhi aktivitas gameplay**; fenomena spiritual punya **aturan kemunculan dan dampak yang jelas**; perubahan cuaca dan musim **tersinkron dengan single-player online dan cloud save**.
- Terkait: musim dan kalender (D-015), tanaman (D-023), hewan (D-024), ikan (D-025), NPC (D-022), perdagangan (D-021), wilayah (D-009, D-028), event (D-029), bangunan spiritual (D-027), cloud save (D-014).
- Menegaskan: **jumlah musim = empat** (sebelumnya terbuka di 6.2); keberadaan **cuaca** (sudah dicatat di 6.13).

**[BELUM DITETAPKAN]:** nama dan panjang tiap musim, panjang hari dan siklus siang-malam, daftar cuaca dan peluangnya per iklim, daftar iklim dan pemetaannya ke wilayah, bentuk "fenomena ekstrem", **arti "fenomena spiritual"** dan aturan kemunculan/dampaknya, "kondisi alam langka", bentuk perubahan lingkungan berkelanjutan (apakah permanen), tampilan (visual/audio) tiap musim/cuaca, aturan bila waktu perangkat diubah (lihat D-029). **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.21 UI, HUD, dan Antarmuka Pemain — D-031, LOCKED (Kombinasi Semua Sistem)
**Ditetapkan:**
- **HUD RPG** dan informasi karakter.
- **HUD farming** dan **hotbar alat.**
- **Inventory, equipment, skill, dan quest.**
- **Peta, kalender, cuaca, dan waktu.**
- **Menu peternakan, crafting, dan alkimia.**
- **Antarmuka dungeon dan combat.**
- **UI adaptif** sesuai aktivitas pemain.
- **Pengaturan ukuran dan posisi tombol.**
- Standar: **Android landscape** utama; kontrol **nyaman untuk layar sentuh**; HUD **tidak menutupi area permainan berlebihan**; **Indonesia utama, English kedua**; visual UI **konsisten dengan 3D Stylized**; UI menampilkan kontrol/informasi **sesuai aktivitas**; **ukuran dan posisi tombol dapat disesuaikan**.
- Terkait: orientasi (D-004), bahasa (D-007), gaya visual (D-008), semua sistem game yang ditampilkan UI (D-013 sampai D-030), akun/koneksi (D-014).

**[BELUM DITETAPKAN]:** gaya visual UI rinci dan tema; tata letak tiap HUD dan daftar layar/menu; jenis dan jumlah tombol aksi; skema kontrol sentuh konkret; dukungan kontroler; ukuran target sentuh minimum; dukungan ukuran layar berbeda (HP kecil/besar, tablet); aksesibilitas (ukuran teks, kontras, buta warna); cara menampilkan status koneksi dan sinkronisasi cloud; aturan konteks "adaptif" (aktivitas apa yang mengubah UI). **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.22 Audio, Musik, dan Efek Suara — D-032, LOCKED (Kombinasi Semua Sistem)
**Ditetapkan:**
- **Musik adaptif** menurut wilayah dan aktivitas; musik pertanian, desa, dungeon, pertempuran; **musik orkestra** untuk cerita dan boss.
- **Efek lingkungan** mengikuti cuaca, musim, dan wilayah.
- **Suara aktivitas** NPC, hewan, dan monster; efek senjata, skill, sihir, crafting.
- **Audio fenomena spiritual** dan event dunia; boss dan event besar punya audio khusus.
- Transisi musik **halus**, tidak mengganggu gameplay; tiap aktivitas punya **identitas suara** berbeda.
- **Volume musik, efek suara, dan ambience diatur terpisah** oleh pemain.
- Terkait: D-009, D-013, D-016, D-019, D-022, D-023 sampai D-026, D-028, D-029, D-030, D-031.

**[BELUM DITETAPKAN]:** gaya musik tiap wilayah, daftar lagu, sumber/lisensi aset audio, suara pengisi, arti audio "fenomena spiritual", format/ukuran aset dan batas ukuran APK, perilaku saat di latar belakang/panggilan masuk, aksesibilitas audio. **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.23 Kamera dan Kontrol Karakter — D-033, LOCKED (Kamera Adaptif)
**Ditetapkan:**
- Kamera **menyesuaikan konteks** aktivitas.
- **Farming dan eksplorasi:** framing lebih luas (area sekitar, lahan, objek, jalur terlihat jelas).
- **Interaksi dan combat:** kamera boleh **mendekat** agar karakter dan aksi mudah diamati.
- Pemain dapat mengatur **zoom dan rotasi** dalam **batas terkontrol**.
- Peralihan **halus dan konsisten**, tidak membuat pemain kehilangan orientasi.
- Prioritas **kenyamanan kontrol Android landscape** dan **performa** (Godot 4.7.2, GL Compatibility).
- Terkait: D-004, D-008, D-013, D-016, D-023, D-027, D-028, D-030, D-031, D-032.

**[BELUM DITETAPKAN]:** sudut dan jarak tiap konteks, batas zoom/rotasi, skema kontrol sentuh kamera, penargetan/lock-on, kamera di ruang sempit (bangunan, dungeon), tabrakan kamera dengan objek, mode rumah/dekorasi, aksesibilitas, efek guncangan dan sinematik, dukungan kontroler. **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.24 Metode Kontrol Karakter Android — D-034, LOCKED (Kontrol Hybrid)
**Ditetapkan:**
- **Virtual joystick** sebagai kontrol gerakan utama.
- **Tombol aksi kontekstual** sesuai aktivitas (farming, interaksi, eksplorasi, combat).
- **Tap-to-move** sebagai opsi untuk aktivitas/situasi yang sesuai.
- Ketiga metode **tidak saling mengganggu**.
- Tata letak nyaman di **Android landscape** dan **berbagai ukuran layar**.
- Pengaturan **ukuran, posisi, dan sensitivitas** kontrol jika memungkinkan (selaras D-031).
- **Terintegrasi dengan Kamera Adaptif** (D-033); perhatikan performa (Godot 4.7.2, GL Compatibility).
- Terkait: D-004, D-013, D-023, D-028, D-031, D-033.

**[BELUM DITETAPKAN]:** jumlah/jenis/ikon tombol aksi, situasi tap-to-move dan cara beralih, jenis joystick, kontrol kamera bersama joystick, penargetan/lock-on, gestur tambahan, kontroler/keyboard, rentang sensitivitas, aksesibilitas (satu tangan, tahan vs ketuk), getaran. **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.25 Interaksi dengan Dunia dan Objek — D-035, LOCKED (Interaksi Hybrid)
**Ditetapkan:**
- Tiga metode: **proximity**, **direct tap**, dan **tombol aksi kontekstual**.
- Konteks objek dikenali: tanaman, hewan, NPC, fasilitas, item di tanah, peti, pintu, objek dungeon.
- Hanya **aksi yang valid** untuk objek dan kondisi pemain yang ditampilkan.
- **Tanpa interaksi ganda/konflik input** saat objek berdekatan; **target pilihan pemain diprioritaskan**.
- Terintegrasi dengan **Kontrol Hybrid** (D-034) dan **Kamera Adaptif** (D-033).
- UI nyaman di **Android landscape**, **Indonesia dan English**.
- **Tidak semua interaksi otomatis**; pemain mengendalikan tindakan penting.
- Terkait: D-007, D-013, D-016, D-022, D-023, D-024, D-027, D-028, D-031 sampai D-034.

**[BELUM DITETAPKAN]:** daftar jenis objek dan aksi, radius interaksi, aturan prioritas rinci, definisi "tindakan penting" (konfirmasi), penanda target dan petunjuk aksi, animasi/durasi interaksi, interaksi saat combat, ambil banyak item sekaligus, aksesibilitas, kontroler. **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.26 Inventory dan Pengelolaan Item — D-036, LOCKED (Inventory Hybrid Lengkap)
**Ditetapkan:**
- Tampilan **slot grid**.
- **Kategori** minimal: farming dan benih; hasil panen dan produk ternak; ikan dan hasil perairan; material dan bahan tambang; material monster dan dungeon; makanan dan ramuan; senjata dan armor; equipment dan aksesori; quest dan item khusus.
- **Pencarian, penyortiran, filter, dan akses cepat.**
- **Kapasitas atau berat** dengan aturan jelas dan mudah dipahami; dapat **ditingkatkan** lewat tas, equipment, atau perkembangan karakter; **tidak terlalu ketat** agar alur permainan tidak terganggu.
- Aturan **stack**, batas per slot, **item unik**, item tak bisa ditumpuk, dan **inventory penuh** akan ditentukan (nilainya belum).
- Pindah, pakai, simpan, dan ambil item dengan **kontrol sentuh nyaman**; **Android landscape**, **Indonesia dan English**.
- Terintegrasi dengan farming, fishing, livestock, crafting, alchemy, dungeon, equipment, dan ekonomi.
- Terkait: D-007, D-013, D-016, D-018, D-020, D-021, D-023 sampai D-027, D-031, D-034, D-035.

**[BELUM DITETAPKAN]:** model kapasitas (slot/berat/gabungan) dan angkanya, batas stack, daftar item unik, perilaku saat penuh, slot akses cepat, penyimpanan rumah/peti, apakah kualitas memisahkan stack, aturan item quest, cara memindahkan banyak item, aksesibilitas. **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.27 Quest dan Misi — D-037, LOCKED (Quest Hybrid Lengkap)
**Ditetapkan:**
- **Jenis quest:** Main Story; Side; Branching; Daily dan Repeatable; Adventurer Guild; Farming dan Village Life; Trading dan Economy; Dungeon dan Monster Hunt; Hidden dan Special.
- **Quest bercabang:** beberapa pilihan, kondisi, konsekuensi, dan hasil; keputusan pemain dapat memengaruhi hasil quest, hubungan NPC, akses wilayah, hadiah, atau cerita sesuai kebutuhan naratif.
- Tiap quest: **identitas unik, pemberi, persyaratan, objektif, status, hadiah, aturan penyelesaian**; objektif **bertahap** dan **beberapa sekaligus**.
- **Quest journal**, pelacakan objektif aktif, indikator lokasi, notifikasi, dan riwayat.
- Quest harian/berulang **mengikuti kalender dan waktu dunia** secara konsisten.
- Quest Guild **terintegrasi dengan rank dan reputasi Guild** (D-017).
- Quest dapat **disimpan dan disinkronkan** lewat cloud save Supabase.
- UI **Android landscape**, **Indonesia dan English**.
- **Tidak boleh ada quest yang bertentangan atau buntu** akibat urutan progres.
- Terkait: D-007, D-009, D-013 sampai D-018, D-021, D-022, D-023, D-028 sampai D-031, D-036, D-014.

**[BELUM DITETAPKAN]:** isi cerita dan daftar quest, format data quest, tipe objektif dan pemicu, prasyarat dan aturan gagal/batal, aturan quest harian/berulang, sistem pilihan dan konsekuensi, hadiah, detail rank/reputasi Guild, mekanisme pencegah quest buntu, quest musim/event, perilaku saat waktu perangkat diubah, peran konsep "spiritual" (belum didefinisikan). **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.28 Dialog dan Percakapan NPC — D-038, LOCKED (Dialog Hybrid Lengkap)
**Ditetapkan:**
- **Jenis dialog:** cerita utama dan side quest; percakapan sehari-hari; pilihan jawaban pemain; dialog bercabang dengan beberapa hasil; berdasarkan hubungan, kepercayaan, dan reputasi; **dinamis** menurut waktu, lokasi, musim, cuaca, event, dan perkembangan dunia; khusus Guild, dungeon, perdagangan, dan kehidupan desa.
- NPC punya **identitas, kepribadian, konteks sosial, dan aturan respons yang konsisten.**
- Pilihan pemain dapat memengaruhi **hubungan NPC, akses quest, informasi, dan hasil cerita** jika relevan.
- Mendukung **percakapan berurutan, kondisi pembuka, pilihan terkunci, dan konsekuensi.**
- UI dialog **mudah dibaca**, nyaman di **Android landscape**.
- **Indonesia utama, English kedua**; teks bahasa **tidak ditanam di aset visual.**
- Terintegrasi dengan **NPC, quest D-037, hubungan sosial, kalender, dan cloud save Supabase.**
- **Tidak ada dialog berulang** yang tidak sesuai keadaan/progres NPC.
- Terkait: D-007, D-014, D-015, D-017, D-021, D-022, D-023, D-029 sampai D-033, D-035, D-037.

**[BELUM DITETAPKAN]:** daftar NPC dan isi dialog, format data dan kondisi, tampilan UI dialog, suara pengisi, kamera saat bicara, prioritas bila banyak dialog memenuhi syarat, batas pilihan, aturan pilihan terkunci, cara mencegah pengulangan, cakupan reputasi, kata ganti/nama di dua bahasa, aksesibilitas, konsep "spiritual" (belum didefinisikan), romansa/pernikahan/keluarga (belum diputuskan). **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.29 Hubungan Sosial dan Persahabatan — D-039, LOCKED (Social System Hybrid Lengkap)
**Ditetapkan:**
- **Komponen:** friendship tiap NPC; **trust**; **reputasi** pada komunitas, desa, kota, dan Guild; personal story dan perkembangan NPC; friendship events dan interaksi khusus; konsekuensi tindakan pemain.
- **Hubungan individu dibedakan dari reputasi komunitas**; hubungan baik dengan satu NPC tidak otomatis menaikkan reputasi semua komunitas.
- Hubungan berkembang lewat **percakapan, bantuan, quest, hadiah, tindakan, event.**
- Tiap NPC boleh punya **preferensi, batas kepercayaan, kepribadian, dan reaksi berbeda.**
- Kemajuan membuka **dialog, cerita pribadi, quest, bantuan, hadiah, interaksi khusus**; reputasi memengaruhi **akses layanan, respons NPC, dan kesempatan.**
- **Indikator hubungan mudah dipahami** tanpa menjadikan interaksi sekadar mengejar angka.
- Terintegrasi dengan **jadwal NPC, dialog D-038, quest D-037, event dunia, cloud save Supabase**; UI **Android landscape**, **Indonesia dan English.**
- **Tidak boleh ada kenaikan yang tidak masuk akal** atau konsekuensi yang tidak konsisten.
- Terkait: D-007, D-014, D-015, D-017, D-021, D-022, D-029, D-031, D-035, D-037, D-038.

**[BELUM DITETAPKAN]:** skala dan nama tingkat friendship/trust, daftar komunitas dan ambang reputasi, rumus dan batas perubahan, preferensi hadiah, peluruhan/pemulihan, daftar friendship event, bentuk indikator UI, cara tindakan terlihat oleh komunitas, detail terkait Guild, konsep "spiritual" (belum didefinisikan). **Romansa, pernikahan, keluarga, dan anak BELUM diputuskan; tidak dimodelkan.** **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.30 NPC dan Kehidupan Desa — D-040, LOCKED (NPC Living World Hybrid)
**Ditetapkan:**
- **Komponen kehidupan NPC:** jadwal harian dan rutinitas; AI perilaku dan keputusan; kebutuhan dan kondisi individu; pekerjaan dan aktivitas ekonomi; interaksi sosial antar-NPC; respons terhadap event dan perubahan dunia; perkembangan kehidupan desa.
- NPC punya **identitas, pekerjaan, lokasi aktivitas, jadwal, kepribadian, preferensi yang konsisten.**
- **Aktivitas:** bekerja, berdagang, bertani, memasak, berjalan, beristirahat, bersosialisasi, menghadiri event.
- Perilaku mengikuti **waktu, musim, cuaca, lokasi, kondisi, progres dunia.**
- **AI efisien di Android:** NPC dekat = simulasi lebih detail; NPC jauh = simulasi ringan/berbasis waktu; **tanpa AI berat tiap frame.**
- **Navigasi dan penanganan terjebak**; **fallback** bila lokasi/jalur tidak tersedia.
- Terintegrasi dengan sosial D-039, dialog D-038, quest D-037, kalender, cuaca, event, dan cloud save; **konsisten saat pindah wilayah atau memuat ulang.**
- UI dan konten **Indonesia dan English.**
- Terkait: D-007, D-009, D-014, D-015, D-017, D-021 sampai D-024, D-026 sampai D-030, D-032, D-035, D-037 sampai D-039.

**[BELUM DITETAPKAN]:** daftar NPC dan peran, jenis dan kerincian kebutuhan NPC, model keputusan AI, jarak LOD dan batas NPC aktif, dampak interaksi antar-NPC, dampak ekonomi NPC ke harga/pasokan, bentuk dan pemicu perkembangan desa, aturan fallback/terjebak rinci, perilaku saat pertarungan/bencana, konsep "spiritual" (belum didefinisikan). **Romansa, pernikahan, keluarga, dan anak BELUM diputuskan; tidak dimodelkan.** **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.31 Kustomisasi Karakter Pemain — D-041, LOCKED (Character Customization Hybrid Lengkap)
**Ditetapkan:**
- **Identitas visual:** wajah, rambut, warna rambut, dan elemen penampilan lain yang didukung model.
- **Koleksi pakaian** per aktivitas: sehari-hari, petani, petualang, kostum khusus.
- **Equipment visual:** armor, senjata terlihat, aksesori, perlengkapan khusus.
- **Pembukaan penampilan** lewat quest, dungeon, event, eksplorasi, pencapaian, progres.
- **Fungsi equipment dipisah dari cosmetic** bila perlu: tampilan dipilih tanpa kehilangan atribut.
- Pergantian pakaian/perlengkapan **konsisten pada model 3D dan animasi.**
- **UI character creator dan wardrobe** nyaman di **Android landscape.**
- Terintegrasi dengan **inventory D-036, equipment/crafting, progression, quest, event, cloud save Supabase.**
- **Indonesia dan English**; **tanpa teks pada aset visual.**
- **Jumlah variasi mesh, material, aksesori dijaga** untuk performa Android.
- Terkait: D-007, D-008, D-013, D-014, D-018 sampai D-021, D-029, D-031, D-033, D-036, D-037.

**[BELUM DITETAPKAN]:** pilihan jenis kelamin/tubuh, daftar opsi penampilan, slot kosmetik, daftar set pakaian dan sumber pembukaan, cara memperoleh (beli/buat/dibuka), aturan ganti otomatis per aktivitas, perlakuan senjata saat tidak dipakai, aturan mengganti penampilan, anggaran variasi dan performa, penerapan ke NPC/companion, mode foto, aksesibilitas, konsep "spiritual" (belum didefinisikan). **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.32 Mount dan Kendaraan — D-042, LOCKED (Mount System Hybrid Lengkap)
**Ditetapkan:**
- **Jenis transportasi:** hewan tunggangan biasa (mis. kuda); **monster mount** hasil taming; **kendaraan darat** (kereta, alat khusus); **transportasi air** (perahu); **mount langka dan spiritual** dengan kemampuan khusus.
- Tiap mount/kendaraan: **kecepatan, stamina/energi** (bila relevan), **kemampuan, kapasitas, batas medan.**
- Mount punya **atribut, level, ikatan dengan pemain**, dan kemampuan yang dapat berkembang sesuai jenisnya.
- **Monster mount terintegrasi** dengan taming dan companion (D-019).
- Mengikuti **aturan akses wilayah, medan, dungeon, dan progres.**
- Pemain dapat **memanggil, menaiki, menurunkan, mengganti** mount dengan kontrol sentuh nyaman.
- Memperhatikan **navigasi, animasi, collision, dan Kamera Adaptif** (D-033).
- Terintegrasi dengan **inventory D-036, eksplorasi, progression, quest, cloud save Supabase.**
- **Tidak semua kendaraan dapat dipakai di semua medan**; tiap transportasi punya fungsi masuk akal.
- UI **Android landscape**, **Indonesia dan English.**
- Terkait: D-007, D-009, D-013, D-014, D-016, D-018, D-019, D-024, D-025, D-027, D-028, D-031 sampai D-037, D-041.

**[BELUM DITETAPKAN]:** daftar jenis dan angka, cara memperoleh, aturan stamina/perawatan, aturan medan, aturan pemanggilan (tempat, cooldown, biaya), kapasitas muatan, mount dalam combat, penyimpanan mount, kemampuan mount spiritual (arti "spiritual" belum didefinisikan), kustomisasi tampilan mount, aturan saat mount terluka/mati, hubungan dengan perjalanan cepat. **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.33 Tutorial dan Panduan Pemain — D-043, LOCKED (Tutorial Hybrid Adaptif)
**Ditetapkan:**
- **Komponen:** tutorial awal (pengenalan dan kontrol dasar); **contextual tutorial** saat pertama kali bertemu fitur/aktivitas; **pembelajaran lewat NPC, quest, dan eksplorasi**; **panduan dan buku bantuan** yang dapat dibuka kembali.
- Muncul menurut **konteks dan progres**, bukan urutan waktu semata.
- **Tidak memaksa mengulang** bagi pemain yang sudah paham; panduan dapat **dilewati/ditutup**, kecuali instruksi penting yang wajib untuk melanjutkan.
- Tiap panduan: **tujuan, kontrol, langkah, hasil**, singkat dan mudah dipahami.
- Cakupan: farming, livestock, fishing, crafting, alchemy, combat, dungeon, taming, Guild, NPC, ekonomi, eksplorasi.
- **Status tutorial disimpan** agar tidak muncul berulang tanpa alasan.
- Terintegrasi dengan **quest D-037, dialog D-038, inventory D-036, kontrol D-034, cloud save Supabase.**
- UI **Android landscape**, **Indonesia dan English.**
- Terkait: D-007, D-013, D-014, D-016, D-017, D-019 sampai D-026, D-028, D-031, D-033 sampai D-038, D-040 sampai D-042.

**[BELUM DITETAPKAN]:** isi dan urutan tutorial awal, daftar topik dan pemicu, bentuk tampilan, daftar instruksi wajib, isi buku bantuan, cara mendeteksi pemain yang sudah paham, opsi menonaktifkan petunjuk, tutorial ulang/reset, tutorial kontroler/pengaturan tombol, aksesibilitas, konsep "spiritual" (belum didefinisikan). **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.34 Save, Load, dan Cloud Synchronization — D-044, LOCKED (Cloud Save Hybrid Lengkap)
**Ditetapkan:**
- **Supabase** sebagai penyimpanan cloud utama; game **online-only** (D-014).
- Komponen: **Automatic Save, Cloud Save, Local Cache, Cloud Synchronization, Data Recovery, Conflict Resolution.**
- **Auto-save** pada peristiwa penting: quest selesai, perubahan inventory, perkembangan karakter, perubahan hubungan NPC, aktivitas farming, progres dungeon.
- Penyimpanan **aman**: data penting tidak hilang saat aplikasi tertutup atau koneksi terputus.
- **Cache lokal** mempercepat pemuatan dan menahan perubahan sementara saat koneksi terganggu; **bukan mode offline penuh.**
- Sinkronisasi **konsisten**; resolusi konflik **tidak menimpa progres terbaru sembarangan** dan tidak menggabungkan data tak kompatibel.
- **Indikator status save dan sinkronisasi** mudah dipahami.
- **Validasi data, versioning save, retry terbatas, perlindungan duplikasi transaksi.**
- Data akun **hanya dapat diakses pemiliknya** (kebijakan keamanan Supabase).
- Mencakup **semua progres:** quest, inventory, karakter, NPC, hubungan sosial, farming, mount, dunia.
- UI **Android landscape**, **Indonesia dan English.**
- Terkait: D-007, D-014, D-031, D-036, D-037, D-039, D-040, D-042, D-043, O-003.

**[BELUM DITETAPKAN]:** perilaku saat koneksi putus lama, metode login dan multi-perangkat, jumlah slot dan peran slot di cloud, aturan rinci resolusi konflik, frekuensi auto-save, batas ukuran dan retensi cadangan, validasi server (ekonomi/rank), kebijakan hapus akun/data, bentuk indikator UI, jam perangkat diubah, konsep "spiritual" (belum didefinisikan). **Tidak ada implementasi cloud/save lanjutan sebelum seluruh tahap desain selesai.**

### 6.35 Pengaturan dan Aksesibilitas — D-045, LOCKED (Settings Hybrid Lengkap)
**Ditetapkan:**
- **Kategori:** Audio (musik, efek suara, ambience); Graphics (kualitas, efek visual, opsi performa); Camera (sensitivitas, zoom, rotasi); Controls (ukuran, posisi, sensitivitas kontrol sentuh); HUD (tampilan dan elemen); Language (Indonesia dan English); Accessibility (ukuran teks, kontras, kenyamanan visual); **Configuration Profiles**.
- **Kualitas grafis** menyesuaikan kemampuan perangkat Android.
- **Kontrol:** virtual joystick, tombol aksi kontekstual, dan tap-to-move dapat diatur (D-034).
- **Kamera** konsisten dengan Kamera Adaptif (D-033).
- **HUD** dapat diubah ukuran dan posisinya **tanpa merusak tata letak** (D-031).
- **Bahasa** memakai localization; **tanpa teks pada aset gambar.**
- Pengaturan penting **tersimpan dan dipulihkan**; **pengaturan lokal perangkat dipisah dari progres cloud** bila secara teknis lebih tepat.
- **Reset ke default** tersedia.
- Prioritas **Android landscape** dan **performa** (Godot 4.7.2, GL Compatibility).
- Terkait: D-004, D-007, D-008, D-014, D-031 sampai D-034, D-043, D-044.

**[BELUM DITETAPKAN]:** opsi grafis rinci dan tingkatnya, deteksi tingkat perangkat, isi aksesibilitas rinci, profil konfigurasi, pembagian pengaturan lokal vs cloud, kontroler/keyboard, pengaturan baterai/data, tata letak layar Pengaturan, perubahan saat bermain, konsep "spiritual" (belum didefinisikan). **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

> **Catatan:** Tahap 35 (Sistem Akun dan Login Pemain) berstatus **PENDING** dan dibahas saat persiapan publikasi Google Play Store (P-006); tidak diubah oleh keputusan ini.

### 6.36 Achievement, Title, dan Koleksi — D-046, LOCKED (Achievement Hybrid Lengkap)
**Ditetapkan:**
- **Komponen:** Achievement; **Character Title**; **Collection Book dan Encyclopedia**; **Milestone progression**; **Exclusive achievement rewards**; **Player Journey Record.**
- **Cakupan achievement:** farming dan panen; peternakan; fishing dan aquatic collection; crafting dan alchemy; combat dan dungeon; taming dan companion; Guild dan rank; eksplorasi, rahasia, dan event; hubungan sosial dan kehidupan desa.
- **Title** dibuka lewat pencapaian dan dapat **dipasang** pada profil atau karakter.
- **Collection Book** mencatat tanaman, ikan, hewan, monster, material, lokasi, dan objek penting.
- **Milestone** jangka pendek dan panjang.
- **Hadiah:** item, kosmetik, title, material langka, atau akses khusus sesuai desain hadiah.
- **Indikator progres, status terkunci/terbuka, detail persyaratan, riwayat penyelesaian.**
- **Hindari achievement yang mendorong pengulangan berlebihan tanpa nilai permainan.**
- Terintegrasi dengan **progression, quest, inventory, Guild, koleksi monster, eksplorasi, cloud save Supabase**; UI **Android landscape**, **Indonesia dan English.**
- Terkait: D-007, D-013 sampai D-029, D-031, D-032, D-036, D-037, D-039 sampai D-045, D-014.

**[BELUM DITETAPKAN]:** daftar achievement/title/entri koleksi, tingkat dan poin, achievement tersembunyi, aturan anti-grinding, hadiah rinci dan keseimbangan, bonus koleksi, bentuk Player Journey Record, tempat title ditampilkan, hubungan dengan platform pihak ketiga, achievement yang dapat terlewat, notifikasi, konsep "spiritual" (belum didefinisikan). **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.37 Monetisasi dan Toko Kosmetik — D-047, LOCKED (Cosmetic Only)
**Ditetapkan:**
- Monetisasi **hanya untuk kosmetik:** kostum/pakaian, skin dan variasi penampilan, **dekorasi rumah dan lahan**, aksesori, tampilan visual mount dan perlengkapan.
- **Tidak dijual:** kekuatan/statistik, keunggulan combat/dungeon, level/progression, material wajib crafting atau quest, item berkeuntungan kompetitif.
- **Semua konten gameplay utama dapat diperoleh lewat permainan**; pemain tanpa pembelian menikmati progres secara adil.
- **Tidak ada bonus statistik tersembunyi** pada kosmetik berbayar.
- **Kepemilikan kosmetik dipisah dari equipment** yang menentukan atribut (D-041).
- **Katalog kosmetik** dengan info item dan status kepemilikan jelas.
- Kosmetik dapat diperoleh lewat **pembelian maupun hadiah gameplay** sesuai kebijakan desain (D-046).
- **Tidak ada premium currency dan tidak ada season pass.**
- Transaksi **mengikuti kebijakan platform distribusi** yang diputuskan saat persiapan publikasi.
- **Tahap 35 (Akun dan Login) tetap PENDING** sampai persiapan Google Play (P-006).
- Terkait: D-008, D-013, D-016, D-018, D-020, D-021, D-027, D-031, D-036, D-037, D-041, D-042, D-044 sampai D-046, D-014.

**[BELUM DITETAPKAN]:** daftar dan harga kosmetik, platform dan metode pembayaran, kebijakan toko dan pengembalian dana, batas usia, bentuk penjualan (item/paket), batas dekorasi murni visual vs bangunan fungsional, kosmetik hadiah vs berbayar, pemulihan pembelian di perangkat baru, kebijakan iklan (tidak ada sampai diputuskan), privasi dan persetujuan, konsep "spiritual" (belum didefinisikan). **Tidak ada implementasi toko/transaksi sebelum desain dan persiapan publikasi terkait selesai.**

### 6.38 Update Konten dan Live Operations — D-048, LOCKED (Live Operations Hybrid Lengkap)
**Ditetapkan:**
- **Jalur konten jangka panjang:** Regular Game Updates; New Content Updates; **World Events dan Live Events**; **New Region dan World Expansion**; Dungeon, Boss, dan Monster Expansion; Quest dan Story Expansion; Balancing dan Performance Optimization; Bug Fixes dan Quality Improvements.
- Update dapat menambah **tanaman, hewan, ikan, item, equipment, NPC, fasilitas, lokasi, dungeon, monster, dan aktivitas.**
- **Event dunia terintegrasi** dengan kalender, musim, cuaca, NPC, ekonomi, dan quest.
- **Konten baru tidak merusak progres yang ada**; save schema, migrasi data, dan **sinkronisasi cloud Supabase** dijaga kompatibel.
- **Versioning dan pemeriksaan kompatibilitas** versi game.
- Update memperhatikan **koneksi, ukuran unduhan, kapasitas perangkat Android, dan performa** (Godot 4.7.2).
- **Event berbatas waktu:** aturan waktu konsisten; **progres permanen tidak hilang tidak adil.**
- **Konten gameplay penting tidak bergantung pada pembelian kosmetik** (D-047).
- **Deployment dan pengujian update** bertahap agar tidak langsung merusak produksi.
- Terkait: D-009, D-013, D-014, D-016, D-017, D-019 sampai D-030, D-040, D-043 sampai D-047, O-001, O-002, O-004.

**[BELUM DITETAPKAN]:** ritme rilis, saluran distribusi konten dan kebijakan platform, jenis konten yang boleh live tanpa update aplikasi, batas unduhan, versi minimum/paksa-update, aturan event berbatas waktu rinci, kompensasi saat balancing, lingkungan dan peluncuran bertahap, rollback, pemantauan/analitik dan privasi, komunikasi ke pemain, pemeliharaan, konsep "spiritual" (belum didefinisikan). **Tidak ada implementasi live operations atau konten tambahan sebelum seluruh tahap desain selesai.**

#### Post-Launch Roadmap (arah, bukan jadwal)
Urutan dan isi pasca-peluncuran belum dijadwalkan. Jalur yang ditetapkan D-048 menjadi kerangka: pembaruan rutin dan perbaikan → konten baru (tanaman, hewan, ikan, item, NPC, fasilitas) → event live musiman → ekspansi wilayah, dungeon, boss, dan cerita. Tanggal dan prioritas diputuskan nanti.

### 6.39 Quality Assurance dan Strategi Pengujian — D-049, LOCKED (QA Hybrid Lengkap)
**Ditetapkan:**
- **Enam jenis pengujian:** Manual; Automated; Performance; Android Device Compatibility; Integration; Regression.
- **Manual:** pengalaman bermain nyata, kontrol sentuh, UI, NPC, farming, combat, dungeon, aktivitas lain.
- **Otomatis:** fungsi inti, validasi data, quest, inventory, progression, save/load, dan sistem yang dapat diuji otomatis.
- **Performa:** FPS, RAM, CPU, suhu, waktu muat, kestabilan.
- **Kompatibilitas:** ukuran layar, resolusi, hardware, versi Android.
- **Integrasi** antarfitur dan **regresi wajib** untuk perubahan yang berpotensi memengaruhi fitur stabil.
- **Catatan uji:** test case, hasil, tingkat keparahan bug, langkah reproduksi, status perbaikan.
- **Release gate:** APK **tidak siap rilis** bila ada bug kritis atau uji penting yang belum selesai.
- **Perangkat fisik dibedakan dari emulator/CI**; keberhasilan di perangkat fisik **tidak diklaim tanpa bukti nyata** dari pengguna atau tester.
- QA terintegrasi dengan **GitHub Actions** dan pembuatan APK.
- Terkait: O-001, O-004, P-005, D-013 sampai D-048 (sistem yang diuji), terutama D-031, D-034, D-044, D-045, D-047, D-048.

**[BELUM DITETAPKAN]:** daftar perangkat uji dan versi Android minimum, tester dan pengumpulan laporan, target performa per kelas perangkat, definisi keparahan bug dan kriteria gate rinci, alat pelacak, cakupan otomatis wajib, uji emulator/perangkat dari CI, pelaporan crash dan telemetri, beta tertutup, konsep "spiritual" (belum didefinisikan). **Tidak ada implementasi sistem QA lengkap sebelum seluruh tahap desain selesai.**

### 6.40 Keamanan dan Perlindungan Data Pemain — D-050, LOCKED (Security Hybrid Lengkap)
**Ditetapkan:**
- **Lima lapisan:** server-side validation (aktivitas dan data penting); perlindungan database dan data pemain; **anti-cheat** (manipulasi inventory, mata uang, atribut, transaksi, progres); **audit log** aktivitas penting; **security monitoring** untuk aktivitas mencurigakan.
- **Fitur dasar untuk semua pemain**: **tanpa langganan atau biaya keamanan**; **biaya server dan database ditanggung pengelola game.**
- **Monetisasi kosmetik (D-047) tidak berubah**; game tetap **single-player online** (D-014).
- Terkait: D-014, D-018, D-021, D-036, D-037, D-039, D-044 sampai D-049, O-003, O-004.

**[BELUM DITETAPKAN]:** tingkat validasi/otoritas server, tingkat penegakan terhadap kecurangan pribadi, daftar aksi wajib validasi, aturan deteksi dan ambang, tindakan dan banding, audit log (isi, retensi, akses), alat monitoring, anggaran operasional, enkripsi dan cadangan, kebijakan privasi dan hak data, hubungan dengan akun/login (Tahap 35 PENDING, P-006), pelaporan celah, konsep "spiritual" (belum didefinisikan). **Tidak ada implementasi keamanan sebelum seluruh tahap desain selesai.**

### 6.41 Performa dan Optimasi Perangkat Android — D-052, LOCKED (Adaptive Performance Hybrid Lengkap)
**Ditetapkan:**
- **Delapan area:** CPU/GPU; RAM dan memori; **grafis adaptif** menurut kemampuan perangkat; pemuatan aset dan resource; optimasi NPC, AI, animasi, dan simulasi dunia; **baterai dan kesadaran termal**; **frame pacing dan stabilitas FPS**; penanganan perangkat Android berkemampuan berbeda.
- Platform tetap **Android native, landscape-first, arm64, Godot 4.7.2, GL Compatibility.**
- **Stabilitas gameplay didahulukan** daripada efek visual.
- Grafik adaptif **menjaga keterbacaan UI dan identitas visual** 3D Stylized.
- Selaras dengan kamera (D-033), NPC (D-040), wilayah (D-009, D-028), pengaturan grafis (D-045), dan QA (D-049).
- **Tidak ada klaim hasil performa atau uji perangkat fisik** sebelum benar-benar dilakukan.
- Terkait: O-001, D-004, D-008, D-009, D-022, D-028, D-031 sampai D-034, D-040 sampai D-042, D-044, D-045, D-048 sampai D-050.

**[BELUM DITETAPKAN]:** target FPS dan batas bawah, kelas perangkat dan klasifikasinya, opsi dan urutan penurunan kualitas, ambang suhu/baterai, anggaran nyata (memori, draw call, poligon, tekstur, ukuran APK), perangkat dan versi Android minimum, mode hemat baterai, peran renderer lain, konsep "spiritual" (belum didefinisikan). **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.42 Loading dan Transisi Antarwilayah — D-053, LOCKED (Hybrid Loading & World Streaming)
**Ditetapkan:**
- **Loading screen** (ilustrasi, tips, indikator progres) bila diperlukan.
- **Transisi mulus** antararea bila kondisi teknis memungkinkan; **tidak dipaksakan** jika menyebabkan stutter atau RAM berlebihan.
- **Pemuatan asinkron** untuk mengurangi jeda; **streaming dunia dinamis** menurut posisi dan kebutuhan pemain.
- **Manajemen resource otomatis** dan **pelepasan memori** untuk resource yang tak terpakai.
- **Dungeon, interior, dan wilayah khusus** dapat memakai loading screen.
- Terintegrasi dengan **eksplorasi dunia (D-028)**, **performa adaptif (D-052)**, dan **kamera (D-033)**.
- Platform tetap Godot 4.7.2, GL Compatibility, Android arm64, landscape-first.
- Terkait: O-001, D-004, D-008, D-009, D-016, D-023, D-027, D-028, D-031 sampai D-033, D-040, D-042 sampai D-045, D-048 sampai D-050, D-052.

**[BELUM DITETAPKAN]:** pembagian transisi seamless vs loading screen, ukuran dan jarak chunk, ambang menampilkan loading screen, isi dan gaya ilustrasi, aturan tips, bentuk indikator progres, interaksi saat memuat, penanganan gagal/lambat, keselamatan pemain saat transisi, auto-save saat transisi, konsep "spiritual" (belum didefinisikan). **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.43 Peta Dunia dan Navigasi — D-054, LOCKED (World Map & Navigation Hybrid Lengkap)
**Ditetapkan:**
- **Peta dunia interaktif:** zoom, pan, wilayah, lokasi, detail peta.
- **Minimap** saat gameplay; **compass dan petunjuk arah**.
- **Quest markers dan objective markers**; **pelacakan posisi pemain.**
- **Penemuan eksplorasi** untuk lokasi dan wilayah tersembunyi.
- **Fast travel** ke lokasi yang sudah terbuka dan memenuhi persyaratan progres.
- Terintegrasi dengan **quest, dungeon, guild, mount, eksplorasi, dan Progressive World Unlock.**
- **Tidak semua wilayah terbuka sejak awal**; fast travel **mengikuti progres dan aturan dunia.**
- **Mudah dipakai di Android landscape** dengan layar sentuh; **Indonesia dan English.**
- Selaras dengan D-028, D-033 (kamera), dan D-053 (fast travel memakai transisi Loading).
- Terkait: D-009, D-016, D-017, D-019, D-029 sampai D-035, D-037, D-040, D-042 sampai D-046, D-052, D-053.

**[BELUM DITETAPKAN]:** gaya tampilan peta, aturan kerahasiaan/penemuan, jenis penanda dan filter, penanda buatan pemain, aturan fast travel rinci, peta tujuan untuk jalan otomatis, desain minimap dan kompas, peta interior/dungeon, aksesibilitas peta, konsep "spiritual" (belum didefinisikan). **Tidak ada implementasi sebelum seluruh tahap desain selesai.**

### 6.44 Waktu, Kalender, dan Jam Permainan — D-055, LOCKED (Dynamic Time & Calendar Hybrid Lengkap)
**Ditetapkan:**
- **Jam dalam permainan** dan **kalender** (hari, tanggal, bulan, tahun).
- **Siklus pagi, siang, sore, malam.**
- **Jadwal harian NPC** berdasarkan waktu; **festival dan aktivitas kalender.**
- **Aktivitas monster dan lokasi** dipengaruhi waktu; **event dunia** dengan jadwal/syarat waktu.
- Terintegrasi dengan **musim, cuaca, pertanian, peternakan, memancing, dungeon, dan ekonomi.**
- **Waktu permainan memakai simulasi internal**, bukan semata-mata jam perangkat; disimpan di save sebagai sumber kebenaran.
- **Konsistensi waktu:** perpindahan wilayah dan loading tidak membuat waktu melompat/mundur; mengubah jam perangkat tidak mengubah waktu permainan; gangguan koneksi tidak memajukan atau memundurkan waktu (perilaku lanjutan menunggu D-051).
- Selaras dengan D-029, D-030, D-040, D-044, dan D-051 (isi D-051 belum diterima).
- Terkait: D-009, D-015, D-016, D-021 sampai D-026, D-031, D-032, D-045, D-048, D-050, D-052 sampai D-054.

**[BELUM DITETAPKAN]:** panjang hari/bulan/tahun dan fase hari, kecepatan jam, apakah waktu berjalan di menu/dialog/pertarungan/latar belakang/offline, kebijakan event waktu nyata vs kalender, aturan catch-up, panjang musim, konsep "spiritual" (belum didefinisikan). **Tidak ada** model romansa/pernikahan/keluarga/anak (belum diputuskan).

### 6.45 Tidur, Istirahat, dan Pergantian Hari — D-056, LOCKED (Rest & Sleep Hybrid Lengkap)
**Ditetapkan:**
- **Tidur di rumah**, **tidur di penginapan**, dan **istirahat di kemah** saat menjelajah.
- **Pemulihan melalui istirahat** (efek belum ditentukan).
- **Advance day** dan **pemrosesan pergantian hari**: pertanian, peternakan, NPC, toko, ekonomi, dan event.
- Terintegrasi dengan **kalender, jam, musim, cuaca, dan save.**
- Pergantian hari **satu jalur resmi**, deterministik (seed + tanggal), **tidak memakai jam perangkat**, tanpa waktu mundur.
- **Pemrosesan berat tidak dalam satu frame**; ditutupi transisi/loading (D-053).
- **Aman terhadap gangguan koneksi dan penyimpanan** (transaksi idempoten, penulisan atomik, tanpa dobel proses).
- Tetap **single-player online** (D-014). Selaras dengan D-044, D-055, dan D-051 (isi D-051 belum diterima).
- Terkait: D-015, D-021 sampai D-024, D-027 sampai D-032, D-040, D-045, D-048 sampai D-050, D-052, D-053.

**[BELUM DITETAPKAN]:** efek pemulihan, batas tidur dan aturan jam tidur, biaya/fasilitas penginapan, aturan dan risiko kemah, tidur singkat tanpa ganti hari, perilaku offline/catch-up, konsep "spiritual" (belum didefinisikan). **Tidak ada** model romansa/pernikahan/keluarga/anak (belum diputuskan).

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
2. ~~Pertarungan~~ (D-013 terkunci); sisanya: detail aturan combat (kamera D-033 dan kontrol D-034 terkunci).
3. Struktur dunia dan wilayah (ukuran, loading, peta).
4. ~~Sistem kehidupan~~ (D-015 terkunci); sisanya: detail aturan (musim, waktu, stamina, ekonomi, resep, festival).
5. ~~Dungeon~~ (D-016 terkunci: tetap + acak); sisanya: detail loot, boss, kesulitan.
6. ~~Guild, rank, quest~~ (D-017 terkunci); sisanya: progres cerita dan detail quest.
7. ~~NPC dan hubungan~~ (D-022 terkunci); sisanya: daftar NPC, romansa/keluarga (belum ditetapkan).
8. Art direction 3D Stylized dan sumber aset.
9. ~~Monetisasi~~ (D-047 terkunci: Cosmetic Only; detail harga, platform pembayaran, dan kebijakan toko menunggu persiapan publikasi).

Setiap keputusan baru wajib dicatat di `DESIGN_DECISIONS.md` sebelum implementasi.
