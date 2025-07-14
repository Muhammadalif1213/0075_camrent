part of 'cart_bloc.dart';

@immutable
class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}

class CartInitial extends CartState {
  const CartInitial() : super(items: const []);
}
