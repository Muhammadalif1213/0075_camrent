import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paml_camrent/data/models/response/booking/booking_response_model.dart';
import 'package:paml_camrent/data/presentation/booking/booking_bloc.dart';

class AdminBookingListScreen extends StatefulWidget {
  const AdminBookingListScreen({super.key});

  @override
  State<AdminBookingListScreen> createState() => _AdminBookingListScreenState();
}

class _AdminBookingListScreenState extends State<AdminBookingListScreen> {
  @override
  void initState() {
    super.initState();
    // Kirim event untuk mengambil semua data booking saat halaman dibuka
    context.read<BookingBloc>().add(FetchAllBookingsEvent());
  }

  // Helper untuk mendapatkan warna berdasarkan status
  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange.shade700;
      case 'approved':
      case 'ongoing':
        return Colors.blue.shade700;
      case 'completed':
        return Colors.green.shade700;
      case 'rejected':
      case 'cancelled':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Booking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<BookingBloc>().add(FetchAllBookingsEvent());
            },
          ),
        ],
      ),
      // Gunakan BlocConsumer untuk listener (aksi notifikasi) dan builder (membangun UI)
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          // Tampilkan notifikasi untuk hasil update status
          if (state is BookingActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is CreateBookingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          // --- KONDISI LOADING ---
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // --- KONDISI GAGAL MEMUAT DATA ---
          if (state is CreateBookingFailure) {
            return Center(child: Text(state.error));
          }
          // --- KONDISI SUKSES MEMUAT DATA ---
          if (state is AllBookingsLoadSuccess) {
            if (state.bookings.isEmpty) {
              return const Center(child: Text('Tidak ada pesanan booking.'));
            }
            // Tampilkan daftar booking
            return ListView.builder(
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                final cameraNames = booking.cameras
                    .map((c) => c.name)
                    .join(', ');

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Informasi Utama Booking ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'Booking #${booking.id} - ${booking.user.name}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Chip(
                              label: Text(
                                booking.status.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: _getStatusColor(booking.status),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        const Divider(),
                        // --- Detail Booking ---
                        Text(
                          'Tanggal: ${booking.startDate} s/d ${booking.endDate}',
                        ),
                        Text('Item: $cameraNames'),
                        Text(
                          'Total: Rp ${booking.totalPrice}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        // --- Tombol Aksi (Hanya muncul jika status 'pending') ---
                        if (booking.status == 'pending')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  // Kirim event Reject
                                  context.read<BookingBloc>().add(
                                    UpdateBookingStatusEvent(
                                      bookingId: booking.id,
                                      status: 'rejected',
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Reject'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  // Kirim event Approve
                                  context.read<BookingBloc>().add(
                                    UpdateBookingStatusEvent(
                                      bookingId: booking.id,
                                      status: 'approved',
                                    ),
                                  );
                                },
                                child: const Text('Approve'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          // Tampilan default atau saat state adalah Initial
          return const Center(child: Text('Memuat data booking...'));
        },
      ),
    );
  }
}
