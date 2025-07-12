part of 'booking_bloc.dart';

@immutable
sealed class BookingEvent {}

class AddBookingEvent extends BookingEvent {
  final AddBookingRequestModel requestModel;
  AddBookingEvent({required this.requestModel});
}
