import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/product_repository.dart';
import '../models/product.dart';

abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

class ProductState {
  final List<Product> products;
  final bool loading;
  final String? error;
  ProductState({required this.products, required this.loading, this.error});
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repo;
  ProductBloc(this.repo) : super(ProductState(products: [], loading: true)) {
    on<LoadProducts>((event, emit) async {
      emit(ProductState(products: [], loading: true));
      try {
        final products = await repo.fetchProducts();
        emit(ProductState(products: products, loading: false));
      } catch (e) {
        emit(ProductState(products: [], loading: false, error: e.toString()));
      }
    });
  }
}
