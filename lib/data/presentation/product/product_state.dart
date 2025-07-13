part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductAdded extends ProductState {
  final AddProductResponseModel product;

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

class ProductDetailLoaded extends ProductState {
  final Datum product;

  ProductDetailLoaded(this.product);
}

class ProductUpdated extends ProductState {
  final Data product;

  ProductUpdated({required this.product});
}

class ProductUpdateError extends ProductState {
  final String message;

  ProductUpdateError({required this.message});
}

class ProductUpdating extends ProductState {}

class ProductDeleted extends ProductState {
  final String message;

  ProductDeleted({required this.message});
}
