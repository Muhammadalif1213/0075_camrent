import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paml_camrent/data/presentation/product/product_bloc.dart';
import 'package:paml_camrent/data/models/response/product/get_all_product__response_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final Datum product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name ?? 'Detail Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context, product.id);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Text("Nama: ${product.name}"),
            Text("Merek: ${product.brand}"),
            Text("Harga Sewa: Rp${product.rentalPricePerDay}/hari"),
            Text("Status: ${product.status}"),
            const SizedBox(height: 16),
            Text("Deskripsi:"),
            Text(product.description ?? ''),
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
              context.read<ProductBloc>().add(DeleteProductEvent(productId: productId));
              Navigator.pop(context); // kembali ke halaman sebelumnya
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Produk dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
