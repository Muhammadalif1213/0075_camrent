import 'package:flutter/material.dart';
import 'package:paml_camrent/screens/customer/customer_confirm_screen.dart';

// Import halaman-halaman yang akan Anda tampilkan
import 'package:paml_camrent/screens/customer/booking_list_screen.dart';
import 'package:paml_camrent/screens/customer/my_booking_screen.dart';
import 'package:paml_camrent/screens/customer/profile_screen.dart';


class MainCustomerScreen extends StatefulWidget {
  const MainCustomerScreen({super.key});

  @override
  State<MainCustomerScreen> createState() => _MainCustomerScreenState();
}

class _MainCustomerScreenState extends State<MainCustomerScreen> {
  // Variabel untuk melacak halaman mana yang sedang aktif
  int _selectedIndex = 0; 

  // Daftar semua halaman yang akan ditampilkan
  static const List<Widget> _widgetOptions = <Widget>[
    CustomerConfirmScreen(), // Index 0
    BookingListScreen(), // Index 1
    ProfileScreen(),     // Index 2
  ];

  // Fungsi yang akan dipanggil saat item navigasi diketuk
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan menampilkan halaman yang sesuai dengan index yang dipilih
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // Ini adalah Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Peminjaman',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex, // Item yang aktif saat ini
        selectedItemColor: Colors.deepPurple, // Warna item yang dipilih
        onTap: _onItemTapped, // Panggil fungsi saat item diketuk
      ),
    );
  }
}