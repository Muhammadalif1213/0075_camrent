import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:paml_camrent/data/models/request/booking/add_booking_request_model.dart';
import 'package:paml_camrent/data/models/response/booking/add_booking_response_model.dart';
import 'package:paml_camrent/data/models/response/booking/booking_response_model.dart';
import 'package:paml_camrent/data/models/response/booking/booking_history_response_model.dart';
import 'package:paml_camrent/repository/booking_repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc({required this.bookingRepository}) : super(BookingInitial()) {
    on<AddBookingEvent>(_handleSubmitBooking);
    // on<FetchMyBookingEvent>(_onFetchMyBookings);
    on<FetchAllBookingsEvent>(_onFetchAllBookings);
    on<UpdateBookingStatusEvent>(_onUpdateStatus);
    on<BookingEvent>((event, emit) async {});
  }

  Future<void> _handleSubmitBooking(
    AddBookingEvent event, // <-- Tipe event sekarang sudah spesifik dan benar
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());

    final result = await bookingRepository.createBooking(event.requestModel);

    result.fold(
      (error) => emit(CreateBookingFailure(error: error)),
      (successResponse) =>
          emit(CreateBookingSuccess(response: successResponse)),
    );
  }

  // Future<void> _onFetchMyBookings(
  //   FetchMyBookingEvent event,
  //   Emitter<BookingState> emit,
  // ) async {
  //   emit(MyBookingLoading());
  //   final bookings = await bookingRepository.fetchMyBookings();
  //   try {
  //     emit(MyBookingLoaded(bookings: bookings));
  //   } catch (e) {
  //     emit(MyBookingError(message: e.toString()));
  //   }
  // }

  // Handler untuk mengambil riwayat booking customer
  // Future<void> _onFetchMyBookings(
  //   FetchMyBookings event,
  //   Emitter<BookingState> emit,
  // ) async {
  //   emit(BookingLoading());
  //   final result = await bookingRepository.getMyBookings();
  //   result.fold(
  //     (error) => emit(CreateBookingFailure(error: error)),
  //     (bookings) => emit(MyBookingsLoadSuccess(bookings: bookings)),
  //   );
  // }

  // Handler untuk mengambil semua booking (admin)
  Future<void> _onFetchAllBookings(
    FetchAllBookingsEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await bookingRepository.getAllBookings();
    result.fold(
      (error) => emit(CreateBookingFailure(error: error)),
      (bookings) => emit(AllBookingsLoadSuccess(bookings: bookings)),
    );
  }

  // Handler untuk update status booking (admin)
  Future<void> _onUpdateStatus(
    UpdateBookingStatusEvent event,
    Emitter<BookingState> emit,
  ) async {
    // Anda bisa emit state loading spesifik jika ingin menampilkan loading per item
    // emit(BookingUpdateLoading(bookingId: event.bookingId));
    final result = await bookingRepository.updateBookingStatus(
      event.bookingId,
      event.status,
    );
    result.fold((error) => emit(CreateBookingFailure(error: error)), (
      successMessage,
    ) {
      emit(BookingActionSuccess(message: successMessage));
      // Secara otomatis mengambil ulang daftar booking setelah status diubah
      add(FetchAllBookingsEvent());
    });
  }
}
