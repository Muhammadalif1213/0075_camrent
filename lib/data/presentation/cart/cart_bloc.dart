import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:paml_camrent/data/models/request/booking/add_booking_request_model.dart';
import 'package:paml_camrent/data/models/response/product/get_all_product__response_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState()) {
    on<CartEvent>((event, emit) {
      
    });
    on<AddToCartEvent>((event, emit) {
      final exists = state.items.any((e) => e.cameraId == event.item.cameraId);
      if (!exists) {
        final updated = List<CartItem>.from(state.items)..add(event.item);
        emit(state.copyWith(items: updated));
      }
    });

    on<RemoveFromCartEvent>((event, emit) {
      final updated = state.items.where((e) => e.cameraId != event.cameraId).toList();
      emit(state.copyWith(items: updated));
    });

    on<ClearCartEvent>((event, emit) {
      emit(const CartState(items: []));
    });
  }
}
