# Usulan Lingkup Rilis Awal (P-007) — DRAFT PROPOSAL (rev. 2)

> **Status: DRAFT PROPOSAL. BUKAN keputusan.** P-007 **tidak dikunci** sampai pemilik menyetujui secara resmi.
> Rev. 2 memasukkan jawaban pemilik untuk Q1 sampai Q6 (diterima sebagai arahan, belum dikunci). Tidak mengubah keputusan resmi Tahap 1 sampai 60 dan D-051.
> Tidak ada tanggal rilis, target biaya, atau angka performa/ukuran. Induk: `RELEASE_SCOPE.md`. Roadmap: `../project/ROADMAP.md`.

**Fakta yang dipegang:** APK publik via **GitHub Releases (D-005)**; Account/Login permanen (Tahap 35) **DEFERRED** (P-006); Google Play dibahas terpisah; game **online, bukan full offline** (D-014, D-044, D-051); "spiritual" masih **TBD**; target performa D-052 **belum diukur**.

## 1. Jawaban pemilik atas Q1 sampai Q6 (ringkas)

| Q | Jawaban pemilik |
|---|---|
| Q1 | **Identitas anonim otomatis (Supabase Anonymous Auth)** untuk Cloud Save; tanpa username/password; siapkan account linking untuk login permanen; peringatan risiko kehilangan akses bila aplikasi dihapus sebelum ditautkan; keamanan dan kepemilikan save tetap dijaga |
| Q2 | **YA, Rilis Awal:** ramuan HP, stamina, mana; herbal dasar; crafting ramuan sederhana. Alkimia tingkat tinggi = pembaruan |
| Q3 | **YA, versi dasar:** companion dasar (mengikuti pemain, status dan hubungan, bantuan aktivitas sederhana, fungsi pendukung petualangan). Taming lanjutan, monster legendaris, evolusi, skill khusus = pembaruan |
| Q4 | **YA, tahap awal:** persahabatan, kedekatan, dialog berdasarkan hubungan, ketertarikan romantis awal, cerita personal NPC. Pertunangan, pernikahan, keluarga, anak = pembaruan. D-066 tetap berlaku |
| Q5 | **Target perencanaan:** 3 wilayah awal, 2 dungeon, 12 NPC inti bernama. Wilayah: (1) desa awal dan area pertanian, (2) hutan dan kawasan petualangan, (3) wilayah spiritual awal atau kawasan kuno. Dungeon: (1) utama terkait cerita, (2) opsional eksplorasi. **Target desain yang perlu divalidasi lewat estimasi produksi dan pengujian; bukan batas permanen** |
| Q6 | **Kustomisasi dasar masuk:** penampilan dasar, gaya dan warna rambut, pakaian awal, tanpa pengaruh statistik, dekorasi rumah dasar. **Transaksi kosmetik ditunda** sampai game stabil. D-047 berlaku: tidak menjual kekuatan, statistik, atau keunggulan gameplay |

## 2. Legenda

**WAJIB** = harus ada di Rilis Awal. **UPDATE** = boleh lewat pembaruan setelah Rilis Awal (fondasi data/save disiapkan bila tertulis). **LANJUTAN** = menunggu konten lanjutan.

## 3. Tabel per sistem

| # | Sistem (keputusan) | Status | Isi di Rilis Awal | Ditunda ke pembaruan | Alasan |
|---|---|---|---|---|---|
| 1 | Pertanian (D-023) | **WAJIB** | Tanam, rawat, panen, jual mengikuti musim | Tanaman langka/tambahan (UPDATE) | Inti identitas |
| 2 | Peternakan (D-024) | **WAJIB** | Hewan ternak dasar dan hasilnya | Jenis tambahan (UPDATE); hewan "spiritual" (LANJUTAN, arti TBD) | Inti |
| 3 | Memancing (D-025) | **WAJIB** | Memancing dasar, ikan awal | Ikan langka (UPDATE) | Inti |
| 4 | Memasak dan crafting (D-026, D-020) | **WAJIB** | Resep dan crafting dasar, perlengkapan awal | Resep dan set lanjutan (UPDATE) | Mendukung vitalitas (D-057) |
| 5 | Ramuan dasar dan herbal (D-026, D-020, D-057) | **WAJIB** (Q2) | Ramuan HP, stamina, mana; herbal dasar; crafting ramuan sederhana | , | Jawaban Q2; pemulihan lewat ramuan sudah ada di D-057 |
| 6 | Alkimia tingkat tinggi (D-026) | **UPDATE** (Q2) | Fondasi data efek saja | Ramuan lanjut, profesi Alchemist penuh | Jawaban Q2 |
| 7 | Rumah, lahan, dekorasi dasar (D-027) | **WAJIB** | Rumah dan ladang awal; dekorasi rumah dasar **non-berbayar** (Q6) | Perluasan, dekorasi lanjut (UPDATE); rumah keluarga (UPDATE) | Basis kehidupan |
| 8 | Ekonomi dan perdagangan (D-021) | **WAJIB** | Toko, jual-beli, harga dasar | Perdagangan lanjut (UPDATE) | Inti |
| 9 | NPC, dialog, hubungan sosial (D-022, D-038, D-039) | **WAJIB** | **12 NPC inti bernama** (target Q5), dialog berdasarkan hubungan | NPC tambahan (UPDATE) | Hubungan dasar masuk Rilis Awal |
| 10 | Cerita personal NPC (D-038, D-040, D-067) | **WAJIB** (dasar, Q4) | Cerita personal dasar untuk NPC inti (jumlah per NPC belum ditetapkan) | Cerita personal lanjutan (UPDATE) | Jawaban Q4 |
| 11 | NPC hidup, jadwal (D-040) | **WAJIB** | Kehidupan desa awal | Skala lebih besar (UPDATE) | Inti |
| 12 | Pertarungan (D-013) | **WAJIB** | Pertarungan dasar | Skill/senjata lanjutan (UPDATE) | Inti |
| 13 | Perkembangan karakter (D-018) | **WAJIB** | Progres dasar | Cabang lanjutan (UPDATE) | Pendukung |
| 14 | Monster musuh (D-019 sisi musuh) | **WAJIB** | Monster wilayah dan dungeon awal | Tambahan (UPDATE); langka/legendaris (LANJUTAN) | Pendukung combat |
| 15 | **Companion dasar** (D-019) | **WAJIB** (Q3) | Mengikuti pemain, status dan hubungan, bantuan aktivitas sederhana, fungsi pendukung petualangan | , | Jawaban Q3 |
| 16 | Taming lanjutan, evolusi, skill khusus, monster legendaris (D-019) | **UPDATE** / **LANJUTAN** (legendaris) | Fondasi data companion yang dapat diperluas | Semuanya | Jawaban Q3 |
| 17 | Dungeon (D-016) | **WAJIB** | **2 dungeon** (target Q5): utama terkait cerita; opsional eksplorasi | Dungeon lanjutan/rahasia (LANJUTAN) | Jawaban Q5 |
| 18 | Boss (D-016) | **WAJIB** (boss cerita) | Boss penutup busur cerita; boss dungeon opsional **belum ditetapkan** | Legendaris (LANJUTAN) | Pemilik: legendaris kemudian |
| 19 | Guild (D-017) | **WAJIB** | Rank awal, papan quest | Rank tinggi (UPDATE/LANJUTAN) | Inti |
| 20 | Quest (D-037) | **WAJIB** | Utama dan sampingan wilayah awal | Tambahan (UPDATE) | Inti |
| 21 | Eksplorasi dan wilayah (D-009, D-028) | **WAJIB** | **3 wilayah awal** (target Q5): desa dan pertanian; hutan dan petualangan; wilayah spiritual awal atau kawasan kuno | Wilayah lanjutan (UPDATE); wilayah tersembunyi dan reruntuhan kuno lanjutan (LANJUTAN) | Jawaban Q5; sifat wilayah 3 dan arti "spiritual" TBD |
| 22 | Peta dan navigasi (D-054) | **WAJIB** (dasar) | Peta, minimap, penanda quest | Fast travel lanjut (UPDATE) | Untuk eksplorasi |
| 23 | Waktu, tidur, vitalitas, kekalahan, status effect (D-055 s.d. D-059) | **WAJIB** (dasar) | Paket dasar konsisten | Katalog efek (UPDATE) | Menopang lingkaran inti |
| 24 | Musim dan cuaca (D-030) | **WAJIB** | Dasar | Cuaca ekstrem, bencana, fenomena D-065 (LANJUTAN) | Menopang pertanian |
| 25 | Event dunia (D-029) | **WAJIB** (dasar) | Festival/event kalender dasar | Event langka (LANJUTAN) | Kehidupan desa |
| 26 | Ras, suku (D-060); organisasi (D-061) | **WAJIB** (fondasi) | Hanya yang dibutuhkan cerita dan NPC awal | Tambahan (UPDATE/LANJUTAN) | Konsistensi dunia |
| 27 | Reputasi faksi dan diplomasi (D-062) | **UPDATE** | Fondasi data | Fitur penuh | Tidak inti |
| 28 | Perang dan konflik (D-063) | **LANJUTAN** | Fondasi data | Konflik dunia | Menunggu konten lanjutan |
| 29 | Hukum, bounty (D-064) | **UPDATE** | Fondasi data | Fitur penuh | Tidak inti |
| 30 | Persahabatan dan kedekatan NPC (D-039, D-066 tahap awal) | **WAJIB** | Friendship/trust, dialog berdasarkan hubungan | , | Pemilik |
| 31 | **Ketertarikan romantis awal** (D-066) | **WAJIB** (tahap awal, Q4) | Tahap awal saja; detail kandidat dan aturan **belum ditetapkan** (lihat TBD) | , | Jawaban Q4 |
| 32 | Pertunangan, pernikahan, kehidupan bersama, anak, keluarga (D-066) | **UPDATE** (bertahap) | **Fondasi** bagian save opsional `FamilyState` agar save kompatibel | Semua fitur ini | Jawaban Q4; D-066 tidak dihapus |
| 33 | Cerita utama (D-067) | **WAJIB** | Satu busur lengkap berpenutup (bagian 4) | Ekspansi cerita (LANJUTAN) | Pemilik |
| 34 | Free play pascacerita (D-068) | **WAJIB** | Dunia berlanjut | , | Dunia tidak berhenti |
| 35 | Endgame lengkap (D-068) | **LANJUTAN** | Hanya free play | Tantangan endgame, koleksi langka | Pemilik |
| 36 | **Kustomisasi dasar** (D-041) | **WAJIB** (Q6) | Penampilan dasar, rambut dan warna, pakaian awal; **tanpa pengaruh statistik** | Opsi lanjutan, kostum khusus (UPDATE) | Jawaban Q6 |
| 37 | Mount (D-042) | **UPDATE** | Tidak ada | Mount | Tidak inti |
| 38 | Achievement dan koleksi (D-046) | **UPDATE** | Fondasi pencatat event | Katalog | Tidak inti |
| 39 | **Transaksi kosmetik** (D-047) | **UPDATE** (ditunda, Q6) | **Tidak ada transaksi**; kosmetik Rilis Awal diperoleh lewat gameplay | Dibuka setelah game stabil; D-047 berlaku penuh | Jawaban Q6 |
| 40 | UI/HUD, audio, kamera, kontrol, interaksi, inventory (D-031 s.d. D-036) | **WAJIB** | Seluruh fondasi pemakaian | Poles | Tanpa ini tidak dapat dimainkan |
| 41 | Tutorial (D-043) | **WAJIB** | Bertahap untuk sistem Rilis Awal | Sistem baru (UPDATE) | Pengalaman inti |
| 42 | Save, Load, Cloud Save (D-044) | **WAJIB** | Save lokal + Cloud Save dengan **identitas anonim Supabase** (bagian 5) | Login permanen (Tahap 35, DEFERRED) | Jawaban Q1 |
| 43 | Penautan akun (account linking) | **WAJIB** (mekanisme disiapkan) / **DEFERRED** (login permanen) | Fondasi penautan dan peringatan risiko; **tampilan penautan di Rilis Awal belum diputuskan** | Login permanen Tahap 35 | Jawaban Q1 |
| 44 | Ketahanan koneksi (D-051) | **WAJIB** | Sambung ulang, pemulihan sesi, data belum sinkron, retry idempoten, status koneksi | Penyempurnaan | Online wajib |
| 45 | Pengaturan, aksesibilitas, lokalisasi Indonesia/English (D-045) | **WAJIB** | Inti dan dua bahasa | Opsi tambahan | Kualitas dasar |
| 46 | Live ops dan pembaruan (D-048) | **WAJIB** (fondasi) | Versi konten, migrasi save, penanda fitur | Event live (UPDATE) | Syarat pembaruan |
| 47 | QA, keamanan, performa, loading (D-049, D-050, D-052, D-053) | **WAJIB** | Uji otomatis, keamanan dasar, performa adaptif; **angka perlu diukur nyata** | Penyempurnaan | Stabil dan layak |
| 48 | Account/Login permanen (Tahap 35, P-006) | **DEFERRED** | **Bukan** syarat Rilis Awal | Saat persiapan Google Play | Pemilik |

## 4. Kebutuhan cerita utama Rilis Awal (kerangka, BUKAN plot)

1. Satu busur utama lengkap (pembuka, tengah, klimaks, penutup) di 3 wilayah awal.
2. Pembuka mengenalkan dunia, desa, Guild bersama tutorial (D-043).
3. Konflik utama dapat diselesaikan dengan sistem Rilis Awal (combat, dungeon utama, boss cerita).
4. Penutup memuaskan **tanpa menghentikan permainan** (free play).
5. Cerita personal dasar NPC inti; pilihan pemain tersimpan dan konsisten (D-067).
6. Benang untuk ekspansi tanpa membatalkan penutup; graf cerita aditif, save Rilis Awal tetap valid.
7. Jumlah ending: usulan minimal satu ending utama lengkap (belum diputuskan).
8. Plot, karakter utama, bab, ending: **TBD**.

## 5. Implikasi teknis Supabase Anonymous Auth dan account linking (Q1)

Dirujuk dari dokumentasi Supabase (Anonymous Sign-Ins); detail wajib diverifikasi ulang saat implementasi.

1. **Identitas anonim = pengguna nyata bertoken di perangkat.** Dokumentasi menyatakan pengguna anonim tidak dapat mengakses akunnya bila keluar, membersihkan data, atau memakai perangkat lain. **Maka hapus aplikasi, hapus data aplikasi, atau ganti HP = save cloud tidak dapat diakses, kecuali identitas sudah ditautkan.** Cloud Save anonim melindungi dari gangguan koneksi, **bukan** dari kehilangan perangkat/aplikasi. Pemulihan lintas perangkat dan setelah uninstall **tidak boleh diasumsikan** sebelum penautan.
2. **Penautan mempertahankan ID pengguna yang sama** (email/telepon lewat `updateUser`, atau OAuth lewat `linkIdentity`); save tidak dipindah, hanya identitasnya diperkuat. Menambah kata sandi mensyaratkan email/telepon terverifikasi dulu. `linkIdentity` OAuth butuh manual linking diaktifkan di proyek. **Metode penautan (email, Google, lainnya) belum diputuskan**; itu bagian Tahap 35.
3. **RLS:** pengguna anonim memakai peran `authenticated` seperti pemain permanen. Kebijakan harus berbasis `auth.uid() = player_id` dan bila perlu membedakan lewat klaim `is_anonymous` di JWT. Tidak boleh ada kebijakan yang menganggap `authenticated` sama dengan "punya akun permanen".
4. **Kepemilikan save:** `saves(player_id, slot)` dengan `player_id` = `auth.uid()`; tidak ada akses lintas pemain (D-014, D-050). Penautan tidak mengubah `player_id`.
5. **Sesi hilang atau tidak valid (D-051):** klien **tidak boleh diam-diam membuat identitas anonim baru** lalu mengunggah save, karena itu menyembunyikan hilangnya save lama. Perlu status jelas: identitas lama tidak ditemukan. Perlakuan save lokal yang masih ada (apakah boleh diikat ke identitas baru) = **TBD**, sensitif keamanan.
6. **Pencadangan Android:** apakah token sesi ikut dicadangkan Android dan dipulihkan setelah pasang ulang **tidak diasumsikan**; kebijakan (mengecualikan token dari cadangan atau tidak) = TBD dan perlu uji perangkat nyata.
7. **Penyalahgunaan:** pembuatan identitas anonim dapat dibanjiri; perlu pembatasan laju, pertimbangan CAPTCHA, dan **kebijakan pembersihan identitas anonim terlantar** (belum ditetapkan; kuota proyek dapat terbebani).
8. **Peringatan ke pemain:** dalam bahasa Indonesia/English; muncul saat pertama bermain dan berkala sebelum penautan; menjelaskan risiko hilang akses bila aplikasi dihapus. Teks, frekuensi, dan tempat tampil = TBD.
9. **Transaksi nanti:** saat transaksi kosmetik dibuka, usulan perlu akun yang telah ditaut (agar pembelian tidak hilang). Ini **belum keputusan**.
10. **Konfigurasi proyek:** Anonymous sign-ins harus diaktifkan di proyek Supabase (belum ada proyek dibuat). Tidak ada kode atau akun dibuat di tahap ini.

**Konsistensi:** D-014 butir "setiap pemain punya akun; registrasi dan login" tetap tertulis. Tafsir pemilik: akun anonim otomatis memenuhi "punya akun" pada Rilis Awal, registrasi/login permanen menyusul. Teks D-014 **tidak diubah**; mohon konfirmasi tafsir ini saat persetujuan resmi.

## 6. Pemeriksaan konsistensi dengan keputusan terkait

| Keputusan | Hasil |
|---|---|
| D-014 | Online tetap wajib; identitas anonim = akun otomatis. Catatan tafsir di atas |
| D-019 | Selaras: versi dasar vs lanjutan hanya mengatur kapan dirilis; isi D-019 tidak diubah. Monster taming dasar belum jelas masuk atau tidak (TBD) |
| D-034 | Tidak ada konflik. Kontrol tidak berubah; perintah companion sederhana memakai tombol aksi kontekstual dan tap-to-move yang sudah ada. (Kustomisasi relevan ada di D-041, juga diperiksa: selaras) |
| D-041 | Selaras: kustomisasi dasar tanpa pengaruh statistik sesuai butir 5 |
| D-044 | Selaras; pemulihan lintas perangkat ("Data Recovery") bersyarat pada penautan |
| D-047 | Selaras: transaksi ditunda; tidak menjual kekuatan/statistik/keunggulan. Dekorasi dasar gratis di Rilis Awal tidak bertentangan dengan butir dekorasi berbayar nanti |
| D-066 | Selaras: tahap awal masuk, sisanya bertahap; detail kandidat/kelayakan/opsional masih terbuka di D-066 |
| D-069 | Selaras: Q5 mengisi jumlah target; Q1 memerlukan penafsiran D-014 |
| Teknis | Pemulihan pasca-uninstall tidak dijanjikan; Fase 4 tidak boleh memuat kriteria "pulih setelah uninstall" sebelum penautan ada |

## 7. TBD yang masih membutuhkan keputusan

| # | TBD | Keterangan |
|---|---|---|
| T1 | Tampilan penautan akun di Rilis Awal | Hanya peringatan, atau juga tombol tautkan? Metode (email/Google)? Tahap 35 DEFERRED |
| T2 | Perlakuan saat identitas anonim hilang | Apakah save lokal dapat diikat ke identitas baru; pesan ke pemain |
| T3 | Pencadangan token sesi Android | Perlu uji perangkat nyata |
| T4 | Anti-penyalahgunaan dan pembersihan identitas anonim | Batas laju, CAPTCHA, retensi |
| T5 | Teks dan frekuensi peringatan risiko | Dua bahasa |
| T6 | Akun tertaut sebagai syarat transaksi nanti | Belum diputuskan |
| T7 | Kriteria "game stabil" untuk membuka transaksi kosmetik | Perlu definisi terukur |
| T8 | Companion: jumlah/jenis, apakah ada menjinakkan dasar | "Taming lanjutan" ditunda; "dasar" belum didefinisikan |
| T9 | Romansa awal: kandidat, kelayakan, opsional atau wajib, batas "ketertarikan awal", peringkat usia/kepatuhan toko | Terbuka di D-066; harus ditentukan sebelum implementasi |
| T10 | Wilayah: nama, isi, arti "spiritual", beda "kawasan kuno" Rilis Awal dengan "reruntuhan kuno/tersembunyi" lanjutan | "Spiritual" belum didefinisikan |
| T11 | Dungeon: skala, ada tidaknya boss di dungeon opsional, hadiah | Belum ditetapkan |
| T12 | 12 NPC inti: daftar, peran, mana yang menjadi kandidat romansa, cerita personal per NPC | Belum ditetapkan |
| T13 | Validasi angka 3/2/12 | Estimasi produksi dan pengujian (belum dilakukan) |
| T14 | Ramuan: jenis, efek, angka; sihir/mana bergantung D-013 | Angka belum diputuskan |
| T15 | Kustomisasi dasar: daftar opsi, tubuh/jenis kelamin, set pakaian, batas dekorasi dasar | Terbuka di D-041 |
| T16 | Plot, ending, jumlah ending | Cerita TBD |
| T17 | Detail angka D-051 (interval, batas, tampilan) | Terbuka |
| T18 | Target performa dan ukuran (D-052) | Perlu pengukuran nyata |
| T19 | Google Play (Tahap 35, kepatuhan, transaksi) | Pembahasan terpisah |
| T20 | Arti "spiritual" | TBD |

## 8. Fitur yang ditunda (ringkas)

- **LANJUTAN:** endgame lengkap; wilayah tersembunyi dan reruntuhan kuno lanjutan; dungeon dan boss lanjutan/legendaris; ekspansi cerita; konflik dunia; fenomena ekstrem; monster legendaris.
- **UPDATE:** pertunangan, pernikahan, keluarga, anak (D-066); taming lanjutan, evolusi, skill khusus; alkimia tingkat tinggi; faksi/diplomasi penuh; hukum penuh; mount; achievement penuh; transaksi kosmetik; kustomisasi lanjutan; event live; login permanen.

## 9. Langkah berikutnya

Pemilik memeriksa proposal ini dan memberi persetujuan resmi atau revisi (termasuk konfirmasi tafsir D-014 dan keputusan T1 sampai T20 sebagai prioritas). P-007 baru dikunci setelah itu; lalu dilakukan putaran penguncian detail lingkup Rilis Awal/vertical slice.
