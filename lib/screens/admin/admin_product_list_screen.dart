import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paml_camrent/data/presentation/product/product_bloc.dart';
import 'package:paml_camrent/screens/admin/product_detail_screen.dart';

class AdminProductListScreen extends StatelessWidget {
  const AdminProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Kamera Tersedia')),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductListLoaded) {
            if (state.products.isEmpty) {
              return const Center(child: Text('Belum ada produk.'));
            }

            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(product.name ?? 'No Name'),
                      subtitle: Text('${product.brand} • Rp${product.rentalPricePerDay}/hari'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmation(context, product.id);
                        },
                      ),
                    ), 
                  ),
                );
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            // State awal, trigger ambil data
            context.read<ProductBloc>().add(FetchAllProductsEvent());
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int? productId) {
    if (productId == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: const Text('Apakah kamu yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Hapus'),
            onPressed: () {
              Navigator.pop(context);
              context.read<ProductBloc>().add(DeleteProductEvent(productId: productId));
            },
          ),
        ],
      ),
    );
  }
}
