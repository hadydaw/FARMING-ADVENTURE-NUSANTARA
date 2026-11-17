# Build dan Rilis APK — Farming Adventure Nusantara

Pipeline: `.github/workflows/android-build.yml` + skrip di `tools/ci/`.

## 1. Gambaran Alur

| Pemicu | Yang terjadi | Hasil |
|---|---|---|
| Pull request ke `main` | Uji fondasi → build APK dev | Artefak Actions |
| Push ke `main` | Uji fondasi → build APK dev | Artefak Actions **dan** pre-release `dev-latest` di GitHub Releases |
| Tag `vMAJOR.MINOR.PATCH` | Uji fondasi → build APK **rilis** (kunci rahasia) → verifikasi | GitHub Release `vX.Y.Z` berisi APK |
| Manual (`workflow_dispatch`) | Seperti push (build dev) | Artefak |

Tahapan job `build`: pasang JDK 17 → Android SDK (platform-tools, build-tools 35.0.1, platform android-35, NDK 28.1.13356709, CMake 3.10.2.4988404) → Godot 4.7.2 + export template Android (diverifikasi SHA-512) → set editor settings → tentukan versi → siapkan kunci → import → export → verifikasi APK (paket, arm64, tanda tangan) → unggah.

## 2. Konfigurasi Android

| Item | Nilai | Catatan |
|---|---|---|
| Ekspor | Template prebuilt (tanpa Gradle) | T-003 |
| Arsitektur | `arm64-v8a` | Cukup untuk HP modern; ditinjau bila perlu perangkat lama |
| Orientasi | `sensor_landscape` | `project.godot` |
| Izin | `INTERNET`, `ACCESS_NETWORK_STATE` | Game online |
| Mode layar | Immersive | |
| Renderer | GL Compatibility | T-002 |
| Preset | `export_presets.cfg` (preset "Android") | Versi/paket diisi otomatis oleh CI |

## 3. Versi dan Paket

- Versi game: `config/version` di `project.godot` (SemVer).
- **Rilis:** tag `vX.Y.Z` **wajib sama** dengan `config/version` (CI menolak bila beda). `versionCode = X*1.000.000 + Y*1.000 + Z`. Paket: `com.hadydaw.farmingadventurenusantara` (**resmi, disetujui O-002; tidak boleh diubah tanpa persetujuan pemilik**).
- **Dev:** versi `X.Y.Z-dev.<nomor_run>`, `versionCode = nomor_run`, paket `…nusantara.dev`, nama aplikasi "FAN Dev" → bisa terpasang berdampingan dengan rilis.

## 4. Penandatanganan (Kunci Rilis)

Panduan langkah demi langkah: [`SIGNING_GUIDE.md`](SIGNING_GUIDE.md). CI menolak rilis bila APK bertanda tangan kunci dev.

- **Dev:** `tools/keystore/dev.keystore` (alias `fan-dev`, password `android`) sengaja **publik** di repo. Hanya untuk build dev; jangan bagikan APK dev sebagai rilis.
- **Rilis:** wajib kunci pribadi yang **tidak pernah masuk repo**. Isi GitHub Secrets (Settings → Secrets and variables → Actions):

| Secret | Isi |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | Berkas keystore rilis di-encode base64 |
| `ANDROID_KEY_ALIAS` | Alias kunci |
| `ANDROID_KEY_PASSWORD` | Password (Godot mensyaratkan password keystore = password key) |

Tanpa ketiganya, build rilis **berhenti dengan pesan jelas** (tidak menerbitkan APK yang ditandatangani kunci publik).

**Penting:** kunci rilis yang sama harus dipakai selamanya; jika hilang, pemain tidak bisa meng-update dan harus uninstall. **Cadangkan keystore dan password di tempat aman di luar repo.**

Membuat keystore rilis (di mesin dengan JDK):

```bash
keytool -genkeypair -v -keystore fan-release.keystore -alias fan-release \
  -keyalg RSA -keysize 2048 -validity 36500
base64 -w0 fan-release.keystore   # hasilnya = isi ANDROID_KEYSTORE_BASE64
```

## 5. Cara Merilis

1. Pastikan `main` hijau di tab Actions.
2. Naikkan `config/version` di `project.godot` (mis. `0.1.0`), update `CHANGELOG.md`, commit ke `main`.
3. Buat tag dan dorong: `git tag v0.1.0 && git push origin v0.1.0` (atau buat Release dari antarmuka GitHub dengan tag baru).
4. Actions membangun APK rilis dan membuat GitHub Release `v0.1.0` dengan APK terlampir (catatan rilis otomatis).
5. Pemain mengunduh APK dari halaman **Releases**; aktifkan "pasang dari sumber tidak dikenal" di Android untuk browser/pengelola berkas yang dipakai.

## 6. Distribusi APK Publik

- Rilis stabil: halaman **Releases** (hanya tag `v*`).
- Build uji terbaru: pre-release **`dev-latest`** (ditimpa tiap push ke `main`; ditandai pre-release agar tidak tertukar dengan rilis).
- Disarankan menaruh checksum SHA-256 di catatan rilis (rencana perbaikan).
- Google Play: belum direncanakan (D-005 hanya APK). Jika nanti dipilih, perlu format AAB, Gradle build, dan kunci unggah terpisah.

## 7. Uji APK di HP

Lihat [`../project/TESTING_APK.md`](../project/TESTING_APK.md).

## 8. Menjalankan Uji Fondasi Secara Lokal

```bash
godot --headless --path . --import
tools/ci/run_smoke_test.sh
```

## 9. Pemecahan Masalah Umum

| Gejala | Penyebab/aksi |
|---|---|
| "Build rilis dibatalkan: GitHub Secrets belum diisi" | Isi 3 secret di §4 |
| "Tag … tidak sama dengan config/version" | Samakan tag dan `project.godot` |
| "Invalid Android SDK path" | Langkah "Atur editor settings Android" gagal / SDK tidak terpasang |
| "No export template found" | Versi Godot dan template tidak sama; cek `GODOT_VERSION` di workflow |
| APK tidak bisa di-update di HP | Tanda tangan beda (dev vs rilis, atau kunci berganti) → uninstall dulu |
