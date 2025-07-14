part of 'payment_bloc.dart';

@immutable
sealed class PaymentEvent {}

class SubmitPaymentEvent extends PaymentEvent {
  final AddPaymentRequestModel model;
  SubmitPaymentEvent(this.model);
}