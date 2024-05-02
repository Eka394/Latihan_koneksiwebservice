import 'dart:convert'; // Import library untuk mengonversi JSON string menjadi objek Dart
import 'package:flutter/material.dart'; // Import library Flutter untuk membangun antarmuka pengguna

void main() {
  runApp(MyApp()); // Fungsi main untuk menjalankan aplikasi Flutter
}

class MyApp extends StatelessWidget { // Kelas MyApp sebagai root widget
  @override
  Widget build(BuildContext context) {  // Metode untuk membangun antarmuka pengguna halaman transkrip mahasiswa
    return MaterialApp( // Widget MaterialApp sebagai kerangka aplikasi
      title: 'Transkrip Mahasiswa', // Judul aplikasi
      home: TranskripMahasiswaPage(), // Halaman awal aplikasi
    );
  }
}

class TranskripMahasiswaPage extends StatefulWidget { // StatefulWidget untuk halaman transkrip mahasiswa
  @override
  _TranskripMahasiswaPageState createState() => _TranskripMahasiswaPageState(); // Membuat state untuk halaman transkrip mahasiswa
}

class _TranskripMahasiswaPageState extends State<TranskripMahasiswaPage> {  // Kelas State untuk halaman transkrip mahasiswa
  String jsonTranskrip = ''' 
  {
    "mahasiswa": {
      "nama": "Vivi Eka Juliatus Sholihah",
      "nim" : "22082010037",
      "program_studi": "Sistem Informasi",
      "transkrip": [
        {
          "mata_kuliah": "Statistika Komputasi",
          "sks": 3,
          "nilai": "A-"
        },
        {
          "mata_kuliah": "Pemrograman Mobile",
          "sks": 3,
          "nilai": "A"
        },
        {
          "mata_kuliah": "Manajemen Pengantar Sistem Informasi",
          "sks": 3,
          "nilai": "A-"
        },
        {
          "mata_kuliah": "Pemrograman Web",
          "sks": 3,
          "nilai": "A"
        }
      ]
    }
  }
  ''';

  Map<String, dynamic> transkrip = {}; // Variabel untuk menyimpan data transkrip dalam bentuk objek Dart
  List<Map<String, dynamic>> daftarMataKuliah = []; // Variabel untuk menyimpan daftar mata kuliah dari transkrip
  double totalSKS = 0; // Total SKS dari semua mata kuliah
  double totalBobot = 0; // Total bobot dari semua mata kuliah

  @override
  void initState() { // Metode initState dipanggil saat widget pertama kali dibuat
    super.initState(); // Memanggil metode initState dari kelas induk untuk inisialisasi state halaman
    transkrip = jsonDecode(jsonTranskrip); // Mengonversi string JSON menjadi objek Dart
    daftarMataKuliah = (transkrip['mahasiswa']['transkrip'] as List).cast<Map<String, dynamic>>(); // Mendapatkan daftar mata kuliah dari objek transkrip
  }

  @override
  Widget build(BuildContext context) { // Metode untuk membangun antarmuka pengguna halaman transkrip mahasiswa
    return Scaffold( // Scaffold sebagai kerangka utama halaman
      appBar: AppBar( // AppBar sebagai bagian atas halaman
        title: Text('Transkrip Mahasiswa'), // Judul AppBar
      ),
      body: SingleChildScrollView( // SingleChildScrollView agar konten dapat di-scroll jika terlalu panjang
        padding: EdgeInsets.all(16.0), // Padding pada konten
        child: Column( // Column untuk menata konten secara vertikal
          crossAxisAlignment: CrossAxisAlignment.stretch, // Menentukan tata letak lintas sumbu
          children: [  // Daftar widget yang akan ditampilkan dalam halaman transkrip mahasiswa
            Text( // Widget untuk menampilkan informasi mahasiswa
              'Informasi Mahasiswa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Gaya teks judul
            ),
            SizedBox(height: 8), // SizedBox untuk memberikan jarak vertikal
            Text('Nama                  : ${transkrip['mahasiswa']['nama']}'), // Widget untuk menampilkan nama mahasiswa
            Text('NIM                     : ${transkrip['mahasiswa']['nim']}'), // Widget untuk menampilkan NIM mahasiswa
            Text('Program Studi   : ${transkrip['mahasiswa']['program_studi']}'), // Widget untuk menampilkan program studi mahasiswa
            SizedBox(height: 16), // SizedBox untuk memberikan jarak vertikal
            Text( // Widget untuk menampilkan judul data transkrip mahasiswa
              'Data Transkrip Mahasiswa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Gaya teks judul
            ),
            SizedBox(height: 16), // SizedBox untuk memberikan jarak vertikal
            for (var mataKuliah in daftarMataKuliah) // Perulangan untuk menampilkan daftar mata kuliah
              ListTile( // Widget ListTile untuk menampilkan setiap mata kuliah dalam bentuk baris
                title: Text('Mata Kuliah: ${mataKuliah['mata_kuliah']}'), // Widget untuk menampilkan nama mata kuliah
                subtitle: Text('SKS: ${mataKuliah['sks']}, Nilai: ${mataKuliah['nilai']}'), // Widget untuk menampilkan SKS dan nilai mata kuliah
              ),
            SizedBox(height: 16), // SizedBox untuk memberikan jarak vertikal
            ElevatedButton( // Widget untuk membuat tombol "Hitung IPK"
              onPressed: () { // Aksi yang dijalankan ketika tombol ditekan
                showDialog( // Menampilkan dialog untuk menampilkan IPK
                  context: context, // Context dari aplikasi
                  builder: (BuildContext context) {  // Membangun tampilan dialog menggunakan builder
                    return AlertDialog( // Widget AlertDialog untuk menampilkan pesan
                      title: Text('IPK'), // Judul dialog
                      content: Text('IPK Anda adalah: ${hitungIPK().toStringAsFixed(2)}'), // Isi dialog berupa hasil perhitungan IPK
                      actions: <Widget>[ // Tombol aksi dalam dialog
                        TextButton( // Tombol untuk menutup dialog
                          onPressed: () { // Aksi yang dijalankan ketika tombol ditekan
                            Navigator.of(context).pop(); // Menutup dialog
                          },
                          child: Text('OK'), // Teks pada tombol
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Hitung IPK'), // Teks pada tombol
            ),
          ],
        ),
      ),
    );
  }

  double hitungIPK() { // Fungsi untuk menghitung IPK
    for (var mataKuliah in daftarMataKuliah) { // Melakukan iterasi untuk setiap mata kuliah dalam daftar
      int sks = mataKuliah['sks']; // Mendapatkan jumlah SKS dari mata kuliah
      String nilai = mataKuliah['nilai']; // Mendapatkan nilai dari mata kuliah

      double bobot = konversiNilaiKeBobot(nilai); // Mengonversi nilai menjadi bobot
      totalSKS += sks; // Menambahkan SKS ke total SKS
      totalBobot += bobot * sks; // Menambahkan bobot mata kuliah ke total bobot
    }

    double ipk = totalBobot / totalSKS; // Menghitung IPK
    return ipk; // Mengembalikan nilai IPK
  }

  double konversiNilaiKeBobot(String nilai) { // Fungsi untuk mengonversi nilai huruf menjadi bobot numerik
    switch (nilai) { // Menggunakan switch untuk menentukan bobot berdasarkan nilai
      case 'A': // Jika nilai adalah A, mengembalikan bobot 4.0
        return 4.0;
      case 'A-': // Jika nilai adalah A-, mengembalikan bobot 3.7
        return 3.7;
      case 'B+': // Jika nilai adalah B+, mengembalikan bobot 3.3
        return 3.3;
      case 'B':  // Jika nilai adalah B, mengembalikan bobot 3.0
        return 3.0;
      case 'B-': // Jika nilai adalah B-, mengembalikan bobot 2.7
        return 2.7;
      case 'C+': // Jika nilai adalah C+, mengembalikan bobot 2.3
        return 2.3;
      case 'C': // Jika nilai adalah C, mengembalikan bobot 2.0
        return 2.0;
      case 'C-': // Jika nilai adalah C-, mengembalikan bobot 1.7
        return 1.7;
      case 'D': // Jika nilai adalah D, mengembalikan bobot 1.0
        return 1.0;
      default: // Jika nilai tidak valid, mengembalikan bobot 0.0
        return 0.0; 
    }
  }
}
