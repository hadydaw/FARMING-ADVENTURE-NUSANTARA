# Daftar Induk Aset

Status: Requested -> Generated -> Approved -> Integrated -> Tested.
Kolom: ID, Nama, Kategori, Gambar referensi, Ukuran/format, Animasi/frame, Lokasi berkas, Status, Catatan revisi.

## A. Aset yang ada saat ini (bukan aset final)

| ID | Nama | Kategori | Referensi | Ukuran/format | Animasi | Lokasi | Status | Catatan |
|---|---|---|---|---|---|---|---|---|
| A-000 | Ikon aplikasi sementara | ui_icon | - | SVG | - | `icon.svg` | **PLACEHOLDER** (Requested) | Harus diganti ikon final dari ChatGPT |
| A-001 | Kubus uji render | diagnostik | - | mesh primitif | putar | `game/diagnostics/foundation_test.tscn` | **PLACEHOLDER teknis**, bukan aset | Hanya uji render, dilabeli di layar |
| A-002 | Font bawaan Godot | ui_font | - | bawaan engine | - | (engine) | Sementara | Font final belum ditentukan |

## B. Kebutuhan Milestone 2 (Playable Foundation, visual 3D Stylized)

Spesifikasi lengkap: `ASSET_REQUESTS_M2.md`. ChatGPT membuat gambar (acuan ortografis, tekstur seamless, ikon, UI); Claude membangun model 3D dari gambar yang disetujui.

| ID | Nama | Kategori | Ringkasan spesifikasi | Status |
|---|---|---|---|---|
| B-001 | Karakter pemain (paket acuan) | char | turnaround ortografis 4096x2048, A-pose, key pose idle/jalan, palet; model ≤ 5k tri dibuat Claude | Requested |
| B-002 | Tekstur tanah/rumput | env | 3 rumput + 1 jalan tanah, 1024x1024 seamless (4 m/ubin) + mask transisi | Requested |
| B-003 | Props dunia awal | env | pohon x2, batu x2, pagar, semak, tuft: acuan ortografis + tekstur 512 seamless + kartu daun RGBA | Requested |
| B-004 | Rumah pemain (eksterior) | bld | elevasi ortografis + denah atap + 3 tekstur 512 seamless; model ≤ 3k tri | Requested |
| B-005 | Ikon HUD | ui | 128x128 RGBA: jam, kalender, koin, 4 fase hari, 4 musim, 6 cuaca | Requested |
| B-006 | Panel/tombol UI 9-slice | ui | panel 256x256, tombol 4 status 256x96, margin sudut 32/48 px | Requested |
| B-007 | Joystick dan tombol aksi | ui | base 512, knob 256, tombol aksi normal/tekan 256 | Requested |

## C. Kebutuhan Milestone 3 (Core Farming)

| ID | Nama | Kategori | Spesifikasi teknis | Status |
|---|---|---|---|---|
| C-001 | Tekstur petak lahan (kering, digemburkan, disiram) | env | 3 tekstur seamless 512x512 + acuan ortografis petak; mesh petak oleh Claude, pas ke grid | Requested |
| C-002 | Tahap tumbuh tanaman awal | crop | per tanaman: acuan ortografis benih + 4 tahap + siap panen (+ tekstur kecil); mesh oleh Claude; jumlah tanaman menunggu daftar data | Requested |
| C-003 | Ikon item (alat, benih, hasil panen) | ui | 128x128 per ikon | Requested |
| C-004 | Pose kunci aksi pemain: mencangkul, menyiram, menanam, memanen | char | sheet pose kunci tampak samping (4 pose per aksi) sebagai acuan animasi 3D | Requested |
| C-005 | Tekstur efek: tanah, air, panen | fx | tekstur partikel RGBA 64x64 (kartu 2D, sistem partikel oleh Claude) | Requested |
| C-006 | Ikon dan panel inventaris | ui | slot 128x128, panel 9-slice | Requested |

Catatan: kolom ukuran C-001..C-006 bersifat awal dan akan dirinci seperti `ASSET_REQUESTS_M2.md` sebelum diminta. Daftar tanaman dan item awal ditentukan lewat data (`game/data`) dan tidak boleh dibuat Claude tanpa keputusan konten; Claude akan mengajukan daftar minimal teknis sebelum meminta aset.
