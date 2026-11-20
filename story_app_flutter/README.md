# Story App (Dicoding Flutter Intermediate - Submission)

Aplikasi berbagi cerita (*Story App*) berbasis Flutter yang dibangun dengan arsitektur bersih, **Declarative Navigation (Navigator 2.0)**, integrasi **Google Maps**, **Infinite Scrolling Pagination**, **Code Generation**, serta **Build Variants (Flavors)** dengan desain antarmuka modern yang terinspirasi oleh kesederhanaan dan struktur linimasa **Threads / Twitter**.

---

## 🚀 Cara Menjalankan Aplikasi

> [!IMPORTANT]
> Pastikan terminal Anda berada di **direktori root proyek** (`D:\dicoding\story_app_flutter`), **bukan** di dalam folder `android/`. Jika saat ini berada di folder `android`, kembali ke root terlebih dahulu:
> ```bash
> cd ..
> ```

### 1. Menjalankan Varian Paid (Pro)
Varian dengan fitur lengkap termasuk pemilih lokasi pada peta saat membuat cerita:
```bash
flutter run --flavor paid -t lib/main_paid.dart
```

### 2. Menjalankan Varian Free
Varian gratis di mana fitur penambahan lokasi dikunci dan menampilkan banner informatif:
```bash
flutter run --flavor free -t lib/main_free.dart
```

---

## ⚡ Pintasan Keyboard Saat Aplikasi Berjalan (Reload / Restart)

Ketika aplikasi sedang berjalan via terminal melalui perintah `flutter run`, Anda dapat menggunakan pintasan keyboard berikut:

| Tombol | Aksi | Keterangan |
| :---: | :--- | :--- |
| **`r`** | **Hot Reload** | Memperbarui kode dan UI seketika (hitungan sub-detik) tanpa mereset status aplikasi (*state*). |
| **`R`** *(Shift + r)* | **Hot Restart** | Memulai ulang aplikasi dari awal dan mereset status aplikasi (*state*). |
| **`c`** | **Clear Console** | Membersihkan tampilan log di terminal. |
| **`p`** | **Debug Paint** | Menampilkan garis bantu layout rendering UI di layar. |
| **`q`** | **Quit** | Menghentikan sesi penjalankan aplikasi. |

---

## 📱 Build Variants (Flavors)

Aplikasi memiliki dua varian (*flavor dimension: tier*) yang dikonfigurasi melalui Gradle:

| Fitur | Varian Free | Varian Paid (Pro) |
| :--- | :---: | :---: |
| **Application ID** | `com.example.story_app_flutter.free` | `com.example.story_app_flutter.paid` |
| **App Title** | Story App (Free) | Story App Pro |
| **Entry Point** | `lib/main_free.dart` | `lib/main_paid.dart` |
| **Melihat Linimasa Cerita** | ✅ | ✅ |
| **Pagination Infinite Scroll** | ✅ | ✅ |
| **Melihat Peta di Detail Cerita** | ✅ | ✅ |
| **Memilih Lokasi Saat Buat Cerita** | ❌ *(Terkunci / Banner)* | ✅ *(Interaktif via Google Maps)* |

---

## 🗺️ Integrasi Google Maps & Geocoding

1. **Google Maps API Key**:
   Telah dikonfigurasi di file [`android/app/src/main/AndroidManifest.xml`](file:///d:/dicoding/story_app_flutter/android/app/src/main/AndroidManifest.xml):
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_GOOGLE_MAPS_API_KEY" />
   ```
2. **Catatan Otorisasi Peta**:
   Jika peta menampilkan warna krem/beige polos dengan logo Google di pojok kiri bawah:
   * Di **Google Cloud Console**, pastikan **Maps SDK for Android** berstatus **Enabled**.
   * Jika API Key diberi pembatasan (*Application restriction*), ubah ke **"None"** saat pengujian/review Dicoding, atau daftarkan kedua package name:
     * `com.example.story_app_flutter.paid`
     * `com.example.story_app_flutter.free`
   * Pastikan akun penagihan (*Billing Account*) Google Cloud aktif.

---

## ⚙️ Code Generation

Aplikasi menggunakan `json_serializable` dan `build_runner` untuk serialisasi data model otomatis. Untuk memperbarui atau menghasilkan ulang kode:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 🧪 Pengujian Unit & Navigasi (Testing)

Untuk menjalankan seluruh unit test navigasi Declarative (Navigator 2.0):

```bash
flutter test
```

---

## 🛠️ Build APK Rilis / Debug

Untuk menghasilkan file installer APK secara mandiri:

```bash
# Build APK Debug Paid
flutter build apk --flavor paid -t lib/main_paid.dart --debug

# Build APK Debug Free
flutter build apk --flavor free -t lib/main_free.dart --debug
```
File APK akan tersedia pada folder `build/app/outputs/flutter-apk/`.
