part of 'booking_bloc.dart';

@immutable
sealed class BookingState {}

final class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class CreateBookingSuccess extends BookingState {
  final AddBookingResponseModel response; // Membawa response sukses
  CreateBookingSuccess({required this.response});
}

class CreateBookingFailure extends BookingState {
  final String error;
  CreateBookingFailure({required this.error});
}

// State sukses KHUSUS setelah berhasil MENGAMBIL daftar booking
class BookingFetchSuccess extends BookingState {
  final List<Booking> bookings;
  BookingFetchSuccess({required this.bookings});
}

// // Saat memuat list pemesanan
// class BookingListLoaded extends BookingState {
//   final List<BookingData> bookings;
//   BookingListLoaded({required this.bookings});
// }

// Saat gagal mengambil list atau terjadi kesalahan umum
class BookingError extends BookingState {
  final String message;
  BookingError({required this.message});
}

// Saat status pemesanan berhasil diubah (approve/reject)
class BookingStatusUpdated extends BookingState {
  final String message; // e.g. "Status berhasil diubah ke approved"
  BookingStatusUpdated({required this.message});
}

// Saat gagal mengubah status pemesanan
class BookingStatusUpdateFailed extends BookingState {
  final String error;
  BookingStatusUpdateFailed({required this.error});
}

class AllBookingsLoadSuccess extends BookingState {
  final List<Booking> bookings;
  AllBookingsLoadSuccess({required this.bookings});
}

// State umum jika ada aksi yang sukses (create, update, dll)
class BookingActionSuccess extends BookingState {
  final String message;
  BookingActionSuccess({required this.message});
}

class MyBookingLoading extends BookingState {}

class MyBookingLoaded extends BookingState {
  final List<BookingData> bookings;
  MyBookingLoaded({required this.bookings});
}

class MyBookingError extends BookingState {
  final String message;
  MyBookingError({required this.message});
}
