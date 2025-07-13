import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:paml_camrent/data/presentation/auth/login/login_bloc.dart';
import 'package:paml_camrent/data/presentation/auth/login_screen.dart';
import 'package:paml_camrent/data/presentation/auth/profile/profile_bloc_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Ambil data profil saat halaman pertama kali dibuka
    context.read<ProfileBloc>().add(FetchProfile());
  }

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
      appBar: AppBar(title: const Text('Profil Saya')),
      // Gunakan BlocListener untuk menangani aksi logout
      body: BlocBuilder<ProfileBloc, ProfileBlocState>(
        builder: (context, state) {
          // --- KONDISI LOADING ---
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // --- KONDISI GAGAL ---
          if (state is ProfileFailure) {
            return Center(child: Text('Gagal memuat profil: ${state.error}'));
          }

          // --- KONDISI SUKSES (INI BAGIAN PENTINGNYA) ---
          if (state is ProfileSuccess) {
            // Ambil data user dari state
            final user = state.profile.user;

            // Gunakan data 'user' untuk membangun UI
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person, size: 50),
                      ),
                      const SizedBox(height: 16),
                      Text( user?.name ?? 'Nama Pengguna',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        user?.email ??
                            'email@pengguna.com', // <-- Gunakan data dari state
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 40),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Nama Lengkap'),
                    subtitle: Text(
                      user?.name ?? '-',
                    ), // <-- Gunakan data dari state
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Email'),
                    subtitle: Text(
                      user?.email ?? '-',
                    ), // <-- Gunakan data dari state
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.shield_outlined),
                    title: const Text('Peran'),
                    subtitle: Text(
                      user?.role?.toUpperCase() ?? '-',
                    ), // <-- Gunakan data dari state
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _confirmLogout(context);
                    },
                    child: const Text('Logout'),
                  ),
                ),
              ],
            );
          }

          // Tampilan default jika state adalah Initial atau lainnya
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
