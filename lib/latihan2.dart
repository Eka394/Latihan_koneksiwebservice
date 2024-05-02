import 'package:flutter/material.dart'; // Import library Flutter untuk membangun antarmuka pengguna
import 'package:http/http.dart' as http; // Import library http untuk melakukan HTTP requests
import 'dart:convert'; // Import library untuk mengonversi JSON string menjadi objek Dart

void main() {
  runApp(const MyApp()); // Menjalankan aplikasi Flutter
}

// Kelas untuk menampung data hasil pemanggilan API
class Activity {
  String aktivitas;
  String jenis;

  Activity({required this.aktivitas, required this.jenis}); // Constructor

  // Method untuk mengonversi JSON ke atribut
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'],
      jenis: json['type'],
    );
  }
}

class MyApp extends StatefulWidget { // Kelas MyApp sebagai StatefulWidget
  const MyApp({Key? key}) : super(key: key); // Constructor untuk MyApp dengan menerima kunci sebagai parameter opsional dan meneruskannya ke superclass StatelessWidget

  @override
  State<StatefulWidget> createState() { // Membuat state baru untuk MyApp
    return MyAppState(); // Mengembalikan instance dari MyAppState sebagai state untuk MyApp
  }
}

class MyAppState extends State<MyApp> { // State untuk MyApp
  late Future<Activity> futureActivity; // Variabel untuk menampung hasil aktivitas

  String url = "https://www.boredapi.com/api/activity"; // URL endpoint API

  Future<Activity> init() async { // Metode untuk menginisialisasi futureActivity
    return Activity(aktivitas: "", jenis: ""); // Mengembalikan objek Activity dengan nilai atribut aktivitas dan jenis kosong
  }

  Future<Activity> fetchData() async { // Metode untuk melakukan fetch data dari API
    final response = await http.get(Uri.parse(url)); // Mengirim GET request ke URL
    if (response.statusCode == 200) { // Jika request berhasil
      // Parse JSON response
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // Jika request gagal, lempar exception
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() { // Metode yang dipanggil saat initState
    super.initState(); // Memanggil metode initState dari kelas induk untuk melakukan inisialisasi state
    futureActivity = init(); // Inisialisasi futureActivity
  }

  @override
  Widget build(Object context) { // Metode untuk membangun antarmuka pengguna
    return MaterialApp( // Widget MaterialApp sebagai kerangka aplikasi
        home: Scaffold( // Widget Scaffold sebagai kerangka halaman
      body: Center( // Widget Center untuk menengahkan konten
        child: Column( // Widget Column untuk menata konten secara vertikal
            mainAxisAlignment: MainAxisAlignment.center, // Menengahkan konten secara vertikal
            children: [ // Daftar widget yang akan ditampilkan dalam halaman transkrip mahasiswa
          Padding( // Widget Padding untuk memberi padding pada konten
            padding: EdgeInsets.only(bottom: 20), // Padding di bagian bawah
            child: ElevatedButton( // Tombol untuk memanggil fetchData()
              onPressed: () {  // Aksi yang dijalankan ketika tombol ditekan
                setState(() { // Memanggil fetchData() saat tombol ditekan
                  futureActivity = fetchData(); // Memperbarui futureActivity dengan hasil dari pemanggilan fetchData()
                });
              },
              child: Text("Saya bosan ..."), // Teks pada tombol
            ),
          ),
          FutureBuilder<Activity>( // Widget FutureBuilder untuk menampilkan hasil futureActivity
            future: futureActivity, // Future yang akan dipantau
            builder: (context, snapshot) { // Builder untuk membangun tampilan berdasarkan status futureActivity
              if (snapshot.hasData) { // Jika data tersedia
                return Center( // Widget Center untuk menengahkan konten
                    child: Column( // Widget Column untuk menata konten secara vertikal
                        mainAxisAlignment: MainAxisAlignment.center, // Menengahkan konten secara vertikal
                        children: [
                      Text(snapshot.data!.aktivitas), // Teks aktivitas
                      Text("Jenis: ${snapshot.data!.jenis}") // Teks jenis aktivitas
                    ]));
              } else if (snapshot.hasError) { // Jika terjadi error
                return Text('${snapshot.error}'); // Teks error
              }
              // Default: menampilkan loading spinner
              return const CircularProgressIndicator(); // Widget CircularProgressIndicator untuk menampilkan loading spinner
            },
          ),
        ]),
      ),
    ));
  }
}
