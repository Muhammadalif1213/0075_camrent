part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class AddProductEvent extends ProductEvent {
  final AddProductRequestModel requestModel;

  AddProductEvent({required this.requestModel});
}

class FetchAllProductsEvent extends ProductEvent {}

class FetchProductDetailEvent extends ProductEvent {
  final int id;

  FetchProductDetailEvent(this.id);
}

class DeleteProductEvent extends ProductEvent {
  final int productId;

  DeleteProductEvent({required this.productId});
}

class UpdateProductEvent extends ProductEvent {
  final int productId;
  final AddProductRequestModel updatedModel;
  final File? imageFile;

  UpdateProductEvent({
    required this.productId,
    required this.updatedModel,
    this.imageFile,
  });
}
