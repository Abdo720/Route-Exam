import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../widgets/product_card.dart';
import '../widgets/snackbar_homescreen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.loading) return Center(child: CircularProgressIndicator());
        if (state.error != null)
          return Center(child: Text('Error: ${state.error}'));
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Image.asset("assets/images/logo.png", height: 40, width: 86),
            actions: [
              BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) => Stack(
                  children: [
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsetsGeometry.only(right: 16, bottom: 16),
                        child: Image.asset(
                          "assets/images/shopping-basket.png",
                          height: 24,
                          width: 24,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CartScreen()),
                        );
                      },
                    ),
                    if (cartState.itemCount > 0)
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${cartState.itemCount}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Align(
                alignment: .centerLeft,
                child: Padding(
                  padding: EdgeInsetsGeometry.only(top: 8, left: 8),
                  child: Text(
                    "Recommendations",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: .w400,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (_) => SnackbarHomescreen(
                            product: product,
                            pool: product.pool,
                          ),
                        );
                      },
                      child: ProductCard(
                        product: product,
                        onAddToCart: () {
                          context.read<CartBloc>().add(AddToCart(product));
                          // show bottom sheet with pool = true when added to cart
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (_) => SnackbarHomescreen(
                              product: product,
                              pool: true,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
