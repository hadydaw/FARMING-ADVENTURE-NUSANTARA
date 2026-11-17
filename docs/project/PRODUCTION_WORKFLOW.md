# Workflow Produksi: ChatGPT (visual) dan Claude (teknis)

Status: **berlaku** (arahan wajib pemilik, dicatat sebagai O-009). Tidak mengubah D-001 sampai D-069.

**Klarifikasi O-010:** D-008 (3D Stylized) tetap berlaku. ChatGPT membuat seluruh gambar (konsep, turnaround, tekstur, ikon, UI, referensi visual); **Claude membangun model 3D, geometri, material, shader teknis, rig, dan integrasi** dari desain visual ChatGPT. Claude tidak membuat/mengganti desain visual final. Spesifikasi aset ada di `docs/assets/ASSET_REQUESTS_M2.md`; analisis kelayakan di `docs/assets/ANALISIS_3D_STYLIZED_WORKFLOW.md`.

## 1. Pembagian peran

| Pihak | Tanggung jawab |
|---|---|
| **ChatGPT** | Seluruh desain visual dan aset gambar: art direction; desain dunia, bangunan, karakter, monster, NPC, hewan, companion, boss (konsep dan acuan ortografis); tekstur dan material swatch; terrain, props, tanaman, aset dungeon (acuan); ikon, UI art, HUD, menu, peta; tekstur efek dan partikel. |
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

## 5. Risiko produksi terbuka

1. **D-008 dikonfirmasi: 3D Stylized tetap** (O-010). Istilah "sprite/sprite sheet" pada arahan awal dipahami sebagai acuan gambar; aset final dunia berupa model 3D.
2. **Sumber model 3D.** ChatGPT menghasilkan gambar 2D, bukan mesh. Claude membangun mesh lewat kode (tanpa Blender di lingkungan ini). Batas kualitas, terutama bentuk organik (karakter, hewan, monster), diuraikan di `docs/assets/ANALISIS_3D_STYLIZED_WORKFLOW.md` beserta opsi A/B/C. Keputusan metode untuk karakter menunggu uji percontohan props/bangunan dan persetujuan pemilik.
3. Aturan "tidak dari bentuk geometri sederhana" perlu ditegaskan pemilik terhadap mesh poli rendah yang dibangun dari profil kustom.
