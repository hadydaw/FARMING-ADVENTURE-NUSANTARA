# Development Rules — Farming Adventure Nusantara

## 1. Aturan Proyek (dari pemilik, wajib)

1. **Jangan** memakai source code proyek lama.
2. **Jangan** mencampur aset atau dokumentasi proyek lama.
3. **Jangan** mengganti judul resmi: **Farming Adventure Nusantara**.
4. **Jangan** mengubah keputusan desain yang sudah ditetapkan (`DESIGN_DECISIONS.md` bagian A).
5. Keputusan teknis rutin diambil mandiri; jangan meminta persetujuan untuk pekerjaan teknis kecil.
6. Laporkan hal yang butuh **akses, kredensial, biaya, atau keputusan khusus** pemilik (catat di `DESIGN_DECISIONS.md` bagian C).
7. Dokumentasikan setiap perkembangan (`PROGRESS_LOG.md`).
8. Setiap tahap harus punya **hasil yang dapat diperiksa**.
9. **Jangan implementasi gameplay** sebelum desain sistem terkait ditetapkan dan dicatat.

## 2. Aturan Bukti

- Klaim "selesai" harus punya bukti: CI hijau, output uji, APK yang benar-benar dibangun, atau tangkapan layar dari game yang benar-benar dijalankan.
- Jangan menyimpulkan "tidak bisa" sebelum mencoba cara lain; jangan meminta pemilik menguji hal yang bisa diuji otomatis.
- Bila sesuatu belum terbukti (mis. build di CI), tulis **belum terbukti** di log, bukan "selesai".

## 3. Git

- Cabang `main` harus selalu dapat dibangun. Pekerjaan besar lewat cabang `feat/…`, `fix/…`, `docs/…` lalu merge.
- Pesan commit gaya Conventional Commits: `feat:`, `fix:`, `docs:`, `build:`, `ci:`, `refactor:`, `test:`, `chore:`; ringkas, bahasa Indonesia atau Inggris konsisten per commit.
- Satu perubahan logis per commit. Jangan commit: kunci rilis, `.env`, `.godot/`, hasil build.
- Versi memakai SemVer; rilis ditandai tag `vX.Y.Z` (lihat `BUILD_AND_RELEASE.md`).

## 4. Kode (GDScript)

- Gaya resmi GDScript: tab, `snake_case` fungsi/variabel, `PascalCase` kelas, `UPPER_SNAKE` konstanta.
- Beri tipe statis pada variabel dan fungsi publik.
- Komentar menjelaskan **alasan**, bukan mengulang kode. Dokumentasi kelas dengan `##`.
- Tidak ada string UI di kode: pakai kunci terjemahan (`tr("KEY")`) dan tambahkan `id` **dan** `en`.
- Tidak ada angka keseimbangan hardcode: taruh di data (`game/data/`).
- Jaringan hanya lewat `BackendClient`.
- Fitur baru yang punya logika wajib punya uji di `tools/ci/` (atau folder uji bila nanti dibuat) yang berjalan headless di CI.

## 5. Aset

- Model: glTF 2.0 `.glb`; tekstur PNG; audio OGG. Nama berkas `snake_case` huruf kecil, awalan kategori (`char_`, `mon_`, `bld_`, `crop_`, `env_`, `ui_`, `sfx_`, `bgm_`).
- Semua aset harus **asli, berlisensi jelas, atau buatan sendiri**; catat sumber dan lisensi di `docs/project/ASSET_CREDITS.md` (dibuat saat aset pertama masuk). Aset dari proyek lama dilarang.
- Patuhi anggaran performa (`TECHNICAL_ARCHITECTURE.md` §3). Ukuran APK dipantau tiap rilis.
- Gaya visual **3D Stylized yang konsisten** (D-008); art direction rinci menyusul.
- **Semua aset visual dibuat lewat ChatGPT** (O-009); Claude hanya mengintegrasikan. Tidak ada placeholder yang diklaim final; placeholder berlabel "PLACEHOLDER" dan tercatat di `docs/assets/ASSET_MASTER_LIST.md`. Lihat `docs/project/PRODUCTION_WORKFLOW.md`.

## 6. Dokumentasi

- Perubahan desain → perbarui GDD dan tambah entri `DESIGN_DECISIONS.md` **sebelum** kode.
- Perubahan teknis penting → entri keputusan baru (jangan hapus riwayat; tandai yang digantikan).
- Setiap sesi kerja → entri `PROGRESS_LOG.md` (apa yang selesai, bukti, kendala, langkah berikut).
- Rilis → `CHANGELOG.md`.

## 7. Keamanan

- Tidak ada rahasia di repo. Kunci rilis hanya di GitHub Secrets + cadangan pribadi pemilik.
- APK dev memakai kunci publik; tidak boleh disebarkan sebagai rilis.
- Data pemain dari klien tidak dipercaya untuk fitur online yang rawan curang (validasi di server).

## 8. Definisi "Selesai" untuk Sebuah Tahap

1. Fungsi bekerja dan terbukti (uji/CI/perangkat).
2. Dokumen terkait diperbarui.
3. Entri log + commit pada `main`.
4. Tidak ada peringatan/error baru di CI.
