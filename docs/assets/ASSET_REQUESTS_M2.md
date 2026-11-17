# Permintaan Aset Milestone 2 (B-001 sampai B-007), untuk ChatGPT

Status: Requested. Visual 3D Stylized tetap berlaku (D-008). ChatGPT membuat seluruh **gambar**; Claude membangun model 3D, material, rig, dan integrasi dari gambar yang disetujui. Semua nilai ukuran/skala di bawah adalah **acuan teknis sementara**, bukan keputusan desain.

## Aturan umum (berlaku untuk semua aset)

1. Format PNG 8-bit sRGB (RGBA bila disebut transparan). Tanpa watermark, tanpa teks/huruf di dalam gambar (bahasa lewat lokalisasi).
2. Satu gaya konsisten: 3D Stylized, bentuk sederhana, warna jelas, tanpa pencahayaan/bayangan yang dipanggang di tekstur.
3. Skala dunia acuan: **1 unit Godot = 1 meter**. Karakter pemain kira-kira 1,6 m. Gambar acuan menyertakan garis skala/grid 1 m.
4. Kirim: berkas terpisah per aset + satu lembar ringkasan (contact sheet) + daftar hex palet.
5. Nama berkas `snake_case` dengan awalan kategori, mis. `char_player_ref_front.png`.
6. Bila ada beberapa gambar dari satu aset, **proporsi dan detail harus sama persis antar sudut** (dasar konstruksi 3D).
7. Setelah disetujui pemilik, gambar menjadi acuan visual resmi; revisi lewat `ASSET_QC_LOG.md`.

## B-001 Karakter pemain (paket acuan 3D)

- **Gambar:** satu sheet turnaround ortografis pada latar polos/transparan: depan, belakang, kiri, kanan, plus 1 tampilan 3/4 depan. Pose netral (A-pose: kaki selebar bahu, lengan sedikit turun). Semua tampilan sejajar secara vertikal (garis kepala, bahu, pinggul, lutut, kaki segaris).
- **Ukuran:** sheet 4096x2048 (tiap tampilan tinggi sama, ≥ 1500 px); tambah garis skala 1 m.
- **Proporsi:** tentukan dan tuliskan rasio kepala:badan (gaya stylized; mis. 3 sampai 4 kepala) dan tinggi total.
- **Detail:** bagi pakaian/aksesori per zona material (kulit, rambut, atasan, bawahan, sepatu, aksesori) dan beri swatch warna tiap zona.
- **Pose kunci (referensi animasi, sheet terpisah, tampak samping):** idle (2 pose), jalan (4 pose kunci siklus). Garis lantai konsisten.
- **Opsional:** lembar ekspresi wajah (4 ekspresi).
- **Catatan 3D:** poli target karakter ≤ 5.000 segitiga; hindari detail sangat halus (rambut individual, jari rinci).
- **Penyerahan:** `char_player_ref_turnaround.png`, `char_player_ref_keypose_idle.png`, `char_player_ref_keypose_walk.png`, `char_player_palette.png`.

## B-002 Tekstur tanah dan rumput dunia awal

- **Gambar:** 4 tekstur seamless: `env_grass_a`, `env_grass_b`, `env_grass_c` (variasi rumput), `env_dirt_path`.
- **Ukuran:** 1024x1024 PNG opak, seamless di 4 sisi (uji ubin 3x3 tanpa sambungan terlihat).
- **Kepadatan:** 1024 px mewakili ubin 4 m x 4 m di dunia.
- **Gaya:** dilukis tangan stylized, pandangan lurus dari atas, tanpa perspektif, tanpa bayangan/sorotan, tanpa objek besar (batu/bunga tunggal) agar tidak terlihat berulang.
- **Tambahan:** satu gambar transisi `env_grass_dirt_blend_mask` (grayscale, seamless 1024x1024) untuk pencampuran rumput dan tanah.

## B-003 Props dunia awal

Aset: **pohon (2 jenis)**, **batu (2 jenis)**, **pagar kayu (1 segmen)**, **semak (1)**, **rumput liar/tuft (1)**.

- **Gambar acuan per aset:** ortografis depan, samping, atas (3 tampilan sejajar, skala 1 m), sheet ≥ 2048x1024.
- **Dimensi acuan (meter, boleh disesuaikan lalu dicatat):** pohon tinggi 4 sampai 6 m, batu 0,5 sampai 1,5 m, pagar segmen lebar 2 m x tinggi 1 m, semak 1 m, tuft 0,4 m.
- **Tekstur terkait (seamless 512x512):** `env_bark`, `env_rock`, `env_wood_plank`.
- **Daun/rumput:** 1 gambar RGBA transparan 512x512 gugus daun (`env_leaf_cluster`) dan 1 gambar bilah rumput (`env_grass_blade_tuft`) untuk kartu.
- **Catatan 3D:** objek dunia ≤ 1.000 segitiga.

## B-004 Rumah pemain (eksterior)

- **Gambar acuan:** elevasi ortografis depan, belakang, kiri, kanan, denah atap (atas), dan satu 3/4; sheet ≥ 4096x2048, garis skala 1 m.
- **Dimensi acuan:** denah kira-kira 6 m x 5 m, tinggi dinding 3 m, tinggi total ≤ 5 m (boleh disesuaikan lalu dicatat).
- **Detail:** posisi dan ukuran pintu dan jendela ditandai jelas; atap, dinding, kayu struktur, pintu sebagai zona material berbeda.
- **Tekstur (seamless 512x512):** `bld_wall`, `bld_roof`, `bld_wood`.
- **Gaya:** arsitektur bernuansa Nusantara sesuai art direction yang disetujui; tanpa teks.
- **Catatan 3D:** ≤ 3.000 segitiga untuk eksterior.

## B-005 Ikon HUD

- **Ukuran:** masing-masing PNG RGBA transparan **128x128**, objek di tengah dengan margin ≥ 8 px, gaya satu keluarga.
- **Daftar:** `ui_icon_clock`, `ui_icon_calendar`, `ui_icon_coin`; fase hari: `ui_icon_phase_morning`, `ui_icon_phase_day`, `ui_icon_phase_evening`, `ui_icon_phase_night`; musim (4 ikon generik, nama musim belum diputuskan): `ui_icon_season_1` sampai `ui_icon_season_4`; cuaca (lingkup D-030): `ui_icon_weather_clear`, `ui_icon_weather_cloudy`, `ui_icon_weather_rain`, `ui_icon_weather_storm`, `ui_icon_weather_fog`, `ui_icon_weather_snow`.
- **Tanpa teks**, kontras baik di latar gelap dan terang.

## B-006 Panel dan tombol UI (9-slice)

- **Berkas:** `ui_panel` (256x256), `ui_button_normal`, `ui_button_pressed`, `ui_button_disabled`, `ui_button_focus` (masing-masing 256x96).
- **Aturan 9-slice:** margin sudut tetap **32 px** (panel 48 px) dan terdefinisi jelas; bagian tengah dan sisi dapat diregangkan tanpa merusak gambar (tanpa detail unik di tengah). Sudut simetris. PNG RGBA, tepi luar transparan.
- **Tanpa teks/ikon.**

## B-007 Joystick dan tombol aksi

- **Berkas:** `ui_joystick_base` (512x512), `ui_joystick_knob` (256x256), `ui_action_button_normal` dan `ui_action_button_pressed` (256x256 lingkaran).
- PNG RGBA transparan, pusat visual tepat di tengah kanvas, simetris melingkar. Semitransparan tetap terbaca di atas dunia terang dan gelap.
- Tanpa ikon/teks (ikon aksi dibuat terpisah).

## Penyerahan dan integrasi

Setelah gambar dikirim ke pemilik dan disetujui, Claude: membuat model/material/UI dari acuan, mengintegrasikan ke Godot, menguji tampilan, ukuran, performa, lalu memperbarui `ASSET_MASTER_LIST.md` dan `ASSET_QC_LOG.md`. Belum ada aset di daftar ini yang berstatus Generated, Approved, Integrated, atau Tested.
