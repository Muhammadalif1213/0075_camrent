import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paml_camrent/data/models/request/product/add_product_request_model.dart';
import 'package:paml_camrent/data/presentation/product/product_bloc.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _selectedImage;
  String _selectedStatus = 'available';

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 75);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final model = AddProductRequestModel(
        name: _nameController.text,
        brand: _brandController.text,
        description: _descriptionController.text,
        rentalPricePerDay: int.tryParse(_priceController.text),
        status: _selectedStatus,
      );

      context.read<ProductBloc>().add(AddProductEvent(requestModel: model));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Produk Kamera')),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Produk berhasil ditambahkan')),
            );
            Navigator.pop(context); // kembali ke halaman sebelumnya
          } else if (state is ProductError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Gagal: ${state.message}')));
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nama Kamera'),
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: _brandController,
                    decoration: const InputDecoration(labelText: 'Merek'),
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                    maxLines: 3,
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Harga Sewa / Hari',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    items: ['available', 'rented', 'maintenance']
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Status'),
                  ),
                  const SizedBox(height: 20),
                  if (_selectedImage != null)
                    Image.file(_selectedImage!, height: 150),

                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: Icon(Icons.camera_alt),
                        label: Text('Kamera'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: Icon(Icons.photo_library),
                        label: Text('Galeri'),
                      ),
                    ],
                  ),

                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
