# Usulan Lingkup Rilis Awal (P-007) — DRAFT PROPOSAL

> **Status: DRAFT PROPOSAL. BUKAN keputusan.** P-007 **tidak dikunci** sampai pemilik menyetujui atau merevisi tabel ini.
> Tidak mengubah keputusan resmi Tahap 1 sampai 60 (dan D-051). Tidak ada tanggal rilis, target biaya, jumlah konten final, atau angka performa/ukuran.
> Dasar: D-069, rekomendasi awal pemilik (setelah Tahap 60), dan keputusan terkunci. Dokumen induk: `RELEASE_SCOPE.md`. Roadmap: `../project/ROADMAP.md`.

**Fakta yang dipegang:** distribusi APK publik = **GitHub Releases (D-005)**; Account/Login (Tahap 35) = **DEFERRED** (P-006) dan bukan syarat Rilis Awal; Google Play dibahas terpisah; game **tidak** full offline (D-014, D-044, D-051); definisi "spiritual" masih **TBD**; target performa D-052 **belum diukur**.

## 1. Legenda status

| Kode | Arti |
|---|---|
| **WAJIB** | Harus ada di Rilis Awal (pengalaman inti utuh) |
| **UPDATE** | Boleh dirilis lewat pembaruan setelah Rilis Awal; bila tertulis "fondasi", struktur data/save-nya sudah disiapkan di Rilis Awal agar pembaruan kompatibel |
| **LANJUTAN** | Memang menunggu konten lanjutan (bukan sekadar fitur yang tertunda) |

## 2. Tabel per sistem

| # | Sistem (keputusan) | Status | Isi di Rilis Awal (usulan) | Ditunda ke pembaruan | Alasan |
|---|---|---|---|---|---|
| 1 | Pertanian (D-023) | **WAJIB** | Lingkaran tanam → rawat → panen → jual, mengikuti musim | Tanaman langka/tambahan (UPDATE) | Inti identitas game |
| 2 | Peternakan (D-024) | **WAJIB** | Hewan ternak dasar dan hasilnya | Jenis tambahan (UPDATE); hewan "spiritual" (LANJUTAN, arti TBD) | Disebut pemilik sebagai inti |
| 3 | Memancing (D-025) | **WAJIB** | Memancing dasar dengan ikan awal | Ikan langka (UPDATE) | Disebut pemilik sebagai inti |
| 4 | Memasak dan crafting (D-026 memasak, D-020 crafting dan perlengkapan) | **WAJIB** | Resep dan crafting dasar, perlengkapan awal | Resep dan set lanjutan (UPDATE) | Disebut pemilik; mendukung vitalitas (D-057) |
| 5 | Alkimia (D-026 alkimia) | **UPDATE** | Fondasi data efek; ramuan pemulihan dasar hanya bila diperlukan vitalitas (Q2) | Alkimia lanjut | Tidak disebut sebagai inti oleh pemilik |
| 6 | Rumah dan lahan (D-027) | **WAJIB** | Rumah dan ladang awal | Perluasan dan dekorasi lanjut (UPDATE); rumah keluarga (UPDATE) | Basis kehidupan pemain |
| 7 | Ekonomi dan perdagangan (D-021) | **WAJIB** | Toko, jual-beli, harga dasar | Perdagangan lanjutan (UPDATE) | Disebut pemilik |
| 8 | NPC, dialog, hubungan sosial (D-022, D-038, D-039) | **WAJIB** | NPC inti desa, dialog, hubungan dasar (friendship/trust) | NPC tambahan, cerita pribadi lanjutan (UPDATE) | Hubungan dasar NPC masuk Rilis Awal (pemilik) |
| 9 | NPC hidup, jadwal harian (D-040) | **WAJIB** | Kehidupan desa awal dengan jadwal dan LOD | Skala lebih besar (UPDATE) | Kehidupan desa disebut pemilik |
| 10 | Pertarungan (D-013) | **WAJIB** | Pertarungan dasar | Skill dan senjata lanjutan (UPDATE) | Disebut pemilik |
| 11 | Perkembangan karakter (D-018) | **WAJIB** | Progres dasar yang cukup untuk cerita Rilis Awal | Cabang lanjutan (UPDATE) | Pendukung combat dan quest |
| 12 | Monster musuh (D-019, sisi musuh) | **WAJIB** | Monster di wilayah awal dan dungeon awal | Monster tambahan (UPDATE); monster langka (LANJUTAN) | Pendukung combat |
| 13 | Companion dan taming (D-019, sisi companion) | **UPDATE** | Fondasi model makhluk bersama dan save | Companion/taming (Q3) | Tidak disebut sebagai inti; tetap punya fondasi karena identitas "adventure" |
| 14 | Dungeon (D-016) | **WAJIB** (awal) | Dungeon awal (jumlah belum ditetapkan, Q5) | Dungeon lanjutan dan rahasia (LANJUTAN) | Disebut oleh pemilik: lanjutan dirilis kemudian |
| 15 | Boss | **WAJIB** (boss cerita) | Boss yang menutup busur cerita Rilis Awal | Boss legendaris (LANJUTAN) | Pemilik: boss legendaris dirilis kemudian |
| 16 | Guild petualang (D-017) | **WAJIB** | Rank awal, papan quest | Rank tinggi, ujian, tantangan tinggi (UPDATE/LANJUTAN) | Disebut pemilik |
| 17 | Quest (D-037) | **WAJIB** | Quest utama dan sampingan wilayah awal | Quest tambahan (UPDATE) | Disebut pemilik |
| 18 | Eksplorasi wilayah awal (D-009, D-028) | **WAJIB** | Wilayah awal (jumlah belum ditetapkan, Q5) | Wilayah lanjutan (UPDATE); wilayah tersembunyi dan reruntuhan kuno (LANJUTAN) | Pemilik: wilayah tersembunyi dirilis kemudian |
| 19 | Peta dan navigasi (D-054) | **WAJIB** (dasar) | Peta, minimap, penanda quest | Fast travel lanjutan (UPDATE) | Dibutuhkan untuk eksplorasi |
| 20 | Waktu, kalender, tidur, vitalitas, kekalahan, status effect (D-055 s.d. D-059) | **WAJIB** (dasar) | Satu paket dasar yang konsisten | Katalog efek tambahan (UPDATE) | Menopang lingkaran inti |
| 21 | Musim dan cuaca (D-030) | **WAJIB** | Musim dan cuaca dasar | Cuaca ekstrem, bencana, fenomena (D-065) (LANJUTAN) | Musim menopang pertanian |
| 22 | Event dunia (D-029) | **WAJIB** (dasar) | Festival/event kalender dasar untuk kehidupan desa | Event langka (LANJUTAN) | Kehidupan desa |
| 23 | Ras, suku, asal-usul (D-060) | **WAJIB** (fondasi) | Data kelompok yang dibutuhkan cerita dan NPC awal | Kelompok tambahan (UPDATE) | Identitas dunia yang konsisten |
| 24 | Organisasi dunia (D-061) | **WAJIB** (fondasi) | Guild dan organisasi yang dibutuhkan cerita awal | Kerajaan, sekte, klan, aliansi, rahasia (UPDATE/LANJUTAN) | Hanya yang diperlukan cerita |
| 25 | Reputasi faksi dan diplomasi (D-062) | **UPDATE** | Fondasi data; belum tampil di UI | Fitur penuh | Bergantung banyak organisasi |
| 26 | Perang dan konflik (D-063) | **LANJUTAN** | Fondasi data saja | Konflik dunia | Menunggu konten organisasi lanjutan |
| 27 | Hukum, kejahatan, bounty (D-064) | **UPDATE** | Fondasi data | Fitur penuh | Tidak disebut sebagai inti |
| 28 | Hubungan NPC dasar (D-039, D-066 tahap awal) | **WAJIB** | Persahabatan dan kedekatan dengan NPC | , | Pemilik: hubungan dasar NPC masuk Rilis Awal |
| 29 | Romansa, pertunangan, pernikahan, keluarga, anak (D-066) | **UPDATE** (bertahap) | **Fondasi** model hubungan bertahap dan bagian save opsional; keputusan D-066 tetap utuh | Hubungan romantis, pertunangan, pernikahan, keluarga, anak dirilis bertahap (Q4) | Pemilik: dikembangkan bertahap tanpa menghapus D-066 |
| 30 | Cerita utama (D-067) | **WAJIB** | Satu busur utama **dengan penutup memuaskan** (lihat bagian 3) | Ekspansi cerita (LANJUTAN) | Pemilik: Rilis Awal punya cerita utama dengan penutup memuaskan |
| 31 | Free play setelah cerita (D-068, butir free play) | **WAJIB** | Dunia berlanjut setelah penutup; semua aktivitas kehidupan tetap tersedia | , | Dunia tidak boleh berhenti setelah ending |
| 32 | Endgame lengkap (D-068) | **LANJUTAN** | Tidak ada selain free play | Tantangan endgame, koleksi langka, dungeon dan boss lanjutan | Pemilik: dirilis kemudian |
| 33 | Kustomisasi karakter (D-041) | **UPDATE** | Opsi kosmetik minimal bila perlu (Q6) | Opsi lanjutan | Tidak inti |
| 34 | Mount (D-042) | **UPDATE** | Tidak ada | Mount | Tidak inti |
| 35 | Achievement dan koleksi (D-046) | **UPDATE** | Fondasi pencatat event | Katalog achievement | Tidak inti |
| 36 | Monetisasi kosmetik (D-047) | **UPDATE** | Usulan: tidak ada transaksi (Q6) | Katalog kosmetik berbayar | Distribusi Rilis Awal via GitHub Releases; keputusan pemilik |
| 37 | UI/HUD, audio, kamera, kontrol, interaksi, inventory (D-031 s.d. D-036) | **WAJIB** | Seluruh fondasi pemakaian | Poles dan opsi tambahan | Tanpa ini game tidak dapat dimainkan |
| 38 | Tutorial (D-043) | **WAJIB** | Tutorial bertahap untuk sistem Rilis Awal | Tutorial sistem baru (UPDATE) | Pengalaman inti utuh |
| 39 | Save, Load, Cloud Save (D-044) | **WAJIB** | Save lokal dan Cloud Save (identitas lihat Q1) | Peningkatan | D-014/D-044 |
| 40 | Ketahanan koneksi (D-051) | **WAJIB** | Sambung ulang, pemulihan sesi, perlindungan data belum sinkron, retry idempoten, status koneksi | Penyempurnaan | Online wajib; tanpa full offline |
| 41 | Pengaturan, aksesibilitas, lokalisasi Indonesia/English (D-045) | **WAJIB** | Pengaturan inti dan dua bahasa | Opsi tambahan | Kualitas dasar |
| 42 | Live ops dan pembaruan konten (D-048) | **WAJIB** (fondasi) | Versi konten, migrasi save, penanda fitur | Event live dan pembaruan terjadwal (UPDATE) | Syarat pembaruan berkelanjutan |
| 43 | QA, keamanan, performa, loading (D-049, D-050, D-052, D-053) | **WAJIB** | Uji otomatis, keamanan dasar, performa adaptif; **angka performa harus diukur nyata dulu** | Penyempurnaan | Stabil dan layak dimainkan |
| 44 | Account/Login (Tahap 35, P-006) | **DEFERRED** | **Bukan** syarat Rilis Awal | Dibahas saat persiapan publikasi Google Play | Keputusan pemilik |

## 3. Cerita utama yang diperlukan untuk Rilis Awal (kerangka struktural, BUKAN plot)

Plot, karakter utama, bab, dan ending tetap **TBD**. Yang diusulkan hanya syarat struktural agar penutup memuaskan:
1. Satu busur cerita utama **lengkap** (pembuka, tengah, klimaks, penutup) yang berlangsung di wilayah awal.
2. Pembuka yang mengenalkan dunia, desa, dan Guild bersama tutorial (D-043).
3. Konflik utama yang dapat diselesaikan dengan sistem Rilis Awal (pertarungan, dungeon awal, boss cerita).
4. **Penutup yang memuaskan dan tidak menghentikan permainan:** dunia berlanjut (free play).
5. Cerita pribadi dasar untuk NPC inti; pilihan pemain yang ada tersimpan dan konsisten (D-067).
6. Benang cerita yang dapat dilanjutkan oleh ekspansi **tanpa membatalkan penutup**; graf cerita bersifat tambahan (aditif) dan save Rilis Awal tetap valid.
7. Jumlah ending Rilis Awal: usulan **minimal satu ending utama lengkap**; variasi ending boleh menyusul (belum diputuskan).
8. Tidak memaksa pemain meninggalkan kehidupan harian secara permanen (D-067).

## 4. Status romansa dan keluarga (D-066)

- **D-066 tetap utuh dan tidak dihapus.**
- Rilis Awal (usulan): persahabatan dan kedekatan dengan NPC (WAJIB), ditambah **fondasi** model hubungan bertahap dan bagian save opsional.
- Hubungan romantis, pertunangan, pernikahan, kehidupan bersama, anak, dan perkembangan keluarga: **dikembangkan bertahap lewat pembaruan** (Q4: apakah tahap romantis awal masuk Rilis Awal).
- Syarat: save Rilis Awal harus dapat dimigrasikan ke fitur ini tanpa kehilangan data.

## 5. Daftar fitur yang ditunda ke pembaruan (ringkas)

- **Ekspansi dan konten lanjutan (LANJUTAN):** endgame lengkap; wilayah tersembunyi dan reruntuhan kuno; dungeon lanjutan dan rahasia; boss legendaris dan monster langka; ekspansi cerita; konflik dunia (D-063); cuaca ekstrem, bencana, dan fenomena (D-065).
- **Fitur bertahap (UPDATE):** romansa dan keluarga (D-066) setelah fondasi; companion/taming; alkimia lanjut; reputasi faksi dan diplomasi (D-062) penuh; hukum dan bounty (D-064) penuh; mount; kustomisasi lanjutan; achievement penuh; katalog kosmetik berbayar (D-047); event live.
- Catatan: nama wilayah, jumlah dungeon/boss/NPC, dan isi tiap pembaruan belum ditetapkan.

## 6. Pertanyaan untuk pemilik (perlu jawaban sebelum P-007 dikunci)

| # | Pertanyaan | Mengapa penting |
|---|---|---|
| Q1 | Tanpa Login (Tahap 35 DEFERRED), **identitas apa yang dipakai Cloud Save pada Rilis Awal?** Pilihan dasar: (a) identitas sementara/anonim yang dibuat otomatis, (b) Cloud Save ditunda sampai Tahap 35 (save lokal dengan perlindungan data), (c) login minimal hanya untuk Cloud Save. | D-014 menyebut akun dan login, sedangkan Tahap 35 DEFERRED; Cloud Save Supabase (RLS) butuh identitas. Dampak ke D-044 dan D-051. **Saya tidak memutuskan.** |
| Q2 | Apakah ramuan pemulihan dasar (alkimia) masuk Rilis Awal? | Vitalitas (D-057) menyebut ramuan sebagai sumber pemulihan |
| Q3 | Apakah companion/taming (D-019) masuk Rilis Awal atau pembaruan? | Bagian identitas "adventure" |
| Q4 | Apakah tahap romantis awal (sebelum pertunangan) masuk Rilis Awal atau semuanya bertahap? | Batas fondasi vs fitur |
| Q5 | Berapa wilayah awal, dungeon awal, dan NPC inti di Rilis Awal? (angka dari pemilik) | Menentukan beban konten dan ukuran |
| Q6 | Apakah Rilis Awal via GitHub Releases memuat transaksi kosmetik (D-047) dan opsi kustomisasi minimal? | Monetisasi dan kepatuhan |

## 7. Langkah setelah pemilik meninjau

Pemilik menyetujui atau merevisi tabel dan menjawab Q1 sampai Q6; barulah P-007 dikunci. Setelah itu dilakukan putaran penguncian detail lingkup Rilis Awal/vertical slice.
