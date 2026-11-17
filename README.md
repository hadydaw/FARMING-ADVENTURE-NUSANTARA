# Farming Adventure Nusantara

Game **Farming Simulation + Life Simulation + Adventure/Action RPG + Dungeon Exploration** bertema Nusantara, bergaya visual **3D Stylized**, untuk **Android (landscape, online)**.
Bahasa: Indonesia (utama) dan Inggris.

> **Status: Fase 0 — Fondasi proyek.** Belum ada gameplay. Sistem pertarungan, farming, dungeon, NPC, dan multiplayer akan ditetapkan lewat tahap desain sebelum diimplementasikan.
> Ini proyek baru dari nol dan tidak berhubungan dengan proyek game lain.

## Unduh APK

- **Rilis stabil:** halaman [Releases](../../releases) (tag `vX.Y.Z`) — belum ada rilis pertama.
- **Build uji terbaru:** pre-release [`dev-latest`](../../releases/tag/dev-latest) (otomatis dari `main`, paket `.dev`, hanya untuk uji).

Panduan pasang dan uji: [docs/project/TESTING_APK.md](docs/project/TESTING_APK.md).

## Teknologi

Godot 4.7.2 (GDScript), renderer GL Compatibility, ekspor Android arm64, GitHub Actions + GitHub Releases, backend online terpisah (rancangan). Alasan lengkap: [Technical Architecture](docs/technical/TECHNICAL_ARCHITECTURE.md).

## Struktur Repository

```
.github/workflows/   pipeline build APK (GitHub Actions)
docs/
  design/            GDD, catatan keputusan
  technical/         arsitektur, rancangan backend, build & rilis
  project/           roadmap, aturan pengembangan, log progres
game/                konten game (res://game/)
  boot/ core/ i18n/ data/ world/ ui/ assets/
backend/             backend online (rancangan; belum ada kode)
tools/ci/            skrip pipeline dan uji
tools/keystore/      kunci DEV publik (bukan kunci rilis)
project.godot  export_presets.cfg  icon.svg
```

## Lisensi

Proprietary / All Rights Reserved (lihat [LICENSE](LICENSE)). Source boleh dilihat, tidak boleh disalin, diubah, atau didistribusikan tanpa izin.

## Dokumentasi

Mulai dari [`docs/README.md`](docs/README.md).

## Pengembangan Cepat

```bash
godot --headless --path . --import      # import aset
tools/ci/run_smoke_test.sh              # uji fondasi
```

Aturan kerja: [Development Rules](docs/project/DEVELOPMENT_RULES.md). Build dan rilis: [Build & Release](docs/technical/BUILD_AND_RELEASE.md).
