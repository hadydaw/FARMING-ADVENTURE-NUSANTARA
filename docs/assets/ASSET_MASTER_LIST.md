# Daftar Induk Aset

Status: Requested -> Generated -> Approved -> Integrated -> Tested.
Kolom: ID, Nama, Kategori, Gambar referensi, Ukuran/format, Animasi/frame, Lokasi berkas, Status, Catatan revisi.

## A. Aset yang ada saat ini (bukan aset final)

| ID | Nama | Kategori | Referensi | Ukuran/format | Animasi | Lokasi | Status | Catatan |
|---|---|---|---|---|---|---|---|---|
| A-000 | Ikon aplikasi sementara | ui_icon | - | SVG | - | `icon.svg` | **PLACEHOLDER** (Requested) | Harus diganti ikon final dari ChatGPT |
| A-001 | Kubus uji render | diagnostik | - | mesh primitif | putar | `game/diagnostics/foundation_test.tscn` | **PLACEHOLDER teknis**, bukan aset | Hanya uji render, dilabeli di layar |
| A-002 | Font bawaan Godot | ui_font | - | bawaan engine | - | (engine) | Sementara | Font final belum ditentukan |

## B. Kebutuhan Milestone 2 (Playable Foundation)

Format umum: PNG RGBA, latar transparan, nama `snake_case` dengan awalan kategori. Bila arah visual 3D dipilih, ganti dengan `.glb` (lihat risiko D-008).

| ID | Nama | Kategori | Spesifikasi teknis | Status |
|---|---|---|---|---|
| B-001 | Karakter pemain (sprite sheet) | char | 4 arah (bawah, atas, kiri, kanan) x idle 4 frame + jalan 6 frame; sel 256x256; satu sheet atau satu sheet per animasi; pivot di kaki (tengah-bawah) | Requested |
| B-002 | Tanah/rumput dunia awal | env | tile 256x256 seamless, 3 variasi rumput + jalan tanah | Requested |
| B-003 | Props dunia awal (pohon, batu, pagar, semak) | env | masing-masing PNG RGBA maks 512x512, pivot dasar | Requested |
| B-004 | Rumah pemain (eksterior) | bld | 1 gambar maks 1024x1024, pivot dasar | Requested |
| B-005 | Ikon HUD (waktu, hari, musim, cuaca, uang) | ui | 128x128 per ikon | Requested |
| B-006 | Panel/tombol UI (9-slice) | ui | panel, tombol normal/tekan/nonaktif; sudut jelas untuk 9-slice | Requested |
| B-007 | Joystick dan tombol aksi (art) | ui | dasar joystick 512x512, kenop 256x256, tombol 256x256 normal/tekan | Requested |

## C. Kebutuhan Milestone 3 (Core Farming)

| ID | Nama | Kategori | Spesifikasi teknis | Status |
|---|---|---|---|---|
| C-001 | Petak lahan (kering, digemburkan, disiram) | env | 3 keadaan, sel 256x256, pas ke grid | Requested |
| C-002 | Tahap tumbuh tanaman awal | crop | per tanaman: benih + 4 tahap + siap panen; 256x256; jumlah tanaman menunggu daftar data | Requested |
| C-003 | Ikon item (alat, benih, hasil panen) | ui | 128x128 per ikon | Requested |
| C-004 | Animasi pemain: mencangkul, menyiram, menanam, memanen | char | 4 arah x 4-6 frame, sel sama dengan B-001 | Requested |
| C-005 | Efek: tanah, air, panen | fx | sheet partikel 64x64, 4-8 frame | Requested |
| C-006 | Ikon dan panel inventaris | ui | slot 128x128, panel 9-slice | Requested |

Daftar tanaman dan item awal ditentukan lewat data (`game/data`) dan tidak boleh dibuat Claude tanpa keputusan konten; Claude akan mengajukan daftar minimal teknis sebelum meminta aset.
