# Panduan Kunci Rilis dan GitHub Secrets

Tujuan: APK rilis resmi ditandatangani kunci **production** milik Anda. Kunci ini **tidak pernah** masuk repository, dan dipisah dari kunci **development**.

| | Development | Production |
|---|---|---|
| Berkas | `tools/keystore/dev.keystore` (publik, di repo) | `fan-release.keystore` (RAHASIA, di luar repo) |
| Dipakai untuk | APK `dev-latest` (paket `.dev`) | Rilis tag `vX.Y.Z` |
| Password | `android` (publik) | Rahasia, hanya di GitHub Secrets + cadangan pribadi |

Pengaman otomatis di CI: build rilis **gagal** bila Secrets kosong, bila keystore/alias/password tidak cocok, atau bila APK ternyata bertanda tangan kunci dev.

## 1. Buat keystore production

Pilih salah satu:

**A. Di HP lewat Termux** (tanpa PC)
```bash
pkg update && pkg install openjdk-17 -y
keytool -genkeypair -v -keystore fan-release.keystore -alias fan-release \
  -keyalg RSA -keysize 2048 -validity 36500
base64 -w0 fan-release.keystore > fan-release.keystore.b64
```
Saat ditanya password: pakai satu password kuat yang **sama** untuk keystore dan key (syarat Godot).

**B. Minta Claude membuatkan** di sesi kerja. Kunci lalu dikirim ke Anda sebagai berkas lewat chat pribadi; setelah Anda menyimpannya, kunci tidak disimpan di repo. (Dipilih hanya bila Anda mengizinkan.)

## 2. Cadangkan (WAJIB sebelum lanjut)

Simpan di **dua tempat aman di luar GitHub**: berkas `fan-release.keystore`, alias, dan password (mis. pengelola password + penyimpanan cloud pribadi). Jika kunci hilang, pemain tidak bisa meng-update aplikasi dan harus uninstall.

## 3. Masukkan ke GitHub Secrets

Di GitHub (web/app browser): repo → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**. Buat tiga secret:

| Name | Value |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | Seluruh isi `fan-release.keystore.b64` (satu baris panjang) |
| `ANDROID_KEY_ALIAS` | `fan-release` |
| `ANDROID_KEY_PASSWORD` | Password tadi |

Setelah itu hapus `*.b64` dari HP/penyimpanan sementara. Jangan menempel secret di issue, chat publik, atau commit.

## 4. Uji (tanpa rilis publik)

Rilis production pertama **baru dibuat setelah Anda memberi izin**. Uji dilakukan dengan tag pra-rilis sementara (mis. `v0.0.1`) dan Release itu dihapus setelah dicek. Pengecekan: tanda tangan APK bukan kunci dev dan paket `com.hadydaw.farmingadventurenusantara`.

## 5. Bila rahasia bocor

Hapus Secret, jangan pakai kunci itu lagi, buat kunci baru. Karena kunci berubah, pemain harus uninstall dan pasang ulang. Karena itu jaga kerahasiaannya sejak awal.
