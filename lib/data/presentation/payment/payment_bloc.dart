import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:paml_camrent/data/models/request/payment/add_payment_request_model.dart';
import 'package:paml_camrent/data/models/response/payment/add_payment_response_model.dart';
import 'package:paml_camrent/repository/payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentBloc({required this.paymentRepository}) : super(PaymentInitial()) {
    on<SubmitPaymentEvent>(_onSubmitPayment);
  }

  Future<void> _onSubmitPayment(
    SubmitPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await paymentRepository.addPayment(event.model);

    result.fold(
      (error) => emit(PaymentFailure(error)),
      (response) => emit(PaymentSuccess(response)),
    );
  }
}
