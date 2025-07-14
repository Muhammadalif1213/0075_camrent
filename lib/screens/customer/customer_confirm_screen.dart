import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paml_camrent/data/models/response/product/get_all_product__response_model.dart';
import 'package:paml_camrent/data/presentation/auth/profile/profile_bloc_bloc.dart';
import 'package:paml_camrent/data/presentation/product/product_bloc.dart';
import 'package:paml_camrent/screens/customer/product_detail_screen_customer.dart';

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
    context.read<ProfileBloc>().add(FetchProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('CamRent'),
        centerTitle: true,
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildGreetingBanner(),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductListLoaded) {
                  if (state.products.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada kamera tersedia.'),
                    );
                  }

                  final sorted = [...state.products];
                  sorted.sort((a, b) {
                    const priority = {
                      'available': 0,
                      'rented': 1,
                      'maintenance': 2,
                    };
                    return (priority[a.status] ?? 99).compareTo(
                      priority[b.status] ?? 99,
                    );
                  });

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: sorted.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemBuilder: (context, index) {
                      final cam = sorted[index];
                      Uint8List? imageBytes;
                      if (cam.fotoCamera != null &&
                          cam.fotoCamera!.isNotEmpty) {
                        try {
                          imageBytes = base64Decode(cam.fotoCamera!);
                        } catch (_) {}
                      }

                      final isAvailable = cam.status == 'available';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailScreenCustomer(product: cam),
                            ),
                          );
                        },
                        child: Card(
                          color: isAvailable
                              ? Colors.white
                              : Colors.grey.shade300,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: imageBytes != null
                                    ? Image.memory(
                                        imageBytes,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 120,
                                        width: double.infinity,
                                        color: Colors.grey.shade200,
                                        child: const Icon(
                                          Icons.camera_alt,
                                          size: 40,
                                        ),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cam.name ?? 'Tanpa Nama',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Merek: ${cam.brand ?? '-'}'),
                                    Text(
                                      'Rp${cam.rentalPricePerDay ?? '-'} / hari',
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isAvailable
                                            ? Colors.green.shade100
                                            : Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        cam.status ?? 'unknown',
                                        style: TextStyle(
                                          color: isAvailable
                                              ? Colors.green
                                              : Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ProductError) {
                  return Center(
                    child: Text('Gagal memuat data: ${state.message}'),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingBanner() {
    return BlocBuilder<ProfileBloc, ProfileBlocState>(
      builder: (context, state) {
        String greetingName = 'Customer';

        if (state is ProfileSuccess) {
          final userName = state.profile.user?.name;
          if (userName != null && userName.isNotEmpty) {
            greetingName = userName;
          }
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          color: Colors.orange.shade700,
          child: Row(
            children: [
              const Icon(Icons.camera_alt, size: 40, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat datang, $greetingName! 👋',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Kamu mau cari kamera apa ?📸',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
