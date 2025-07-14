part of 'booking_bloc.dart';

@immutable
sealed class BookingEvent {}

class AddBookingEvent extends BookingEvent {
  final AddBookingRequestModel requestModel;
  AddBookingEvent({required this.requestModel});
}

class FetchMyBookingEvent extends BookingEvent {}

class FetchAllBookingsEvent extends BookingEvent {}

class UpdateBookingStatusEvent extends BookingEvent {
  final int bookingId;
  final String status;

  UpdateBookingStatusEvent({required this.bookingId, required this.status});
}

