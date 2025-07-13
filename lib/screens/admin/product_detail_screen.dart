import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paml_camrent/data/models/response/product/get_all_product__response_model.dart';
import 'package:paml_camrent/data/presentation/product/product_bloc.dart';
import 'package:paml_camrent/screens/admin/update_product_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Datum product;

  const ProductDetailScreen({super.key, required this.product});

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
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context, product.id);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
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
            Text("Harga Sewa: Rp${product.rentalPricePerDay ?? '-'} / hari"),
            Text("Status: ${product.status ?? '-'}"),
            const SizedBox(height: 16),
            const Text("Deskripsi:"),
            Text(product.description ?? '-'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdateProductScreen(product: product),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Produk"),
            ),
          ],
        ),
      ),
    );
  }
  void _showDeleteConfirmation(BuildContext context, int? productId) {
    if (productId == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProductBloc>().add(
                DeleteProductEvent(productId: productId),
              );
              Navigator.pop(context); // kembali ke halaman sebelumnya
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Produk dihapus')));
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
