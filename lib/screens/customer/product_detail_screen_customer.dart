import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paml_camrent/data/models/request/booking/add_booking_request_model.dart';
import 'package:paml_camrent/data/presentation/bloc/booking_bloc.dart';

import 'package:paml_camrent/repository/booking_repository.dart';

import 'package:paml_camrent/data/models/response/product/get_all_product__response_model.dart';
import 'package:paml_camrent/screens/customer/customer_checkout_screen.dart';
import 'package:paml_camrent/screens/customer/date_picker_screen.dart';
import 'package:paml_camrent/services/services_http_client.dart';

class ProductDetailScreenCustomer extends StatelessWidget {
  final Datum product;

  const ProductDetailScreenCustomer({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name ?? 'Detail Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Mengubah ListView menjadi Column
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar produk jika ada (opsional)
            // if (product.imageUrl != null)
            //   Image.network(product.imageUrl!, height: 200, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text("Nama: ${product.name ?? '-'}"),
            Text("Merek: ${product.brand ?? '-'}"),
            Text("Harga Sewa: Rp${product.rentalPricePerDay ?? '0'}/hari"),
            Text("Status: ${product.status ?? '-'}"),
            const SizedBox(height: 16),
            const Text(
              "Deskripsi:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(product.description ?? 'Tidak ada deskripsi.'),

            const Spacer(), // Mendorong tombol ke bagian bawah

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman pilih tanggal dan kirim data kamera
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DatePickerScreen(camera: product),
                    ),
                  );
                },
                child: const Text('Sewa Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
