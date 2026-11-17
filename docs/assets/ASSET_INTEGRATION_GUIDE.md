# Panduan Integrasi Aset (untuk Claude dan pembuat aset)

1. **Penamaan**: `snake_case`, awalan kategori (`char_`, `mon_`, `bld_`, `crop_`, `env_`, `ui_`, `fx_`, `sfx_`, `bgm_`). Sprite sheet: `char_player_walk_down.png`, dst.
2. **Lokasi**: `game/assets/<kategori>/`. Berkas `.import` dan `.uid` ikut di-commit.
3. **Sprite sheet**: grid sel seragam, tanpa jarak antar sel (atau jarak dicatat), urutan frame kiri-ke-kanan, atas-ke-bawah per arah. Jumlah frame dan ukuran sel dicatat di `ASSET_MASTER_LIST.md`.
4. **Import**: Compatibility renderer; tekstur 2D dengan kompresi VRAM bila aman, tanpa mipmap untuk UI; filter linear untuk art halus, nearest untuk pixel art (sesuai arahan art direction).
5. **Pemeriksaan integrasi** (wajib sebelum status Integrated): tampil benar, ukuran sesuai skala dunia, animasi mulus, collision/pivot tepat, performa dalam anggaran, ukuran APK dipantau.
6. **Cacat visual** dilaporkan di `ASSET_QC_LOG.md` dengan ID aset, deskripsi, dan permintaan revisi. Claude tidak memperbaiki isi gambar.
7. **Lisensi/sumber**: setiap aset dicatat di `docs/project/ASSET_CREDITS.md` (asal: dibuat via ChatGPT, tanggal, persetujuan pemilik).
