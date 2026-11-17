# Laporan Uji Percontohan: Custom Mesh Lewat Kode (Opsi A), Props B-003

Tanggal: 2026-11-17. Status: **PILOT TEKNIS, bukan aset final.** Belum ada gambar acuan B-003 dari ChatGPT, jadi siluet, warna, dan proporsi di pilot adalah bentuk generik untuk mengukur metode. Saat acuan disetujui, props dibangun ulang mengikuti acuan dan model pilot dihapus.

## Yang dibangun

- Toolkit `game/tools/mesh/mesh_builder.gd` (MeshBuilder): lathe profil putar, blob ikosfer ber-noise, tabung sapuan, bilah lengkung, segitiga datar, warna vertex, normal datar, ekspor ke `.glb`.
- Generator `game/tools/mesh/pilot_props.gd`; bake `tools/mesh/bake_pilot_props.gd`; hasil `game/assets/models/pilot/*.glb`; skrip pasca-impor warna vertex `tools/mesh/post_import_vertex_color.gd`.
- Layar diagnostik "Pilot Mesh" (menu utama) untuk melihat props dari berbagai sudut di HP.

## Hasil per prop

| Prop | Segitiga | Tinggi | Catatan |
|---|---|---|---|
| tree_a (tajuk membulat) | 559 | 5,9 m | batang melebar di akar, 3 dahan, 5 gugus daun |
| tree_b (konifer tingkat) | 272 | 5,7 m | 4 tingkat rok bergerigi |
| rock_a (berlumut) | 400 | 1,0 m | lumut berdasarkan arah normal |
| rock_b (memanjang) | 480 | 1,4 m | 3 gugus batu |
| fence (1 segmen) | 140 | 1,1 m | tiang berujung, 2 rel melengkung, penyangga |
| bush | 320 | 0,8 m | 4 gugus bonggol |
| tuft | 55 | 0,4 m | 11 bilah melengkung (dua sisi) |

Semua ≤ 1.000 segitiga (anggaran TA §3). Uji otomatis (75 pemeriksaan): anggaran, ukuran, determinisme seed, tanpa NaN, arah normal keluar, urutan sisi depan Godot, hasil `.glb` termuat dengan warna vertex.

## Temuan dan keterbatasan metode

1. **Hasil layak untuk props organik sederhana.** Pohon, semak, rumput, dan batu poli rendah terbaca sebagai aset game bergaya, bukan kubus/bola berwarna.
2. **Bentuk generik, bukan identitas.** Karakter visual spesifik (mis. pohon khas Nusantara) hanya tercapai bila diatur manual per aset mengikuti acuan. Tidak ada pahatan interaktif; setiap penyesuaian = ubah parameter kode, render, lihat, ulangi.
3. **Noise membuat batu seragam ("kusut").** Variasi facet kurang terarah. Bentuk batu yang sangat spesifik butuh logika pemotongan bidang tambahan.
4. **Belum ada UV dan tekstur.** Pilot memakai warna vertex. Tekstur seamless ChatGPT (B-002/B-003) belum bisa dipetakan tanpa UV. Solusi teknis yang diusulkan: shader triplanar (Claude) untuk tanah/batu, dan UV sederhana yang dibangun lewat kode untuk batang/bangunan.
5. **Pencocokan acuan masih manual.** Usulan: alat uji siluet yang merender tampak ortografis mesh lalu membandingkan dengan siluet gambar acuan (IoU) agar penyetelan terukur.
6. **Belum diuji di perangkat fisik** (performa, tampilan layar kecil).
7. **Karakter belum diuji.** Rig, bobot kulit, wajah, rambut, dan pakaian jauh lebih sulit dibanding props; kualitasnya tidak boleh diasumsikan dari hasil props ini.
8. **Kategori lain belum terbukti:** bangunan, terrain, karakter, hewan, monster masing-masing perlu uji sendiri.

## Permintaan

Mohon evaluasi visual pilot (lembar screenshot dan layar Pilot Mesh di APK). Produksi tidak diperluas sebelum evaluasi. Untuk produksi sebenarnya, gambar acuan B-003 dari ChatGPT diperlukan lebih dulu.
