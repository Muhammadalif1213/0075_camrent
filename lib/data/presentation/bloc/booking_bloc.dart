import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:paml_camrent/data/models/request/booking/add_booking_request_model.dart';
import 'package:paml_camrent/data/models/response/booking/add_booking_response_model.dart';
import 'package:paml_camrent/repository/booking_repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc({required this.bookingRepository}) : super(BookingInitial()) {
    on<AddBookingEvent>(_handleSubmitBooking);
    on<BookingEvent>((event, emit) async {});
  }

  Future<void> _handleSubmitBooking(
    AddBookingEvent event, // <-- Tipe event sekarang sudah spesifik dan benar
    Emitter<BookingState> emit,
  ) async {
    emit(CreateBookingLoading());

    final result = await bookingRepository.createBooking(event.requestModel);

    result.fold(
      (error) => emit(CreateBookingFailure(error: error)),
      (successResponse) =>
          emit(CreateBookingSuccess(response: successResponse)),
    );
  }
}
