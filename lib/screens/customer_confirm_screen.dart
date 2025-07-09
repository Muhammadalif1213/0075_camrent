import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:paml_camrent/data/models/response/product/get_all_product__response_model.dart';
import 'package:paml_camrent/data/presentation/auth/login_screen.dart';
import 'package:paml_camrent/data/presentation/product/product_bloc.dart';

class CustomerConfirmScreen extends StatefulWidget {
  const CustomerConfirmScreen({super.key});

  @override
  State<CustomerConfirmScreen> createState() => _CustomerConfirmScreenState();
}

class _CustomerConfirmScreenState extends State<CustomerConfirmScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchAllProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Customer'),
        
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductListLoaded) {
            if (state.products.isEmpty) {
              return const Center(child: Text('Tidak ada produk tersedia.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final Datum product = state.products[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(product.name ?? 'Tanpa Nama'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Brand: ${product.brand ?? '-'}'),
                        Text('Harga: Rp${product.rentalPricePerDay ?? '-'} / hari'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text('Gagal mengambil data: ${state.message}'));
          }

          return const Center(child: Text('Memuat data produk...'));
        },
      ),
    );
  }
}
