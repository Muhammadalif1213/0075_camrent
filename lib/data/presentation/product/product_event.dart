part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {
  
}

class AddProductEvent extends ProductEvent {
  final AddProductRequestModel requestModel;

  AddProductEvent({required this.requestModel});
}

class FetchAllProductsEvent extends ProductEvent {}
