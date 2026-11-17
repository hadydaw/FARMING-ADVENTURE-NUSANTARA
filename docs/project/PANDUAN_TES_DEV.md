# Panduan Tes Build Uji (dev) — Farming Adventure Nusantara

Status: build uji teknis. SEMUA konten (item, resep, monster, quest, festival, teman, dll.) adalah data generik
berlabel `provisional`, bukan konten resmi. Visual = penanda sementara. Uji perangkat fisik BELUM dilakukan
oleh pengembang; hasil tes Android ada di pemilik.

## Pasang
APK terbaru: halaman Releases repo, pre-release `dev-latest` (berkas `FarmingAdventureNusantara-dev-N.apk`).

## Alur tes yang disarankan (denah desa uji, awal di tengah)
1. **Menu**: "Mulai (uji dunia awal)". Setelah ada simpanan, muncul "Lanjutkan".
2. **Pertanian**: dekati petak, tombol Interaksi berulang = cangkul -> tanam -> siram -> (tidur) -> panen. Biaya stamina kecil.
3. **Tidur**: tempat tidur ungu (hari berganti, HP/stamina pulih, simpan otomatis ke slot 1).
4. **Toko**: kios kuning "Toko uji": panel Beli/Jual.
5. **Memancing**: kolam di kanan (butuh Pancing + umpan opsional); ikan uji.
6. **Ternak**: kandang kiri-atas; beri pakan harian, hasil setelah dewasa.
7. **NPC**: 2 warga uji, dialog bercabang, hubungan naik.
8. **Dapur / Meja ramuan / Meja kerja**: menu resep; bahan dari panen/memancing/kumpul.
9. **Tas**: tombol Tas; ketuk item makanan/ramuan = Pakai.
10. **Peta/Wilayah**: tombol Peta; gerbang ke Hutan dan Kawasan Kuno (Kuno butuh item ikan uji).
11. **Kumpul**: kerucut hijau (herbal) dan batu di wilayah; tumbuh lagi 2-3 hari.
12. **Monster** (waktu-nyata): bola berwarna di Hutan/Kuno mengejar bila kamu dekat (<7 m) dan menyerang berkala; tekan Interaksi dekat monster = serang (jeda 0.5 dtk); drop, EXP, level; HP habis = pingsan (uang -10%). Kabur jauh = monster pulang dan pulih.
13. **Papan guild** (desa atas): quest kumpul/kalahkan, peringkat, hadiah.
14. **Gua uji** (Kawasan Kuno): 3 ruangan + bos, hadiah, tutup 3 hari.
15. **Tukang upgrade** (desa): tas +6 slot, stamina/HP maks.
16. **Kemah teman** (desa): rekrut dan aktifkan teman (bonus serang/tahan).
17. **Cermin** (desa bawah): ubah warna kulit/pakaian.
18. **Festival**: hari ke-14 musim 1 (tidur beberapa kali) -> hadiah.
19. **Pengaturan**: bahasa, ukuran teks, kontras tinggi, lama pesan, petunjuk.
20. **Simpan/Muat**: tombol HUD (slot 0); autosave slot 1 saat bangun; "Lanjutkan" di menu.

## Yang BELUM ada / sengaja tidak dikarang
Cerita, lore, NPC/romansa resmi, boss/monster/quest resmi, aset visual final, audio, animasi, ikon item,
tombol serang khusus/animasi/dodge, status efek, equip senjata, event/festival aktif, layar pilih slot,
upgrade rumah/petak, nama karakter, rambut/wajah, mode buta warna, akun/login (ditunda).
TBD T1-T20 dan D-009/D-021/D-023/D-025/D-030/D-056..D-059 detail tetap terbuka.

## Masalah yang diketahui
- `world_start.gd` masih ~1060 baris (bisa dipecah lagi).
- Tampilan tumpang tindih kecil antara teks Tas dan panel toko; label hewan muda "(muda)".
- Link APK tidak bisa diverifikasi dari lingkungan build; ambil dari halaman Releases.

## Tes otomatis
`godot --headless --path . --script res://tests/run_all.gd` (30 berkas, 2888 pemeriksaan); smoke: `bash tools/ci/run_smoke_test.sh`.
Pesan ERROR "gagal pindah ke 'tidak_ada'" dan "ConfigFile parse error" di log adalah uji negatif yang disengaja.
