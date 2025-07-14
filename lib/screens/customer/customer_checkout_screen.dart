import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paml_camrent/data/models/request/booking/add_booking_request_model.dart';
import 'package:paml_camrent/data/models/response/product/get_all_product__response_model.dart';
import 'package:paml_camrent/data/presentation/booking/booking_bloc.dart';

class CustomerCheckoutScreen extends StatelessWidget {
  final List<Datum> productList;
  final List<CartItem> cartItems;
  final String startDate;
  final String endDate;
  final double totalPrice;

  const CustomerCheckoutScreen({
    super.key,
    required this.cartItems,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.productList,
  });

  void _submitBooking(BuildContext context) {
    final requestModel = AddBookingRequestModel(
      startDate: startDate,
      endDate: endDate,
      items: cartItems,
    );
    context.read<BookingBloc>().add(AddBookingEvent(requestModel: requestModel));
  }

  @override
  Widget build(BuildContext context) {
    final DateTime start = DateTime.parse(startDate);
    final DateTime end = DateTime.parse(endDate);
    final int durationInDays = end.difference(start).inDays + 1;
    final formatter = NumberFormat.decimalPattern('id');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Akhir'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is CreateBookingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.response.message ?? 'Booking Berhasil!')),
            );
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (state is CreateBookingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ringkasan Pesanan',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),

              // Daftar item
              ...cartItems.map((item) {
                final product = productList.firstWhere((p) => p.id == item.cameraId);
                final double pricePerDay =
                    double.tryParse(product.rentalPricePerDay ?? '0') ?? 0;
                final double itemTotal =
                    pricePerDay * durationInDays * item.quantity;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name ?? '-',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Durasi: $durationInDays hari'),
                        Text('Harga per hari: Rp ${formatter.format(pricePerDay)}'),
                        Text('Subtotal: Rp ${formatter.format(itemTotal)}'),
                      ],
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 8),
              Text('Tanggal Mulai: $startDate'),
              Text('Tanggal Selesai: $endDate'),
              const Divider(height: 32),

              // Total Price
              Card(
                color: Colors.green.shade50,
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rp ${formatter.format(totalPrice)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Button
              BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  if (state is BookingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('Konfirmasi & Booking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () => _submitBooking(context),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
