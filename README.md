# KELOMPOK eden_9

Selengkapnya dapat dilihat di folder #Tugas_Kelompok_Final/

## A. Pembagian tugas

1. (221111044) Kevin Lidan:
   - Mengkoordinasi pembagian tugas anggota kelompok .
   - Memimpin keseluruhan pembuatan dan revisi kode bersama anggota dengan repository Github.
   - Membuat tampilan UI dan kode awal aplikasi.
   - Meninjau dan mendiskusikan hasil kerja kelompok bersama.
1. (221110019) Stevie Sawita:
   - Merevisi tampilan UI aplikasi.
   - Menambahkan validasi dan merevisi bagian Text-to-Speech hasil translate.
   - Membuat dokumentasi.
   - Meninjau dan mendiskusikan hasil kerja kelompok bersama.
1. (221110724) David Joevincent:
   - Merevisi penanganan bahasa input sesuai pilihan pada bagian Speech Recognition.
   - Merevisi bagian Speech-to-Text hasil Speech Recognition.
   - Menyunting video presentasi.
   - Meninjau dan mendiskusikan hasil kerja kelompok bersama.
1. (221112256) Vincent Salim:
   - Mencari referensi library flutter yang bisa digunakan.
   - Menambahkan logic pada bagian Select Language.
   - Merevisi bagian Multi Language Translation.
   - Meninjau dan mendiskusikan hasil kerja kelompok bersama.
1. (221113855) Vincent:
   - Mencari referensi cara menggunakan library.
   - Merevisi logic untuk aktivasi Speech Recognition.
   - Menambahkan bahasa yang bisa digunakan input/output.
   - Meninjau dan mendiskusikan hasil kerja kelompok bersama.

## B. Dokumentasi Program

### B.1 Tentang Program

Sesuai dengan feedback dan challenge yang diberikan pada penggumpulan progress tugas sebelumnya, maka kami melakukan perubahan pada program kami sebagai berikut:

- Membuat program menjadi versi mobile (sebelumnya output terminal).
  Jadi bahasa pemograman yang sebelumnya menggunakan Python diganti menjadi bahasa pemograman dart dengan framework flutter. Maka kode dan library yang digunakan direvisi sesuai bahasa pemograman, dengan konsep beserta penerapan AI yang masih sama dengan sebelumnya.
- Menambahkan fitur Voice-to-Voice Translation Multi Language.
  Sebelumnya hanya berfokus pada Speech Recognition dan Speech-to-Text. Fitur Translate dan hasilnya ditambahkan Text-to-Speech.

### B.2 Library yang diperlukan

Agar program dapat dijalankan, pastikan sudah terinstall tools yang diperlukan seperti: flutter, sdk, dan lainnya

Library yang diperlukan:

- speech_to_text, untuk Speech Recognition dan Speech-to-Text
- translator, untuk menerjemahkan.
- flutter_tts, untuk Text-to-Speech hasil terjemahan.
- cupertino_icons, untuk komponen ikon yang digunakan.
- avatar_glow, untuk animasi button.

Library/ packages akan otomatis ikut terinstall dengan perintah: `flutter pub get`

### B.3 Cara Menjalankan Program

Pastikan sudah install library/packages sebelumnya. Jalankan perintah `flutter run`
