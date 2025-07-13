import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paml_camrent/data/models/response/booking/add_booking_response_model.dart';

// Import model dan halaman yang relevan
import 'package:paml_camrent/data/models/response/product/get_all_product__response_model.dart';
import 'package:paml_camrent/data/models/request/booking/add_booking_request_model.dart';
import 'package:paml_camrent/screens/customer/customer_checkout_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paml_camrent/data/presentation/booking/booking_bloc.dart';
import 'package:paml_camrent/repository/booking_repository.dart';
import 'package:paml_camrent/services/services_http_client.dart';

class DatePickerScreen extends StatefulWidget {
  final Datum camera; // Menerima data kamera dari halaman detail
  const DatePickerScreen({super.key, required this.camera});

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
      // Hitung selisih hari
      _numberOfDays = _endDate!.difference(_startDate!).inDays + 1;
      // Ambil harga dari model kamera dan hitung totalnya
      final pricePerDay =
          double.tryParse(widget.camera.rentalPricePerDay ?? '0') ?? 0;
      setState(() {
        _totalPrice = pricePerDay * _numberOfDays;
      });
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
        // Hitung ulang harga setiap kali tanggal berubah
        _calculatePrice();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (widget.camera.fotoCamera != null &&
        widget.camera.fotoCamera!.isNotEmpty) {
      try {
        imageBytes = base64Decode(widget.camera.fotoCamera!);
      } catch (_) {}
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Tanggal Sewa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Text(
              'Kamera: ${widget.camera.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Harga: Rp ${widget.camera.rentalPricePerDay} / hari',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _startDateController,
              decoration: const InputDecoration(
                labelText: 'Tanggal Mulai',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, true),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _endDateController,
              decoration: const InputDecoration(
                labelText: 'Tanggal Selesai',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, false),
            ),
            const SizedBox(height: 24),
            // Menampilkan total biaya secara dinamis
            if (_totalPrice > 0)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total Biaya: Rp $_totalPrice untuk $_numberOfDays hari',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    (_startDate != null &&
                        _endDate != null &&
                        _endDate!.isAfter(_startDate!))
                    ? () {
                        final item = CartItem(
                          cameraId: widget.camera.id!,
                          quantity: 1,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              // PERBAIKAN: Buat instance baru di sini, bukan context.read()
                              create: (context) => BookingBloc(
                                bookingRepository: BookingRepository(
                                  ServicesHttpClient(),
                                ),
                              ),
                              child: CustomerCheckoutScreen(
                                cartItems: [item],
                                startDate: _startDateController.text,
                                endDate: _endDateController.text,
                                totalPrice: _totalPrice,
                              ),
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text('Lanjut ke Keranjang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
