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
      appBar: AppBar(
        title: Text(product.name ?? 'Detail Produk'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk
            if (imageBytes != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  imageBytes,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Nama Produk
            Text(
              product.name ?? 'Nama Kamera',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              product.brand ?? 'Merek',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),

            // Harga & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rp${product.rentalPricePerDay ?? '0'}/hari',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Chip(
                  label: Text(
                    product.status?.toUpperCase() ?? 'STATUS',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: product.status == 'available'
                      ? Colors.green
                      : Colors.redAccent,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Deskripsi
            const Text(
              'Deskripsi Produk',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              product.description ?? 'Tidak ada deskripsi.',
              style: const TextStyle(height: 1.5),
            ),
            const SizedBox(height: 32),

            // Tombol Aksi
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Tambah ke Keranjang'),
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
                            backgroundColor: Colors.orange,
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
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  tooltip: 'Lihat Keranjang',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const BookingCartScreen(productList: []),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tombol Sewa Sekarang
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.schedule_send),
                label: const Text('Sewa Sekarang'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.orange.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DatePickerScreen(cameras: [product]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
