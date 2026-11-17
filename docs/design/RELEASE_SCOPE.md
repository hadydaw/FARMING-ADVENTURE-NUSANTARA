# Release Scope — Farming Adventure Nusantara

> **Status:** Prinsip rilis (bagian 1) dan aturan pembaruan (bagian 5) **terkunci** oleh D-069. Isi Rilis Awal **belum dikunci**: tabel rinci ada di `RELEASE_SCOPE_PROPOSAL_P007.md` (**DRAFT PROPOSAL**, P-007, menunggu persetujuan pemilik).
> Tidak ada tanggal rilis, target biaya, atau angka performa/ukuran di dokumen ini (belum ada data dan persetujuan).
> Dokumen terkait: `DESIGN_DECISIONS.md` (D-069, D-051, D-014, D-005), `GDD.md` (§6.58, §6.59), `../project/ROADMAP.md`, `../technical/TECHNICAL_ARCHITECTURE.md` (§4az, §4ba).

## 1. Prinsip Rilis (terkunci oleh D-069)

1. **Rilis Awal** berisi **pengalaman inti yang utuh, stabil, dan layak dimainkan.**
2. **Tidak semua** fitur, wilayah, cerita, dungeon, monster, dan konten endgame dipaksakan masuk Rilis Awal. **Ekspansi bukan syarat Rilis Awal.**
3. Konten lain ditambahkan **bertahap lewat pembaruan terencana setelah Rilis Awal**.
4. **Setiap pembaruan** menjaga kompatibilitas save, progres pemain, dan sistem yang berjalan.
5. Lingkup mempertimbangkan kapasitas perangkat Android, performa, ukuran unduhan, dan stabilitas.
6. Tetap **single-player online** (D-014) dengan **Cloud Save Supabase** (D-044); **bukan** mode offline penuh. Gangguan koneksi ditangani oleh **Connection Resilience (D-051)**.
7. **Account/Login (Tahap 35) DEFERRED** (P-006) dan **tidak otomatis menjadi syarat Rilis Awal.** Arahan pemilik (draft, belum dikunci): Cloud Save memakai **identitas anonim otomatis (Supabase Anonymous Auth)** dengan persiapan account linking dan peringatan risiko; pemulihan setelah aplikasi dihapus **tidak dijamin** sebelum identitas ditautkan (lihat proposal P-007 §5).
8. **Kanal APK publik Rilis Awal: GitHub Releases (D-005).** Google Play dibahas terpisah saat persiapan publikasi.
9. Tanggal rilis dan target biaya tidak ditetapkan tanpa data dan persetujuan pemilik.
10. Lingkup rilis hanya memilih *seberapa banyak* dari sistem terkunci yang dibuka pada tiap rilis; keputusan desain tidak berubah.

## 2. Arti "Pengalaman Inti Utuh" (kriteria kualitatif; angka belum ada)

Rilis Awal dianggap utuh bila pemain dapat menjalani satu lingkaran bermain dari awal sampai penutup cerita tanpa jalan buntu:
- Memulai permainan (tutorial D-043), mengelola rumah/ladang, bertani, memasak, menjual (D-023, D-026, D-027, D-021).
- Hidup di desa dengan NPC, hubungan dasar, dan quest (D-022, D-037 s.d. D-040), terhubung ke Guild (D-017).
- Menjelajah wilayah awal, bertarung, dan menyelesaikan tantangan dungeon awal (D-013, D-016, D-028).
- Waktu, tidur, vitalitas, dan pemulihan dari kekalahan konsisten (D-055 s.d. D-058).
- Cerita utama yang selesai dengan penutup yang memuaskan, lalu dunia tetap dapat dimainkan (D-067, D-068).
- Progres tersimpan aman: Cloud Save dan ketahanan koneksi (D-044, D-051).
- Pengaturan, aksesibilitas, dua bahasa (D-045).
- Stabil dan cukup cepat di perangkat Android sasaran (D-052; **target belum diukur**).

## 3. Isi Rilis Awal

Tabel per sistem (WAJIB / UPDATE / LANJUTAN), jawaban pemilik Q1 sampai Q6, kebutuhan cerita utama, implikasi teknis identitas anonim, pemeriksaan konsistensi, dan daftar TBD (T1 sampai T20) ada di **`RELEASE_SCOPE_PROPOSAL_P007.md`**. Itu **DRAFT PROPOSAL**; belum keputusan. Ringkasan arah usulan:
- **WAJIB:** pertanian, peternakan, memancing, memasak/crafting dan ramuan dasar, ekonomi, NPC dan kehidupan desa (target 12 NPC inti), pertarungan, companion dasar, quest, Guild awal, target 3 wilayah dan 2 dungeon, romansa tahap awal, kustomisasi dasar, cerita utama berpenutup, dan seluruh fondasi platform (save/Cloud Save, ketahanan koneksi, pengaturan, tutorial, lokalisasi, keamanan, QA).
- **UPDATE (fondasi di Rilis Awal bila perlu):** pertunangan, pernikahan, keluarga, anak (D-066 tetap utuh), taming lanjutan/evolusi, alkimia tingkat tinggi, faksi/diplomasi, hukum, mount, achievement, transaksi kosmetik (ditunda), event live, login permanen.
- **LANJUTAN:** endgame lengkap, wilayah tersembunyi, dungeon dan boss lanjutan/legendaris, ekspansi cerita, konflik dunia, fenomena ekstrem.

## 4. Gerbang Kelayakan Rilis Awal (checklist; tanpa angka)

- [ ] Lingkaran inti dapat dimainkan tuntas di perangkat nyata (P-005 menutup Fase 0).
- [ ] Uji otomatis headless di CI hijau, termasuk uji migrasi save dari fixture (D-048, D-049).
- [ ] Performa **terukur** di matriks perangkat yang disetujui; target D-052 **perlu pengukuran nyata**, tidak ada klaim sebelum diukur.
- [ ] Ukuran unduhan dan memori diukur dan diterima pemilik.
- [ ] **Uji putus koneksi → pemulihan koneksi** lulus (D-051): sambung ulang, pemulihan sesi, data belum sinkron aman, retry idempoten.
- [ ] Cloud Save dengan identitas anonim teruji, termasuk perilaku saat sesi hilang; pemulihan lintas perangkat hanya bila identitas sudah ditautkan. Tahap 35 **tidak** disyaratkan (DEFERRED).
- [ ] Keamanan dasar (D-050) dan kebijakan privasi.
- [ ] Kunci production dibuat dan dicadangkan (P-002); penandatanganan teruji.
- [ ] Persetujuan pemilik atas lingkup final Rilis Awal (P-007).

## 5. Aturan Pembaruan (terkunci oleh D-069, memakai D-044 dan D-048)

- Save berversi; migrasi **aditif dan idempoten**; cadangan sebelum migrasi; save lama selalu dapat dimuat.
- Konten baru berupa **data ber-ID stabil**; ID tidak dihapus atau dipakai ulang.
- Konten baru **tidak** menulis ulang dunia save lama; muncul lewat kondisi data dan pembukaan progresif.
- Setiap pembaruan lolos uji fixture save semua versi sebelumnya, uji regresi performa, dan catatan rilis (`CHANGELOG.md`).
- Fitur belum rilis disembunyikan lewat penanda fitur data tanpa menghapus keputusan desainnya.
- Pembaruan tidak mensyaratkan pembelian untuk konten gameplay penting (D-047).
- Perubahan keputusan terkunci memerlukan keputusan baru dari pemilik.

## 6. Belum Ditetapkan

Tanggal rilis dan target biaya; tampilan penautan akun dan perlakuan saat identitas anonim hilang (T1, T2); isi final Rilis Awal (P-007); validasi target 3 wilayah, 2 dungeon, 12 NPC (T13); isi tiap pembaruan; matriks perangkat dan batas ukuran/performa; kebijakan analitik dan privasi; detail D-051 (interval, batas, tampilan status); arti "spiritual" (TBD); Google Play (terpisah).

## 7. Koreksi dan Ketidakselarasan (diperbarui setelah koreksi pemilik)

| # | Ketidakselarasan | Status |
|---|---|---|
| 1 | ROADMAP lama menaruh ekspansi sebelum rilis. | **Diperbaiki:** ekspansi menjadi pembaruan setelah Rilis Awal (ROADMAP G0 s.d. G7+). |
| 2 | Istilah "uji offline→online". | **Diperbaiki:** diganti "uji putus koneksi → pemulihan koneksi" (game tidak full offline). |
| 3 | Kanal distribusi dianggap belum diputuskan. | **Diperbaiki:** GitHub Releases (D-005); Google Play terpisah. |
| 4 | Login dianggap syarat rilis karena teks D-014. | **Diperbaiki:** Tahap 35 DEFERRED; bukan syarat Rilis Awal. Teks D-014 tidak diubah; tegangan dengan Cloud Save dicatat sebagai Q1. |
| 5 | D-051 belum diterima. | **Selesai:** D-051 dicatat (§6.59, TA §4ba); detail angka terbuka. |
| 6 | Kriteria Fase 1 menuntut GDD tanpa bagian kritis terbuka. | Terbuka: butuh putaran penguncian detail setelah P-007. |
| 7 | Target performa D-052 belum diukur. | Terbuka: perlu pengukuran perangkat nyata; tidak ada angka estimasi disajikan sebagai hasil uji. |
