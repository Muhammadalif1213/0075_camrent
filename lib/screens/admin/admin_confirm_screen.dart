import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:paml_camrent/data/presentation/auth/login_screen.dart';
import 'package:paml_camrent/screens/admin/admin_booking_screen.dart';
import 'package:paml_camrent/screens/admin/admin_product_list_screen.dart';
import 'add_product_screen.dart'; // import halaman tambah produk

class AdminConfirmScreen extends StatelessWidget {
  const AdminConfirmScreen({super.key});

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), // batal
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // tutup dialog dulu
              _logout(context);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    const storage = FlutterSecureStorage();

    await storage.delete(key: 'authToken');

    // Tampilkan snackbar sebelum navigasi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Berhasil logout'),
        duration: Duration(seconds: 2),
      ),
    );

    // Tunggu sebentar agar user lihat snackbarnya
    await Future.delayed(const Duration(milliseconds: 1500));

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Admin'),
        actions: [
          // Tombol Logout
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selamat datang Admin!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Produk Kamera'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminProductListScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('List kamera tersedia'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminBookingListScreen()),
                );
              },
              icon: const Icon(Icons.assignment),
              label: const Text('List Peminjaman Kamera'),
            ),
          ],
        ),
      ),
    );
  }
}
