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
}
