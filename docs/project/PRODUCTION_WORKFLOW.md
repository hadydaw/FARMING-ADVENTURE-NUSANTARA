# Workflow Produksi: ChatGPT (visual) dan Claude (teknis)

Status: **berlaku** (arahan wajib pemilik, dicatat sebagai O-009). Tidak mengubah D-001 sampai D-069.

## 1. Pembagian peran

| Pihak | Tanggung jawab |
|---|---|
| **ChatGPT** | Seluruh desain visual dan aset gambar: art direction; desain dunia, bangunan, karakter, monster, NPC, hewan, companion, boss; sprite, sprite sheet, frame animasi; terrain, props, tanaman, aset dungeon; ikon, UI art, HUD, menu, peta; tekstur efek dan partikel. |
| **Claude** | Arsitektur teknis Godot, GDScript, sistem gameplay, scene/node, collision/fisika, navigasi/AI, sistem animasi dengan aset yang disediakan, import setting/atlas, material/shader teknis, implementasi UI dengan art yang disediakan, integrasi audio, debugging/optimasi, build APK, uji otomatis. |
| **Pemilik** | Meninjau dan menyetujui aset, menjalankan uji di perangkat fisik, menyetujui keputusan resmi. |

Claude boleh **menetapkan kebutuhan aset** (ukuran, format, jumlah frame, tata letak sprite sheet, spesifikasi teknis), tetapi tidak membuat isi visualnya.

## 2. Larangan untuk Claude

- Tidak membuat sprite/gambar dengan AI lain atau menggambar aset final.
- Tidak memakai placeholder visual yang diklaim sebagai final.
- Tidak mengubah desain visual yang sudah disetujui.
- Tidak mengambil aset dari game lain.
- Tidak membuat aset final dari bentuk geometri sederhana.
- Tidak mengubah komposisi sprite sheet yang disetujui tanpa alasan teknis dan persetujuan.
- Placeholder teknis hanya boleh bila **berlabel jelas "PLACEHOLDER"** (nama berkas dan tampilan) dan tercatat di `docs/assets/ASSET_MASTER_LIST.md` berstatus `Requested`.

## 3. Alur kerja satu aset

1. Claude menganalisis kebutuhan, memberi daftar aset dan spesifikasi teknis (`ASSET_MASTER_LIST.md`).
2. ChatGPT membuat aset (status **Generated**).
3. Pemilik meninjau; disetujui = **Approved** dan menjadi referensi visual resmi.
4. Claude mengintegrasikan ke Godot dan menguji tampilan, ukuran, animasi, collision, performa (**Integrated**, lalu **Tested**).
5. Cacat visual dijelaskan balik untuk revisi lewat `ASSET_QC_LOG.md`.
6. Claude memperbarui inventaris aset, commit, push.

Aset **belum selesai** sebelum gambar final ada, terintegrasi, dan diperiksa.

## 4. Dokumen terkait

`docs/assets/ASSET_MASTER_LIST.md`, `ART_DIRECTION.md`, `ASSET_INTEGRATION_GUIDE.md`, `ASSET_QC_LOG.md`.

## 5. Risiko produksi terbuka (butuh keputusan pemilik)

1. **D-008 (3D Stylized) versus sprite/sprite sheet.** Arahan produksi menyebut sprite dan sprite sheet, sedangkan D-008 menetapkan 3D Stylized. Claude tidak mengubah D-008. Perlu dipastikan: apakah visual final 3D (model `.glb`) atau 2D/2.5D (sprite di dunia 3D, billboard)?
2. **Sumber model 3D.** Pembuatan gambar oleh ChatGPT menghasilkan gambar 2D, bukan mesh `.glb`. Bila D-008 tetap 3D penuh, sumber model 3D harus ditentukan pemilik. Sampai ada keputusan, Claude hanya membangun sistem yang tidak bergantung pada format visual (data, logika, input, UI).
