import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paml_camrent/data/presentation/product/product_bloc.dart';
import 'package:paml_camrent/screens/admin/product_detail_screen.dart';

class AdminProductListScreen extends StatelessWidget {
  const AdminProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kamera'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProductBloc>().add(FetchAllProductsEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductListLoaded) {
            if (state.products.isEmpty) {
              return const Center(child: Text('Belum ada produk.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                final status = product.status ?? 'unknown';

                // Decode base64 image
                Image? imageWidget;
                if (product.fotoCamera != null) {
                  try {
                    final imageBytes = base64Decode(product.fotoCamera!);
                    imageWidget = Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    );
                  } catch (e) {
                    imageWidget = null;
                  }
                }

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
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar Produk
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            color: Colors.grey[200],
                          ),
                          child:
                              imageWidget ??
                              const Center(
                                child: Icon(Icons.image_not_supported),
                              ),
                        ),
                        const SizedBox(width: 12),

                        // Info Produk
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name ?? 'Tanpa Nama',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  product.brand ?? 'Tanpa Merek',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rp${product.rentalPricePerDay}/hari',
                                  style: const TextStyle(color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                _buildStatusBadge(status),
                              ],
                            ),
                          ),
                        ),

                        // Tombol Hapus
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _showDeleteConfirmation(context, product.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            context.read<ProductBloc>().add(FetchAllProductsEvent());
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    switch (status.toLowerCase()) {
      case 'available':
        bgColor = Colors.green;
        break;
      case 'not available':
        bgColor = Colors.red;
        break;
      default:
        bgColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 12),
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
              context.read<ProductBloc>().add(
                DeleteProductEvent(productId: productId),
              );
            },
          ),
        ],
      ),
    );
  }
}
