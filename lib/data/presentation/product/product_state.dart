part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductAdded extends ProductState {
  final Data product;

  ProductAdded({required this.product});
}

class ProductError extends ProductState {
  final String message;

  ProductError({required this.message});
}

class ProductListLoaded extends ProductState {
  final List<Datum> products;

  ProductListLoaded({required this.products});
}
