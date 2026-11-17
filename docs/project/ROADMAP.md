# Project Roadmap — Farming Adventure Nusantara

Roadmap berbasis **tahap dan hasil yang dapat diperiksa**, bukan tanggal (belum ada keputusan jadwal). Setiap tahap selesai hanya bila kriteria selesainya terpenuhi dan dicatat di `PROGRESS_LOG.md`.

## Fase 0 — Fondasi Proyek *(tahap sekarang)*

- [x] Repository GitHub, struktur direktori, dokumentasi (GDD, Technical Architecture, Roadmap, Development Rules, catatan keputusan)
- [x] Proyek Godot 4.7.2 (Compatibility, landscape, i18n id/en, layar boot 3D)
- [x] Fondasi inti: `SaveService` (teruji), `BackendClient` (antarmuka), `AppInfo`
- [x] Konfigurasi ekspor Android + pipeline GitHub Actions + rancangan rilis
- [x] **Bukti build:** workflow Actions hijau dan APK dev terunduh dari `dev-latest` (2026-11-17)
- [ ] **Bukti perangkat:** APK dev terpasang dan layar boot tampil di HP (landscape, 3D, sentuh, ganti bahasa)
- [x] Keputusan pemilik: package ID, backend Supabase, lisensi
- [ ] Pemilik: kunci production + GitHub Secrets (P-002)

**Kriteria selesai:** dua "bukti" di atas terpenuhi.

## Fase 1 — Desain Bersama (belum ada kode gameplay)

Sesi desain bersama ChatGPT; hasil dituangkan ke GDD v1.0 dan `DESIGN_DECISIONS.md`.
Selesai/terkunci: visual (D-008), dunia (D-009), pertarungan (D-013), single-player online (D-014). Sistem kehidupan (D-015) terkunci. Dungeon (D-016) terkunci. Guild (D-017) terkunci. Perkembangan karakter (D-018) terkunci. Companion dan monster taming (D-019) terkunci. Equipment dan crafting (D-020) terkunci. Ekonomi dan perdagangan (D-021) terkunci. NPC dan kehidupan sosial (D-022) terkunci. Pertanian dan pertumbuhan tanaman (D-023) terkunci. Peternakan dan hewan (D-024) terkunci. Memancing dan kehidupan perairan (D-025) terkunci. Memasak dan alkimia (D-026) terkunci. Rumah, lahan, dan bangunan (D-027) terkunci. Eksplorasi dunia dan perjalanan (D-028) terkunci. Event dunia (D-029) terkunci. Musim, cuaca, dan lingkungan (D-030) terkunci. UI/HUD (D-031) terkunci. Audio (D-032) terkunci. Kamera (D-033) terkunci. Kontrol karakter (D-034) terkunci. Interaksi dunia dan objek (D-035) terkunci. Inventory (D-036) terkunci. Quest dan misi (D-037) terkunci. Dialog NPC (D-038) terkunci. Hubungan sosial (D-039) terkunci. NPC dan kehidupan desa (D-040) terkunci. Kustomisasi karakter (D-041) terkunci. Mount dan kendaraan (D-042) terkunci. Tutorial dan panduan (D-043) terkunci. Save dan cloud sync (D-044) terkunci. Pengaturan dan aksesibilitas (D-045) terkunci. Tahap 35 (akun dan login) PENDING sampai persiapan publikasi Google Play (P-006). Achievement, title, dan koleksi (D-046) terkunci. Monetisasi Cosmetic Only (D-047) terkunci. Update konten dan live operations (D-048) terkunci. QA dan pengujian (D-049) terkunci. Keamanan dan perlindungan data (D-050) terkunci. Performa dan optimasi perangkat (D-052, Tahap 43) loading/transisi antarwilayah (D-053, Tahap 44), peta dunia/navigasi (D-054, Tahap 45), dan waktu/kalender (D-055, Tahap 46), tidur/pergantian hari (D-056, Tahap 47), energi/stamina/kebutuhan karakter (D-057, Tahap 48), kekalahan/kebangkitan (D-058, Tahap 49), status effect/buff/debuff (D-059, Tahap 50), ras/suku/asal-usul (D-060, Tahap 51), kerajaan/organisasi dunia (D-061, Tahap 52), reputasi/hubungan faksi/diplomasi (D-062, Tahap 53), perang/konflik antarfaksi (D-063, Tahap 54), hukum/kejahatan/bounty (D-064, Tahap 55), cuaca ekstrem/bencana/fenomena (D-065, Tahap 56), romansa/pernikahan/keluarga (D-066, Tahap 57; memperbarui batasan D-015), cerita utama/narasi dunia (D-067, Tahap 58), endgame/aktivitas pascacerita (D-068, Tahap 59), dan prioritas konten/versi rilis/roadmap (D-069, Tahap 60) terkunci; D-051 (Tahap 42) dicadangkan menunggu keputusan. Sedang berjalan: Tahap 42 (menunggu) dan berikutnya. Urutan usulan sisanya: kontrol/kamera sentuh → struktur dunia dan wilayah → siklus farming → dungeon → rank/quest/cerita → NPC → art direction.

**Kriteria selesai:** GDD v1.0 tanpa bagian kritis bertanda [BELUM DITETAPKAN] untuk lingkup vertical slice.

## Fase 2 — Fondasi Gameplay dan Pipeline Aset

Kontrol sentuh + kamera, karakter dasar, pipeline aset 3D stylized (impor, konvensi nama, anggaran performa), UI dasar, audio manager, pengukuran performa di HP.
**Selesai:** karakter dapat bergerak di area uji dengan 60/≥30 FPS sesuai anggaran.

## Fase 3 — Vertical Slice

Satu desa awal yang dapat dimainkan: loop inti (ladang → hasil → jual/masak) + guild + satu quest + satu area monster/dungeon kecil + satu boss. Simpan/muat progres.
**Selesai:** alur desa→guild→dungeon→kembali dapat dimainkan tuntas di HP.

## Fase 4 — Online

> **Catatan konflik (D-069):** frasa "uji offline→online" di bawah tidak selaras dengan D-014/D-044 (game online; cache lokal bukan mode offline penuh). Rekomendasi: ganti menjadi "uji putus koneksi→pulih" setelah D-051 diterima. Teks belum diubah menunggu persetujuan.

Backend sesuai `BACKEND_DESIGN.md`: akun, sinkronisasi save, penanganan konflik. Akun, login, Cloud Save, sinkron progres (D-014 Single-Player Online); tanpa multiplayer.
**Selesai:** progres dapat dipulihkan di perangkat lain; uji offline→online dan konflik lulus.

## Fase 5 — Ekspansi Konten (Progressive World Unlock)

> **Catatan konflik (D-069):** urutan Fase 5 sebelum Fase 6 (Rilis 1.0) menyiratkan seluruh ekspansi ada di Rilis 1.0, bertentangan dengan D-069 (Rilis Awal berlingkup inti; konten lain lewat pembaruan terencana). Rekomendasi: perlakukan Fase 5 sebagai **pembaruan setelah Rilis Awal** (lihat "Roadmap Rilis dan Konten" di bawah). Urutan lama belum dihapus menunggu persetujuan.

Wilayah demi wilayah: desa/kota, sumber daya, monster, dungeon, rank F → SSS, cerita.
Rilis berkala dengan CHANGELOG.

## Fase 6 — Beta dan Rilis 1.0

> **Catatan (D-069):** "Rilis 1.0" = **Rilis Awal** berlingkup inti (`../design/RELEASE_SCOPE.md`). Kanal publik (GitHub Releases atau toko) belum diputuskan (P-007) dan terkait Tahap 35 (P-006).

Optimasi performa/ukuran APK, uji perangkat beragam, QA regresi, keseimbangan, kebijakan privasi, rilis publik v1.0 di GitHub Releases.

## Roadmap Rilis dan Konten (D-069)

Berbasis **gerbang kriteria**, bukan tanggal. Isi tiap gerbang di bawah adalah **usulan** sampai disetujui pemilik (P-007); tidak ada tanggal, biaya, atau angka performa/ukuran.

| Gerbang | Isi | Selesai bila |
|---|---|---|
| G0 Fondasi | Fase 0 | Bukti build (sudah) dan bukti perangkat (P-005); kunci production (P-002) |
| G1 Penguncian lingkup | Persetujuan lingkup Rilis Awal (P-007); penguncian detail untuk lingkup vertical slice; isi D-051 diterima | GDD tanpa [BELUM DITETAPKAN] kritis untuk lingkup slice |
| G2 Fondasi gameplay | Fase 2 | Karakter bergerak di area uji; pengukuran performa di HP |
| G3 Vertical slice | Fase 3 | Alur desa → guild → dungeon → kembali dapat dimainkan tuntas di HP |
| G4 Online dan akun | Fase 4; Tahap 35 diputuskan (P-006) | Progres pulih di perangkat lain; uji putus koneksi → pulih lulus |
| G5 Uji tertutup | Uji perangkat beragam, performa terukur, ukuran diukur, uji migrasi save | Kriteria `RELEASE_SCOPE.md` §4 terpenuhi |
| G6 Rilis Awal | Release candidate, kebijakan privasi, penandatanganan, kanal distribusi | Persetujuan pemilik |
| G7+ Pembaruan berkala | Gelombang pembaruan terencana | Tiap pembaruan lolos uji save fixture, regresi performa/ukuran, dan CHANGELOG |

**Urutan gelombang pembaruan (usulan, belum final):** (1) wilayah tambahan dan bab cerita; (2) dungeon dan boss tambahan; (3) monster, companion, dan perlengkapan; (4) aktivitas kehidupan lanjutan (peternakan, memancing, memasak, alkimia); (5) fitur sosial lanjutan (romansa, keluarga, cerita pribadi NPC); (6) faksi, konflik, hukum, dan fenomena dunia; (7) endgame (D-068). Urutan dapat berubah dengan persetujuan pemilik.

**Aturan tiap pembaruan:** kompatibilitas save dan progres dijaga; ID konten stabil; migrasi aditif dan idempoten; uji fixture dari semua versi sebelumnya; konten baru tidak menulis ulang dunia save lama; konten gameplay penting tidak mensyaratkan pembelian.

## Risiko dan Ketergantungan

| Ketergantungan | Memblokir |
|---|---|
| Keputusan desain (Fase 1) | Semua implementasi gameplay |
| Kunci rilis (P-002) | Rilis publik bertanda tangan |
| Keputusan backend (P-003) | Fase 4 |
| Sumber/pipeline aset 3D | Fase 2–3 |
