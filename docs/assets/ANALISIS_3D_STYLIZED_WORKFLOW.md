# Analisis: 3D Stylized (D-008) dengan Workflow Aset ChatGPT

Status: analisis teknis. **Pemilik memilih Opsi A (O-011)**; hasil uji percontohan props ada di `PILOT_MESH_OPSI_A.md`. **D-008 tidak berubah** (3D Stylized tetap berlaku; O-010 hanya klarifikasi pelaksanaan).

## 1. Fakta batasan

- ChatGPT menghasilkan **gambar 2D** (konsep, turnaround, tekstur, ikon, UI). Ia tidak menghasilkan mesh `.glb`, rig, atau animasi.
- Claude (di lingkungan ini) tidak memiliki Blender (`bpy` tidak ada) dan jaringan untuk memasang alat tertutup. Yang tersedia: Python + numpy dan Godot 4.7.2 headless.
- Karena itu Claude dapat membangun mesh **lewat kode** (menulis geometri vertex per vertex, ekstrusi/lathe/profil, heightfield, lalu menyimpan `.glb` atau resource Godot) berdasarkan gambar acuan ChatGPT. Tidak ada pemahatan manual interaktif.

## 2. Pembagian per jenis aset

| Kebutuhan | Perlu model 3D? | Dibuat oleh | Catatan |
|---|---|---|---|
| Karakter pemain, NPC | Ya (+ rig + animasi) | Konsep: ChatGPT. Mesh, rig, animasi: Claude | Risiko tertinggi: bentuk organik lewat kode terbatas |
| Monster, hewan, companion, boss | Ya (+ rig) | Sama | Setelah M3 |
| Bangunan | Ya | Konsep + elevasi: ChatGPT. Mesh: Claude | Bentuk kotak/atap/tiang paling cocok untuk kode |
| Props (pohon, batu, pagar, semak) | Ya (poli rendah) | Sama | Pohon: batang berprofil + kartu daun |
| Terrain | Ya (heightfield + material) | Tekstur: ChatGPT. Mesh/shader: Claude | |
| Tanaman (tahap tumbuh) | Ya, mesh kecil | Sama | Instancing |
| Item di dunia, alat | Ya, mesh kecil | Sama | |
| Tekstur, decal, warna | Tidak | ChatGPT | Seamless/swatch, bukan atlas UV |
| Ikon, UI, HUD, peta | Tidak | ChatGPT | Implementasi: Claude |
| Partikel/efek | Tidak (kartu 2D) | Tekstur: ChatGPT. Sistem: Claude | |

## 3. Alur konstruksi teknis

1. ChatGPT menyerahkan paket acuan: turnaround ortografis (depan, belakang, samping, atas, 3/4), skala dalam meter, palet warna, daftar material.
2. Claude mengukur proporsi dari gambar acuan, menetapkan anggaran poligon (TA §3: karakter ≤ 5k segitiga, objek dunia ≤ 1k, tekstur ≤ 1024 px), lalu membangun mesh lewat kode dengan UV per zona material.
3. Warna: material per zona (warna datar atau tekstur seamless dari ChatGPT), tanpa pencahayaan yang dipanggang. Shader teknis (toon/rim ringan) oleh Claude, selaras Compatibility renderer.
4. Rig dan animasi: kerangka tulang dan bobot dibuat lewat kode; animasi (idle, jalan, aksi) sebagai resource Animation. Pose kunci acuan dari ChatGPT dipakai sebagai referensi.
5. Impor ke Godot, uji (ukuran, collision, performa), simpan ke `game/assets/models/`.
6. Cacat bentuk dikembalikan ke pemilik/ChatGPT sebagai revisi acuan; Claude tidak mengubah desain.

## 4. Risiko dan batas yang jujur

1. **Kualitas organik.** Karakter/hewan/monster yang dibangun murni lewat kode akan lebih kaku dibanding model pahatan manual. Gaya "chunky, poli rendah, bentuk sederhana" paling aman. Bila art direction menuntut bentuk organik halus, hasilnya bisa tidak sesuai acuan.
2. **Aturan "bukan bentuk geometri sederhana".** Mesh dari profil, ekstrusi, dan vertex kustom mengikuti siluet acuan; tetapi objek poli rendah memang tersusun dari bentuk dasar. Perlu kesepakatan pemilik bahwa pendekatan ini memenuhi aturan.
3. **Skala pekerjaan.** 12 NPC, monster, hewan, dan bangunan banyak; produksi lewat kode memakan waktu dan butuh iterasi dengan acuan yang konsisten.
4. **Kesesuaian gambar dan mesh.** Gambar acuan dari generator gambar sering tidak konsisten antar sudut; turnaround yang tidak cocok mempersulit konstruksi 3D.

## 5. Opsi (keputusan di pemilik; tidak ada yang diambil sepihak)

- **A. Konstruksi lewat kode oleh Claude (default saat ini).** Tanpa alat tambahan. Mulai dengan uji percontohan: satu prop (mis. pagar atau pohon) dan satu bangunan kecil, tinjau kualitasnya sebelum karakter.
- **B. Sumber model 3D eksternal** (mis. alat pembuat model dari gambar atau pemodel manusia) yang diimpor Claude. Mengubah aturan "semua aset lewat ChatGPT" sehingga perlu persetujuan eksplisit.
- **C. Hybrid:** objek dunia 3D lewat kode, karakter lewat sumber eksternal. Juga perlu persetujuan.

Rekomendasi teknis: mulai dengan A untuk props/bangunan/terrain (kuat di kode), lakukan uji percontohan, lalu putuskan untuk karakter berdasarkan hasilnya.

## 6. Dampak ke permintaan aset

Spesifikasi di `ASSET_REQUESTS_M2.md` sudah disusun untuk 3D: ChatGPT memberi **acuan ortografis, palet, tekstur seamless, ikon, dan UI**, bukan sprite sheet.
