part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final CartItem item;
  AddToCartEvent({required this.item});
}

class RemoveFromCartEvent extends CartEvent {
  final int cameraId;
  RemoveFromCartEvent({required this.cameraId});
}

class ClearCartEvent extends CartEvent {}
