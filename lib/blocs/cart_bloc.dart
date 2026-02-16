import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final Product product;
  AddToCart(this.product);
}

class RemoveFromCart extends CartEvent {
  final int productId;
  RemoveFromCart(this.productId);
}

class IncrementQty extends CartEvent {
  final int productId;
  IncrementQty(this.productId);
}

class DecrementQty extends CartEvent {
  final int productId;
  DecrementQty(this.productId);
}

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

class CartState {
  final List<CartItem> cartItems;
  CartState(this.cartItems);

  double get total => cartItems.fold(
    0,
    (sum, item) => sum + item.product.price * item.quantity,
  );
  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState([])) {
    on<AddToCart>((event, emit) {
      final items = List<CartItem>.from(state.cartItems);
      final index = items.indexWhere(
        (item) => item.product.id == event.product.id,
      );
      if (index == -1) {
        items.add(CartItem(product: event.product));
      } else {
        items[index].quantity++;
      }
      emit(CartState(items));
    });

    on<RemoveFromCart>((event, emit) {
      final items = List<CartItem>.from(state.cartItems)
        ..removeWhere((item) => item.product.id == event.productId);
      emit(CartState(items));
    });

    on<IncrementQty>((event, emit) {
      final items = List<CartItem>.from(state.cartItems);
      final index = items.indexWhere(
        (item) => item.product.id == event.productId,
      );
      if (index != -1) items[index].quantity++;
      emit(CartState(items));
    });

    on<DecrementQty>((event, emit) {
      final items = List<CartItem>.from(state.cartItems);
      final index = items.indexWhere(
        (item) => item.product.id == event.productId,
      );
      if (index != -1 && items[index].quantity > 1) items[index].quantity--;
      emit(CartState(items));
    });
  }
}
