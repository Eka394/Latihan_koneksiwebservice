import 'package:flutter/material.dart'; // Import library Flutter untuk membangun antarmuka pengguna
import 'package:http/http.dart' as http; // Import library http untuk melakukan HTTP requests
import 'dart:convert'; // Import library untuk mengonversi JSON string menjadi objek Dart

class University { // Kelas untuk merepresentasikan informasi universitas
  String name; // Atribut untuk menyimpan nama universitas
  String website; // Atribut untuk menyimpan situs web universitas

  University({required this.name, required this.website}); // Constructor untuk kelas University
}

class MyApp extends StatefulWidget { // Kelas MyApp sebagai StatefulWidget
  @override
  State<StatefulWidget> createState() { // Membuat state baru untuk MyApp
    return MyAppState(); // Mengembalikan instance dari MyAppState sebagai state untuk MyApp
  }
}

class MyAppState extends State<MyApp> { // State untuk MyApp
  late Future<List<University>> futureUniversities; // Variabel untuk menampung hasil universitas

  String url = "http://universities.hipolabs.com/search?country=Indonesia"; // URL endpoint API

  // Metode untuk melakukan fetch data dari API
  Future<List<University>> fetchUniversities() async {
    final response = await http.get(Uri.parse(url)); // Mengirim GET request ke URL

    if (response.statusCode == 200) { // Jika request berhasil
      List<dynamic> data = json.decode(response.body); // Mendekode JSON response
      List<University> universities = []; // Membuat list kosong untuk menampung objek University

      for (var item in data) { // Looping melalui data response
        universities.add( // Menambahkan data universitas ke dalam list
          University( // Membuat instance dari kelas University
            name: item['name'], // Mendapatkan nama universitas
            website: item['web_pages'][0], // Mendapatkan situs web pertama
          ),
        );
      }

      return universities; // Mengembalikan list universitas
    } else {
      throw Exception('Gagal load'); // Jika request gagal, lempar exception
    }
  }

  @override
  void initState() { // Metode yang dipanggil saat initState
    super.initState(); // Memanggil metode initState dari superclass untuk melakukan inisialisasi state
    futureUniversities = fetchUniversities(); // Inisialisasi futureUniversities dengan hasil fetchUniversities
  }

  @override
  Widget build(BuildContext context) { // Metode untuk membangun antarmuka pengguna
    return MaterialApp( // Widget MaterialApp sebagai kerangka aplikasi
      title: 'Universities App', // Judul aplikasi
      home: Scaffold( // Widget Scaffold sebagai kerangka halaman
        appBar: AppBar( // Widget AppBar sebagai bagian atas halaman
          title: Text('Universitas Di Indonesia'), // Judul AppBar
        ),
        body: FutureBuilder<List<University>>( // Widget FutureBuilder untuk menampilkan hasil futureUniversities
          future: futureUniversities, // Future yang akan dipantau
          builder: (context, snapshot) { // Builder untuk membangun tampilan berdasarkan status futureUniversities
            if (snapshot.connectionState == ConnectionState.waiting) { // Jika masih dalam proses loading
              return Center( // Widget Center untuk menengahkan konten
                child: CircularProgressIndicator(), // Widget CircularProgressIndicator untuk menampilkan loading spinner
              );
            } else if (snapshot.hasError) { // Jika terjadi error
              return Center( // Widget Center untuk menengahkan konten
                child: Text('${snapshot.error}'), // Widget Text untuk menampilkan pesan error
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) { // Jika tidak ada data atau data kosong
              return Center( // Widget Center untuk menengahkan konten
                child: Text('No data available'), // Widget Text untuk menampilkan pesan bahwa tidak ada data tersedia
              );
            } else { // Jika data tersedia
              return ListView.separated( // Widget ListView.separated untuk menampilkan daftar universitas
                shrinkWrap: true, // Widget ListView akan menyesuaikan ukuran sesuai konten
                itemCount: snapshot.data!.length, // Jumlah item dalam ListView
                separatorBuilder: (BuildContext context, int index) => Divider(), // Widget Divider untuk membuat pemisah antar item
                itemBuilder: (context, index) { // Builder untuk membangun tampilan setiap item dalam ListView
                  return ListTile( // Widget ListTile untuk menampilkan setiap item dalam bentuk baris
                    title: Text(snapshot.data![index].name), // Teks nama universitas
                    subtitle: Text(snapshot.data![index].website), // Teks situs web universitas
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

void main() { // Fungsi main untuk menjalankan aplikasi
  runApp(MyApp()); // Menjalankan aplikasi MyApp
}
