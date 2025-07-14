part of 'payment_bloc.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final AddPaymentResponseModel response;
  PaymentSuccess(this.response);
}

class PaymentFailure extends PaymentState {
  final String error;
  PaymentFailure(this.error);
}