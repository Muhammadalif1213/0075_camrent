import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paml_camrent/data/models/request/booking/add_booking_request_model.dart';
import 'package:paml_camrent/data/presentation/bloc/booking_bloc.dart';

class CustomerCheckoutScreen extends StatelessWidget {
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
  });

  // Method submit tetap sama
  void _submitBooking(BuildContext context) {
    final requestModel = AddBookingRequestModel(
      startDate: startDate,
      endDate: endDate,
      items: cartItems,
    );
    context.read<BookingBloc>().add(
      AddBookingEvent(requestModel: requestModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil nama kamera dari item pertama (karena alurnya dari detail)
    // Untuk alur multi-item, Anda perlu menampilkan list
    final cameraName =
        'Kamera Pilihan Anda'; // Ganti dengan data asli jika perlu

    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi Akhir')),
      body: BlocListener<BookingBloc, BookingState>(
        // Listener untuk hasil booking
        listener: (context, state) {
          if (state is CreateBookingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.response.message ?? 'Booking Berhasil!'),
              ),
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
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text('Item: $cameraName'),
              Text('Tanggal Mulai: $startDate'),
              Text('Tanggal Selesai: $endDate'),
              const Divider(height: 32),
              Text(
                'Total Pembayaran: Rp $totalPrice',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  if (state is CreateBookingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _submitBooking(context),
                      child: const Text('Konfirmasi & Booking'),
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
