import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paml_camrent/data/models/request/product/add_product_request_model.dart';
import 'package:paml_camrent/data/models/response/product/get_all_product__response_model.dart';
import 'package:paml_camrent/data/presentation/product/product_bloc.dart';

class UpdateProductScreen extends StatefulWidget {
  final Datum product;

  const UpdateProductScreen({super.key, required this.product});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  String? _selectedStatus;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _brandController = TextEditingController(text: widget.product.brand);
    _descriptionController = TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(text: widget.product.rentalPricePerDay?.toString());
    _selectedStatus = widget.product.status ?? 'available';
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _submitUpdate() {
    if (_formKey.currentState!.validate()) {
      final updatedModel = AddProductRequestModel(
        name: _nameController.text,
        brand: _brandController.text,
        description: _descriptionController.text,
        rentalPricePerDay: int.tryParse(_priceController.text),
        status: _selectedStatus,
      );

      context.read<ProductBloc>().add(UpdateProductEvent(
        productId: widget.product.id!,
        updatedModel: updatedModel,
        imageFile: _selectedImage,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Produk")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Produk berhasil diperbarui")));
              Navigator.pop(context);
            } else if (state is ProductUpdateError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is ProductUpdating) {
              return const Center(child: CircularProgressIndicator());
            }

            return Form(
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
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Harga Sewa / Hari'),
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    items: ['available', 'rented', 'maintenance']
                        .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedStatus = value),
                    decoration: const InputDecoration(labelText: 'Status'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text("Ganti Gambar (Opsional)"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitUpdate,
                    child: const Text("Simpan Perubahan"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
