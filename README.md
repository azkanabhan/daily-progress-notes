# Better Day

Aplikasi Flutter untuk merefleksikan hari-hari yang lebih baik. Aplikasi ini membantu Anda mencatat refleksi harian, melacak perasaan, dan melihat statistik perkembangan Anda.

## Fitur

## Getting Started

### 1. Daily Reflection Entry
- **Apa yang membuat hari ini lebih baik dari kemarin?** - Kolom untuk mencatat hal-hal positif
- **Hal apa yang bisa diperbaiki untuk besok?** - Kolom untuk refleksi dan perbaikan
- **Mood Selector** - Pilih perasaan hari ini dengan emoji (opsional)
- **Tanggal dan Jam Otomatis** - Tercatat otomatis saat menyimpan
- **Rich Text Editor** - Format teks sederhana (bold, italic, bullet list)

### 2. Timeline / Journal View
- Daftar semua refleksi berdasarkan tanggal
- Filter berdasarkan:
  - Semua entri
  - Minggu ini
  - Bulan ini
- Scroll untuk melihat entri sebelumnya
- Tap entri untuk melihat detail atau edit

### 3. Statistik Emosi / Refleksi
- **Grafik Perasaan** - Visualisasi mood dari hari ke hari (30 hari terakhir)
- **Distribusi Perasaan** - Statistik sebaran mood
- **Streak Counter** - Hitung berapa hari berturut-turut menulis refleksi

### 4. Daily Reminder
- Notifikasi pengingat setiap hari pada waktu yang ditentukan
- Dapat diaktifkan/nonaktifkan di pengaturan
- Pesan: "Sudahkah kamu menulis hal yang membuat hari ini lebih baik?"

## Teknologi yang Digunakan

- **Flutter** - Framework UI
- **Provider** - State Management
- **sqflite** - Local Database
- **flutter_quill** - Rich Text Editor
- **fl_chart** - Charts & Graphs
- **flutter_local_notifications** - Local Notifications
- **intl** - Internationalization & Date Formatting
- **shared_preferences** - Settings Storage

## Struktur Project

```
lib/
├── models/              # Data models
│   ├── mood.dart
│   └── reflection_entry.dart
├── screens/            # UI Screens
│   ├── home_screen.dart
│   ├── reflection_entry_screen.dart
│   ├── timeline_screen.dart
│   ├── statistics_screen.dart
│   └── settings_screen.dart
├── widgets/            # Reusable Widgets
│   ├── mood_selector.dart
│   ├── rich_text_field.dart
│   └── date_time_display.dart
├── services/           # Business Logic
│   ├── database_service.dart
│   └── notification_service.dart
├── providers/          # State Management
│   └── reflection_provider.dart
└── main.dart          # App Entry Point
```

## Instalasi

1. Clone repository ini
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run aplikasi:
   ```bash
   flutter run
   ```

## Build untuk Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Penggunaan

1. **Menulis Refleksi Harian**
   - Tap tombol "Tulis Refleksi" di halaman beranda
   - Isi kolom "Apa yang membuat hari ini lebih baik?"
   - Isi kolom "Hal apa yang bisa diperbaiki?"
   - Pilih mood (opsional)
   - Tap "Simpan Refleksi"

2. **Melihat Timeline**
   - Buka tab "Timeline"
   - Gunakan filter untuk melihat entri berdasarkan periode
   - Tap entri untuk melihat detail atau edit

3. **Melihat Statistik**
   - Buka tab "Statistik"
   - Lihat grafik perasaan dan streak counter

4. **Mengatur Reminder**
   - Buka tab "Pengaturan"
   - Aktifkan "Daily Reminder"
   - Pilih waktu pengingat

## Clean Code & Modular Component

Aplikasi ini dibangun dengan prinsip:
- **Separation of Concerns** - Setiap layer memiliki tanggung jawab yang jelas
- **Reusable Components** - Widget dapat digunakan kembali
- **State Management** - Menggunakan Provider untuk manajemen state
- **Service Layer** - Business logic terpisah dari UI
- **Type Safety** - Menggunakan model classes untuk type safety

## Lisensi

Proyek ini dibuat untuk keperluan pembelajaran dan penggunaan pribadi.
