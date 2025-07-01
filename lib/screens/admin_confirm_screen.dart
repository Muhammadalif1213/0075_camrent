import 'package:flutter/material.dart';

class AdminConfirmScreen extends StatelessWidget {
  const AdminConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Admin')
      ),
      body: const Center(
        child: Text(
          'Selamat datang Admin!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
