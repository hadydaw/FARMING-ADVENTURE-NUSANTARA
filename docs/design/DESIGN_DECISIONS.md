# Catatan Keputusan Desain dan Teknis

Seri ID: **D-xxx** = keputusan desain game (nomor sesuai tahap desain bersama ChatGPT); **O-xxx** = persetujuan pemilik atas hal teknis/operasional; **T-xxx** = keputusan teknis rutin; **P-xxx** = menunggu pemilik.
Catatan 2026-11-17: entri yang sebelumnya bernomor D-013…D-019 (ID lama itu tidak berlaku lagi; nomor D-013 dan seterusnya kini hanya untuk keputusan desain tahap bersama ChatGPT) (engine, package ID, backend, kunci rilis, lisensi, uji HP, larangan fitur) dinomori ulang menjadi **O-001…O-007** agar ID **D-013** dipakai untuk sistem pertarungan sesuai instruksi pemilik. Isinya tidak berubah.

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
| D-011 | Rank petualang direncanakan: F, E, D, C, B, A, S, SS, SSS (dikukuhkan di D-017). | 2026-11-17 |
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

**Batasan (DIPERBARUI oleh D-066, Tahap 57):** pada saat D-015 dicatat, hubungan romantis, pernikahan, membangun keluarga, dan memiliki anak belum dipilih. **D-066 kini menetapkan seluruh aspek itu sebagai bagian resmi permainan (cakupan saja; detail belum final).** Fitur kehidupan lain di D-015 tidak berubah.

Catatan: ID D-015 tersedia saat dicatat (tidak ada bentrokan). Detail aturan tiap fitur (daftar tanaman/hewan, panjang musim, resep, harga, jadwal festival, tahap upgrade) belum ditetapkan. Implementasi belum dimulai.

### D-016 — Sistem Dungeon *(APPROVED / LOCKED, 2026-11-17, Tahap 6)*
Pilihan: **D. Kombinasi Dungeon Tetap dan Acak.**

1. **Story Dungeon:** desain dan tata letak ruangan **tetap**; terhubung dengan cerita atau quest; monster dan boss khusus; hadiah penyelesaian.
2. **Exploration Dungeon:** tata letak ruangan **acak**; penempatan monster dan tantangan dapat bervariasi; menyediakan material dan harta karun; dapat dijelajahi berulang kali.
3. **Fitur tambahan:** dungeon rahasia, boss spesial, hadiah unik.

Detail (jumlah lantai/ruangan, algoritma acak, tabel loot, kesulitan, syarat dungeon rahasia, daftar boss) belum ditetapkan. Implementasi belum dimulai. ID D-016 tersedia saat dicatat (tanpa bentrokan).

### D-017 — Sistem Adventurer Guild *(APPROVED / LOCKED, 2026-11-17, Tahap 7)*
Pilihan: **D. Guild Petualang Lengkap.** Fitur yang ditetapkan:
1. Rank petualang **F, E, D, C, B, A, S, SS, SSS** (menegaskan D-011)
2. Quest Board dan misi khusus
3. Ujian kenaikan rank
4. Sistem reputasi dan prestasi
5. Spesialisasi petualang
6. Training dan pengembangan kemampuan
7. Hadiah, gelar, dan penghargaan
8. Guild Master dan NPC pengurus

Detail (syarat tiap rank, isi ujian, jenis spesialisasi, daftar quest/gelar/hadiah, rumus reputasi, nama dan karakter NPC) belum ditetapkan. Implementasi belum dimulai. ID D-017 tersedia saat dicatat (tanpa bentrokan).

### D-018 — Sistem Perkembangan Karakter *(APPROVED / LOCKED, 2026-11-17, Tahap 8)*
Pilihan: **D. Kombinasi Semua Sistem.** Fitur yang ditetapkan:
1. Level dan atribut karakter
2. Skill Tree bercabang
3. Skill aktif dan pasif
4. Sistem Class dan Job
5. Perubahan spesialisasi karakter
6. Perkembangan penguasaan senjata
7. Kemampuan sihir dan elemen
8. Perkembangan karakter jangka panjang

Pemain dapat mengembangkan karakter lewat berbagai jalur kemampuan dan kombinasi spesialisasi.

Hubungan dengan keputusan lain (tidak mengubah isinya): memperluas butir Skill Tree dan Magic/Elemen pada **D-013**; berkaitan dengan spesialisasi dan training pada **D-017**; level karakter adalah salah satu syarat pembukaan wilayah pada **D-009**.
Detail (rumus level/atribut, daftar class/job, aturan ganti spesialisasi dan biayanya, batas level, struktur cabang skill tree) belum ditetapkan. Implementasi belum dimulai. ID D-018 tersedia saat dicatat (tanpa bentrokan).

### D-019 — Sistem Companion dan Monster Taming *(APPROVED / LOCKED, 2026-11-17, Tahap 9)*
Pilihan: **D. Kombinasi Semua Sistem.** Fitur yang ditetapkan:
1. Pet untuk kehidupan sehari-hari
2. Combat Companion untuk membantu pertarungan
3. Monster Taming untuk menjinakkan monster dungeon
4. Koleksi monster langka
5. Level dan evolusi monster
6. Skill dan kemampuan khusus monster
7. Sistem hubungan dan loyalitas companion
8. Monster dapat membantu aktivitas tertentu

Companion memiliki fungsi berbeda sesuai jenis, kemampuan, dan karakteristiknya.

Hubungan dengan keputusan lain (tidak mengubah isinya): monster berasal dari dungeon (**D-016**) dan sistem pertarungan (**D-013**); pemeliharaan hewan ternak adalah bagian **D-015** dan dibedakan dari pet/companion (batas keduanya belum ditetapkan); "membantu aktivitas tertentu" berkaitan dengan Sistem Kehidupan (D-015) dan dungeon, jenis aktivitasnya belum ditetapkan.
Detail (daftar monster dan pet, cara menjinakkan, batas jumlah companion, rumus level/evolusi, mekanik loyalitas, aktivitas yang dibantu) belum ditetapkan. Implementasi belum dimulai. ID D-019 tersedia saat dicatat (tanpa bentrokan dengan ID yang berlaku).

### D-020 — Sistem Equipment dan Crafting *(APPROVED / LOCKED, 2026-11-17, Tahap 10)*
Pilihan: **D. Kombinasi Semua Sistem.** Fitur yang ditetapkan:
1. Crafting senjata dan armor
2. Equipment Upgrade
3. Enchant dan atribut tambahan
4. Mining dan Gathering
5. Profesi Blacksmith dan Alchemist
6. Pembuatan potion dan makanan
7. Material langka dari dungeon
8. Material legendaris dari Boss
9. Sistem kualitas dan rarity item

Syarat: sistem crafting harus terhubung dengan pertanian, gathering, pertambangan, perburuan monster, dan eksplorasi dungeon.

Hubungan dengan keputusan lain (tidak mengubah isinya): senjata dan armor melengkapi pertarungan (**D-013**) dan penguasaan senjata (**D-018**); material langka/legendaris berasal dari dungeon dan boss (**D-016**); pertanian dan memasak adalah bagian **D-015** (makanan dibuat lewat sistem memasak/crafting; batas keduanya belum ditetapkan); Blacksmith dan Alchemist adalah profesi, hubungannya dengan Class/Job (**D-018**) dan spesialisasi guild (**D-017**) belum ditetapkan.
Detail (daftar equipment, slot, tier, resep, stat, jenis enchant, rumus kualitas dan rarity, tingkat profesi, titik mining/gathering) belum ditetapkan. Implementasi belum dimulai. ID D-020 tersedia saat dicatat (tanpa bentrokan).

### D-021 — Sistem Ekonomi dan Perdagangan *(APPROVED / LOCKED, 2026-11-17, Tahap 11)*
Pilihan: **D. Kombinasi Semua Sistem.** Ruang lingkup:
1. Jual beli hasil pertanian
2. Merchant dan toko khusus
3. Perdagangan material monster
4. Ekonomi dinamis
5. Harga barang dipengaruhi musim dan wilayah
6. Permintaan, penawaran, dan kelangkaan barang
7. Perdagangan antarwilayah
8. Perkembangan kekayaan dan usaha pemain

Integrasi ekonomi:
- Hasil pertanian dapat dijual atau diproses menjadi barang bernilai lebih tinggi.
- Material tambang dan monster dapat diperdagangkan atau dipakai untuk crafting.
- Merchant memiliki spesialisasi barang.
- Perubahan musim, wilayah, ketersediaan, dan permintaan dapat memengaruhi harga.

Hubungan dengan keputusan lain (tidak mengubah isinya): merinci butir "ekonomi dan perdagangan" pada **D-015**; material dan crafting pada **D-020**; musim pada D-015; wilayah pada **D-009**; material monster dan tambang dari **D-013/D-016**; kekayaan dan usaha pemain berkaitan dengan pengembangan ladang/rumah (D-015).
**Catatan konsistensi dengan D-014 (Single-Player Online):** D-014 menetapkan dunia sebagai progres pribadi dan tanpa multiplayer. D-021 tidak menyebut ekonomi bersama antarpemain, sehingga "ekonomi dinamis" dicatat sebagai **ekonomi pribadi per pemain**. Apakah harga dihitung di klien atau di server, dan apakah ada ekonomi bersama, **belum ditetapkan** dan tidak boleh diasumsikan.
Detail (daftar barang dan harga dasar, rumus permintaan/penawaran, daftar merchant dan spesialisasinya, rute dan aturan perdagangan antarwilayah, bentuk "usaha" pemain, mata uang) belum ditetapkan. Implementasi belum dimulai. ID D-021 tersedia saat dicatat (tanpa bentrokan).

### D-022 — Sistem NPC dan Kehidupan Sosial *(APPROVED / LOCKED, 2026-11-17, Tahap 12)*
Pilihan: **D. Kombinasi Semua Sistem.** Ruang lingkup:
1. NPC memiliki jadwal harian dan rutinitas
2. NPC mempunyai pekerjaan dan aktivitas mandiri
3. Sistem hubungan pertemanan dan kepercayaan
4. Cerita pribadi NPC dan quest bercabang
5. NPC bereaksi terhadap tindakan pemain
6. Interaksi sosial dan event desa
7. Perubahan perilaku NPC berdasarkan perkembangan dunia

Ketentuan desain:
- NPC harus memiliki identitas, pekerjaan, karakter, dan rutinitas yang konsisten.
- Aktivitas NPC mempertimbangkan waktu dan kondisi dunia.
- Hubungan sosial berkembang berdasarkan interaksi pemain.
- Dialog, quest, dan event dapat berubah sesuai hubungan dan perkembangan cerita.
- Sistem dirancang agar **jumlah NPC yang besar tetap dapat dikelola dengan baik**.

**Batasan (DIPERBARUI oleh D-066):** D-022 sendiri hanya menyebut hubungan **pertemanan dan kepercayaan** dan isinya **tidak diubah**; romansa, pernikahan, keluarga, dan anak kini ditetapkan oleh **D-066** sebagai keputusan terpisah yang menambah (bukan mengganti) cakupan hubungan D-022.

Hubungan dengan keputusan lain (tidak mengubah isinya): jadwal dan kondisi dunia memakai kalender/musim/festival (**D-015**); NPC pengurus guild dan quest (**D-017**); merchant dengan spesialisasi (**D-021**); perkembangan dunia dan wilayah (**D-009**); dunia dan NPC adalah progres pribadi pemain (**D-014**).
Detail (daftar NPC, kepribadian, tingkat hubungan, bentuk reaksi, struktur quest bercabang, jumlah NPC target) belum ditetapkan. Implementasi belum dimulai. ID D-022 tersedia saat dicatat (tanpa bentrokan).

### D-023 — Sistem Pertanian dan Pertumbuhan Tanaman *(APPROVED / LOCKED, 2026-11-17, Tahap 13)*
Pilihan: **D. Kombinasi Semua Sistem.** Ruang lingkup:
1. Mekanisme bertani lengkap: mengolah tanah, menanam, merawat, memanen
2. Banyak jenis tanaman, bibit, dan varietas
3. Kualitas tanah, pupuk, dan sistem pengairan
4. Musim dan cuaca memengaruhi pertumbuhan tanaman
5. Tanaman spiritual dan tanaman langka
6. Integrasi pertanian dengan crafting, alkimia, dan ekonomi
7. Pengembangan lahan dan teknologi pertanian

Ketentuan desain:
- Setiap tanaman punya karakteristik dan tahapan pertumbuhan.
- Kebutuhan air, pupuk, musim, dan kondisi tanah dapat berbeda antarjenis tanaman.
- Tanaman spiritual dan langka punya mekanisme dan kegunaan khusus.
- Hasil panen dipakai untuk perdagangan, crafting, alkimia, dan kebutuhan petualangan.
- Sistem harus mudah diperluas dengan tanaman dan wilayah baru.

Hubungan dengan keputusan lain (tidak mengubah isinya): merinci butir farming dan pengembangan ladang pada **D-015**; musim (D-015) dan cuaca, yang kini dinyatakan memengaruhi tanaman; crafting dan profesi Alchemist pada **D-020** (istilah "alkimia" dibaca sebagai bagian sistem Alchemist D-020; rinciannya belum ditetapkan); ekonomi pada **D-021**; wilayah baru pada **D-009**; "kebutuhan petualangan" (mis. bahan potion/makanan) pada **D-013/D-020**.
Hal baru yang **belum didefinisikan**: arti "tanaman spiritual" dan mekanismenya. Detail (daftar tanaman/varietas, lama tumbuh, tahap pertumbuhan, jenis cuaca, jenis pupuk, mekanik pengairan, teknologi pertanian, langkanya tanaman langka) belum ditetapkan. Implementasi belum dimulai. ID D-023 tersedia saat dicatat (tanpa bentrokan).

### D-024 — Sistem Peternakan dan Hewan *(APPROVED / LOCKED, 2026-11-17, Tahap 14)*
Pilihan: **D. Kombinasi Semua Sistem.** Ruang lingkup:
1. Hewan ternak biasa dan hewan langka
2. Sistem kesehatan dan kebutuhan makanan hewan
3. Pertumbuhan dan perkembangbiakan
4. Kualitas produk ternak
5. Hewan spiritual dengan kemampuan khusus
6. Integrasi peternakan dengan crafting, ekonomi, dan petualangan
7. Pengembangan kandang dan fasilitas peternakan

Ketentuan desain:
- Setiap spesies punya kebutuhan, karakteristik, dan hasil produk berbeda.
- Kesehatan dan kualitas perawatan memengaruhi produktivitas.
- Hewan tumbuh dan berkembang biak sesuai aturan spesies.
- Hewan spiritual punya karakteristik dan kemampuan unik.
- Sistem mendukung penambahan spesies dan fasilitas baru.

Hubungan dengan keputusan lain (tidak mengubah isinya): merinci butir peternakan dan pemeliharaan hewan pada **D-015**; produk ternak untuk crafting/makanan (**D-020**) dan perdagangan (**D-021**); pakan dapat berasal dari hasil pertanian (**D-023**); "petualangan" dapat berkaitan dengan companion/monster (**D-019**) dan material/loot (**D-016/D-020**); pengembangan kandang berkaitan dengan pengembangan ladang dan rumah (**D-015**).
**Batas yang masih terbuka:** perbedaan hewan ternak (D-024) dengan pet/companion (D-019), serta hubungan "hewan spiritual" dengan companion dan monster, belum ditetapkan. "Hewan spiritual" (seperti "tanaman spiritual" di D-023) belum didefinisikan. "Perkembangbiakan" dibaca sebagai berlaku untuk **hewan**; tidak berkaitan dengan keluarga/anak pemain, yang tetap belum ditetapkan (D-015).
Detail (daftar spesies dan produk, jenis fasilitas, aturan kesehatan, kebutuhan pakan, aturan kawin/lahir, daftar hewan langka dan spiritual) belum ditetapkan. Implementasi belum dimulai. ID D-024 tersedia saat dicatat (tanpa bentrokan).

### D-025 — Sistem Memancing dan Kehidupan Perairan *(APPROVED / LOCKED, 2026-11-17, Tahap 15)*
Pilihan: **D. Kombinasi Semua Sistem.** Ruang lingkup:
1. Memancing di sungai, danau, laut, dan lokasi khusus
2. Beragam spesies ikan dengan tingkat kelangkaan
3. Pengaruh lokasi, musim, cuaca, dan waktu
4. Umpan, alat pancing, dan kualitas hasil tangkapan
5. Ikan spiritual dan makhluk air fantasi
6. Koleksi, perdagangan, memasak, dan crafting
7. Tantangan menangkap ikan legendaris

Ketentuan desain:
- Setiap spesies punya habitat dan karakteristik tersendiri.
- Ketersediaan ikan dipengaruhi lokasi, musim, cuaca, dan waktu.
- Peralatan dan umpan memengaruhi peluang dan kualitas tangkapan.
- Makhluk air spiritual dan legendaris punya karakteristik khusus.
- Hasil tangkapan dimanfaatkan untuk koleksi, ekonomi, memasak, dan crafting.

Hubungan dengan keputusan lain (tidak mengubah isinya): merinci butir memancing pada **D-015**; musim dan cuaca (D-015, D-023); perdagangan (**D-021**); memasak dan crafting (**D-015, D-020**; alat pancing dan umpan termasuk equipment/item, D-020); wilayah dan lokasi air per wilayah (**D-009**); tantangan ikan legendaris dapat berkaitan dengan guild/quest (D-017) dan prestasi (D-017), keterkaitannya belum ditetapkan.
**Terbuka:** "ikan spiritual" dan "makhluk air fantasi" belum didefinisikan (sama seperti tanaman dan hewan spiritual di D-023, D-024); apakah makhluk air dapat menjadi companion/monster (D-019) belum ditetapkan; apakah ada pertarungan dengan makhluk air (D-013) belum ditetapkan.
Detail (daftar spesies dan lokasi, mekanik memancing, jenis alat/umpan, aturan kelangkaan, daftar ikan legendaris) belum ditetapkan. Implementasi belum dimulai. ID D-025 tersedia saat dicatat (tanpa bentrokan).

### D-026 — Sistem Memasak dan Alkimia *(APPROVED / LOCKED, 2026-11-17, Tahap 16)*
Pilihan: **D. Kombinasi Semua Sistem.** Ruang lingkup:
1. Sistem memasak lengkap dengan banyak resep
2. Kualitas bahan dan kemampuan memasak
3. Makanan dengan efek pemulihan dan buff
4. Sistem alkimia dan pembuatan ramuan
5. Herbal, tanaman spiritual, dan material monster
6. Resep langka dan penemuan resep baru
7. Pengembangan dapur dan laboratorium alkimia
8. Integrasi dengan pertanian, peternakan, memancing, dungeon, dan ekonomi

Ketentuan desain:
- Bahan punya kualitas dan kegunaan berbeda.
- Resep dapat ditemukan, dipelajari, dan dikembangkan.
- Makanan dan ramuan punya efek yang jelas.
- Material dari berbagai aktivitas dunia dapat menjadi bahan masakan atau alkimia.
- Dapur dan laboratorium dapat dikembangkan seiring progres pemain.

Hubungan dengan keputusan lain (tidak mengubah isinya): merinci butir **memasak** pada **D-015** dan "pembuatan potion dan makanan" serta profesi Alchemist pada **D-020** (D-026 menjadi sistem rinci untuk makanan dan ramuan; batas dengan profesi Alchemist dan crafting equipment di D-020 belum ditetapkan); bahan dari pertanian (**D-023**, termasuk herbal dan tanaman spiritual), peternakan (**D-024**), memancing (**D-025**), dungeon/monster (**D-016, D-013**); efek buff/pemulihan terhubung dengan pertarungan (**D-013**) dan perkembangan karakter (**D-018**); resep sebagai barang dagang/ekonomi (**D-021**); pengembangan dapur/laboratorium berkaitan dengan pengembangan rumah (**D-015**).
**Terbuka:** "tanaman spiritual" masih belum didefinisikan (D-023); rumus efek, daftar resep, dan cara resep ditemukan/dipelajari/dikembangkan belum ditetapkan; apakah memasak/alkimia berupa keterampilan pemain, profesi NPC, atau keduanya belum ditetapkan.
Implementasi belum dimulai. ID D-026 tersedia saat dicatat (tanpa bentrokan).

### D-027 — Sistem Rumah, Lahan, dan Bangunan *(APPROVED / LOCKED, 2026-11-17, Tahap 17)*
Pilihan: **D. Kombinasi Semua Sistem.** Ruang lingkup:
1. Rumah utama dengan upgrade bertingkat
2. Gudang, kandang, greenhouse, dan workshop
3. Bangunan produksi dan fasilitas peternakan
4. Paviliun serta bangunan spiritual
5. Dekorasi dan penataan lahan bebas
6. Ekspansi lahan dan fasilitas
7. Bangunan dengan fungsi khusus sesuai progres pemain

Ketentuan desain:
- Bangunan punya fungsi gameplay yang jelas.
- Rumah dan fasilitas dikembangkan bertahap.
- Tata letak dan dekorasi lahan dapat disesuaikan pemain.
- Fasilitas produksi terintegrasi dengan pertanian, peternakan, memasak, dan alkimia.
- Bangunan spiritual dapat dibuka lewat progres permainan.
- Sistem mendukung penambahan jenis bangunan baru.

Hubungan dengan keputusan lain (tidak mengubah isinya): merinci butir **pengembangan rumah** dan **pengembangan/perluasan ladang** pada **D-015**; pertanian (**D-023**, greenhouse), peternakan (**D-024**, kandang dan fasilitas), memasak dan alkimia (**D-026**, dapur dan laboratorium sebagai fasilitas), crafting (**D-020**, workshop/penyimpanan); biaya dan material berkaitan dengan ekonomi (**D-021**); pembukaan bangunan spiritual lewat progres (**D-009**, **D-017**) bergantung pada keputusan yang belum ada.
**Terbuka:** arti "bangunan spiritual" dan "paviliun" (fungsi gameplay) belum didefinisikan, sama seperti elemen "spiritual" lain (D-023, D-024, D-025); apakah penataan lahan bebas berbasis grid atau penempatan bebas belum ditetapkan; batas dengan sistem pengembangan di D-015 (rumah/ladang) tidak bertentangan, hanya dirinci.
**Penegasan (DIPERBARUI oleh D-066):** D-027 sendiri tidak memutuskan kamar keluarga, pasangan, atau anak dan isinya tidak diubah; romansa, pernikahan, keluarga, dan anak kini ditetapkan oleh **D-066** (cakupan saja); rumah bersama pasangan/keluarga adalah detail yang belum diputuskan.
Detail (daftar bangunan, tahap upgrade, ukuran lahan, biaya, syarat buka bangunan spiritual) belum ditetapkan. Implementasi belum dimulai. ID D-027 tersedia saat dicatat (tanpa bentrokan).

### D-028 — Sistem Eksplorasi Dunia dan Perjalanan *(APPROVED / LOCKED, 2026-11-17, Tahap 18)*
Pilihan: **D. Kombinasi Semua Sistem.** Ruang lingkup:
1. Dunia luas dengan wilayah yang dibuka bertahap
2. Desa, kota, hutan, gunung, gua, dan lautan
3. Wilayah spiritual, reruntuhan, dan pulau tersembunyi
4. Sumber daya, monster, rahasia, dan lokasi unik
5. Perjalanan darat, air, dan transportasi khusus
6. Peta dunia, penanda lokasi, dan fast travel
7. Eksplorasi terintegrasi dengan quest, dungeon, dan progres pemain

Ketentuan desain:
- Setiap wilayah punya identitas visual, sumber daya, dan tantangan tersendiri.
- Pembukaan wilayah mengikuti progres pemain dan kebutuhan cerita.
- Perjalanan dan transportasi sesuai karakteristik geografis wilayah.
- Peta membantu mengenali lokasi, penanda, dan tempat yang telah ditemukan.
- Fast travel dibuka dengan aturan progres yang jelas.
- Eksplorasi terhubung dengan pertanian, petualangan, quest, dan dungeon.

Hubungan dengan keputusan lain (tidak mengubah isinya): merinci **Progressive World Unlock (D-009)** (wilayah, desa/kota, sumber daya, monster, dungeon per wilayah); dungeon (**D-016**, termasuk dungeon rahasia); guild, rank, dan quest (**D-017**); monster (**D-013**); sumber daya dan material (**D-020, D-023, D-025**); pembukaan wilayah memakai level (**D-018**), rank (**D-017**), quest, dan cerita; lautan dan perairan (**D-025**); progres dunia bersifat pribadi (**D-014**).
**Terbuka:** arti "wilayah spiritual" belum didefinisikan (sama seperti elemen "spiritual" lain); jenis "transportasi khusus" (kendaraan, tunggangan, kapal), apakah tunggangan terkait companion/monster (D-019); aturan fast travel (syarat, biaya, batasan); ukuran dunia dan jumlah wilayah; apakah perjalanan memakan waktu permainan (kalender).
Detail (daftar wilayah, peta dunia, syarat buka tiap wilayah, rute, lokasi unik) belum ditetapkan. Implementasi belum dimulai. ID D-028 tersedia saat dicatat (tanpa bentrokan).

### D-029 — Sistem Event Dunia dan Kejadian Dinamis *(APPROVED / LOCKED, 2026-11-17, Tahap 19)*
Pilihan: **D. Kombinasi Semua Sistem.** Ruang lingkup:
1. Event terjadwal berdasarkan kalender permainan
2. Kejadian acak dan dinamis
3. Serangan monster dan invasi wilayah
4. World boss dan monster legendaris
5. Bencana alam dan fenomena spiritual
6. Pedagang misterius serta penemuan langka
7. Dampak event terhadap NPC, ekonomi, dan wilayah
8. Hadiah, quest khusus, dan perubahan dunia

Ketentuan desain:
- Event dapat dipicu oleh kalender, kondisi wilayah, progres pemain, atau peluang kejadian.
- Event punya kondisi awal, durasi, dampak, penyelesaian, dan konsekuensi yang jelas.
- Kejadian dunia memengaruhi aktivitas NPC, perdagangan, sumber daya, dan keamanan wilayah.
- Event besar dan langka punya pemberitahuan serta persiapan yang sesuai.
- Sistem mempertimbangkan bahwa game ini **single-player online dengan progres tersimpan di cloud** (D-014).

Hubungan dengan keputusan lain (tidak mengubah isinya): kalender, musim, festival, dan acara desa (**D-015**, event terjadwal); NPC dan event desa (**D-022**); ekonomi dan pedagang (**D-021**, dampak harga dan "pedagang misterius"); wilayah dan keamanan (**D-009, D-028**); monster, boss, dan dungeon (**D-013, D-016**); quest dan hadiah (**D-017**); material (**D-020**); bencana memengaruhi pertanian/peternakan/memancing (**D-023, D-024, D-025**) dan bangunan (**D-027**).
**Penegasan konsistensi dengan D-014:** "world boss" dan "invasi wilayah" dicatat sebagai **pengalaman pemain tunggal dalam dunia pribadi**; bukan multiplayer, tidak ada co-op atau dunia bersama. Penafsiran lain tidak boleh diasumsikan.
**Terbuka:** arti "fenomena spiritual" belum didefinisikan (elemen "spiritual" lain, D-023 sampai D-028); apakah event dapat berlangsung saat pemain tidak bermain atau offline; bagaimana event diperlakukan bila waktu perangkat berubah atau pemain memuat ulang save (aturan keadilan); frekuensi dan keparahan konsekuensi (apakah ada kerugian permanen/kehilangan item atau bangunan).
Detail (daftar event, jadwal, bobot peluang, dampak, hadiah) belum ditetapkan. Implementasi belum dimulai. ID D-029 tersedia saat dicatat (tanpa bentrokan).

### D-030 — Sistem Musim, Cuaca, dan Lingkungan *(APPROVED / LOCKED, 2026-11-17, Tahap 20)*
Pilihan: **D. Kombinasi Semua Sistem.** Ruang lingkup:
1. **Empat musim** dengan perubahan lingkungan
2. Cuaca dinamis dan pergantian siang malam
3. Hujan, badai, salju, kabut, dan fenomena ekstrem
4. Iklim berbeda di setiap wilayah
5. Fenomena spiritual dan kondisi alam langka
6. Pengaruh terhadap tanaman, hewan, ikan, dan monster
7. Pengaruh terhadap NPC, eksplorasi, dan perdagangan
8. Kalender dunia dan perubahan lingkungan berkelanjutan

Ketentuan desain:
- Setiap wilayah dapat punya karakteristik iklim berbeda.
- Perubahan musim dan cuaca konsisten dengan kalender dunia.
- Kondisi lingkungan dapat memengaruhi aktivitas gameplay.
- Fenomena spiritual punya aturan kemunculan dan dampak yang jelas.
- Perubahan cuaca dan musim tersinkron dengan sistem single-player online dan cloud save.

Hubungan dengan keputusan lain (tidak mengubah isinya): merinci butir **pergantian musim** (D-015) dan menetapkan **jumlah musim = empat**; cuaca yang memengaruhi tanaman (**D-023**), ikan (**D-025**), hewan (**D-024**), monster dan wilayah (**D-013, D-028**); NPC dan jadwal (**D-022**); perdagangan dan harga (**D-021**); event bencana dan fenomena (**D-029**); kalender dan festival (**D-015**); sinkronisasi dengan akun/cloud save (**D-014**).
**Terbuka:** arti "fenomena spiritual" belum didefinisikan (dan kini dinyatakan harus punya aturan kemunculan serta dampak jelas, tetapi isinya belum ada); panjang tiap musim, nama musim, dan daftar cuaca per iklim; daftar iklim/wilayah; hubungan fenomena spiritual dengan event (D-029) dan bangunan spiritual (D-027); acuan waktu (perangkat vs server) dan aturan bila waktu perangkat diubah (lihat D-029).
Detail (panjang musim, daftar cuaca, peluang, dampak numerik, iklim tiap wilayah) belum ditetapkan. Implementasi belum dimulai. ID D-030 tersedia saat dicatat (tanpa bentrokan).

### D-031 — Sistem UI, HUD, dan Antarmuka Pemain *(APPROVED / LOCKED, 2026-11-17, Tahap 21)*
Pilihan: **D. Kombinasi Semua Sistem.** Ruang lingkup:
1. HUD RPG dan informasi karakter
2. HUD farming dan hotbar alat
3. Inventory, equipment, skill, dan quest
4. Peta, kalender, cuaca, dan waktu
5. Menu peternakan, crafting, dan alkimia
6. Antarmuka dungeon dan combat
7. UI adaptif sesuai aktivitas pemain
8. Pengaturan ukuran dan posisi tombol

Standar desain:
- Android landscape sebagai orientasi utama.
- Kontrol nyaman untuk layar sentuh.
- HUD tidak menutupi area permainan secara berlebihan.
- Bahasa Indonesia utama, English kedua.
- Visual UI konsisten dengan gaya 3D Stylized.
- UI menampilkan kontrol dan informasi sesuai aktivitas pemain.
- Ukuran dan posisi tombol dapat disesuaikan.

Hubungan dengan keputusan lain (tidak mengubah isinya): orientasi dan platform (**D-004**), bahasa (**D-007**), gaya visual (**D-008**); skema kontrol sentuh yang masih terbuka di GDD §4 kini harus memenuhi standar ini; UI menampilkan sistem pertarungan (**D-013**), perkembangan karakter dan skill (**D-018**), guild/quest (**D-017**), companion (**D-019**), equipment/crafting (**D-020**), ekonomi/toko (**D-021**), pertanian/peternakan/memancing/memasak (**D-023 sampai D-026**), bangunan (**D-027**), peta dan perjalanan (**D-028**), event (**D-029**), musim/cuaca/waktu (**D-030**), dan koneksi/akun (**D-014**).
**Terbuka:** gaya visual UI rinci (art direction, tema), tata letak tiap HUD, jenis dan jumlah tombol aksi, skema kontrol sentuh konkret (joystick atau tap-to-move), dukungan kontroler, ukuran target sentuh minimum, apakah ada mode UI untuk layar kecil/besar/tablet, aksesibilitas (ukuran teks, kontras, buta warna), tampilan status koneksi/sinkronisasi cloud.
Detail tata letak dan daftar layar belum ditetapkan. Implementasi UI/HUD belum dimulai (layar boot saat ini hanya uji fondasi, bukan UI game). ID D-031 tersedia saat dicatat (tanpa bentrokan).

### D-032 — Sistem Audio, Musik, dan Efek Suara *(APPROVED / LOCKED, 2026-11-17, Tahap 22)*
Pilihan: **D. Kombinasi Semua Sistem.** Ruang lingkup:
1. Musik adaptif berdasarkan wilayah dan aktivitas
2. Musik pertanian, desa, dungeon, dan pertempuran
3. Musik orkestra untuk cerita dan boss
4. Efek suara lingkungan, cuaca, dan musim
5. Suara aktivitas NPC, hewan, dan monster
6. Efek senjata, skill, sihir, dan crafting
7. Audio fenomena spiritual dan event dunia
8. Pengaturan volume musik, efek suara, dan ambience secara terpisah

Ketentuan:
- Musik berubah sesuai lokasi, aktivitas, dan situasi permainan.
- Transisi musik halus dan tidak mengganggu gameplay.
- Efek lingkungan mengikuti cuaca, musim, dan wilayah.
- Tiap aktivitas gameplay punya identitas suara berbeda.
- Boss dan event besar punya audio khusus.
- Pemain mengatur volume musik, efek suara, dan ambience secara terpisah.

Hubungan (tidak mengubah isi keputusan lain): wilayah dan eksplorasi (**D-009**, **D-028**), pertarungan dan dungeon (**D-013**, **D-016**), NPC (**D-022**), pertanian/peternakan/memancing/memasak (**D-023 sampai D-026**), event dunia (**D-029**), musim dan cuaca (**D-030**; "tampilan audio tiap musim/cuaca" yang terbuka di sana kini ditangani di sini), UI/pengaturan (**D-031**), dan monster/companion (**D-019**).
**Terbuka:** gaya dan genre musik tiap wilayah, daftar lagu dan aturan transisi, sumber dan lisensi aset audio, suara pengisi (voice) dan bahasanya, arti audio "fenomena spiritual" (konsep spiritual belum didefinisikan, tidak ditebak), format dan ukuran aset, batas ukuran APK, perilaku saat aplikasi di latar belakang atau ada panggilan masuk, dukungan headphone/mono, subtitle/aksesibilitas audio. Implementasi audio belum dimulai. ID D-032 tersedia saat dicatat (tanpa bentrokan).

### D-033 — Sistem Kamera dan Kontrol Karakter *(APPROVED / LOCKED, 2026-11-17, Tahap 23)*
Pilihan: **D. Kamera Adaptif.** Ketentuan:
1. Kamera menyesuaikan konteks aktivitas pemain.
2. Saat farming dan eksplorasi: framing lebih luas agar area sekitar, lahan, objek, dan jalur terlihat jelas.
3. Saat interaksi dan combat: kamera boleh mendekat agar karakter dan aksi mudah diamati.
4. Tersedia pengaturan zoom dan rotasi kamera dengan batas terkontrol.
5. Peralihan kamera halus, konsisten, dan tidak membuat pemain kehilangan orientasi.
6. Prioritas: kenyamanan kontrol di Android landscape dan performa Godot 4.7.2 dengan GL Compatibility.
7. Tidak mengubah keputusan desain lain yang terkunci.

Hubungan (tidak mengubah isi keputusan lain): platform dan orientasi (**D-004**), gaya visual (**D-008**), pertarungan (**D-013**; penargetan/kamera saat bertarung yang terbuka di sana kini mengikuti keputusan ini), dungeon (**D-016**), pertanian (**D-023**), rumah/bangunan (**D-027**), eksplorasi (**D-028**), cuaca/waktu (**D-030**), UI dan kontrol sentuh (**D-031**), audio posisional (**D-032**).
**Terbuka:** sudut dan jarak kamera tiap konteks, rentang batas zoom dan rotasi, skema kontrol sentuh konkret untuk kamera (gestur/tombol/stik), penargetan dan lock-on saat combat, perilaku kamera di dalam bangunan/dungeon sempit, penanganan tabrakan kamera dengan objek, mode kamera rumah/dekorasi, aksesibilitas (mis. kurangi guncangan), efek guncangan/sinematik cerita dan boss, dukungan kontroler. Implementasi kamera belum dimulai. ID D-033 tersedia saat dicatat (tanpa bentrokan).

### D-034 — Metode Kontrol Karakter Android *(APPROVED / LOCKED, 2026-11-17, Tahap 24)*
Pilihan: **D. Kontrol Hybrid.** Ketentuan:
1. Virtual joystick sebagai kontrol gerakan utama.
2. Tombol aksi kontekstual yang menyesuaikan aktivitas (farming, interaksi, eksplorasi, combat).
3. Opsi tap-to-move untuk aktivitas atau situasi yang sesuai.
4. Ketiga metode tidak saling mengganggu.
5. Tata letak nyaman di Android landscape dan mendukung berbagai ukuran layar.
6. Pengaturan ukuran, posisi, dan sensitivitas kontrol jika memungkinkan.
7. Terintegrasi dengan Kamera Adaptif (D-033).
8. Mempertimbangkan performa Godot 4.7.2 dan GL Compatibility.

Hubungan (tidak mengubah isi keputusan lain): platform dan orientasi (**D-004**), pertarungan (**D-013**; kontrol sentuh untuk aksi combat yang terbuka di sana kini mengikuti keputusan ini), pertanian (**D-023**), eksplorasi (**D-028**), UI dan pengaturan tombol (**D-031**), kamera (**D-033**).
**Terbuka:** jumlah, jenis, dan ikon tombol aksi tiap konteks; daftar situasi tap-to-move dan cara beralih/mengaktifkannya; jenis joystick (tetap/mengambang); cara mengontrol kamera bersama joystick (gestur/stik/tombol); kontrol penargetan dan lock-on; gestur tambahan; dukungan kontroler/keyboard; rentang sensitivitas; aksesibilitas (mode satu tangan, tahan vs ketuk); getaran (haptic). Implementasi kontrol belum dimulai. ID D-034 tersedia saat dicatat (tanpa bentrokan).

### D-035 — Sistem Interaksi dengan Dunia dan Objek *(APPROVED / LOCKED, 2026-11-17, Tahap 25)*
Pilihan: **D. Interaksi Hybrid.** Ketentuan:
1. Tiga metode interaksi: **proximity** (jarak karakter ke objek/NPC), **direct tap** (ketuk objek/target langsung), dan **tombol aksi kontekstual** (muncul sesuai objek, aktivitas, dan kondisi pemain).
2. Sistem mengenali konteks objek: tanaman, hewan, NPC, fasilitas, item di tanah, peti, pintu, objek dungeon.
3. Hanya aksi yang valid untuk objek dan kondisi pemain saat itu yang ditampilkan.
4. Hindari interaksi ganda atau konflik input saat beberapa objek berdekatan.
5. Target yang dipilih pemain diprioritaskan saat objek saling berdekatan.
6. Terintegrasi dengan Kontrol Hybrid (D-034) dan Kamera Adaptif (D-033).
7. UI nyaman di Android landscape dan mendukung lokalisasi Indonesia dan English.
8. Tidak semua interaksi otomatis; pemain tetap memegang kendali jelas atas tindakan penting.

Hubungan (tidak mengubah isi keputusan lain): bahasa (**D-007**), pertarungan (**D-013**), dungeon (**D-016**), NPC (**D-022**), pertanian/peternakan (**D-023**, **D-024**), bangunan/peti/rumah (**D-027**), eksplorasi (**D-028**), UI (**D-031**), audio (**D-032**), kamera (**D-033**), kontrol (**D-034**).
**Terbuka:** daftar lengkap jenis objek dan aksinya, jarak/radius interaksi, aturan prioritas rinci saat objek berdekatan, definisi "tindakan penting" yang butuh konfirmasi, tampilan penanda target dan petunjuk aksi, durasi tahan/animasi interaksi, interaksi saat combat, interaksi dengan banyak item di tanah (mis. ambil semua), aksesibilitas (target sentuh lebih besar), dukungan kontroler. Implementasi interaksi belum dimulai. ID D-035 tersedia saat dicatat (tanpa bentrokan).

### D-036 — Sistem Inventory dan Pengelolaan Item *(APPROVED / LOCKED, 2026-11-17, Tahap 26)*
Pilihan: **D. Inventory Hybrid Lengkap.** Ketentuan:
1. Tampilan inventory berbasis **slot grid**.
2. Item dikelompokkan per kategori, minimal: farming dan benih; hasil panen dan produk ternak; ikan dan hasil perairan; material dan bahan tambang; material monster dan dungeon; makanan dan ramuan; senjata dan armor; equipment dan aksesori; quest dan item khusus.
3. Tersedia pencarian, penyortiran, filter, dan akses cepat.
4. Kapasitas atau berat barang dengan aturan jelas dan mudah dipahami.
5. Kapasitas dapat ditingkatkan lewat tas, equipment, atau perkembangan karakter.
6. Ditentukan: perilaku stack, batas jumlah per slot, item unik, item yang tidak dapat ditumpuk, dan penanganan inventory penuh.
7. Pemain dapat memindahkan, menggunakan, menyimpan, dan mengambil item dengan kontrol sentuh yang nyaman.
8. Terintegrasi dengan farming, fishing, livestock, crafting, alchemy, dungeon, equipment, dan ekonomi.
9. UI mendukung Android landscape, Indonesia dan English.
10. Kapasitas tidak terlalu ketat sehingga tidak mengganggu alur permainan.

Hubungan (tidak mengubah isi keputusan lain): bahasa (**D-007**), pertarungan/loot (**D-013**, **D-016**), perkembangan karakter (**D-018**), equipment dan crafting (**D-020**), ekonomi (**D-021**), pertanian/peternakan/memancing/memasak (**D-023 sampai D-026**), rumah dan penyimpanan (**D-027**), UI (**D-031**), kontrol (**D-034**), interaksi (**D-035**).
**Terbuka:** memilih kapasitas berbasis slot, berat, atau gabungan; jumlah slot awal dan tingkat peningkatan; batas stack tiap kategori; daftar item unik/tak bisa ditumpuk; perilaku saat inventory penuh (tolak, jatuh ke tanah, kirim ke penyimpanan); jumlah slot akses cepat; aturan peti/penyimpanan rumah dan hubungannya dengan inventory; apakah kualitas/atribut item memisahkan stack; aturan item quest (tak bisa dijual/dibuang); drag-and-drop vs ketuk, ambil/pindah banyak sekaligus; aksesibilitas. Implementasi inventory belum dimulai. ID D-036 tersedia saat dicatat (tanpa bentrokan).

### D-037 — Sistem Quest dan Misi *(APPROVED / LOCKED, 2026-11-17, Tahap 27)*
Pilihan: **D. Quest Hybrid Lengkap.** Ketentuan:
1. Mendukung jenis quest: Main Story; Side; Branching; Daily dan Repeatable; Adventurer Guild; Farming dan Village Life; Trading dan Economy; Dungeon dan Monster Hunt; Hidden dan Special.
2. Quest bercabang punya beberapa pilihan, kondisi, konsekuensi, dan hasil penyelesaian.
3. Tindakan dan keputusan pemain dapat memengaruhi hasil quest, hubungan NPC, akses wilayah, hadiah, atau perkembangan cerita sesuai kebutuhan naratif.
4. Tiap quest punya identitas unik, pemberi quest, persyaratan, objektif, status, hadiah, dan aturan penyelesaian.
5. Objektif bertahap dan beberapa objektif sekaligus.
6. Quest journal, pelacakan objektif aktif, indikator lokasi, notifikasi, dan riwayat quest.
7. Quest harian/berulang mengikuti kalender dan waktu dunia game secara konsisten.
8. Quest Guild terintegrasi dengan rank dan reputasi Guild.
9. Quest dapat disimpan dan disinkronkan lewat cloud save Supabase.
10. UI nyaman di Android landscape; Indonesia dan English.
11. Hindari quest yang saling bertentangan atau tak dapat diselesaikan akibat urutan progres yang keliru.

Hubungan (tidak mengubah isi keputusan lain): bahasa (**D-007**), cerita dan dunia (**D-009**), pertarungan dan dungeon (**D-013**, **D-016**), guild (**D-017**), perkembangan karakter (**D-018**), ekonomi (**D-021**), NPC dan hubungan (**D-022**), pertanian dan kehidupan desa (**D-023**, **D-015**), eksplorasi dan akses wilayah (**D-009**, **D-028**), event dunia (**D-029**), kalender (**D-030**), UI (**D-031**), inventory/item quest (**D-036**), online dan cloud save (**D-014**, **O-003**).
**Terbuka:** isi cerita utama dan daftar quest; format data quest dan bahasa kondisi/objektif; daftar tipe objektif dan pemicu; aturan pembukaan, prasyarat, dan pembatalan/gagal; aturan quest harian/berulang (reset, jumlah, penolakan); sistem pilihan dan konsekuensi (cabang permanen atau tidak); cara memberi hadiah dan batas; hubungan dengan rank/reputasi Guild secara rinci; cara menjamin quest tak buntu (mis. perbaikan otomatis); quest antarmusim/event; dukungan melewatkan/melanjutkan quest ketika waktu perangkat diubah; konsep "spiritual" bila dipakai di quest (belum didefinisikan, tidak ditebak). Implementasi quest belum dimulai. ID D-037 tersedia saat dicatat (tanpa bentrokan).

### D-038 — Sistem Dialog dan Percakapan NPC *(APPROVED / LOCKED, 2026-11-17, Tahap 28)*
Pilihan: **D. Dialog Hybrid Lengkap.** Ketentuan:
1. Dialog mendukung: cerita utama dan side quest; percakapan sehari-hari; pilihan jawaban pemain; dialog bercabang dengan beberapa hasil; dialog berdasarkan hubungan, kepercayaan, dan reputasi; dialog dinamis berdasarkan waktu, lokasi, musim, cuaca, event, dan perkembangan dunia; dialog khusus Guild, dungeon, perdagangan, dan kehidupan desa.
2. NPC punya identitas, kepribadian, konteks sosial, dan aturan respons yang konsisten.
3. Pilihan pemain dapat memengaruhi hubungan NPC, akses quest, informasi, dan hasil cerita jika relevan.
4. Mendukung percakapan berurutan, kondisi pembuka, pilihan terkunci, dan konsekuensi.
5. UI dialog mudah dibaca dan nyaman di Android landscape.
6. Wajib Indonesia (utama) dan English (kedua); teks bahasa tidak ditanam ke dalam aset visual.
7. Terintegrasi dengan sistem NPC, quest (D-037), hubungan sosial, kalender, dan cloud save Supabase.
8. Hindari dialog berulang yang tidak sesuai keadaan atau progres NPC.

Hubungan (tidak mengubah isi keputusan lain): bahasa (**D-007**), guild (**D-017**), ekonomi/perdagangan (**D-021**), NPC dan hubungan sosial (**D-022**), pertanian/kehidupan desa (**D-015**, **D-023**), event dunia (**D-029**), musim/cuaca/kalender (**D-030**), UI (**D-031**), audio (**D-032**), kamera (**D-033**), interaksi (**D-035**), quest (**D-037**), online dan cloud save (**D-014**, **O-003**).
**Terbuka:** daftar NPC dan penulisan dialog; format data dialog dan bahasa kondisi; tampilan UI (kotak teks, potret, kecepatan teks, lewati, riwayat percakapan); suara pengisi dan efek suara dialog; kamera saat percakapan; aturan prioritas bila beberapa dialog memenuhi syarat; batas jumlah pilihan; aturan pilihan terkunci (apakah alasan ditampilkan); cara menghindari pengulangan (penanda sudah dibicarakan, variasi); cakupan "reputasi" yang memengaruhi dialog; penanganan kata ganti/nama pemain di dua bahasa; aksesibilitas (ukuran teks); peran konsep "spiritual" (belum didefinisikan, tidak ditebak); romansa, pernikahan, keluarga (diperbarui oleh D-066: ditetapkan terpisah, detail belum final). Implementasi dialog belum dimulai. ID D-038 tersedia saat dicatat (tanpa bentrokan).

### D-039 — Sistem Hubungan Sosial dan Persahabatan *(APPROVED / LOCKED, 2026-11-17, Tahap 29)*
Pilihan: **D. Social System Hybrid Lengkap.** Ketentuan:
1. Sistem sosial menggabungkan: friendship tiap NPC; trust/kepercayaan; reputasi pemain pada komunitas, desa, kota, dan Guild; personal story dan perkembangan karakter NPC; friendship events dan interaksi khusus; konsekuensi tindakan pemain terhadap hubungan sosial.
2. Hubungan individu dibedakan dari reputasi komunitas; hubungan baik dengan satu NPC tidak otomatis menaikkan reputasi di semua komunitas.
3. Hubungan berkembang lewat percakapan, bantuan, quest, hadiah, tindakan pemain, dan event.
4. Tiap NPC boleh punya preferensi, batas kepercayaan, kepribadian, dan reaksi berbeda.
5. Perkembangan hubungan dapat membuka dialog, cerita pribadi, quest, bantuan, hadiah, dan akses interaksi khusus.
6. Reputasi komunitas dapat memengaruhi akses layanan, respons NPC, dan kesempatan tertentu.
7. Indikator hubungan mudah dipahami tanpa menjadikan semua interaksi sekadar mengejar angka.
8. Terintegrasi dengan jadwal harian NPC, dialog (D-038), quest (D-037), event dunia, dan cloud save Supabase.
9. UI mendukung Android landscape, Indonesia dan English.
10. Hindari hubungan yang naik tidak masuk akal atau konsekuensi yang tidak konsisten.

Hubungan (tidak mengubah isi keputusan lain): bahasa (**D-007**), kehidupan (**D-015**), guild dan rank/reputasi (**D-017**), ekonomi (**D-021**), NPC dan hubungan (**D-022**; cakupan hubungan yang di sana hanya pertemanan/kepercayaan tetap berlaku), event dunia (**D-029**), UI (**D-031**), interaksi (**D-035**), quest (**D-037**), dialog (**D-038**), online dan cloud save (**D-014**, **O-003**).
**Terbuka:** skala dan tingkat friendship/trust (angka atau tahap) dan nama tingkatnya; daftar komunitas/tingkat reputasi (desa, kota, Guild, lainnya) dan ambangnya; rumus dan batas kenaikan/penurunan harian; preferensi hadiah dan cara menyampaikannya; aturan peluruhan atau pemulihan hubungan; cara memperbaiki hubungan setelah konsekuensi buruk; daftar friendship event dan pemicunya; bentuk indikator UI; bagaimana tindakan terlihat oleh NPC/komunitas (saksi, gosip); hubungan dengan rank dan reputasi Guild secara rinci; peran konsep "spiritual" (belum didefinisikan). **Romansa, pernikahan, keluarga, dan anak: diperbarui oleh D-066** (ditetapkan terpisah; detail belum final); isi D-039 sendiri tidak diubah dan friendship D-039 tidak otomatis mencakupnya. Implementasi sosial belum dimulai. ID D-039 tersedia saat dicatat (tanpa bentrokan).

### D-040 — Sistem NPC dan Kehidupan Desa *(APPROVED / LOCKED, 2026-11-17, Tahap 30)*
Pilihan: **D. NPC Living World Hybrid.** Ketentuan:
1. Sistem kehidupan NPC menggabungkan: jadwal harian dan rutinitas; AI perilaku dan pengambilan keputusan; kebutuhan dan kondisi individu; pekerjaan dan aktivitas ekonomi; interaksi sosial antar-NPC; respons terhadap event dan perubahan dunia; perkembangan kehidupan desa.
2. NPC punya identitas, pekerjaan, lokasi aktivitas, jadwal, kepribadian, dan preferensi yang konsisten.
3. Aktivitas: bekerja, berdagang, bertani, memasak, berjalan, beristirahat, bersosialisasi, menghadiri event.
4. Perilaku mempertimbangkan waktu, musim, cuaca, lokasi, kondisi, dan progres dunia.
5. AI efisien untuk Android: NPC dekat pemain disimulasikan lebih detail; NPC jauh memakai simulasi ringan atau pembaruan berbasis waktu; tanpa kalkulasi AI berat tiap frame.
6. Navigasi dan penanganan kondisi terjebak agar NPC tidak mengulang jalur yang gagal.
7. Perubahan jadwal/aktivitas punya fallback bila lokasi atau jalur tidak tersedia.
8. Terintegrasi dengan sosial (D-039), dialog (D-038), quest (D-037), kalender, cuaca, event dunia, dan cloud save.
9. Perilaku tetap konsisten saat pemain berpindah wilayah atau memuat ulang permainan.
10. UI dan konten mendukung Indonesia dan English.

Hubungan (tidak mengubah isi keputusan lain): bahasa (**D-007**), dunia dan wilayah (**D-009**), kehidupan (**D-015**), guild (**D-017**), ekonomi (**D-021**), NPC dan kehidupan sosial (**D-022**; keputusan ini memperdalam simulasi NPC di sana), pertanian/peternakan/memasak (**D-023**, **D-024**, **D-026**), bangunan dan desa (**D-027**), eksplorasi (**D-028**), event dunia (**D-029**), musim/cuaca (**D-030**), audio (**D-032**), interaksi (**D-035**), quest (**D-037**), dialog (**D-038**), sosial (**D-039**), online dan cloud save (**D-014**, **O-003**).
**Terbuka:** daftar NPC dan perannya; jenis dan jumlah kebutuhan NPC (apakah ada, seberapa rinci); model keputusan AI (mis. jadwal + utilitas ringan); jarak/tingkat LOD simulasi dan jumlah NPC aktif maksimum; aturan interaksi sosial antar-NPC (dampak ke pemain); aktivitas ekonomi NPC (dampak ke harga/pasokan); bentuk "perkembangan desa" dan pemicunya; aturan fallback dan penanganan terjebak secara rinci; perilaku NPC saat pertarungan/bencana; peran konsep "spiritual" (belum didefinisikan). **Romansa, pernikahan, keluarga, dan anak: diperbarui oleh D-066; ditetapkan terpisah, detail belum final.** Implementasi AI NPC belum dimulai. ID D-040 tersedia saat dicatat (tanpa bentrokan).

### D-041 — Sistem Kustomisasi Karakter Pemain *(APPROVED / LOCKED, 2026-11-17, Tahap 31)*
Pilihan: **D. Character Customization Hybrid Lengkap.** Ketentuan:
1. Kustomisasi identitas visual: wajah, rambut, warna rambut, dan elemen penampilan lain yang didukung model karakter.
2. Koleksi pakaian per aktivitas: sehari-hari, petani, petualang, dan kostum khusus.
3. Equipment visual: armor, senjata yang terlihat pada karakter, aksesori, perlengkapan khusus.
4. Penampilan dibuka lewat quest, dungeon, event, eksplorasi, pencapaian, dan progres permainan.
5. Fungsi equipment dipisahkan dari cosmetic appearance jika perlu, sehingga pemain memilih tampilan tanpa kehilangan atribut equipment.
6. Pergantian pakaian dan perlengkapan konsisten pada model 3D dan animasi.
7. UI character creator dan wardrobe nyaman di Android landscape.
8. Terintegrasi dengan inventory (D-036), equipment/crafting, progression karakter, quest, event, dan cloud save Supabase.
9. Semua pilihan penampilan mendukung lokalisasi Indonesia dan English; tidak ada teks pada aset visual.
10. Variasi mesh, material, dan aksesori dijaga agar performa Android terjaga.

Hubungan (tidak mengubah isi keputusan lain): bahasa (**D-007**), gaya visual (**D-008**), pertarungan dan senjata (**D-013**), perkembangan karakter (**D-018**), companion (**D-019**), equipment dan crafting (**D-020**), ekonomi/toko (**D-021**), event dunia (**D-029**), UI (**D-031**), kamera (**D-033**), inventory (**D-036**), quest (**D-037**), online dan cloud save (**D-014**, **O-003**).
**Terbuka:** apakah ada pilihan jenis kelamin/tubuh dan bagaimana dinyatakan; daftar opsi wajah, rambut, warna, dan elemen lain; slot kosmetik (kepala, badan, kaki, punggung, dll.) dan aksesori; daftar set pakaian dan sumber pembukaan tiap item; apakah penampilan dapat dibeli, dibuat, atau hanya dibuka; aturan override kosmetik (per aktivitas, otomatis ganti baju); perlakuan senjata di punggung/pinggang saat tidak dipakai; mengganti penampilan setelah pembuatan karakter (kapan, biaya); batas variasi mesh/material/tekstur dan anggaran performa; apakah NPC/companion memakai sistem yang sama; foto/mode tampil; aksesibilitas; peran konsep "spiritual" (belum didefinisikan). Implementasi creator dan wardrobe belum dimulai. ID D-041 tersedia saat dicatat (tanpa bentrokan).

### D-042 — Sistem Mount dan Kendaraan *(APPROVED / LOCKED, 2026-11-17, Tahap 32)*
Pilihan: **D. Mount System Hybrid Lengkap.** Ketentuan:
1. Transportasi mencakup: hewan tunggangan biasa (mis. kuda); monster mount hasil taming; kendaraan darat (kereta, alat transportasi khusus); transportasi air (perahu); mount langka dan spiritual dengan kemampuan khusus.
2. Tiap mount/kendaraan punya karakteristik: kecepatan, stamina atau energi bila relevan, kemampuan, kapasitas, batas medan.
3. Mount dapat punya atribut, level, ikatan dengan pemain, dan kemampuan yang berkembang sesuai jenisnya.
4. Monster mount terintegrasi dengan monster taming dan companion.
5. Kendaraan dan mount mengikuti aturan akses wilayah, medan, dungeon, dan progres permainan.
6. Pemain dapat memanggil, menaiki, menurunkan, dan mengganti mount dengan kontrol sentuh nyaman.
7. Memperhatikan navigasi, animasi, collision, dan kamera adaptif (D-033) saat memakai mount.
8. Terintegrasi dengan inventory (D-036), eksplorasi dunia, progression karakter, quest, dan cloud save Supabase.
9. Tidak semua kendaraan dapat dipakai di semua medan; tiap transportasi punya fungsi yang masuk akal.
10. UI mendukung Android landscape, Indonesia dan English.

Hubungan (tidak mengubah isi keputusan lain): bahasa (**D-007**), dunia dan wilayah (**D-009**), pertarungan (**D-013**), dungeon (**D-016**), perkembangan karakter (**D-018**), companion dan monster taming (**D-019**), peternakan (**D-024**), memancing dan air (**D-025**), bangunan (**D-027**), eksplorasi dan perjalanan (**D-028**), UI (**D-031**), audio (**D-032**), kamera (**D-033**), kontrol (**D-034**), interaksi (**D-035**), inventory (**D-036**), quest (**D-037**), kustomisasi (**D-041**), online dan cloud save (**D-014**, **O-003**).
**Terbuka:** daftar jenis mount/kendaraan dan angkanya; cara memperoleh (beli, taming, quest, crafting); aturan stamina/energi dan perawatan; aturan medan (mis. darat, air, hutan, gunung, dungeon) dan larangannya; aturan pemanggilan (tempat, cooldown, biaya); kapasitas muatan dan hubungan dengan inventory; apakah mount dapat bertarung atau dipakai saat combat; penyimpanan mount (kandang/istal) dan hubungan dengan peternakan; kemampuan mount spiritual dan arti "spiritual" (belum didefinisikan, tidak ditebak); apakah ada mount kustomisasi tampilan; aturan saat mount terluka/mati; perjalanan cepat dan hubungannya. Implementasi mount belum dimulai. ID D-042 tersedia saat dicatat (tanpa bentrokan).

### D-043 — Sistem Tutorial dan Panduan Pemain *(APPROVED / LOCKED, 2026-11-17, Tahap 33)*
Pilihan: **D. Tutorial Hybrid Adaptif.** Ketentuan:
1. Sistem tutorial menggabungkan: tutorial awal (pengenalan game dan kontrol dasar); contextual tutorial saat pemain pertama kali menemukan fitur/aktivitas; pembelajaran lewat NPC, quest, dan eksplorasi; panduan dan buku bantuan yang dapat dibuka kembali.
2. Tutorial muncul berdasarkan konteks dan progres pemain, bukan sekadar urutan waktu.
3. Pemain yang sudah paham tidak dipaksa mengulang tutorial yang sama.
4. Opsi melewati atau menutup panduan yang tidak diperlukan, kecuali instruksi penting yang harus dipahami untuk melanjutkan.
5. Tiap panduan menjelaskan tujuan, kontrol, langkah, dan hasil aktivitas dengan singkat dan mudah dipahami.
6. Mencakup farming, livestock, fishing, crafting, alchemy, combat, dungeon, taming, Guild, NPC, ekonomi, dan eksplorasi.
7. NPC dan quest dapat menjadi sarana belajar alami.
8. Status tutorial yang telah dilihat/diselesaikan disimpan agar tidak muncul berulang tanpa alasan.
9. Terintegrasi dengan quest (D-037), dialog (D-038), inventory (D-036), kontrol (D-034), dan cloud save Supabase.
10. UI nyaman di Android landscape; Indonesia dan English.

Hubungan (tidak mengubah isi keputusan lain): bahasa (**D-007**), pertarungan (**D-013**), dungeon (**D-016**), guild (**D-017**), companion/taming (**D-019**), crafting (**D-020**), ekonomi (**D-021**), NPC (**D-022**, **D-040**), pertanian/peternakan/memancing/memasak (**D-023 sampai D-026**), eksplorasi (**D-028**), UI (**D-031**), kamera (**D-033**), kontrol (**D-034**), interaksi (**D-035**), inventory (**D-036**), quest (**D-037**), dialog (**D-038**), online dan cloud save (**D-014**, **O-003**). Mount (**D-042**) dan kustomisasi (**D-041**) juga dapat memiliki panduan.
**Terbuka:** isi dan urutan tutorial awal (termasuk apakah ada karakter/cerita pembuka); daftar topik panduan dan pemicunya; bentuk tampilan (kotak petunjuk, sorotan UI, gambar/animasi, video pendek); daftar "instruksi penting yang wajib" dan cara menandainya; isi buku bantuan dan cara membukanya; cara mendeteksi pemain yang sudah paham (mis. sudah melakukan aksi); opsi menonaktifkan semua petunjuk di pengaturan; apakah ada tutorial ulang/reset; tutorial untuk kontroler/pengaturan tombol; aksesibilitas; peran konsep "spiritual" bila ada panduan (belum didefinisikan, tidak ditebak). Implementasi tutorial belum dimulai. ID D-043 tersedia saat dicatat (tanpa bentrokan).

### D-044 — Sistem Save, Load, dan Cloud Synchronization *(APPROVED / LOCKED, 2026-11-17, Tahap 34)*
Pilihan: **D. Cloud Save Hybrid Lengkap.** Ketentuan:
1. **Supabase** sebagai penyimpanan cloud utama (sesuai O-003 dan D-014).
2. Sistem menggabungkan: Automatic Save; Cloud Save; Local Cache; Cloud Synchronization; Data Recovery; Conflict Resolution.
3. Auto-save dipicu peristiwa penting: penyelesaian quest, perubahan inventory, perkembangan karakter, perubahan hubungan NPC, aktivitas farming, progres dungeon.
4. Mekanisme penyimpanan aman agar data penting tidak hilang saat aplikasi tertutup atau koneksi terputus.
5. Cache lokal mempercepat pemuatan dan mempertahankan perubahan sementara saat koneksi terganggu. Game tetap **online-only**; cache **bukan** mode offline penuh.
6. Sinkronisasi menangani perubahan lokal dan cloud secara konsisten.
7. Conflict resolution tidak sembarangan menimpa progres terbaru atau menggabungkan data yang tidak kompatibel.
8. Indikator status save dan sinkronisasi yang mudah dipahami pemain.
9. Validasi data, versioning save, retry dengan batas wajar, perlindungan terhadap duplikasi transaksi.
10. Data akun hanya dapat diakses pemiliknya lewat kebijakan keamanan Supabase yang benar.
11. Terintegrasi dengan semua sistem progres: quest, inventory, karakter, NPC, hubungan sosial, farming, mount, dunia.
12. UI mendukung Android landscape, Indonesia dan English.

Hubungan (tidak mengubah isi keputusan lain): **D-014** (internet wajib, Cloud Save; keputusan ini merinci cara kerjanya dan menjawab sebagian item terbuka D-014 tentang perilaku saat koneksi putus), **O-003** (Supabase), bahasa (**D-007**), UI (**D-031**), inventory (**D-036**), quest (**D-037**), sosial (**D-039**), NPC (**D-040**), mount (**D-042**), tutorial (**D-043**), serta seluruh sistem progres D-013 sampai D-043.
**Catatan konsistensi:** frasa "offline-first" di `BACKEND_DESIGN.md` (§5 dan diagram) dan `TECHNICAL_ARCHITECTURE.md` §8 berarti *tulis ke penyimpanan lokal dulu sebagai penyangga* dan bukan bermain offline; ketiga tempat itu diperjelas. Implementasi lokal saat ini (`SaveService`, 3 slot) adalah fondasi dan tetap berlaku sebagai cache lokal.
**Terbuka:** perilaku game bila koneksi putus berkepanjangan (jeda, mode terbatas, atau keluar ke menu) dan batas waktunya (kerangka koneksi di D-051; rincian tetap terbuka); metode login dan kebijakan multi-perangkat (sudah terbuka di D-014); jumlah slot save per akun (saat ini 3 lokal) dan apakah slot ikut cloud; aturan rinci resolusi konflik (pilihan pemain, penggabungan per bagian yang aman, atau pemenang otomatis dengan syarat); frekuensi dan ambang auto-save; batas ukuran payload dan retensi cadangan cloud; apa yang divalidasi server untuk ekonomi/rank (anti-curang); kebijakan hapus akun dan data; bentuk indikator UI; penanganan jam perangkat yang diubah; peran konsep "spiritual" (belum didefinisikan). Implementasi save/cloud belum dimulai (selain fondasi lokal yang sudah ada). ID D-044 tersedia saat dicatat (tanpa bentrokan).

### D-045 — Sistem Pengaturan dan Aksesibilitas *(APPROVED / LOCKED, 2026-11-17, Tahap 36)*
Pilihan: **D. Settings Hybrid Lengkap.** Ketentuan:
1. Kategori pengaturan: **Audio** (musik, efek suara, ambience); **Graphics** (kualitas grafis, efek visual, opsi performa); **Camera** (sensitivitas, zoom, rotasi); **Controls** (ukuran, posisi, sensitivitas kontrol sentuh); **HUD** (tampilan dan elemen antarmuka); **Language** (Indonesia dan English); **Accessibility** (ukuran teks, kontras, kenyamanan visual); **Configuration Profiles** (penyimpanan konfigurasi pilihan pemain).
2. Pilihan kualitas grafis sesuai kemampuan perangkat Android.
3. Pengaturan kontrol mendukung virtual joystick, tombol aksi kontekstual, dan tap-to-move.
4. Pengaturan kamera konsisten dengan Kamera Adaptif (D-033).
5. Pemain dapat menyesuaikan ukuran dan posisi elemen HUD tanpa merusak tata letak antarmuka.
6. Pengaturan bahasa memakai sistem localization; tidak ada teks bahasa pada aset gambar.
7. Pengaturan penting tersimpan dan dipulihkan saat game dibuka kembali.
8. Pengaturan lokal perangkat dipisah dari data progres cloud jika secara teknis lebih tepat.
9. Opsi reset ke pengaturan default.
10. Prioritas: kemudahan di Android landscape dan performa Godot 4.7.2 GL Compatibility.

Hubungan (tidak mengubah isi keputusan lain): platform dan performa (**D-004**, **T-001** sampai **T-009** dan **O-001** untuk engine), bahasa (**D-007**), gaya visual (**D-008**), UI dan tata letak tombol (**D-031**), volume audio (**D-032**), kamera (**D-033**), kontrol (**D-034**), tutorial/petunjuk (**D-043**), save dan sinkronisasi (**D-044**; pengaturan UI sudah dicatat di sana sebagai jalur terpisah dari progres), online (**D-014**).
**Terbuka:** daftar opsi grafis rinci dan tingkat kualitas (mis. Rendah/Sedang/Tinggi/Auto) serta batas FPS; cara mendeteksi tingkat perangkat; isi Accessibility rinci (skala teks, kontras tinggi, bantuan buta warna, kurangi guncangan kamera, getaran, subtitle/audio, mode satu tangan); jumlah dan nama profil konfigurasi; pengaturan mana yang ikut cloud (per akun) dan mana khusus perangkat (tata letak HUD/kontrol bergantung ukuran layar sehingga bisa per perangkat); dukungan kontroler/keyboard; pengaturan notifikasi/baterai/penghemat data; tata letak layar Pengaturan; apakah pengaturan dapat diubah saat bermain atau hanya lewat menu jeda; konsep "spiritual" (belum didefinisikan). Implementasi pengaturan belum dimulai. ID D-045 tersedia saat dicatat (tanpa bentrokan).

**Catatan status (instruksi pemilik):** Tahap 35 "Sistem Akun dan Login Pemain" berstatus **PENDING** dan baru dibahas saat persiapan publikasi Google Play Store (dicatat sebagai **P-006**). Tidak ada keputusan akun/login yang dibuat di sini; metode login tetap terbuka (D-014). Nomor keputusan D-045 dipakai untuk Tahap 36; tidak ada ID yang dicadangkan untuk Tahap 35.

### D-046 — Sistem Achievement, Title, dan Koleksi *(APPROVED / LOCKED, 2026-11-17, Tahap 37)*
Pilihan: **D. Achievement Hybrid Lengkap.** Ketentuan:
1. Sistem penghargaan menggabungkan: Achievement; Character Title; Collection Book dan Encyclopedia; Milestone progression; Exclusive achievement rewards; Player Journey Record.
2. Achievement mencakup: farming dan hasil panen; livestock dan peternakan; fishing dan aquatic collection; crafting dan alchemy; combat dan dungeon; monster taming dan companion; Adventurer Guild dan rank; eksplorasi, penemuan rahasia, dan event; hubungan sosial dan kehidupan desa.
3. Title dibuka lewat pencapaian tertentu dan dapat dipasang pada profil atau karakter pemain.
4. Collection Book mencatat penemuan tanaman, ikan, hewan, monster, material, lokasi, dan objek penting lainnya.
5. Milestone mendukung perkembangan jangka pendek dan jangka panjang.
6. Hadiah achievement dapat berupa item, kosmetik, title, material langka, atau akses khusus sesuai desain hadiah.
7. Indikator progres, status terkunci/terbuka, detail persyaratan, dan riwayat penyelesaian.
8. Hindari achievement yang hanya mendorong pengulangan aktivitas berlebihan tanpa nilai permainan.
9. Terintegrasi dengan progression, quest, inventory, Guild, monster collection, eksplorasi, dan cloud save Supabase.
10. UI mendukung Android landscape, Indonesia, dan English.

Hubungan (tidak mengubah isi keputusan lain): bahasa (**D-007**), pertarungan dan dungeon (**D-013**, **D-016**), guild (**D-017**), perkembangan karakter (**D-018**), companion dan monster (**D-019**), crafting (**D-020**), ekonomi (**D-021**), NPC dan sosial (**D-022**, **D-039**, **D-040**), pertanian/peternakan/memancing/memasak (**D-023 sampai D-026**), eksplorasi (**D-028**), event dunia (**D-029**), UI (**D-031**), audio (**D-032**), inventory (**D-036**), quest (**D-037**), kustomisasi dan kosmetik (**D-041**), mount (**D-042**), tutorial (**D-043**), save dan cloud (**D-044**), pengaturan (**D-045**), online (**D-014**).
**Terbuka:** daftar achievement, title, dan entri koleksi; kategori, tingkat (mis. perunggu/perak/emas), dan poin bila ada; apakah ada achievement tersembunyi dan cara menampilkannya; aturan pencegahan pengulangan tanpa nilai (ambang bermakna, tanpa "grinding" murni); hadiah rinci dan keseimbangannya (terutama "akses khusus" dan material langka); apakah penemuan di Collection Book memberi bonus (mis. penyelesaian set); bentuk Player Journey Record (linimasa, statistik, album); profil pemain dan tempat title ditampilkan; hubungan dengan platform pihak ketiga (mis. Google Play Games) — tidak diputuskan; achievement yang dapat dilewatkan permanen atau tidak (anti-buntu); tampilan notifikasi; peran konsep "spiritual" (belum didefinisikan). Implementasi belum dimulai. ID D-046 tersedia saat dicatat (tanpa bentrokan). Tahap 35 (akun dan login, P-006) tetap PENDING.

### D-047 — Sistem Monetisasi dan Transaksi Dalam Game *(APPROVED / LOCKED, 2026-11-17, Tahap 38)*
Pilihan: **A. Cosmetic Only.** Ketentuan:
1. Monetisasi **hanya** untuk konten kosmetik: kostum dan pakaian karakter; skin dan variasi penampilan; dekorasi rumah dan lahan pertanian; aksesori karakter; tampilan visual mount dan perlengkapan.
2. **Tidak dijual:** kekuatan/statistik karakter; keunggulan combat atau dungeon; level dan progression; material wajib untuk crafting atau quest; item yang memberi keuntungan gameplay kompetitif.
3. Semua konten gameplay utama tetap dapat diperoleh lewat permainan tanpa pembelian.
4. Pemain yang tidak membeli tetap menikmati seluruh progres gameplay secara adil.
5. Kosmetik berbayar tidak memberi bonus statistik tersembunyi.
6. Data kosmetik yang dimiliki dipisah dari equipment yang menentukan atribut gameplay.
7. Katalog kosmetik dengan informasi item dan status kepemilikan yang jelas.
8. Kosmetik dapat diperoleh lewat pembelian maupun hadiah gameplay bila sesuai kebijakan desain.
9. **Tidak ada premium currency dan tidak ada season pass** dalam keputusan ini.
10. Sistem transaksi mengikuti kebijakan platform distribusi yang diputuskan saat persiapan publikasi.
11. **Tahap 35 (Sistem Akun dan Login) tetap PENDING** sampai persiapan Google Play Store (P-006); implementasinya tidak dipaksakan.

Hubungan (tidak mengubah isi keputusan lain): gaya visual (**D-008**), pertarungan (**D-013**), dungeon (**D-016**), perkembangan karakter (**D-018**), equipment dan crafting (**D-020**), ekonomi (**D-021**; mata uang dalam game tidak diubah), rumah, lahan, dan bangunan (**D-027**), UI (**D-031**), inventory (**D-036**), quest (**D-037**), kustomisasi (**D-041**; pernyataan di sana bahwa cara memperoleh kosmetik "belum diputuskan" kini sebagian dijawab: pembelian dan hadiah gameplay, sesuai ketentuan ini), mount (**D-042**), save dan cloud (**D-044**), pengaturan (**D-045**), achievement dan hadiah (**D-046**), online (**D-014**). Butir "Monetisasi (belum disebut; default: tidak ada)" di daftar usulan GDD kini terjawab oleh keputusan ini.
**Terbuka:** daftar dan harga kosmetik; metode pembayaran dan platform (diputuskan saat persiapan publikasi; kebijakan Google Play Billing, pajak, wilayah, harga regional, pengembalian dana, batas usia/orang tua); apakah ada pembelian langsung per item atau paket kosmetik (tanpa premium currency dan season pass sesuai ketentuan 9); aturan dekorasi (harus murni visual tanpa fungsi gameplay; garis batas dengan bangunan fungsional D-027); kosmetik hadiah vs berbayar (eksklusivitas waktu, bila ada, tidak boleh mengganggu keadilan); apakah kosmetik berbayar dapat diperoleh lewat gameplay belakangan; kosmetik yang terikat akun, pemulihan pembelian (restore) di perangkat baru; kebijakan iklan (tidak disebut; **tidak ada** hingga diputuskan); privasi dan persetujuan; peran konsep "spiritual" (belum didefinisikan). Implementasi toko/transaksi belum dimulai. ID D-047 tersedia saat dicatat (tanpa bentrokan).

### D-048 — Sistem Update Konten dan Live Operations *(APPROVED / LOCKED, 2026-11-17, Tahap 39)*
Pilihan: **D. Live Operations Hybrid Lengkap.** Ketentuan:
1. Pengembangan konten jangka panjang mencakup: Regular Game Updates; New Content Updates; World Events dan Live Events; New Region dan World Expansion; Dungeon, Boss, dan Monster Expansion; Quest dan Story Expansion; Balancing dan Performance Optimization; Bug Fixes dan Quality Improvements.
2. Update dapat menambah tanaman, hewan, ikan, item, equipment, NPC, fasilitas, lokasi, dungeon, monster, dan aktivitas baru.
3. Event dunia terintegrasi dengan kalender, musim, cuaca, NPC, ekonomi, dan quest.
4. Konten baru dapat ditambahkan tanpa merusak progres pemain yang sudah ada.
5. Memperhatikan kompatibilitas save schema, migrasi data, dan sinkronisasi cloud Supabase saat struktur data berubah.
6. Mekanisme versioning dan pemeriksaan kompatibilitas versi game.
7. Update mempertimbangkan koneksi internet, ukuran unduhan, kapasitas perangkat Android, dan performa Godot 4.7.2.
8. Event berbatas waktu punya aturan waktu yang konsisten dan tidak menyebabkan progres permanen hilang secara tidak adil.
9. Konten gameplay penting tidak bergantung pada pembelian kosmetik.
10. Proses deployment dan pengujian update agar perubahan tidak langsung merusak versi produksi.

Hubungan (tidak mengubah isi keputusan lain): dunia dan wilayah (**D-009**), pertarungan dan dungeon (**D-013**, **D-016**), guild (**D-017**), companion/monster (**D-019**), equipment dan crafting (**D-020**), ekonomi (**D-021**), NPC (**D-022**, **D-040**), pertanian sampai memasak (**D-023 sampai D-026**), bangunan (**D-027**), eksplorasi dan wilayah baru (**D-028**), event dunia (**D-029**; keputusan ini menambah event live di atasnya), musim dan cuaca (**D-030**), tutorial (**D-043**), save dan cloud (**D-044**), pengaturan (**D-045**), achievement (**D-046**), monetisasi (**D-047**; kosmetik saja), online (**D-014**), serta keputusan teknis build dan rilis (**O-001**, **O-002**, **O-004**, **T-001** sampai **T-009**).
**Terbuka:** frekuensi dan ritme rilis; saluran distribusi konten (hanya update APK/Play Store, atau juga konten data yang diunduh) dan kepatuhan kebijakan platform tentang pembaruan di luar toko; jenis konten yang boleh live tanpa update aplikasi (data/konfigurasi saja vs aset); batas ukuran unduhan dan penanganan jaringan lambat/seluler; kebijakan versi minimum yang didukung dan paksa-update; aturan event berbatas waktu rinci (zona waktu, penghitungan waktu server vs kalender game, klaim terlambat, event berulang, kompensasi); aturan balancing yang mengubah item/progres pemain (kompensasi); pemisahan lingkungan dev/staging/prod dan tahapan peluncuran bertahap (staged rollout, uji internal/tertutup); kebijakan rollback; pemantauan, laporan crash, dan analitik (privasi); komunikasi ke pemain (catatan rilis, pemberitahuan dalam game); jendela pemeliharaan; peran konsep "spiritual" (belum didefinisikan). Implementasi live operations dan konten tambahan belum dimulai. ID D-048 tersedia saat dicatat (tanpa bentrokan). Tahap 35 (akun dan login, P-006) tetap PENDING.

### D-049 — Sistem Quality Assurance dan Pengujian Game *(APPROVED / LOCKED, 2026-11-17, Tahap 40)*
Pilihan: **D. QA Hybrid Lengkap.** Ketentuan:
1. Standar QA menggabungkan: Manual Testing; Automated Testing; Performance Testing; Android Device Compatibility Testing; Integration Testing; Regression Testing.
2. Manual testing mencakup pengalaman bermain nyata, kontrol sentuh, UI, interaksi NPC, farming, combat, dungeon, dan aktivitas lain.
3. Automated testing memeriksa fungsi inti, validasi data, quest, inventory, progression, save/load, dan sistem yang dapat diuji otomatis.
4. Performance testing memantau FPS, RAM, CPU, suhu perangkat, waktu pemuatan, dan kestabilan aplikasi.
5. Compatibility testing mempertimbangkan ukuran layar, resolusi, kemampuan hardware, dan versi Android.
6. Integration testing memeriksa hubungan antarfitur agar perubahan satu sistem tidak merusak sistem lain.
7. Regression testing wajib untuk perubahan yang berpotensi memengaruhi fitur stabil.
8. Tersedia test case, hasil pengujian, tingkat keparahan bug, langkah reproduksi, dan status perbaikan.
9. **Release gate:** APK tidak dinyatakan siap rilis bila ada bug kritis atau pengujian penting yang belum selesai.
10. Pengujian APK di **perangkat fisik** dibedakan dari hasil emulator atau CI.
11. **Pengujian perangkat fisik tidak boleh diklaim berhasil tanpa bukti nyata dari pengguna atau tester.**
12. QA terintegrasi dengan pipeline GitHub Actions dan pembuatan APK.

Hubungan (tidak mengubah isi keputusan lain): engine dan platform (**O-001**, **D-004**, **T-001** sampai **T-009**), aturan bukti dan definisi "selesai" di `DEVELOPMENT_RULES.md` (keputusan ini memperkuat, tidak mengubahnya), rilis dan penandatanganan (**O-004**, `BUILD_AND_RELEASE.md`, `SIGNING_GUIDE.md`), uji APK dev di HP (**P-005**, `TESTING_APK.md`), semua sistem game yang diuji (**D-013 sampai D-048**), terutama save dan cloud (**D-044**), update dan migrasi (**D-048**), kontrol dan UI (**D-031**, **D-034**, **D-045**), monetisasi (**D-047**).
**Terbuka:** daftar perangkat uji fisik minimum dan matriks (kelas RAM/GPU, versi Android minimum yang didukung, rasio layar); siapa tester dan cara mengumpulkan laporan; target performa konkret (FPS, RAM, suhu, waktu muat) per kelas perangkat; definisi tingkat keparahan bug (kritis/tinggi/sedang/rendah) dan kriteria release gate rinci; alat pelacak bug dan test case (mis. GitHub Issues); cakupan otomatis yang wajib per sistem; cara menjalankan uji di emulator/perangkat dari CI (layanan farm perangkat atau tidak); pelaporan crash dan telemetri (privasi, akun P-006); kebijakan uji beta tertutup sebelum rilis publik; peran konsep "spiritual" (belum didefinisikan). Hasil uji perangkat fisik **P-005 tetap menunggu laporan pengguna** dan tidak dianggap lulus. Implementasi sistem QA lengkap belum dimulai (uji fondasi yang sudah ada di CI tidak diubah). ID D-049 tersedia saat dicatat (tanpa bentrokan). Tahap 35 (akun dan login, P-006) tetap PENDING.

### D-050 — Sistem Keamanan dan Perlindungan Data Pemain *(APPROVED / LOCKED, 2026-11-17, Tahap 41)*
Pilihan: **D. Security Hybrid Lengkap.** Ruang lingkup:
1. **Server-side validation** untuk aktivitas dan data penting pemain.
2. **Perlindungan database** dan data pemain.
3. **Anti-cheat** untuk mendeteksi manipulasi inventory, mata uang, atribut karakter, transaksi, dan progres.
4. **Audit log** untuk aktivitas penting.
5. **Security monitoring** untuk mendeteksi aktivitas mencurigakan.

Ketentuan penting:
- Keamanan adalah **fitur dasar untuk semua pemain**.
- **Tidak ada langganan bulanan atau biaya keamanan** yang dibayar pemain.
- **Biaya operasional server dan layanan database ditanggung pengelola game.**
- **Keputusan monetisasi kosmetik (D-047) tidak diubah.**
- Game tetap **single-player online** (D-014).

Hubungan (tidak mengubah isi keputusan lain): single-player online dan Cloud Save (**D-014**; tanpa multiplayer, kunjungan, co-op), Supabase (**O-003**), ekonomi (**D-021**), inventory (**D-036**), perkembangan karakter (**D-018**), quest (**D-037**), sosial (**D-039**), monetisasi kosmetik (**D-047**), save, konflik, dan idempotensi transaksi (**D-044**; keputusan ini menambah lapisan validasi/deteksi di atasnya), update dan migrasi (**D-048**), QA (**D-049**), pengaturan (**D-045**), achievement (**D-046**), serta aturan keamanan kredensial **O-004** (private keystore, rahasia di Secrets). Pernyataan lama bahwa checksum "bukan anti-curang" dan data klien tidak dipercaya untuk fitur ekonomi/rank (TECHNICAL_ARCHITECTURE §5, BACKEND_DESIGN §5) kini memiliki dasar keputusan.
**Terbuka:** seberapa jauh simulasi dijalankan atau divalidasi di server (validasi masuk akal/batas dan invarian vs. otoritas penuh sisi server untuk operasi tertentu) — karena game single-player online, kecurangan murni pribadi tidak merugikan pemain lain, sehingga tingkat penegakan terhadap pemain yang hanya mengubah progres pribadi belum diputuskan (fokus awal: melindungi akun, transaksi/pembelian, integritas save, dan data apa pun yang dibagikan lewat server); daftar data dan aksi yang wajib divalidasi server; aturan deteksi dan ambang (mis. lonjakan mata uang, item mustahil, atribut di luar rentang, kecepatan progres tak wajar); tindakan terhadap pelanggaran (peringatan, pembatasan fitur tertentu, pemulihan data, penangguhan) dan proses banding agar tidak merugikan pemain jujur (false positive); isi, retensi, dan akses audit log serta kepatuhan privasi (data pribadi minimum); alat monitoring dan peringatan, serta siapa yang menanggapi; anggaran operasional (batas paket layanan, biaya validasi dan log yang bertambah seiring pemain — tanggung jawab pengelola; belum dihitung); enkripsi data saat disimpan, kebijakan cadangan dan pemulihan bencana; kebijakan privasi, persetujuan, hak pemain atas data (akses, hapus), dan proteksi usia; hubungan dengan akun/login (**Tahap 35, P-006, tetap PENDING**; tidak ada desain akun dibuat di sini); pelaporan celah keamanan; peran konsep "spiritual" (belum didefinisikan). Implementasi keamanan belum dimulai. ID D-050 tersedia saat dicatat (tanpa bentrokan).

### D-051 — Sistem Ketahanan Koneksi (Connection Resilience) *(APPROVED / LOCKED, 2026-11-17, Tahap 42; isi diterima setelah Tahap 60)*
Pilihan: **Connection Resilience Hybrid Lengkap.** Cakupan:
1. **Automatic reconnect** (sambung ulang otomatis).
2. **Session recovery** (pemulihan sesi).
3. **Perlindungan data yang belum tersinkronisasi.**
4. **Penanganan server outage** (gangguan server).
5. **Safe retry dan idempotency.**
6. **Status koneksi dan sinkronisasi** yang terlihat pemain.
7. **Tidak ada full offline mode.**

Ketentuan:
- **Tidak bertentangan dengan D-014 (Single-Player Online) dan D-044 (Save, Load, Cloud Sync).** Cache lokal tetap hanya penyangga untuk melindungi data dan bukan mode permainan offline penuh.
- Tidak mengubah keputusan lain; penguncian desain; implementasi belum dimulai.

**Prinsip (dasar, tanpa angka):**
- Saat koneksi terputus, game berusaha **tersambung kembali secara otomatis** tanpa tindakan pemain dan tanpa merusak keadaan permainan.
- Setelah tersambung kembali atau aplikasi dibuka ulang, **sesi dipulihkan ke keadaan yang konsisten**. Cara identitas pemain dikenali bergantung pada sistem akun/login (Tahap 35, P-006, DEFERRED) dan tidak diasumsikan di sini.
- **Data yang belum tersinkron dilindungi:** perubahan yang belum terkirim tidak hilang karena putus koneksi, gangguan server, atau aplikasi tertutup; dikirim saat koneksi pulih dengan penyelesaian konflik berbasis revisi (D-044).
- **Gangguan server** ditangani dengan memberi tahu pemain, melindungi data lokal, dan mencoba lagi dengan aman; pemain tidak kehilangan progres.
- **Percobaan ulang aman dan idempoten:** operasi memakai ID transaksi sehingga pengulangan tidak menggandakan hadiah, biaya, atau perubahan (selaras D-044, D-050).
- **Status koneksi dan sinkronisasi terlihat dan mudah dipahami** (mis. tersambung, menyambung ulang, tersinkron, menunggu sinkron) dengan dukungan Indonesia/English dan aksesibilitas (D-031, D-045).
- **Tidak ada full offline mode.**
- Selaras dengan D-055: gangguan koneksi tidak memajukan atau memundurkan waktu permainan.

Hubungan (tidak mengubah isi keputusan lain): single-player online (**D-014**), save/cloud (**D-044**), pengaturan dan aksesibilitas (**D-045**), UI/HUD (**D-031**), update konten (**D-048**), QA (**D-049**), keamanan (**D-050**), performa (**D-052**), loading (**D-053**), waktu (**D-055**), tidur (**D-056**), kekalahan (**D-058**), release (**D-069**). D-052 sampai D-069 ditulis sebelum isi ini diterima; rujukan "menunggu D-051" pada dokumen terkait sudah disinkronkan.

**Terbuka (tidak diputuskan):** selang dan batas percobaan sambung ulang; masa tenggang; perilaku saat gangguan berkepanjangan (jeda, mode terbatas, atau keluar ke menu, terbuka juga di D-044); tindakan apa yang boleh dilakukan saat terputus; batas ukuran dan masa simpan data yang belum tersinkron; pesan dan tampilan status; kebijakan telemetri; kebutuhan identitas/sesi (bergantung Tahap 35, P-006); perilaku event dan konten saat offline/terputus (terbuka di D-029); arti "spiritual" (belum didefinisikan). Semua angka belum ditetapkan dan belum diukur.

### D-052 — Sistem Performa dan Optimasi Perangkat Android *(APPROVED / LOCKED, 2026-11-17, Tahap 43)*
Pilihan: **D. Adaptive Performance Hybrid Lengkap.** Ruang lingkup:
1. Optimasi CPU dan GPU.
2. RAM dan manajemen memori.
3. Kualitas grafis adaptif berdasarkan kemampuan perangkat.
4. Pemuatan aset dan manajemen resource.
5. Optimasi NPC, AI, animasi, dan simulasi dunia.
6. Konsumsi baterai dan kesadaran termal perangkat.
7. Frame pacing dan stabilitas FPS.
8. Penanganan perangkat Android dengan kemampuan berbeda.

Ketentuan:
- Platform tetap Android native, landscape-first, arm64, Godot 4.7.2 dengan GL Compatibility.
- Stabilitas gameplay tidak dikorbankan demi efek visual.
- Grafik adaptif mempertahankan keterbacaan UI dan identitas visual game.
- Selaras dengan keputusan kamera, NPC, dunia/wilayah, dan QA.
- **Tidak boleh mengklaim hasil performa atau pengujian perangkat fisik sebelum benar-benar dilakukan.**
- Ini penguncian desain, bukan instruksi memulai implementasi.

Hubungan (tidak mengubah isi keputusan lain): engine dan renderer (**O-001**, **D-004**, **T-001** sampai **T-009**), gaya visual (**D-008**), dunia, wilayah, dan eksplorasi (**D-009**, **D-028**), pertarungan dan dungeon (**D-013**, **D-016**), companion dan monster (**D-019**), pertanian dan peternakan (**D-023**, **D-024**), bangunan (**D-027**), event dunia dan cuaca (**D-029**, **D-030**), UI (**D-031**), audio (**D-032**), kamera (**D-033**), kontrol (**D-034**), NPC dan kehidupan desa (**D-022**, **D-040**), kustomisasi karakter (**D-041**), mount (**D-042**), save dan sinkronisasi (**D-044**), pengaturan dan profil grafis (**D-045**; keputusan ini mengisi dasar pemilihan profil), update konten (**D-048**), QA dan release gate (**D-049**), keamanan (**D-050**).
**Catatan penomoran:** pemilik menetapkan D-052 untuk Tahap 43. D-051 (Tahap 42) semula dicadangkan karena isinya belum diterima; **isinya kini diterima setelah Tahap 60 dan dicatat sebagai D-051 (Connection Resilience)**, ditempatkan berurutan sebelum D-052. Keputusan D-052 tidak diubah.
**Terbuka (semua angka dan ambang belum diukur):** target FPS (mis. 30/60) dan batas bawah per kelas perangkat; definisi kelas perangkat (rendah/menengah/tinggi) dan cara klasifikasi; daftar opsi grafis adaptif dan urutan penurunan kualitas; ambang suhu, baterai, dan pemicu penurunan kualitas; anggaran memori, draw call, poligon, dan ukuran tekstur nyata; ukuran unduhan dan APK maksimum; versi Android dan perangkat minimum yang didukung; mode hemat baterai; peran Vulkan/Mobile renderer bila GL Compatibility tidak cukup (ditinjau ulang, saat ini tidak diubah); kebijakan aset (kompresi, atlas, LOD) per kelas; peran konsep "spiritual" (belum didefinisikan). **Tidak ada hasil pengukuran atau pengujian perangkat fisik yang diklaim;** P-005 tetap menunggu laporan pengguna. Implementasi belum dimulai. ID D-052 tersedia saat dicatat (tanpa bentrokan). Tahap 35 (akun dan login, P-006) tetap PENDING.

### D-053 — Sistem Loading dan Transisi Antarwilayah *(APPROVED / LOCKED, 2026-11-17, Tahap 44)*
Pilihan: **D. Hybrid Loading & World Streaming.** Ruang lingkup:
1. Loading screen dengan ilustrasi, tips, dan indikator progres bila diperlukan.
2. Transisi mulus (seamless) antararea jika kondisi teknis memungkinkan.
3. Pemuatan asinkron untuk mengurangi jeda permainan.
4. Streaming dunia dinamis berdasarkan posisi dan kebutuhan pemain.
5. Manajemen aset/resource otomatis.
6. Pengelolaan memori dan pelepasan resource yang tidak lagi dipakai.
7. Integrasi dengan optimasi performa Android dan sistem eksplorasi dunia.

Ketentuan:
- Target tetap Godot 4.7.2, GDScript, GL Compatibility, Android native arm64, landscape-first.
- **Seamless tidak dipaksakan** bila menyebabkan stutter atau RAM berlebihan.
- Perpindahan **dungeon, interior, dan wilayah khusus** dapat memakai loading screen bila perlu.
- Selaras dengan D-028 (eksplorasi dunia), D-052 (performa adaptif), dan keputusan kamera (D-033).
- Penguncian desain; implementasi belum dimulai.

Hubungan (tidak mengubah isi keputusan lain): engine (**O-001**, **D-004**), gaya visual (**D-008**), dunia dan wilayah (**D-009**, **D-028**), dungeon (**D-016**), pertanian/bangunan dan interior rumah (**D-023**, **D-027**), event dunia (**D-029**), UI (**D-031**), audio (**D-032**), kamera (**D-033**), mount (**D-042**; aturan medan dan akses), NPC (**D-040**), tutorial dan tips (**D-043**), save (**D-044**), pengaturan (**D-045**), update konten (**D-048**), QA (**D-049**), keamanan (**D-050**), performa (**D-052**). Catatan: D-051 (Tahap 42, Connection Resilience) kini terisi (diterima setelah Tahap 60).
**Terbuka:** daftar jenis transisi (wilayah luar tanpa jeda, pintu masuk interior, dungeon, wilayah khusus, fast travel) mana yang seamless dan mana memakai loading screen; ukuran chunk, jarak muat/bongkar, dan jumlah chunk aktif (belum diukur); ambang waktu "diperlukan" untuk menampilkan loading screen; isi ilustrasi dan gaya loading (art direction), jumlah dan kategori tips, aturan pemilihan tips (kontekstual terhadap wilayah/progres, tidak bocor spoiler); indikator progres (persentase, bar, atau tanpa angka); apakah pemain dapat berinteraksi/melihat peta saat memuat; perilaku bila pemuatan gagal atau lambat (ulang, kembali ke titik aman); posisi dan keselamatan pemain selama transisi (invulnerabilitas sementara, penjagaan NPC/monster); apakah auto-save dipicu saat transisi (selaras D-044); peran konsep "spiritual" untuk wilayah khusus (belum didefinisikan, tidak ditebak). **Tidak ada klaim performa atau hasil pengujian perangkat fisik;** P-005 tetap menunggu laporan pengguna. Implementasi belum dimulai. ID D-053 tersedia saat dicatat (tanpa bentrokan). Tahap 35 (akun dan login, P-006) tetap PENDING.

### D-054 — Sistem Peta Dunia dan Navigasi *(APPROVED / LOCKED, 2026-11-17, Tahap 45)*
Pilihan: **D. World Map & Navigation Hybrid Lengkap.** Ruang lingkup:
1. Interactive World Map: zoom, pan, wilayah, lokasi, dan detail peta.
2. Minimap saat gameplay.
3. Compass dan directional guidance.
4. Quest markers dan objective markers.
5. Player location tracking.
6. Exploration discovery untuk lokasi dan wilayah tersembunyi.
7. Fast travel ke lokasi yang sudah terbuka dan memenuhi persyaratan progres.
8. Integrasi dengan quest, dungeon, guild, mount, world exploration, dan progressive region unlock.

Ketentuan:
- **Tidak membuka semua wilayah sejak awal.**
- **Fast travel mengikuti progres dan aturan dunia permainan.**
- Peta mudah dipakai di Android landscape dengan layar sentuh.
- UI mendukung Indonesia dan English.
- Selaras dengan D-028 (eksplorasi dunia), D-033 (kamera), dan D-053 (loading/transisi).
- Penguncian desain; implementasi belum dimulai.

Hubungan (tidak mengubah isi keputusan lain): Progressive World Unlock (**D-009**), dungeon (**D-016**), guild (**D-017**), companion/monster (**D-019**), event dunia (**D-029**), cuaca dan waktu (**D-030**), UI dan HUD (**D-031**; peta, minimap, dan kompas menjadi bagian HUD), audio (**D-032**), kamera (**D-033**), kontrol dan tap-to-move (**D-034**), interaksi (**D-035**), quest (**D-037**), NPC (**D-040**), mount dan medan (**D-042**), tutorial (**D-043**), save (**D-044**), pengaturan (**D-045**), achievement dan koleksi lokasi (**D-046**), performa (**D-052**), loading dan transisi (**D-053**; fast travel memakai transisi Loading). **D-028** sudah menetapkan "peta dunia, penanda lokasi, dan fast travel" dan fast travel "dibuka dengan aturan progres yang jelas"; keputusan ini merinci dan tidak mengubahnya. D-051 (Tahap 42, Connection Resilience) kini terisi (diterima setelah Tahap 60).
**Terbuka:** tampilan dan gaya peta (ilustrasi, 3D, atau gabungan) dan art direction; tingkat detail dan kerahasiaan bagian peta yang belum ditemukan (kabut/siluet, apakah wilayah belum terbuka terlihat sebagai terkunci atau tersembunyi); cara penemuan lokasi (mendekat, petunjuk, NPC, peta/dokumen item); daftar jenis penanda dan filter; penanda buatan pemain (jumlah, jenis) dan pelacakan satu quest aktif vs banyak; aturan fast travel rinci (titik yang dapat dipakai, biaya, waktu kalender, cooldown, larangan saat combat/dungeon/event, batas karena cuaca atau cerita) dan hubungannya dengan mount dan transportasi; apakah fast travel dapat dari peta mana saja atau hanya dari titik tertentu; apakah pemain boleh mengatur tujuan lewat peta untuk jalan otomatis (tap-to-move, D-034); minimap (ukuran, bentuk, rotasi atau tetap utara, isi); kompas (jenis petunjuk arah dan jarak); penanganan wilayah dalam interior/dungeon (peta tingkat, tanpa peta); apakah ada peta tersendiri tiap wilayah; privasi lokasi (peta pribadi, tanpa berbagi, D-014); aksesibilitas peta (kontras, ukuran penanda, bantuan buta warna); peran konsep "spiritual" untuk wilayah spiritual (belum didefinisikan, tidak ditebak). **Tidak ada klaim performa atau pengujian perangkat fisik;** P-005 tetap menunggu laporan pengguna. Implementasi belum dimulai. ID D-054 tersedia saat dicatat (tanpa bentrokan). Tahap 35 (akun dan login, P-006) tetap PENDING.

### D-055 — Sistem Waktu, Kalender, dan Jam Permainan *(APPROVED / LOCKED, 2026-11-17, Tahap 46)*
Pilihan: **D. Dynamic Time & Calendar Hybrid Lengkap.** Ruang lingkup:
1. Jam dalam permainan.
2. Kalender: hari, tanggal, bulan, tahun.
3. Siklus pagi, siang, sore, malam.
4. Jadwal harian NPC berdasarkan waktu.
5. Festival dan aktivitas kalender.
6. Aktivitas monster dan lokasi yang dipengaruhi waktu.
7. Event dunia dengan jadwal atau syarat waktu.
8. Integrasi waktu dengan musim, cuaca, pertanian, peternakan, memancing, dungeon, dan ekonomi.

Ketentuan:
- **Waktu permainan memakai simulasi waktu internal game**, bukan semata-mata jam perangkat pemain.
- **Aturan konsistensi waktu** ditetapkan untuk perpindahan wilayah, loading, dan gangguan koneksi.
- Selaras dengan D-029 (event dunia), D-030 (musim dan cuaca), D-040 (NPC hidup), D-044 (save/load), dan D-051 (Connection Resilience).
- Tidak mengubah keputusan sebelumnya. Penguncian desain; implementasi belum dimulai.

**Prinsip konsistensi waktu (dasar, tidak menambah angka):**
- Waktu permainan adalah **keadaan internal yang disimpan di save** dan menjadi satu-satunya sumber kebenaran untuk kalender, jadwal, pertumbuhan, dan event; **tidak diturunkan dari jam perangkat**.
- Jam server hanya acuan **urutan** sinkronisasi dan event bersama dasar; mengubah jam perangkat **tidak boleh** mengubah waktu permainan, revisi, atau penyelesaian konflik (selaras D-044 dan D-050).
- Perpindahan wilayah dan loading **tidak boleh** membuat waktu melompat atau mundur (selaras D-053); perjalanan dan fast travel memakai perhitungan hari-selisih yang konsisten (D-054).
- Dasar saat koneksi terganggu: gangguan koneksi **tidak memajukan dan tidak memundurkan** waktu permainan; kerangka sambung ulang dan perlindungan data ditetapkan D-051 (Connection Resilience); rincian jeda, mode terbatas, dan masa tenggang tetap terbuka.
- Hasil acak yang terkait waktu bersifat deterministik dari benih dan tanggal agar tidak bisa diulang lewat muat-ulang save (save-scumming).

Hubungan (tidak mengubah isi keputusan lain): dunia (**D-009**), sistem kehidupan (**D-015**), dungeon (**D-016**), ekonomi (**D-021**), NPC dan sosial (**D-022**), pertanian (**D-023**), peternakan (**D-024**), memancing (**D-025**), memasak/alkimia (**D-026**), event dunia (**D-029**), musim dan cuaca (**D-030**), UI/HUD (**D-031**), audio (**D-032**), NPC hidup (**D-040**), save dan cloud (**D-044**), pengaturan (**D-045**), update konten (**D-048**), keamanan (**D-050**), performa (**D-052**), loading (**D-053**), peta (**D-054**). **D-051** (Connection Resilience) kini berlaku; isinya diterima setelah Tahap 60 dan selaras dengan prinsip dasar di sini.

**Terbuka:** panjang hari/bulan/tahun dan nama bulan; panjang tiap fase hari dan kecepatan jam; apakah waktu berjalan di menu, dialog, pertarungan, atau saat aplikasi di latar belakang; apakah waktu berjalan saat offline atau terputus (kerangka di D-051; rincian tetap terbuka); kebijakan event berbasis waktu nyata vs kalender permainan (terbuka di D-029); aturan susul-kejar (catch-up) setelah lama tidak bermain; panjang musim (terbuka di D-030); arti "spiritual" (belum didefinisikan); romansa/pernikahan/keluarga/anak ditetapkan terpisah oleh D-066 (cakupan saja; detail belum final). Tahap 35 (akun/login) tetap PENDING (P-006).

### D-056 — Sistem Tidur, Istirahat, dan Pergantian Hari *(APPROVED / LOCKED, 2026-11-17, Tahap 47)*
Pilihan: **D. Rest & Sleep Hybrid Lengkap.** Ruang lingkup:
1. Tidur di rumah.
2. Tidur di penginapan.
3. Istirahat di kemah (campsite) saat menjelajah.
4. Pemulihan melalui istirahat.
5. Advance day dan pemrosesan pergantian hari.
6. Pemrosesan aktivitas dunia saat pergantian hari: pertanian, peternakan, NPC, toko, ekonomi, dan event.
7. Integrasi dengan kalender, jam, musim, cuaca, dan sistem save.

Ketentuan:
- Aturan konsistensi waktu dan pergantian hari ditetapkan sebagai **prinsip** (di bawah).
- **Pemrosesan dunia yang berat tidak boleh dalam satu frame.**
- **Pergantian hari aman terhadap gangguan koneksi dan penyimpanan.**
- **Efek pemulihan, batasan tidur, dan aturan waktu tidur BELUM ditentukan**; tidak dikarang dan tidak dikunci tanpa keputusan desain terpisah.
- Tetap **single-player online** (D-014).
- Penguncian desain; implementasi belum dimulai.

**Prinsip pergantian hari (dasar, tanpa angka):**
- Pergantian hari adalah **satu transaksi logis berurutan** yang memajukan `GameClock` (D-055) lewat satu jalur resmi; tidak ada jam perangkat yang dipakai dan tidak ada waktu mundur.
- Hasil diproses dengan simulasi hari-selisih deterministik (seed + tanggal, D-055) sehingga memuat ulang save tidak mengubah hasil (anti save-scumming).
- Pemrosesan dibagi per sistem (pertanian, peternakan, NPC, toko, ekonomi, event, cuaca/musim) dan **dibagi ke beberapa frame** dengan anggaran waktu; layar transisi/loading (D-053) menutupinya.
- **Save aman:** hasil pergantian hari ditulis atomik dengan ID transaksi idempoten dan revisi (D-044); bila terputus di tengah, tidak ada dobel proses atau hari setengah jadi; kembali ke titik save terakhir yang valid.
- **Koneksi terganggu:** pergantian hari tidak boleh merusak data; perilaku saat koneksi putus mengikuti D-051 (Connection Resilience; rincian durasi dan masa tenggang tetap terbuka). Dasar D-055 tetap: koneksi tidak memajukan/memundurkan waktu.
- Satu jalur untuk semua sumber (tidur rumah, penginapan, kemah, advance day) agar hasilnya konsisten.

Hubungan (tidak mengubah isi keputusan lain): sistem kehidupan (**D-015**), dungeon (**D-016**), ekonomi (**D-021**), NPC (**D-022**), pertanian (**D-023**), peternakan (**D-024**), rumah/penginapan (**D-027**), eksplorasi/kemah (**D-028**), event dunia (**D-029**), musim dan cuaca (**D-030**), UI/HUD (**D-031**), audio (**D-032**), NPC hidup (**D-040**), save dan cloud (**D-044**), pengaturan (**D-045**), update konten (**D-048**), QA (**D-049**), keamanan (**D-050**), performa (**D-052**), loading (**D-053**), waktu dan kalender (**D-055**). **D-051** (Connection Resilience) kini berlaku; isinya diterima setelah Tahap 60.

**Terbuka (tidak diputuskan):** efek dan besar pemulihan (HP, stamina, status); batas tidur dan aturan jam tidur (jam paling awal/akhir, tidur paksa saat larut); biaya penginapan dan fasilitas; aturan dan risiko kemah (di mana boleh, gangguan monster); apakah bisa tidur sebentar tanpa ganti hari; apakah event/NPC berjalan saat offline (terbuka di D-029); aturan catch-up setelah lama tidak bermain; arti "spiritual" (belum didefinisikan); romansa/pernikahan/keluarga/anak ditetapkan terpisah oleh D-066 (cakupan saja; detail belum final). Tahap 35 (akun/login) tetap PENDING (P-006).

### D-057 — Sistem Energi, Stamina, dan Kebutuhan Karakter *(APPROVED / LOCKED, 2026-11-17, Tahap 48)*
Pilihan: **D. Character Vitality Hybrid Lengkap.** Ruang lingkup:
1. Health.
2. Stamina untuk aktivitas fisik.
3. Mana untuk sihir dan kemampuan tertentu.
4. Hunger.
5. Thirst.
6. Fatigue.
7. Pemulihan melalui tidur, istirahat, makanan, minuman, dan ramuan.
8. Efek makanan dan potion terhadap kondisi karakter.
9. Integrasi dengan farming, eksplorasi, pertarungan, dungeon, memasak, alkimia, dan sistem tidur.

Ketentuan:
- **Tidak ada angka konsumsi, regenerasi, penalti, atau balance final** tanpa desain lanjutan.
- **Health, Stamina, dan Mana dibedakan** agar fungsi masing-masing jelas (di bawah).
- **Kebutuhan karakter tidak boleh membuat farming dan eksplorasi terlalu merepotkan** (prinsip ramah pemain: rendah gesekan).
- Selaras dengan D-015, D-026, D-043, D-046, dan D-056.
- Penguncian desain; implementasi belum dimulai.

**Fungsi tiap sumber daya (prinsip, tanpa angka):**
- **Health:** daya tahan hidup karakter terhadap kerusakan (pertarungan, bahaya lingkungan).
- **Stamina:** kapasitas aktivitas fisik (mis. alat pertanian, lari, mengumpulkan, memancing, memanjat).
- **Mana:** sumber daya sihir dan kemampuan tertentu.
- **Hunger, Thirst, Fatigue:** kebutuhan karakter yang dipulihkan oleh makanan, minuman, tidur/istirahat; dirancang berdampak ringan dan tidak mengganggu alur dasar bermain.
- Pemulihan lewat **tidur dan istirahat (D-056), makanan dan minuman (D-026), dan ramuan (D-026)**; efek makanan/potion bekerja lewat sistem kondisi/efek bersama.
- Berlaku bagi pemain; pemakaian pada companion/monster mengikuti model makhluk bersama dan tidak ditetapkan di sini.

Hubungan (tidak mengubah isi keputusan lain): pertarungan (**D-013**), sistem kehidupan (**D-015**), dungeon (**D-016**), perkembangan karakter (**D-018**), companion (**D-019**), equipment (**D-020**), ekonomi (**D-021**), pertanian (**D-023**), peternakan (**D-024**), memancing (**D-025**), memasak dan alkimia (**D-026**), eksplorasi (**D-028**), UI/HUD (**D-031**), audio (**D-032**), inventory (**D-036**), mount (**D-042**; stamina mount tetap terbuka di sana), tutorial (**D-043**), save/cloud (**D-044**), pengaturan dan aksesibilitas (**D-045**), achievement (**D-046**), update konten (**D-048**), QA (**D-049**), keamanan (**D-050**), performa (**D-052**), waktu (**D-055**), tidur (**D-056**). **D-051** (Connection Resilience) kini berlaku; isinya diterima setelah Tahap 60.

**Terbuka (tidak diputuskan):** semua angka (kapasitas, konsumsi, regenerasi, penalti, batas); efek bila sumber daya habis (termasuk apakah hunger/thirst/fatigue bisa melemahkan atau hanya memberi bonus/malus ringan, dan apakah ada risiko pingsan atau kekalahan); apakah kebutuhan dapat diatur lewat tingkat kesulitan/pengaturan; apakah Mana dipakai semua kelas; kaitan dengan efek tidur (D-056, yang juga masih terbuka); daftar efek makanan/potion; stamina mount (D-042); arti "spiritual" (belum didefinisikan); romansa/pernikahan/keluarga/anak ditetapkan terpisah oleh D-066 (cakupan saja; detail belum final). Tahap 35 (akun/login) tetap PENDING (P-006).

### D-058 — Sistem Kematian, Pingsan, dan Kebangkitan Karakter *(APPROVED / LOCKED, 2026-11-17, Tahap 49)*
Pilihan: **D. Defeat & Recovery Hybrid Lengkap.** Ruang lingkup:
1. Pingsan (fainting) dan penanganan kekalahan (defeat).
2. Penyelamatan oleh NPC saat pemain pingsan.
3. Klinik dan fasilitas pemulihan.
4. Kebangkitan (revival) di lokasi/fasilitas yang sesuai.
5. Checkpoint berdasarkan lokasi dan kondisi pemain.
6. Integrasi dengan pertarungan, dungeon, eksplorasi, vitalitas, NPC, dan progres dunia.

Ketentuan:
- **Tidak ada penalti** kehilangan item, uang, EXP, atau progres yang ditetapkan tanpa keputusan desain lanjutan.
- **Durasi pemulihan dan aturan checkpoint final tidak ditetapkan sepihak.**
- Sistem harus **adil** dan **tidak membuat pemain kehilangan progres secara tidak wajar** (prinsip).
- Selaras dengan D-015, D-029, D-040, D-044, D-048, D-056, dan D-057.
- Penguncian desain; implementasi belum dimulai.

**Prinsip (dasar, tanpa angka):**
- Kekalahan adalah **keadaan permainan yang dapat dipulihkan**, ditangani oleh satu alur resmi yang konsisten untuk semua konteks (luar ruangan, dungeon, interior, event/quest); pemain selalu punya jalan kembali bermain.
- Pemicu berasal dari sistem vitalitas dan pertarungan (D-057, D-013); pemulihan dapat melibatkan **NPC penyelamat**, **klinik/fasilitas**, dan **checkpoint** sesuai lokasi dan kondisi.
- Tempat kebangkitan dipilih dari aturan data (lokasi/fasilitas/checkpoint yang valid, sudah terbuka, dan aman), bukan titik tetap tunggal.
- Penanganan kekalahan **tidak boleh dipakai untuk menggandakan hadiah atau mengulang hasil acak** (hasil deterministik dari seed dan tanggal, D-055); tidak memakai jam perangkat.
- **Aman terhadap interupsi dan koneksi:** pemrosesan kekalahan ditulis atomik dan idempoten (D-044); perilaku saat koneksi putus mengikuti D-051 (Connection Resilience; rincian durasi dan masa tenggang tetap terbuka).
- Tetap **single-player online** (D-014); tidak ada kematian oleh pemain lain.

Hubungan (tidak mengubah isi keputusan lain): dunia (**D-009**), pertarungan (**D-013**), sistem kehidupan (**D-015**), dungeon (**D-016**), guild (**D-017**), companion (**D-019**), ekonomi (**D-021**), NPC (**D-022**), rumah/fasilitas (**D-027**), eksplorasi (**D-028**), event dunia (**D-029**), UI/HUD (**D-031**), audio (**D-032**), quest (**D-037**), dialog (**D-038**), NPC hidup (**D-040**), tutorial (**D-043**), save/cloud (**D-044**), pengaturan dan aksesibilitas (**D-045**), achievement (**D-046**), update konten (**D-048**), QA (**D-049**), keamanan (**D-050**), performa (**D-052**), loading (**D-053**), peta (**D-054**), waktu (**D-055**), tidur (**D-056**), vitalitas (**D-057**). **D-051** (Connection Resilience) kini berlaku; isinya diterima setelah Tahap 60.

**Terbuka (tidak diputuskan):** semua penalti (item, uang, EXP, progres) dan apakah ada; durasi pemulihan; aturan dan jenis checkpoint final; kondisi tepat pingsan vs kalah; aturan penyelamatan NPC (siapa, kapan, biaya, tidak selalu tersedia); biaya dan layanan klinik; apakah waktu permainan maju saat pingsan (jalur waktu D-055/D-056); nasib companion/monster saat pemain pingsan; perlakuan khusus di dungeon, boss, dan event; opsi kesulitan/pengaturan terkait; arti "spiritual" (belum didefinisikan); romansa/pernikahan/keluarga/anak ditetapkan terpisah oleh D-066 (cakupan saja; detail belum final). Tahap 35 (akun/login) tetap PENDING (P-006).

### D-059 — Sistem Status Effect, Buff, dan Debuff *(APPROVED / LOCKED, 2026-11-17, Tahap 50)*
Pilihan: **D. Status Effect Hybrid Lengkap.** Ruang lingkup:
1. Buff positif.
2. Debuff negatif.
3. Status effect elemental.
4. Status effect spiritual (**arti "spiritual" belum didefinisikan**; hanya dicatat sebagai kategori yang disebut pemilik).
5. Penyakit dan kondisi fisik.
6. Racun dan efek berbahaya lainnya.
7. Perlindungan, resistensi, dan efek defensif.
8. Efek makanan, minuman, dan potion.
9. Integrasi dengan pertarungan, dungeon, pertanian, memasak, alkimia, monster, dan perkembangan karakter.

Ketentuan:
- **Tidak ada katalog final, durasi, aturan stacking, probabilitas, atau angka balance** tanpa desain lanjutan.
- **Setiap efek nantinya harus punya definisi, sumber, target, durasi, dan aturan penghapusan yang jelas** (kewajiban kelengkapan definisi, bukan isi).
- Selaras dengan D-018, D-026, D-046, D-057, dan D-058.
- Tidak mengubah keputusan terdahulu. Penguncian desain; implementasi belum dimulai.

**Prinsip (dasar, tanpa angka):**
- Semua status effect berada dalam **satu sistem bersama** (satu definisi, satu cara menerapkan dan menghapus) yang dipakai pemain, companion, monster, dan sumber lain; efek makanan/minuman/potion (D-026, D-057) memakai sistem yang sama.
- Tiap efek dapat dijelaskan dengan lima bagian: **definisi, sumber, target, durasi, aturan penghapusan** (nilainya ditetapkan kemudian per efek).
- Efek **tidak boleh membuat pemain kehilangan progres secara tidak wajar** dan tidak ada keadaan tanpa jalan keluar (selaras D-058); penyembuhan/penghapusan efek harus selalu mungkin menurut aturan yang kelak ditetapkan.
- Efek **ditampilkan jelas** (HUD, aksesibilitas) dan tidak mengandalkan warna saja.
- Efek berdurasi mengikuti **waktu permainan internal** (D-055), bukan jam perangkat; dihitung konsisten saat tidur, perjalanan, dan loading (D-053, D-056).
- Hasil acak terkait efek deterministik dari seed (anti save-scumming, selaras D-044/D-055).
- Tetap **single-player online**; tidak ada efek antarpemain.

Hubungan (tidak mengubah isi keputusan lain): pertarungan (**D-013**), sistem kehidupan (**D-015**), dungeon (**D-016**), perkembangan karakter (**D-018**), companion dan monster (**D-019**), equipment (**D-020**), pertanian (**D-023**), peternakan (**D-024**), memasak dan alkimia (**D-026**), event dunia (**D-029**), musim dan cuaca (**D-030**), UI/HUD (**D-031**), audio (**D-032**), inventory (**D-036**), tutorial (**D-043**), save/cloud (**D-044**), pengaturan dan aksesibilitas (**D-045**), achievement (**D-046**), update konten (**D-048**), QA (**D-049**), keamanan (**D-050**), performa (**D-052**), waktu (**D-055**), tidur (**D-056**), vitalitas (**D-057**), kekalahan (**D-058**). **D-051** (Connection Resilience) kini berlaku; isinya diterima setelah Tahap 60.

**Terbuka (tidak diputuskan):** katalog efek; durasi; aturan stacking/penggantian/prioritas; probabilitas dan resistensi; semua angka; arti "spiritual" (belum didefinisikan, tidak ditebak); daftar elemen dan penyakit; cara menyembuhkan/menghapus tiap efek; apakah efek bertahan setelah kekalahan/tidur/perpindahan wilayah (aturan lanjutan, selaras D-056/D-058); efek lingkungan/cuaca (D-030); romansa/pernikahan/keluarga/anak ditetapkan terpisah oleh D-066 (cakupan saja; detail belum final). Tahap 35 (akun/login) tetap PENDING (P-006).

### D-060 — Sistem Ras, Suku, dan Asal-Usul Karakter *(APPROVED / LOCKED, 2026-11-17, Tahap 51)*
Pilihan: **D. Racial World Hybrid Lengkap.** Ruang lingkup:
1. Beragam ras fantasi.
2. Beragam suku dan bangsa.
3. Keturunan atau garis keturunan spiritual (**arti "spiritual" belum didefinisikan**; hanya dicatat sebagai hal yang disebut pemilik).
4. Peradaban dan bangsa kuno.
5. Identitas, penampilan, budaya, dan tradisi yang berbeda.
6. Integrasi ras dan suku dengan NPC, wilayah, kota, desa, guild, perdagangan, dan cerita dunia.

Ketentuan:
- **Tidak ada daftar ras final, lore, kemampuan ras, populasi, atau hubungan antarbangsa** tanpa desain lanjutan.
- **Perbedaan ras tidak dijadikan alasan bagi sistem diskriminasi yang tidak dirancang secara sadar** (prinsip di bawah).
- **Setiap kelompok punya identitas dan budaya yang konsisten.**
- **Tidak mengubah keputusan gameplay atau eksplorasi dunia sebelumnya.**
- Penguncian desain, bukan instruksi implementasi.

**Prinsip (dasar, tanpa isi lore):**
- Ras, suku, dan bangsa adalah **identitas dunia** (penampilan, budaya, tradisi, peradaban), bukan alat untuk memberi perlakuan berbeda secara tersembunyi. Setiap perbedaan perlakuan antar kelompok (harga, akses, dialog, reputasi, quest) **harus berupa keputusan desain yang eksplisit dan disengaja**, bukan efek samping.
- **Identitas konsisten:** satu kelompok punya satu rangkaian identitas (nama, penampilan, budaya, tradisi, peradaban) yang dipakai sama oleh NPC, wilayah, bahasa, dan cerita; tidak saling bertentangan antar dokumen atau aset.
- Penggambaran harus **hormat dan tidak berupa karikatur**; bila kelompok fantasi terinspirasi budaya nyata Nusantara atau lainnya, hal itu keputusan lanjutan yang harus eksplisit (belum diputuskan).
- Cerita dan konten melibatkan banyak kelompok secara **setara dalam kualitas**; tidak ada kelompok yang hanya dijadikan musuh atau latar tanpa identitas, kecuali ditetapkan sengaja dalam desain cerita.
- Tidak mengunci mekanik pemain (apakah ras bisa dipilih, apakah memengaruhi statistik); itu tetap terbuka (lihat D-041 dan D-018).
- Tetap **single-player online** (D-014).

Hubungan (tidak mengubah isi keputusan lain): dunia dan Progressive World Unlock (**D-009**), sistem kehidupan (**D-015**), guild (**D-017**), perkembangan karakter (**D-018**), companion dan monster (**D-019**), ekonomi dan perdagangan (**D-021**), NPC dan sosial (**D-022**), eksplorasi (**D-028**), event dunia (**D-029**), quest dan cerita (**D-037**), dialog (**D-038**), hubungan sosial (**D-039**), NPC hidup (**D-040**), kustomisasi karakter (**D-041**), status effect (**D-059**), update konten (**D-048**), pengaturan/lokalisasi (**D-045**). **D-051** (Connection Resilience) kini berlaku; isinya diterima setelah Tahap 60.

**Terbuka (tidak diputuskan):** daftar ras/suku/bangsa; lore dan sejarah; kemampuan/bonus ras (bila ada); populasi dan persebaran; hubungan antarbangsa; apakah pemain memilih ras/suku/asal-usul dan apa dampaknya (D-041, D-018); arti "spiritual" dan "garis keturunan spiritual" (belum didefinisikan, tidak ditebak); daftar peradaban kuno; hubungan dengan budaya nyata; bahasa dan sistem penamaan; romansa/pernikahan/keluarga/anak ditetapkan terpisah oleh D-066 (cakupan saja; detail belum final). Tahap 35 (akun/login) tetap PENDING (P-006).

### D-061 — Sistem Kerajaan, Wilayah Kekuasaan, dan Organisasi Dunia *(APPROVED / LOCKED, 2026-11-17, Tahap 52)*
Pilihan: **D. World Civilization Hybrid Lengkap.** Ruang lingkup:
1. Kerajaan dan kekaisaran.
2. Sekte spiritual (**arti "spiritual" belum didefinisikan**; hanya dicatat sebagai jenis yang disebut pemilik).
3. Klan dan keluarga besar.
4. Guild petualang (tetap sesuai D-017; tidak diubah).
5. Aliansi regional.
6. Kota independen.
7. Organisasi rahasia.
8. Wilayah pengaruh, kepentingan, identitas, dan hubungan antarorganisasi.

Ketentuan:
- **Tidak ada nama, jumlah, pemimpin, peta politik, sejarah, atau hubungan organisasi final** tanpa desain lanjutan.
- **Struktur organisasi harus dapat berkembang seiring progres dunia.**
- Selaras dengan D-028 (eksplorasi dunia), D-060 (ras dan suku), D-017 (guild petualang), dan D-029 (event dunia).
- Tidak mengubah keputusan terdahulu. Penguncian desain, bukan instruksi implementasi.

**Prinsip (dasar, tanpa isi lore):**
- Organisasi dunia adalah **bagian dunia yang dapat berubah**: kondisi dan hubungannya dapat bergeser seiring progres pemain, quest, dan event, tidak statis (arah desain; aturan perubahan belum ditetapkan).
- **Guild petualang (D-017)** tetap satu jenis organisasi yang ada; D-061 menempatkannya sebagai salah satu dari beberapa jenis organisasi tanpa mengubah rank, fitur, atau isinya.
- Identitas, budaya, dan wilayah tiap organisasi **konsisten** dan terkait kelompok (D-060) dan wilayah (D-009, D-028) tanpa diskriminasi tersembunyi: perbedaan perlakuan hanya lewat aturan desain yang eksplisit.
- Wilayah pengaruh tidak membuka atau menutup wilayah di luar aturan Progressive World Unlock (D-009) dan tidak mengubah aturan eksplorasi (D-028).
- Organisasi rahasia **tidak terlihat sebelum ditemukan**; tidak membocorkan informasi lewat peta/UI (selaras D-054).
- Dunia tetap **pribadi per pemain** (single-player online, D-014); perubahan kondisi dunia bersifat per-save.

Hubungan (tidak mengubah isi keputusan lain): dunia (**D-009**), sistem kehidupan (**D-015**), dungeon (**D-016**), guild (**D-017**), perkembangan karakter (**D-018**), ekonomi dan perdagangan (**D-021**), NPC dan sosial (**D-022**), eksplorasi (**D-028**), event dunia (**D-029**), quest dan cerita (**D-037**), dialog (**D-038**), hubungan sosial (**D-039**), NPC hidup (**D-040**), save/cloud (**D-044**), update konten (**D-048**), keamanan (**D-050**), peta (**D-054**), waktu (**D-055**), ras dan suku (**D-060**). **D-051** (Connection Resilience) kini berlaku; isinya diterima setelah Tahap 60.

**Terbuka (tidak diputuskan):** nama, jumlah, pemimpin, peta politik, sejarah, dan hubungan antarorganisasi; arti "spiritual" dan isi sekte (tidak ditebak); aturan dan cara perubahan kondisi organisasi seiring progres; efek mekanik (reputasi per organisasi, akses, dagang, quest); hubungan dengan guild petualang selain D-017; jenis dan cara menemukan organisasi rahasia; apakah ada konflik/perang dan bagaimana ditampilkan; romansa/pernikahan/keluarga/anak ditetapkan terpisah oleh D-066 (cakupan saja; detail belum final), termasuk dalam konteks klan yang belum dirinci. Tahap 35 (akun/login) tetap PENDING (P-006).

### D-062 — Sistem Reputasi, Hubungan Faksi, dan Diplomasi *(APPROVED / LOCKED, 2026-11-17, Tahap 53)*
Pilihan: **D. Faction Relations Hybrid Lengkap.** Ruang lingkup:
1. Reputasi pemain terhadap organisasi.
2. Diplomasi antarorganisasi.
3. Persahabatan dan hubungan baik.
4. Persaingan (rivalry).
5. Permusuhan (hostility).
6. Aliansi dan kerja sama.
7. Konflik antarfaksi.
8. Pengaruh pemain terhadap hubungan dan keadaan organisasi dunia.

Ketentuan:
- **Reputasi pribadi pemain dibedakan dari hubungan antarorganisasi.**
- **Tidak ada skala angka, ambang (threshold), daftar faksi, atau hasil politik final** tanpa desain lanjutan.
- **Pilihan dan tindakan pemain dapat memiliki konsekuensi yang konsisten.**
- Selaras dengan D-017, D-022, D-029, D-039, D-060, dan D-061.
- Tidak mengubah keputusan terdahulu. Penguncian desain; implementasi belum dimulai.

**Prinsip (dasar, tanpa angka):**
- Ada **dua hal yang berbeda**: (a) **reputasi pemain** terhadap suatu organisasi (pribadi, per save) dan (b) **hubungan antarorganisasi** (persahabatan, persaingan, permusuhan, aliansi, konflik) sebagai keadaan dunia. Keduanya tidak disamakan; tindakan pemain dapat memengaruhi keduanya hanya lewat aturan yang eksplisit.
- Reputasi terhadap organisasi **membedakan diri** dari hubungan individu dengan NPC (D-039, D-022): hubungan baik dengan satu NPC tidak otomatis mengubah reputasi atau hubungan faksi, dan sebaliknya. Reputasi komunitas/Guild di D-039 dan rank/reputasi D-017 **tetap berlaku**; D-062 tidak mengubah isinya dan hubungan skalanya masih terbuka.
- **Konsekuensi konsisten:** tindakan yang sama dalam keadaan yang sama menghasilkan dampak yang sama dan dapat dijelaskan kepada pemain; tidak ada perubahan tanpa sebab yang terlihat. Hasil acak (bila ada) deterministik dari seed (D-055).
- **Adil:** perubahan hubungan tidak boleh menjebak pemain tanpa jalan keluar atau menghilangkan progres secara tidak wajar (selaras D-058); cara memperbaiki hubungan harus dimungkinkan (aturan menyusul).
- **Tanpa diskriminasi tersembunyi:** pengaruh ras/suku (D-060) terhadap hubungan hanya lewat aturan desain eksplisit.
- Pengaruh pemain berlangsung dalam **dunia pribadi** (single-player online, D-014); tidak ada politik antarpemain.
- Indikator hubungan mudah dipahami dan tidak mengubah semua interaksi menjadi sekadar mengejar angka (selaras D-039).

Hubungan (tidak mengubah isi keputusan lain): dunia (**D-009**), sistem kehidupan (**D-015**), guild (**D-017**), perkembangan karakter (**D-018**), ekonomi (**D-021**), NPC dan sosial (**D-022**), eksplorasi (**D-028**), event dunia (**D-029**), UI/HUD (**D-031**), quest dan cerita (**D-037**), dialog (**D-038**), hubungan sosial (**D-039**), NPC hidup (**D-040**), save/cloud (**D-044**), pengaturan (**D-045**), update konten (**D-048**), keamanan (**D-050**), peta (**D-054**), waktu (**D-055**), status effect (**D-059**), ras dan suku (**D-060**), organisasi dunia (**D-061**). **D-051** (Connection Resilience) kini berlaku; isinya diterima setelah Tahap 60.

**Terbuka (tidak diputuskan):** skala dan tingkat reputasi (angka atau tahap), ambang, rumus perubahan; daftar faksi (bergantung D-061); hasil politik; hubungan skala D-062 dengan reputasi komunitas D-039 dan rank D-017; aturan peluruhan dan perbaikan hubungan; jenis hubungan antarorganisasi dan bagaimana dunia memunculkannya; bentuk konflik dan penyelesaiannya; seberapa besar pengaruh pemain; cara menampilkan di UI; arti "spiritual" (belum didefinisikan); romansa/pernikahan/keluarga/anak ditetapkan terpisah oleh D-066 (cakupan saja; detail belum final). Tahap 35 (akun/login) tetap PENDING (P-006).

### D-063 — Sistem Perang dan Konflik Antarfaksi *(APPROVED / LOCKED, 2026-11-17, Tahap 54)*
Pilihan: **D. World Conflict Hybrid Lengkap.** Ruang lingkup:
1. Konflik politik antarorganisasi.
2. Perang kerajaan dan kekaisaran.
3. Sengketa dan perebutan wilayah.
4. Perang sekte dan klan (**arti "spiritual" pada sekte belum didefinisikan**).
5. Serangan monster terhadap wilayah dan kota.
6. Pertahanan kota dan pertahanan regional.
7. Keterlibatan pemain dalam konflik dunia.
8. Dampak konflik terhadap NPC, ekonomi, perdagangan, reputasi, dan kondisi wilayah.

Ketentuan:
- **Tidak ada daftar perang, faksi terlibat, korban, aturan perebutan wilayah, atau hasil konflik final** tanpa desain lanjutan.
- **Konflik konsisten dengan hubungan diplomasi dan reputasi faksi** (D-062).
- **Pemain tidak dipaksa mengikuti setiap konflik.**
- **Konflik dunia tidak boleh merusak progres utama pemain atau data save.**
- Selaras dengan D-029, D-028, D-053, D-060, D-061, dan D-062.
- Penguncian desain; implementasi belum dimulai.

**Prinsip (dasar, tanpa isi lore):**
- Konflik adalah **keadaan dunia berdata** yang muncul dari hubungan antarorganisasi (D-062) dan organisasi dunia (D-061); tidak berdiri sendiri dan tidak bertentangan dengan keadaan diplomasi saat itu.
- **Keterlibatan pemain bersifat pilihan:** pemain dapat ikut, mendukung pihak tertentu, membantu pertahanan, atau mengabaikan; mengabaikan tidak menutup progres utama dan tidak membuat pemain buntu. Konsekuensi (reputasi, akses, harga) hanya lewat aturan eksplisit yang konsisten.
- **Progres dan save terlindungi:** konflik tidak boleh menghapus atau merusak data save, progres cerita utama, atau akses ke fungsi inti (misalnya rumah, ladang, penyimpanan) di luar aturan eksplisit yang kelak ditetapkan; keadaan konflik tersimpan per-save dan dapat dipulihkan/dimigrasi.
- **Dampak ke dunia berskala:** NPC, ekonomi, perdagangan, reputasi, dan kondisi wilayah dapat berubah karena konflik lewat efek data eksplisit; perubahan harus dapat dijelaskan kepada pemain dan dapat berakhir (ada jalur pemulihan/penyelesaian).
- **Serangan monster dan pertahanan** memakai sistem pertarungan, event dunia (D-029), dan status wilayah yang sama; tidak menambah sistem terpisah.
- **Wilayah dan eksplorasi:** konflik tidak mengubah aturan Progressive World Unlock (D-009) dan eksplorasi (D-028); transisi ke area terdampak memakai Loading/streaming normal (D-053); fast travel ke area berbahaya mengikuti aturan hambatan data.
- **Tanpa diskriminasi tersembunyi:** pengaruh ras/suku (D-060) hanya lewat aturan eksplisit; penggambaran kelompok hormat, bukan karikatur.
- Dunia pribadi per pemain (single-player online, D-014); tidak ada perang antarpemain.

Hubungan (tidak mengubah isi keputusan lain): dunia (**D-009**), pertarungan (**D-013**), sistem kehidupan (**D-015**), dungeon (**D-016**), guild (**D-017**), companion/monster (**D-019**), ekonomi dan perdagangan (**D-021**), NPC dan sosial (**D-022**), eksplorasi (**D-028**), event dunia (**D-029**), musim dan cuaca (**D-030**), UI/HUD (**D-031**), audio (**D-032**), quest (**D-037**), hubungan sosial (**D-039**), NPC hidup (**D-040**), save/cloud (**D-044**), update konten (**D-048**), QA (**D-049**), keamanan (**D-050**), performa (**D-052**), loading (**D-053**), peta (**D-054**), waktu (**D-055**), tidur (**D-056**), kekalahan (**D-058**), status effect (**D-059**), ras (**D-060**), organisasi (**D-061**), diplomasi (**D-062**). **D-051** (Connection Resilience) kini berlaku; isinya diterima setelah Tahap 60.

**Terbuka (tidak diputuskan):** daftar konflik/perang, faksi terlibat, korban, aturan perebutan wilayah, hasil; apakah dan bagaimana kota/wilayah berubah kepemilikan; peran pemain (pilihan, hadiah, risiko); bentuk pertahanan kota dan skala serangan monster; dampak mekanik pada NPC/ekonomi/harga/akses; apakah NPC dapat terluka/hilang (dan aturan perlindungan NPC penting); apakah konflik berlangsung saat offline (terbuka di D-029) dan aturan catch-up; lamanya konflik; arti "spiritual"; romansa/pernikahan/keluarga/anak ditetapkan terpisah oleh D-066 (cakupan saja; detail belum final). Tahap 35 (akun/login) tetap PENDING (P-006).

### D-064 — Sistem Hukum, Kejahatan, dan Bounty *(APPROVED / LOCKED, 2026-11-17, Tahap 55)*
Pilihan: **D. Law & Justice Hybrid Lengkap.** Ruang lingkup:
1. Penjaga dan penegak hukum regional.
2. Hukum kerajaan dan hukum regional.
3. Sistem kejahatan.
4. Reputasi kriminal.
5. Bounty dan sistem buronan (wanted).
6. Penangkapan dan respons penegakan hukum.
7. Pengadilan dan prosedur keadilan.
8. Aturan dan otoritas khusus wilayah.

Ketentuan:
- **Tidak ada kategori kejahatan final, prosedur hukum, hukuman, formula bounty, atau konsekuensi final** tanpa desain lanjutan.
- **Reputasi sosial, reputasi faksi, dan reputasi kriminal dibedakan.**
- **Sistem hukum konsisten dengan struktur kerajaan dan hubungan faksi** (D-061, D-062).
- **Tindakan pemain yang tidak disengaja tidak boleh langsung menghasilkan hukuman berat.**
- Selaras dengan D-017, D-022, D-039, D-060, D-061, D-062, dan D-063.
- Penguncian desain; implementasi belum dimulai.

**Prinsip (dasar, tanpa angka):**
- Tiga jenis reputasi **tidak disamakan**: (a) **reputasi sosial** (hubungan dengan NPC dan komunitas, D-039/D-022); (b) **reputasi faksi** (pemain terhadap organisasi, D-062); (c) **reputasi kriminal** (catatan pemain di mata hukum suatu wilayah). Mengubah satu tidak otomatis mengubah yang lain, kecuali lewat aturan eksplisit.
- Hukum **berlaku per wilayah dan otoritas**: tiap wilayah/organisasi berkuasa (D-061) dapat punya aturan, penjaga, dan prosedur berbeda; apa yang dianggap kejahatan di satu tempat belum tentu di tempat lain (isi belum ditetapkan).
- **Tidak disengaja ≠ kejahatan berat:** tindakan tidak disengaja atau ambigu harus punya peringatan, kesempatan memperbaiki, atau penanganan ringan sebelum konsekuensi berat; sistem tidak menghukum pemain karena salah klik atau kondisi yang tidak jelas.
- **Adil dan ada jalan keluar:** pemain dapat menebus, membayar, menyelesaikan, atau menghindari konsekuensi lewat jalur yang disediakan; tidak ada keadaan buntu; progres utama dan data save tidak rusak (selaras D-058, D-063); penegakan hukum tidak menghapus item/progres inti di luar aturan eksplisit yang kelak ditetapkan.
- **Konsisten dengan konflik dan diplomasi:** keadaan hukum dapat dipengaruhi oleh konflik (D-063) dan hubungan antarorganisasi (D-062) hanya lewat aturan eksplisit; tanpa diskriminasi tersembunyi berdasarkan ras/suku (D-060).
- Penegakan hukum memakai pertarungan, dialog, dan sistem kekalahan yang sudah ada (D-013, D-038, D-058); tidak menambah mode permainan terpisah.
- Dunia pribadi per pemain (single-player online, D-014); tidak ada hukum antarpemain.

Hubungan (tidak mengubah isi keputusan lain): dunia (**D-009**), pertarungan (**D-013**), sistem kehidupan (**D-015**), dungeon (**D-016**), guild (**D-017**), ekonomi dan perdagangan (**D-021**), NPC dan sosial (**D-022**), eksplorasi (**D-028**), event dunia (**D-029**), UI/HUD (**D-031**), quest (**D-037**), dialog (**D-038**), hubungan sosial (**D-039**), NPC hidup (**D-040**), save/cloud (**D-044**), pengaturan (**D-045**), update konten (**D-048**), QA (**D-049**), keamanan (**D-050**), loading (**D-053**), waktu (**D-055**), kekalahan (**D-058**), status effect (**D-059**), ras (**D-060**), organisasi (**D-061**), diplomasi (**D-062**), konflik (**D-063**). **D-051** (Connection Resilience) kini berlaku; isinya diterima setelah Tahap 60.

**Terbuka (tidak diputuskan):** daftar dan kategori kejahatan; hukuman dan prosedur pengadilan; formula dan nilai bounty; skala dan ambang reputasi kriminal; aturan penangkapan dan respons penjaga; cara menebus/menghapus catatan; perilaku saat tertangkap (penjara, denda, penyitaan, dan dampak ke waktu); aturan khusus wilayah; peran Guild (D-017) dalam penegakan; apakah NPC dapat melapor dan bagaimana saksi bekerja; kejahatan terhadap NPC dan properti; apakah ada hukuman kematian/pertarungan mematikan; arti "spiritual" (belum didefinisikan); romansa/pernikahan/keluarga/anak ditetapkan terpisah oleh D-066 (cakupan saja; detail belum final). Tahap 35 (akun/login) tetap PENDING (P-006).

### D-065 — Sistem Cuaca Ekstrem, Bencana Alam, dan Fenomena Spiritual *(APPROVED / LOCKED, 2026-11-17, Tahap 56)*
Pilihan: **D. World Phenomena Hybrid Lengkap.** Ruang lingkup:
1. Cuaca ekstrem.
2. Bencana alam.
3. Fenomena spiritual (**arti "spiritual" belum didefinisikan**; sudah tercatat terbuka di D-029 dan D-030 dan tidak ditebak di sini).
4. Perubahan lingkungan.
5. Event dunia langka.
6. Dampak fenomena terhadap wilayah, NPC, tanaman, hewan, monster, sumber daya, eksplorasi, dan ekonomi.

Ketentuan:
- **Tidak ada katalog final, frekuensi, probabilitas, tingkat kerusakan, durasi, atau konsekuensi numerik** tanpa desain lanjutan.
- **Fenomena konsisten dengan musim, cuaca, kalender, dan event dunia.**
- **Fenomena tidak boleh merusak data save atau menghilangkan progres pemain secara tidak adil.**
- Selaras dengan D-029, D-030, D-048, D-051, dan D-055.
- Penguncian desain; implementasi belum dimulai.

**Prinsip (dasar, tanpa angka):**
- Fenomena adalah **keadaan dunia berdata** yang memperluas jenis event dunia (D-029) dan sistem musim/cuaca (D-030); tidak memakai sistem terpisah. Setiap fenomena nantinya punya aturan kemunculan, dampak, dan akhir yang jelas (kewajiban kelengkapan, isinya belum ditetapkan).
- **Konsisten dengan waktu dan musim:** kemunculan dan akhir fenomena mengikuti waktu permainan internal (D-055), kalender, musim, dan cuaca; tidak memakai jam perangkat; hasil acak deterministik dari seed (anti save-scumming).
- **Perlindungan progres dan save:** fenomena tidak boleh menghapus atau merusak data save; kerugian bagi pemain (tanaman, hewan, sumber daya, bangunan) hanya lewat aturan eksplisit yang kelak ditetapkan, harus dapat diperkirakan atau diberi peringatan, dan tidak boleh membuat progres utama hilang atau pemain buntu (selaras D-058, D-063).
- **Adil dan dapat dipersiapkan:** pemain mendapat peringatan/isyarat dan pilihan untuk bersiap atau menghindar bila aturan menetapkan; pemain tidak dipaksa mengikuti setiap fenomena.
- **Dampak luas lewat sistem yang ada:** wilayah, NPC (D-040), tanaman (D-023), hewan (D-024), monster (D-019), sumber daya, eksplorasi (D-028), dan ekonomi (D-021) terpengaruh lewat efek data (termasuk status effect D-059), bukan kode khusus.
- **Event langka** tetap pilihan terkait; kelangkaan bukan jaminan angka.
- **Koneksi:** perilaku saat koneksi terganggu mengikuti D-051 (Connection Resilience; rincian durasi dan masa tenggang tetap terbuka); dasar D-055: koneksi tidak memajukan atau memundurkan waktu.
- **Live ops:** fenomena baru ditambah lewat update konten (D-048) sebagai data tanpa merusak save lama.
- Dunia pribadi per pemain (single-player online, D-014).

Hubungan (tidak mengubah isi keputusan lain): dunia (**D-009**), sistem kehidupan (**D-015**), dungeon (**D-016**), companion/monster (**D-019**), ekonomi (**D-021**), NPC (**D-022**), pertanian (**D-023**), peternakan (**D-024**), memancing (**D-025**), eksplorasi (**D-028**), event dunia (**D-029**), musim dan cuaca (**D-030**), UI/HUD (**D-031**), audio (**D-032**), NPC hidup (**D-040**), save/cloud (**D-044**), pengaturan dan aksesibilitas (**D-045**), update konten (**D-048**), QA (**D-049**), keamanan (**D-050**), performa (**D-052**), loading (**D-053**), peta (**D-054**), waktu (**D-055**), tidur (**D-056**), vitalitas (**D-057**), kekalahan (**D-058**), status effect (**D-059**), konflik (**D-063**). **D-051** (Connection Resilience) kini berlaku; isinya diterima setelah Tahap 60.

**Terbuka (tidak diputuskan):** katalog fenomena; frekuensi dan probabilitas; tingkat kerusakan; durasi; konsekuensi numerik; arti "spiritual" (belum didefinisikan); aturan peringatan dan perlindungan (rumah, ladang, bangunan); bagaimana kerugian dipulihkan; perilaku offline (terbuka di D-029) dan catch-up; interaksi dengan pertahanan/konflik (D-063); dampak ke peta dan fast travel; efek visual dan audio; romansa/pernikahan/keluarga/anak ditetapkan terpisah oleh D-066 (cakupan saja; detail belum final). Tahap 35 (akun/login) tetap PENDING (P-006).

### D-066 — Sistem Romansa, Pernikahan, dan Keluarga *(APPROVED / LOCKED, 2026-11-17, Tahap 57)*
Pilihan: **D. Romance & Family Hybrid Lengkap.** Ruang lingkup:
1. Persahabatan dan kedekatan dengan NPC.
2. Hubungan romantis.
3. Pertunangan (engagement).
4. Pernikahan (marriage).
5. Kehidupan bersama pasangan.
6. Memiliki anak.
7. Perkembangan keluarga dan kehidupan keluarga.

**PEMBARUAN BATASAN D-015 (resolusi eksplisit):**
- Pada D-015 (Tahap 5), hubungan romantis, pernikahan, membangun keluarga, dan memiliki anak **belum dipilih**. **D-066 kini menetapkan seluruh aspek itu sebagai bagian resmi permainan.** Untuk aspek romansa dan keluarga, **D-066 adalah keputusan terbaru** dan menggantikan batasan "belum ditetapkan" di D-015.
- **Tidak ada fitur kehidupan lain di D-015 yang dihapus atau diubah** (pertanian, peternakan, memancing, memasak, musim, festival, ekonomi, pengembangan rumah dan ladang, dan seterusnya tetap berlaku).
- Isi D-022 (pertemanan/kepercayaan), D-027 (rumah), dan D-039 (sosial) **tidak diubah**; D-066 menambah cakupan dan tidak mengganti isi keputusan tersebut. Catatan batasan di tiap tempat sudah ditandai "diperbarui oleh D-066".
- Hanya **cakupan** yang ditetapkan; **detail belum final** (lihat Terbuka).

Ketentuan:
- **Tidak ada kandidat pasangan, aturan kelayakan, kecepatan hubungan, mekanisme pernikahan, sistem anak, atau detail keluarga yang final** tanpa desain lanjutan.
- **Terintegrasi** dengan kehidupan harian NPC (D-040), dialog (D-038), hubungan sosial (D-039), kalender (D-055), rumah (D-027), dan event (D-029).
- **Perkembangan hubungan konsisten dan tersimpan** (D-044).
- Selaras dengan D-015, D-022, D-038, D-039, D-040, D-045, dan D-055.
- Penguncian desain; implementasi belum dimulai.

**Prinsip (dasar, tanpa isi final):**
- Hubungan berkembang bertahap dari persahabatan/kedekatan (D-039) hingga bentuk yang lebih jauh; tahapan, nama, dan syarat belum ditetapkan. Perkembangan harus **dapat dipahami, konsisten, dan tidak naik tidak masuk akal** (selaras D-039), serta **tersimpan** dan dapat dipulihkan.
- Hubungan individu tetap dibedakan dari reputasi komunitas, faksi, dan kriminal (D-039, D-062, D-064); tindakan di satu hubungan tidak otomatis mengubah yang lain kecuali lewat aturan eksplisit.
- NPC yang terlibat tetap mengikuti **kehidupan harian dan jadwal** (D-040) dan **waktu permainan internal** (D-055); peristiwa penting (pertunangan, pernikahan, kelahiran, perayaan) terkait **kalender dan event**, bukan jam perangkat.
- **Kehidupan bersama dan keluarga** terkait **rumah** (D-027) dan kehidupan sehari-hari; bentuknya belum diputuskan.
- Perubahan besar harus **aman bagi save dan progres** (penulisan atomik, idempoten; tidak ada kehilangan akibat gangguan koneksi, D-044; aturan koneksi mengikuti D-051, Connection Resilience; rincian tetap terbuka).
- Tetap **single-player online** (D-014): hubungan dengan NPC dalam dunia pribadi pemain; tidak ada pasangan atau keluarga antarpemain.
- Lokalisasi Indonesia/English dan aksesibilitas (D-045).

Hubungan (tidak mengubah isi keputusan lain): sistem kehidupan (**D-015**), NPC dan sosial (**D-022**), rumah (**D-027**), event dunia (**D-029**), UI/HUD (**D-031**), audio (**D-032**), dialog (**D-038**), hubungan sosial (**D-039**), NPC hidup (**D-040**), kustomisasi (**D-041**), save/cloud (**D-044**), pengaturan dan aksesibilitas (**D-045**), achievement (**D-046**), update konten (**D-048**), QA (**D-049**), keamanan (**D-050**), waktu (**D-055**), tidur (**D-056**), kekalahan (**D-058**), status effect (**D-059**), ras (**D-060**), organisasi dan faksi (**D-061**, **D-062**), hukum (**D-064**). **D-051** (Connection Resilience) kini berlaku; isinya diterima setelah Tahap 60.

**Terbuka (tidak diputuskan):** kandidat pasangan dan aturan kelayakan (termasuk pilihan pasangan); apakah dan bagaimana pemain dapat memilih untuk tidak mengikuti jalur ini (wajib/opsional) dan dampak ke progres; kecepatan dan tahapan hubungan; mekanisme pertunangan dan pernikahan; bentuk kehidupan bersama dan rumah bersama (D-027); sistem anak (cara, jumlah, usia, perkembangan) dan detail keluarga; peran keluarga dalam permainan; peringkat usia dan batas konten (mengikuti kebijakan toko, belum dirinci); pengaturan terkait (D-045); apakah ada perpisahan/kehilangan dan konsekuensinya; hubungan dengan ras/suku (D-060); arti "spiritual" (belum didefinisikan). Tahap 35 (akun/login) tetap PENDING (P-006).

### D-067 — Sistem Cerita Utama dan Alur Narasi Dunia *(APPROVED / LOCKED, 2026-11-17, Tahap 58)*
Pilihan: **D. Narrative World Hybrid Lengkap.** Ruang lingkup:
1. Cerita utama (main story).
2. Bab petualangan (adventure chapters).
3. Narasi bercabang (branching narratives).
4. Cerita pribadi NPC.
5. Rahasia dunia dan lore peradaban kuno.
6. Pilihan pemain dan konsekuensinya.
7. Beragam kemungkinan ending.
8. Integrasi narasi dengan quest, eksplorasi, faksi, diplomasi, romansa, dan event dunia.

Ketentuan:
- **Tidak ada plot final, daftar karakter utama, bab cerita, ending, atau detail percabangan** tanpa desain lanjutan.
- **Cerita utama berjalan berdampingan dengan kebebasan aktivitas farming dan kehidupan pemain.**
- **Pilihan pemain punya konsekuensi yang konsisten dan tercatat dalam progres.**
- **Cerita tidak memaksa pemain meninggalkan aktivitas kehidupan sehari-hari secara permanen.**
- Selaras dengan D-037, D-038, D-039, D-060, D-061, D-062, D-063, dan D-066.
- Penguncian desain; implementasi belum dimulai.

**Prinsip (dasar, tanpa isi cerita):**
- Narasi adalah **lapisan di atas sistem yang sudah ada**: quest (D-037), dialog (D-038), hubungan sosial (D-039), eksplorasi (D-028), event dunia (D-029), organisasi dan faksi (D-061, D-062), konflik (D-063), ras dan lore (D-060), romansa dan keluarga (D-066). Narasi tidak membuat sistem terpisah.
- **Kehidupan dan cerita berdampingan:** pemain dapat menjalani farming, kehidupan sehari-hari, dan cerita dengan ritme sendiri; cerita utama tidak mengharuskan meninggalkan kehidupan harian secara permanen, dan kehidupan harian tidak menutup akses ke cerita. Bagaimana tempo cerita diatur (mis. menunggu tindakan pemain) adalah detail yang belum ditetapkan.
- **Pilihan dan konsekuensi konsisten dan tercatat:** keputusan pemain tersimpan sebagai bagian progres (D-044) sehingga dapat dipulihkan, tidak berubah karena memuat ulang save, dan konsisten di seluruh sistem terkait; konsekuensi yang tidak dapat dibalik harus jelas bagi pemain.
- **Adil dan tidak buntu:** cerita tidak membuat progres hilang secara tidak wajar atau pemain terjebak tanpa jalan maju (selaras D-058, D-063); konten penting dapat dilanjutkan.
- **Beragam ending dan percabangan** dimungkinkan; jumlah, bentuk, dan syaratnya belum ditetapkan.
- **Cerita pribadi NPC dan rahasia dunia** dapat ditemukan lewat eksplorasi dan hubungan (D-039, D-028); rahasia tidak bocor sebelum ditemukan.
- **Lore peradaban kuno** dan identitas kelompok konsisten dengan D-060/D-061; tanpa diskriminasi tersembunyi.
- Waktu cerita mengikuti **waktu permainan internal** (D-055); koneksi terganggu mengikuti D-051 (Connection Resilience; rincian durasi dan masa tenggang tetap terbuka).
- Tetap **single-player online** (D-014); narasi bersifat pribadi per pemain.
- Teks mendukung Indonesia dan English (D-045); konten ditambah lewat update (D-048) tanpa merusak save lama.

Hubungan (tidak mengubah isi keputusan lain): dunia (**D-009**), sistem kehidupan (**D-015**), dungeon (**D-016**), guild (**D-017**), perkembangan karakter (**D-018**), NPC (**D-022**), eksplorasi (**D-028**), event dunia (**D-029**), musim dan cuaca (**D-030**), UI/HUD (**D-031**), audio (**D-032**), kamera (**D-033**), quest (**D-037**), dialog (**D-038**), hubungan sosial (**D-039**), NPC hidup (**D-040**), kustomisasi (**D-041**), tutorial (**D-043**), save/cloud (**D-044**), pengaturan (**D-045**), achievement (**D-046**), update konten (**D-048**), QA (**D-049**), keamanan (**D-050**), peta (**D-054**), waktu (**D-055**), kekalahan (**D-058**), ras (**D-060**), organisasi (**D-061**), diplomasi (**D-062**), konflik (**D-063**), hukum (**D-064**), fenomena (**D-065**), romansa dan keluarga (**D-066**). **D-051** (Connection Resilience) kini berlaku; isinya diterima setelah Tahap 60.

**Terbuka (tidak diputuskan):** plot, tema, dan nada cerita; karakter utama; struktur dan jumlah bab; titik percabangan, jumlah dan syarat ending; isi lore peradaban kuno dan rahasia dunia; tempo cerita terhadap kehidupan harian; apakah ada batas waktu cerita dan cara menghindari tekanan; cara pemain meninjau pilihan dan kemungkinan mengulang/menyesuaikan; cerita setelah ending (lanjut bermain); cara menyampaikan (adegan, kamera D-033, audio D-032); arti "spiritual" (belum didefinisikan); detail romansa dan keluarga (terbuka di D-066). Tahap 35 (akun/login) tetap PENDING (P-006).

### D-068 — Sistem Endgame dan Aktivitas Setelah Cerita Utama *(APPROVED / LOCKED, 2026-11-17, Tahap 59)*
Pilihan: **D. Endless Adventure Hybrid Lengkap.** Sistem endgame memungkinkan pemain **melanjutkan petualangan setelah cerita utama selesai.** Ruang lingkup:
1. Free play berkelanjutan: farming, beternak, memancing, memasak, berdagang, dan aktivitas kehidupan.
2. Dungeon endgame dengan tantangan dan tingkat kesulitan lanjutan.
3. Boss legendaris, monster langka, dan tantangan Guild tingkat tinggi.
4. Eksplorasi wilayah tersembunyi, reruntuhan kuno, dan dungeon rahasia.
5. Koleksi item, monster, perlengkapan, dan hadiah langka.
6. Perkembangan hubungan, pasangan, dan keluarga setelah cerita utama.
7. Tantangan dunia berkelanjutan yang memberi tujuan baru.
8. Integrasi dengan sistem dunia, kalender, NPC, ekonomi, Guild, dungeon, dan narasi yang sudah diputuskan.

Ketentuan:
- **Tidak mengubah keputusan resmi Tahap 1 sampai Tahap 58.**
- **Tidak bertentangan dengan sistem single-player online** (D-014).
- **Tidak ada detail cerita, hadiah, angka keseimbangan, atau mekanik final** tanpa desain lanjutan.
- Penguncian desain; implementasi belum dimulai.

**Prinsip (dasar, tanpa isi final):**
- **Dunia tetap berlanjut setelah cerita utama:** menyelesaikan cerita (D-067) tidak mengakhiri permainan; pemain dapat terus bermain di save yang sama dengan semua aktivitas kehidupan dan petualangan tetap tersedia. Bagaimana kondisi dunia setelah ending berbeda dari sebelumnya belum ditetapkan.
- **Endgame memakai sistem yang sudah ada:** dungeon (D-016), guild (D-017), companion/monster (D-019), equipment (D-020), ekonomi (D-021), eksplorasi (D-028), event dunia (D-029), achievement dan koleksi (D-046), dan lainnya; tidak membuat sistem paralel.
- **Tujuan baru, bukan pemaksaan:** tantangan lanjutan memberi tujuan, tetapi pemain bebas memilih (tidak dipaksa mengikuti semua tantangan); aktivitas kehidupan tetap bermakna tanpa harus mengejar tantangan tertinggi.
- **Progres dan save aman:** endgame tidak boleh merusak progres atau save; status penyelesaian cerita dan pilihan tetap tersimpan dan konsisten (D-044, D-067); tidak ada keadaan buntu.
- **Adil dan kosmetik:** hadiah langka tidak boleh menjadi cara membeli keunggulan (monetisasi hanya kosmetik, D-047); keamanan dan fitur dasar tetap gratis (D-050).
- **Waktu dan konsistensi:** semua tantangan berkelanjutan mengikuti waktu permainan internal dan kalender (D-055), tidak jam perangkat; hasil acak deterministik dari seed; perilaku koneksi terganggu mengikuti D-051 (Connection Resilience; rincian durasi dan masa tenggang tetap terbuka).
- **Tetap single-player online:** tidak ada leaderboard antarpemain atau kompetisi langsung yang ditetapkan di sini; bila kelak diinginkan, itu keputusan terpisah dan harus selaras dengan D-014.
- **Konten bertambah lewat live ops** (D-048) tanpa merusak save lama.

Hubungan (tidak mengubah isi keputusan lain): dunia (**D-009**), pertarungan (**D-013**), single-player online (**D-014**), sistem kehidupan (**D-015**), dungeon (**D-016**), guild (**D-017**), perkembangan karakter (**D-018**), companion/monster (**D-019**), equipment (**D-020**), ekonomi (**D-021**), NPC (**D-022**), pertanian sampai alkimia (**D-023** sampai **D-026**), rumah (**D-027**), eksplorasi (**D-028**), event dunia (**D-029**), musim/cuaca (**D-030**), UI/HUD (**D-031**), quest (**D-037**), hubungan sosial (**D-039**), NPC hidup (**D-040**), save/cloud (**D-044**), achievement (**D-046**), monetisasi (**D-047**), live ops (**D-048**), QA (**D-049**), keamanan (**D-050**), peta (**D-054**), waktu (**D-055**), kekalahan (**D-058**), status effect (**D-059**), ras (**D-060**), organisasi dan faksi (**D-061**, **D-062**, **D-063**), hukum (**D-064**), fenomena (**D-065**), romansa dan keluarga (**D-066**), cerita (**D-067**). **D-051** (Connection Resilience) kini berlaku; isinya diterima setelah Tahap 60.

**Terbuka (tidak diputuskan):** apa yang berubah di dunia setelah cerita selesai; daftar dan bentuk tantangan endgame; tingkat kesulitan dan skala (angka); boss legendaris dan monster langka (daftar, aturan); tantangan Guild tingkat tinggi dan hubungan dengan rank D-017; wilayah dan dungeon rahasia; daftar koleksi dan hadiah langka; sumber penghasil (sink) dan aturan ekonomi endgame; aturan pengulangan dan reset tantangan; apakah ada mode kesulitan tambahan atau new-game-plus; kelanjutan hubungan, pasangan, dan keluarga (detail terbuka di D-066); perilaku offline dan catch-up; arti "spiritual" (belum didefinisikan). Tahap 35 (akun/login) tetap PENDING (P-006).

### D-069 — Prioritas Konten, Versi Rilis, dan Roadmap Pengembangan *(APPROVED / LOCKED, 2026-11-17, Tahap 60)*
Pilihan: **D. Hybrid Release dan Roadmap Lengkap.** Ketentuan:
1. Versi awal harus memiliki **pengalaman inti yang utuh, stabil, dan layak dimainkan.**
2. **Tidak memaksakan** seluruh fitur, wilayah, cerita, dungeon, monster, dan konten endgame masuk rilis pertama.
3. Menyusun **roadmap pengembangan konten secara bertahap.**
4. Merencanakan penambahan wilayah, cerita, dungeon, boss, monster, aktivitas, dan fitur lewat **pembaruan terencana.**
5. Setiap pembaruan **mempertahankan kompatibilitas save, progres pemain, dan sistem yang berjalan.**
6. Mempertimbangkan **kapasitas perangkat Android, performa, ukuran unduhan, dan stabilitas.**
7. Mempertahankan **single-player online** dan **Cloud Save Supabase** (D-014, D-044).
8. **Tidak menetapkan tanggal rilis atau target biaya** tanpa data dan persetujuan yang diperlukan.

Dokumen: **`docs/design/RELEASE_SCOPE.md`** (baru) memuat prinsip rilis, arti "pengalaman inti utuh", **usulan** isi Rilis Awal, gerbang kelayakan, aturan pembaruan, dan daftar konflik beserta rekomendasi; **`docs/project/ROADMAP.md`** diperbarui dengan bagian roadmap rilis dan konten.

**Yang terkunci:** prinsip dan aturan di atas. **Yang BUKAN keputusan (usulan menunggu persetujuan pemilik, P-007):** isi final Rilis Awal, daftar konten per rilis, urutan gelombang pembaruan, dan kanal distribusi. Tidak ada tanggal, biaya, atau angka performa/ukuran.

**Koreksi pemilik setelah Tahap 60 (tanpa mengubah ketentuan D-069):**
1. D-014 berarti Single-Player Online dan **tidak otomatis mewajibkan sistem Account/Login tersedia pada Rilis Awal**; isi D-014 tidak diubah. Tahap 35 (Account/Login) tetap **DEFERRED** sampai persiapan publikasi Google Play (P-006). Catatan sebelumnya yang menyebut "D-014 mensyaratkan akun untuk rilis" **dikoreksi**. Pertanyaan teknis yang tersisa (identitas yang dipakai Cloud Save pada Rilis Awal tanpa Login) dicatat terbuka sebagai pertanyaan Q1 di proposal P-007, bukan diputuskan.
2. **Kanal distribusi APK publik sudah ditetapkan: GitHub Releases (D-005)**; catatan sebelumnya yang menyebutnya belum diputuskan **dikoreksi**. Persiapan Google Play merupakan pembahasan terpisah.
3. Istilah uji **"offline→online" diganti "uji putus koneksi→pemulihan koneksi"**; game bukan full offline (D-014, D-044, D-051).
4. **D-051 diterima** (Connection Resilience) dan dicatat resmi.
5. ROADMAP disusun ulang: ekspansi konten ditempatkan **setelah** Rilis Awal.
**Catatan yang masih tersisa dari daftar awal:** kriteria Fase 1 perlu penguncian detail lingkup Rilis Awal; target performa D-052 **belum diukur** dan wajib diukur nyata sebelum angka dipakai. Keputusan terkunci Tahap 1 sampai 59 **tidak diubah**.

Hubungan (tidak mengubah isi keputusan lain): dunia dan Progressive World Unlock (**D-009**), single-player online (**D-014**), seluruh sistem permainan **D-013** sampai **D-068** (D-069 hanya memilih seberapa banyak dibuka pada tiap rilis), save/cloud (**D-044**), pengaturan (**D-045**), monetisasi kosmetik (**D-047**), live ops dan update konten (**D-048**), QA (**D-049**), keamanan (**D-050**), performa (**D-052**), loading (**D-053**), endgame (**D-068**). **D-051** (Connection Resilience) kini berlaku; isinya diterima setelah Tahap 60.

**Terbuka (tidak diputuskan):** isi final Rilis Awal (P-007); apakah Rilis Awal memuat busur cerita yang selesai (D-067) atau cerita berlanjut lewat pembaruan; apakah romansa/keluarga (D-066) masuk Rilis Awal; matriks perangkat sasaran dan batas ukuran/performa; mekanisme pengiriman aset tambahan; urutan dan jadwal gelombang pembaruan; kebijakan analitik/privasi; arti "spiritual" (belum didefinisikan). Tahap 35 (akun/login) tetap PENDING (P-006).

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
| P-006 | Tahap 35: Sistem Akun dan Login Pemain (metode login, multi-perangkat, hapus akun, privasi) | Persiapan publikasi Google Play Store | **PENDING** (atas instruksi pemilik; dibahas saat persiapan publikasi; status tidak diubah); ditandai **DEFERRED** oleh pemilik (setelah Tahap 60): bukan syarat Rilis Awal via GitHub Releases; persiapan Google Play dibahas terpisah |
| P-007 | Persetujuan lingkup final Rilis Awal dan urutan pembaruan (**DRAFT PROPOSAL rev. 2** di `docs/design/RELEASE_SCOPE_PROPOSAL_P007.md`; jawaban pemilik Q1 sampai Q6 dimasukkan, belum dikunci; TBD T1 sampai T20 terbuka) | Rilis Awal via GitHub Releases (D-005) dan penguncian detail vertical slice | Menunggu persetujuan pemilik |
