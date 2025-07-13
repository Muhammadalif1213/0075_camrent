import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paml_camrent/data/models/request/booking/add_booking_request_model.dart';
import 'package:paml_camrent/data/presentation/cart/cart_bloc.dart';

import 'package:paml_camrent/data/models/response/product/get_all_product__response_model.dart';
import 'package:paml_camrent/screens/customer/booking_cart_screen.dart';
import 'package:paml_camrent/screens/customer/date_picker_screen.dart';

class ProductDetailScreenCustomer extends StatelessWidget {
  final Datum product;

  const ProductDetailScreenCustomer({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (product.fotoCamera != null && product.fotoCamera!.isNotEmpty) {
      try {
        imageBytes = base64Decode(product.fotoCamera!);
      } catch (_) {}
    }
    return Scaffold(
      appBar: AppBar(title: Text(product.name ?? 'Detail Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Mengubah ListView menjadi Column
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageBytes != null) ...[
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    imageBytes,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
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

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Tambahkan ke Keranjang'),
                onPressed: () {
                  final bloc = context.read<CartBloc>();
                  final state = bloc.state;

                  final alreadyInCart = state.items.any(
                    (item) => item.cameraId == product.id,
                  );

                  if (alreadyInCart) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Produk sudah ada di keranjang'),
                      ),
                    );
                  } else {
                    bloc.add(
                      AddToCartEvent(
                        item: CartItem(cameraId: product.id!, quantity: 1),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Berhasil ditambahkan ke keranjang'),
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text('Lihat Keranjang'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const BookingCartScreen(productList: []), // Pastikan screen ini sudah dibuat
                    ),
                  );
                },
              ),
            ),

            const Spacer(), // Mendorong tombol ke bagian bawah

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman pilih tanggal dan kirim data kamera
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DatePickerScreen(cameras: [product]),
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
