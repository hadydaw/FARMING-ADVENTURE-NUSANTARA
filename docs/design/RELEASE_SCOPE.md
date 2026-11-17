# Release Scope — Farming Adventure Nusantara

> **Status:** Draf pengunci prinsip (D-069, Tahap 60). **Yang terkunci** hanya prinsip rilis di bagian 1 dan aturan pembaruan di bagian 5. Daftar isi Rilis Awal pada bagian 3 berstatus **USULAN, menunggu persetujuan pemilik (P-007)**; bukan keputusan.
> **Tidak ada** tanggal rilis, target biaya, atau angka performa/ukuran di dokumen ini (belum ada data dan persetujuan).
> Dokumen terkait: `DESIGN_DECISIONS.md` (D-069), `GDD.md` (§6.58), `../project/ROADMAP.md`, `../technical/TECHNICAL_ARCHITECTURE.md` (§4az, §4ag).

## 1. Prinsip Rilis (terkunci oleh D-069)

1. **Rilis Awal** harus berisi **pengalaman inti yang utuh, stabil, dan layak dimainkan.**
2. **Tidak semua** fitur, wilayah, cerita, dungeon, monster, dan konten endgame dipaksakan masuk Rilis Awal.
3. Konten lain ditambahkan **bertahap lewat pembaruan terencana** (wilayah, cerita, dungeon, boss, monster, aktivitas, fitur).
4. **Setiap pembaruan** menjaga kompatibilitas save, progres pemain, dan sistem yang berjalan.
5. Lingkup mempertimbangkan **kapasitas perangkat Android, performa, ukuran unduhan, dan stabilitas.**
6. Tetap **single-player online** dengan **Cloud Save Supabase** (D-014, D-044).
7. **Tanggal rilis dan target biaya tidak ditetapkan** tanpa data dan persetujuan pemilik.
8. Desain terkunci tidak berubah karena rilis bertahap; lingkup rilis hanya memilih *seberapa banyak* dari sistem terkunci yang dibuka pada tiap rilis.

## 2. Arti "Pengalaman Inti Utuh" (kriteria kualitatif; angka belum ada)

Rilis Awal dianggap utuh bila pemain dapat menyelesaikan satu lingkaran bermain dari awal sampai akhir tanpa jalan buntu:
- Memulai permainan (tutorial D-043), mengelola rumah/ladang, bertani dan menjual/memasak (D-023, D-026, D-027, D-021).
- Berinteraksi dengan NPC dan memperoleh quest (D-022, D-037, D-038, D-039, D-040), terhubung ke Guild (D-017).
- Menjelajah, bertarung, dan menyelesaikan tantangan dungeon awal (D-013, D-016, D-028).
- Waktu, tidur, vitalitas, dan pemulihan dari kekalahan bekerja konsisten (D-055 sampai D-058).
- Progres tersimpan aman, termasuk Cloud Save dan akun (D-044; akun/login = Tahap 35, P-006).
- Pengaturan, aksesibilitas, dan dua bahasa (Indonesia/English) (D-045).
- Stabil dan cukup cepat di perangkat Android sasaran (D-052; **target belum diukur**).

## 3. Isi Rilis Awal — USULAN (menunggu persetujuan pemilik, P-007)

| Area (keputusan) | Usulan untuk Rilis Awal | Ditambahkan lewat pembaruan |
|---|---|---|
| Pertanian (D-023) | Lingkaran dasar tanam, rawat, panen, jual | Tanaman tambahan, varietas langka |
| Peternakan, memancing, memasak, alkimia (D-024 s.d. D-026) | Versi dasar yang mendukung lingkaran inti (cakupan rinci belum diputuskan) | Jenis tambahan, resep, alkimia lanjut |
| Rumah dan lahan (D-027) | Rumah dan ladang awal | Pengembangan lanjut |
| Ekonomi dan perdagangan (D-021) | Toko dan harga dasar | Perdagangan lanjut |
| NPC, dialog, sosial (D-022, D-038 s.d. D-040) | Sejumlah NPC inti dengan hubungan dasar | NPC tambahan, cerita pribadi |
| Quest dan cerita (D-037, D-067) | Quest awal; **apakah Rilis Awal memuat busur cerita yang selesai belum diputuskan** | Bab tambahan, percabangan |
| Guild (D-017) | Rank awal | Rank lebih tinggi |
| Pertarungan, monster, companion (D-013, D-019) | Pertarungan dasar, monster awal | Monster, skill, companion tambahan |
| Dungeon dan boss (D-016) | Dungeon dan boss awal (selaras vertical slice) | Dungeon dan boss tambahan |
| Dunia dan peta (D-009, D-028, D-054) | Wilayah awal dan peta dasar | Wilayah lewat Progressive World Unlock |
| Romansa dan keluarga (D-066) | **Belum diputuskan** apakah masuk Rilis Awal | Bertahap |
| Faksi, konflik, hukum, fenomena (D-061 s.d. D-065) | Lapisan dasar bila diperlukan cerita (belum diputuskan) | Bertahap |
| Endgame (D-068) | Ditunda | Pascarilis |
| Mount, kustomisasi, achievement (D-041, D-042, D-046) | Sebagian kosmetik/dasar (belum diputuskan) | Bertahap |
| Fondasi platform: save, akun, pengaturan, tutorial, lokalisasi, keamanan, performa, QA (D-043 s.d. D-045, D-049, D-050, D-052) | **Wajib** sebagai kualitas dasar | Peningkatan |

Catatan: kolom usulan adalah arah awal agar pemilik dapat menyetujui, mengubah, atau menolak. Tidak ada daftar wilayah, NPC, monster, atau hadiah final.

## 4. Gerbang Kelayakan Rilis Awal (checklist; tanpa angka)

- [ ] Lingkaran inti dapat dimainkan tuntas di perangkat nyata (bukti uji perangkat; P-005 menutup Fase 0).
- [ ] Uji otomatis headless di CI hijau, termasuk uji migrasi save dari fixture (D-048, D-049).
- [ ] Performa **terukur** di matriks perangkat yang disetujui; tidak ada klaim sebelum pengukuran (D-052).
- [ ] Ukuran unduhan dan memori diukur dan diterima pemilik (batas dan mekanisme pengiriman aset belum diteliti).
- [ ] Cloud Save, akun, dan pemulihan lintas perangkat teruji; **Tahap 35 diputuskan dan selesai** (P-006).
- [ ] Penanganan gangguan koneksi sesuai **D-051** (isi belum diterima; harus diterima lebih dulu).
- [ ] Keamanan dasar sesuai D-050; kebijakan privasi; peringkat usia dan kepatuhan toko bila toko dipakai.
- [ ] Kunci rilis production dibuat dan dicadangkan (P-002) dan penandatanganan teruji.
- [ ] Kanal distribusi publik disetujui pemilik (P-007).
- [ ] Persetujuan pemilik atas lingkup final Rilis Awal (P-007).

## 5. Aturan Pembaruan (terkunci oleh D-069, memakai D-044 dan D-048)

- Save berversi dan migrasi **aditif dan idempoten**; cadangan sebelum migrasi; save sebelumnya selalu dapat dimuat.
- Konten baru berupa **data ber-ID stabil**; ID tidak dihapus atau dipakai ulang; yang usang ditandai deprecated.
- Konten baru **tidak** menulis ulang dunia save lama; muncul lewat kondisi data dan pembukaan progresif.
- Setiap pembaruan lolos uji save fixture dari semua versi rilis sebelumnya, uji regresi performa, dan catatan rilis (`CHANGELOG.md`).
- Fitur yang belum dirilis disembunyikan lewat penanda fitur data tanpa menghapus keputusan desainnya.
- Pembaruan tidak boleh mensyaratkan pembelian untuk konten gameplay penting (D-047).
- Pembaruan tidak mengubah keputusan desain terkunci; perubahan keputusan memerlukan keputusan baru dari pemilik.

## 6. Belum Ditetapkan

Tanggal rilis dan target biaya; kanal distribusi publik; isi final Rilis Awal (P-007); daftar wilayah, cerita, dungeon, boss, monster, dan aktivitas per rilis; urutan final gelombang pembaruan; matriks perangkat sasaran dan batas ukuran/performa; kebijakan analitik dan privasi; jadwal pembaruan.

## 7. Konflik Dokumen dan Rekomendasi

| # | Konflik/ketidakselarasan | Rekomendasi |
|---|---|---|
| 1 | `ROADMAP.md` lama menaruh Fase 5 (Ekspansi Konten, rank F → SSS, cerita) **sebelum** Fase 6 (Rilis 1.0), seolah Rilis 1.0 memuat seluruh ekspansi. Ini bertentangan dengan D-069. | Pisahkan: Rilis Awal berlingkup inti, lalu pembaruan berkala. Ditandai sebagai catatan di ROADMAP; urutan fase belum dihapus sampai pemilik menyetujui. |
| 2 | Fase 4 di ROADMAP menyebut "uji offline→online"; D-014/D-044 menetapkan game online (cache lokal bukan mode offline penuh). | Ubah ke "uji putus koneksi→pulih" setelah D-051 diterima. |
| 3 | ROADMAP menyebut rilis publik di GitHub Releases; Tahap 35 (P-006) terkait persiapan Google Play. Kanal publik belum diputuskan. | Pemilik memutuskan kanal (P-007); akun/login wajib diputuskan sebelum rilis publik apa pun yang memerlukan akun. |
| 4 | Kriteria Fase 1 menuntut GDD tanpa bagian kritis [BELUM DITETAPKAN] untuk lingkup vertical slice, padahal banyak detail terbuka. | Setelah P-007, lakukan satu putaran "penguncian detail" khusus lingkup Rilis Awal/vertical slice. |
| 5 | D-051 (Tahap 42, "Connection Resilience") tidak pernah diterima, padahal gerbang stabilitas rilis bergantung padanya. | Pemilik mengirim isi D-051 sebelum Fase 4. |
| 6 | Tahap 35 (akun/login) PENDING, tetapi D-014 mewajibkan akun dan Cloud Save untuk rilis. | Jadwalkan Tahap 35 sebelum Fase 4/rilis publik; status tidak diubah sekarang. |
| 7 | Target performa (D-052) belum diukur sehingga kriteria performa rilis belum dapat memakai angka. | Ukur di perangkat nyata dulu; lalu setujui matriks dan batas bersama pemilik. |
