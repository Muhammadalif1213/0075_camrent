import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paml_camrent/data/models/request/booking/add_booking_request_model.dart';
import 'package:paml_camrent/data/models/response/product/get_all_product__response_model.dart';
import 'package:paml_camrent/screens/customer/customer_checkout_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paml_camrent/data/presentation/booking/booking_bloc.dart';
import 'package:paml_camrent/repository/booking_repository.dart';
import 'package:paml_camrent/services/services_http_client.dart';

class DatePickerScreen extends StatefulWidget {
  final List<Datum> cameras;

  const DatePickerScreen({super.key, required this.cameras});

  @override
  State<DatePickerScreen> createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  double _totalPrice = 0.0;
  int _numberOfDays = 0;

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _calculatePrice() {
    if (_startDate != null &&
        _endDate != null &&
        _endDate!.isAfter(_startDate!)) {
      _numberOfDays = _endDate!.difference(_startDate!).inDays + 1;
      _totalPrice = 0;

      for (final cam in widget.cameras) {
        final pricePerDay = double.tryParse(cam.rentalPricePerDay ?? '0') ?? 0;
        _totalPrice += pricePerDay * _numberOfDays;
      }

      setState(() {});
    } else {
      setState(() {
        _numberOfDays = 0;
        _totalPrice = 0.0;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? _startDate ?? DateTime.now()),
      firstDate: isStartDate ? DateTime.now() : _startDate ?? DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        if (isStartDate) {
          _startDate = picked;
          _startDateController.text = formattedDate;
        } else {
          _endDate = picked;
          _endDateController.text = formattedDate;
        }
        _calculatePrice();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Tanggal Sewa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Daftar Kamera yang Disewa:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cameras.length,
                itemBuilder: (context, index) {
                  final cam = widget.cameras[index];
                  Uint8List? imageBytes;
                  if (cam.fotoCamera != null && cam.fotoCamera!.isNotEmpty) {
                    try {
                      imageBytes = base64Decode(cam.fotoCamera!);
                    } catch (_) {}
                  }

                  return Card(
                    child: ListTile(
                      leading: imageBytes != null
                          ? Image.memory(
                              imageBytes,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.camera_alt, size: 40),
                      title: Text(cam.name ?? 'No name'),
                      subtitle: Text(
                        'Rp${cam.rentalPricePerDay}/hari - ${cam.brand}',
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _startDateController,
              decoration: const InputDecoration(
                labelText: 'Tanggal Mulai',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, true),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _endDateController,
              decoration: const InputDecoration(
                labelText: 'Tanggal Selesai',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, false),
            ),
            const SizedBox(height: 16),
            if (_totalPrice > 0)
              Card(
                color: Colors.green.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Total: Rp $_totalPrice untuk $_numberOfDays hari',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    (_startDate != null &&
                        _endDate != null &&
                        _endDate!.isAfter(_startDate!))
                    ? () {
                        final items = widget.cameras.map((cam) {
                          return CartItem(cameraId: cam.id!, quantity: 1);
                        }).toList();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => BookingBloc(
                                bookingRepository: BookingRepository(
                                  ServicesHttpClient(),
                                ),
                              ),
                              child: CustomerCheckoutScreen(
                                cartItems: items,
                                startDate: _startDateController.text,
                                endDate: _endDateController.text,
                                totalPrice: _totalPrice,
                                productList: widget.cameras,
                              ),
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text('Lanjut ke Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
