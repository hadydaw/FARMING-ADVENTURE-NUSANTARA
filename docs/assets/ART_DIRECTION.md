# Art Direction

Status: **kerangka**. Isi visual (palet, proporsi, gaya garis, referensi) dibuat oleh ChatGPT dan disetujui pemilik. Claude tidak mengisi keputusan visual.

## Yang sudah resmi
- Gaya: 3D Stylized, konsisten (D-008). Lihat risiko pada `docs/project/PRODUCTION_WORKFLOW.md` §5.
- Tema: farming + adventure RPG bernuansa Nusantara (GDD).
- Platform: Android landscape, renderer GL Compatibility, anggaran performa di `TECHNICAL_ARCHITECTURE.md` §3.

## Yang menunggu ChatGPT dan persetujuan pemilik
| Bagian | Status |
|---|---|
| Palet warna utama dan per wilayah | Belum ada |
| Proporsi karakter dan gaya wajah | Belum ada |
| Gaya bangunan Nusantara | Belum ada |
| Gaya UI/HUD/ikon | Belum ada |
| Gaya efek dan partikel | Belum ada |

## Batasan teknis untuk pembuat aset
- Ukuran tekstur kelipatan 2, maksimum 2048 px (rekomendasi 1024 untuk karakter).
- Latar transparan (PNG RGBA) untuk sprite/ikon; tanpa watermark.
- Rincian per aset ada di `ASSET_MASTER_LIST.md`.
