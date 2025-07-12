part of 'booking_bloc.dart';

@immutable
sealed class BookingState {}

final class BookingInitial extends BookingState {}
class CreateBookingLoading extends BookingState {}
class CreateBookingSuccess extends BookingState {
  final AddBookingResponseModel response; // Membawa response sukses
  CreateBookingSuccess({required this.response});
}
class CreateBookingFailure extends BookingState {
  final String error;
  CreateBookingFailure({required this.error});
}