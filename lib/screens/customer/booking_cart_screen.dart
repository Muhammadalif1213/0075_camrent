import 'package:flutter/material.dart';
import 'package:paml_camrent/data/models/response/booking/booking_cart_model.dart';
import 'package:paml_camrent/data/models/response/product/get_all_product__response_model.dart';
import 'package:provider/provider.dart';

class BookingCartScreen extends StatelessWidget {
  const BookingCartScreen({super.key, required List<Datum> productList});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<BookingCartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang Booking")),
      body: cart.items.isEmpty
          ? const Center(child: Text("Cart kosong."))
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(item.camera.name ?? ''),
                  subtitle: Text(
                    'Qty: ${item.quantity} — Rp${item.camera.rentalPricePerDay}/hari',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      cart.removeCamera(item.camera.id!);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                onPressed: () {
                  // Lanjut ke halaman tanggal booking
                },
                child: const Text("Pilih Jadwal dan Booking"),
              ),
            )
          : null,
    );
  }
}
