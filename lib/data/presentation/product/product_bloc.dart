import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:paml_camrent/data/models/request/product/add_product_request_model.dart';
import 'package:paml_camrent/data/models/response/product/add_product_response.dart';
import 'package:paml_camrent/data/models/response/product/get_all_product__response_model.dart';
import 'package:paml_camrent/repository/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<AddProductEvent>(_addProduct);
    on<FetchAllProductsEvent>(_fetchAllProducts);
    on<DeleteProductEvent>(_deleteProduct);
    on<UpdateProductEvent>(_updateProduct);
    on<FetchProductDetailEvent>(_onFetchProductDetail);

    on<ProductEvent>((event, emit) async {});
  }

  Future<void> _addProduct(
    AddProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final product = await productRepository.createProduct(event.requestModel);
    product.fold((error) => emit(ProductError(message: error)), (response) {
      emit(ProductAdded(product: response));
    });
  }

  Future<void> _updateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await productRepository.updateProduct(
      id: event.productId,
      model: event.updatedModel,
      imageFile: event.imageFile,
    );
    result.fold(
      (error) => emit(ProductError(message: error)),
      (updatedProduct) => emit(ProductUpdated(product: updatedProduct.data!)),
    );
  }

  Future<void> _onFetchProductDetail(
    FetchProductDetailEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await productRepository.getDetailProduct(event.id);

    result.fold(
      (error) => emit((ProductError(message: error))),
      (product) => emit(ProductDetailLoaded(product)),
    );
  }

  Future<void> _fetchAllProducts(
    FetchAllProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await productRepository.getAllProducts();
      emit(ProductListLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _deleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await productRepository.deleteProduct(event.productId);
      emit(
        ProductDeleted(message: ''),
      ); // Optional: buat state khusus untuk delete
      add(FetchAllProductsEvent()); // untuk refresh data
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}
