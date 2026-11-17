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
