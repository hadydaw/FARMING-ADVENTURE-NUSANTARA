# Panduan Integrasi Aset (untuk Claude dan pembuat aset)

1. **Penamaan**: `snake_case`, awalan kategori (`char_`, `mon_`, `bld_`, `crop_`, `env_`, `ui_`, `fx_`, `sfx_`, `bgm_`). Sprite sheet: `char_player_walk_down.png`, dst.
2. **Lokasi**: `game/assets/<kategori>/`. Berkas `.import` dan `.uid` ikut di-commit.
3. **Model 3D (D-008)**: dibangun Claude dari gambar acuan ChatGPT, disimpan `.glb` (glTF 2.0) di `game/assets/models/`. Anggaran poligon dan tekstur mengikuti `TECHNICAL_ARCHITECTURE.md` §3. Tekstur dari ChatGPT berupa swatch/seamless, bukan atlas UV.
4. **Import**: Compatibility renderer; tekstur 2D dengan kompresi VRAM bila aman, tanpa mipmap untuk UI; filter linear untuk art halus, nearest untuk pixel art (sesuai arahan art direction).
5. **Pemeriksaan integrasi** (wajib sebelum status Integrated): tampil benar, ukuran sesuai skala dunia, animasi mulus, collision/pivot tepat, performa dalam anggaran, ukuran APK dipantau.
6. **Cacat visual** dilaporkan di `ASSET_QC_LOG.md` dengan ID aset, deskripsi, dan permintaan revisi. Claude tidak memperbaiki isi gambar.
7. **Lisensi/sumber**: setiap aset dicatat di `docs/project/ASSET_CREDITS.md` (asal: dibuat via ChatGPT, tanggal, persetujuan pemilik).
