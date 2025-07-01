import 'package:flutter/material.dart';

class CustomerConfirmScreen extends StatelessWidget {
  const CustomerConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Customer')
      ),
      body:  const Center(
          child: Text(
            'Selamat datang Customer!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
    );
  }
}
