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

**Batasan — BELUM ditetapkan (jangan dianggap disetujui):** hubungan romantis, pernikahan, membangun keluarga, memiliki anak.

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

**Batasan (tetap berlaku dari D-015):** hubungan **romantis, pernikahan, membangun keluarga, dan memiliki anak BELUM ditetapkan**. D-022 hanya menyebut hubungan **pertemanan dan kepercayaan**; jangan diartikan mencakup romansa.

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
**Penegasan:** tidak ada keputusan tentang kamar keluarga, pasangan, atau anak; romansa, pernikahan, keluarga, dan anak tetap belum ditetapkan (D-015).
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
**Terbuka:** daftar NPC dan penulisan dialog; format data dialog dan bahasa kondisi; tampilan UI (kotak teks, potret, kecepatan teks, lewati, riwayat percakapan); suara pengisi dan efek suara dialog; kamera saat percakapan; aturan prioritas bila beberapa dialog memenuhi syarat; batas jumlah pilihan; aturan pilihan terkunci (apakah alasan ditampilkan); cara menghindari pengulangan (penanda sudah dibicarakan, variasi); cakupan "reputasi" yang memengaruhi dialog; penanganan kata ganti/nama pemain di dua bahasa; aksesibilitas (ukuran teks); peran konsep "spiritual" (belum didefinisikan, tidak ditebak); romansa, pernikahan, keluarga (belum diputuskan, tidak dimodelkan). Implementasi dialog belum dimulai. ID D-038 tersedia saat dicatat (tanpa bentrokan).

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
**Terbuka:** skala dan tingkat friendship/trust (angka atau tahap) dan nama tingkatnya; daftar komunitas/tingkat reputasi (desa, kota, Guild, lainnya) dan ambangnya; rumus dan batas kenaikan/penurunan harian; preferensi hadiah dan cara menyampaikannya; aturan peluruhan atau pemulihan hubungan; cara memperbaiki hubungan setelah konsekuensi buruk; daftar friendship event dan pemicunya; bentuk indikator UI; bagaimana tindakan terlihat oleh NPC/komunitas (saksi, gosip); hubungan dengan rank dan reputasi Guild secara rinci; peran konsep "spiritual" (belum didefinisikan). **Romansa, pernikahan, keluarga, dan anak tetap BELUM diputuskan dan tidak dimodelkan;** friendship tidak boleh dianggap mencakupnya. Implementasi sosial belum dimulai. ID D-039 tersedia saat dicatat (tanpa bentrokan).

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
**Terbuka:** daftar NPC dan perannya; jenis dan jumlah kebutuhan NPC (apakah ada, seberapa rinci); model keputusan AI (mis. jadwal + utilitas ringan); jarak/tingkat LOD simulasi dan jumlah NPC aktif maksimum; aturan interaksi sosial antar-NPC (dampak ke pemain); aktivitas ekonomi NPC (dampak ke harga/pasokan); bentuk "perkembangan desa" dan pemicunya; aturan fallback dan penanganan terjebak secara rinci; perilaku NPC saat pertarungan/bencana; peran konsep "spiritual" (belum didefinisikan). **Romansa, pernikahan, keluarga, dan anak tetap BELUM diputuskan dan tidak dimodelkan.** Implementasi AI NPC belum dimulai. ID D-040 tersedia saat dicatat (tanpa bentrokan).

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
**Terbuka:** perilaku game bila koneksi putus berkepanjangan (jeda, mode terbatas, atau keluar ke menu) dan batas waktunya; metode login dan kebijakan multi-perangkat (sudah terbuka di D-014); jumlah slot save per akun (saat ini 3 lokal) dan apakah slot ikut cloud; aturan rinci resolusi konflik (pilihan pemain, penggabungan per bagian yang aman, atau pemenang otomatis dengan syarat); frekuensi dan ambang auto-save; batas ukuran payload dan retensi cadangan cloud; apa yang divalidasi server untuk ekonomi/rank (anti-curang); kebijakan hapus akun dan data; bentuk indikator UI; penanganan jam perangkat yang diubah; peran konsep "spiritual" (belum didefinisikan). Implementasi save/cloud belum dimulai (selain fondasi lokal yang sudah ada). ID D-044 tersedia saat dicatat (tanpa bentrokan).

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
| P-006 | Tahap 35: Sistem Akun dan Login Pemain (metode login, multi-perangkat, hapus akun, privasi) | Persiapan publikasi Google Play Store | **PENDING** (atas instruksi pemilik; dibahas saat persiapan publikasi; status tidak diubah) |
