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
    } else {
      _numberOfDays = 0;
      _totalPrice = 0.0;
    }
    setState(() {});
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
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      if (isStartDate) {
        _startDate = picked;
        _startDateController.text = formattedDate;
      } else {
        _endDate = picked;
        _endDateController.text = formattedDate;
      }
      _calculatePrice();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Tanggal Sewa'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Daftar Kamera yang Disewa",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Kamera List
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.cameras.length,
                itemBuilder: (context, index) {
                  final cam = widget.cameras[index];
                  Uint8List? imageBytes;
                  if (cam.fotoCamera != null && cam.fotoCamera!.isNotEmpty) {
                    try {
                      imageBytes = base64Decode(cam.fotoCamera!);
                    } catch (_) {}
                  }

                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            imageBytes != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      imageBytes,
                                      height: 60,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(Icons.camera_alt, size: 40),
                            const SizedBox(height: 6),
                            Text(
                              cam.name ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Rp${cam.rentalPricePerDay}/hari',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Date Picker
            TextFormField(
              controller: _startDateController,
              decoration: const InputDecoration(
                labelText: 'Tanggal Mulai',
                border: OutlineInputBorder(),
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
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, false),
            ),

            const SizedBox(height: 20),

            // Total Price Display
            if (_totalPrice > 0)
              Card(
                color: Colors.green.shade50,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  child: Text(
                    'Total: Rp ${_totalPrice.toStringAsFixed(0)} untuk $_numberOfDays hari',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),

            const Spacer(),

            // Button Checkout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Lanjut ke Checkout'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
