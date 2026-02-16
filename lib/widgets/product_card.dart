import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  ProductCard({required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: product.image,
            placeholder: (context, url) => SizedBox(
              height: 120,
              width: 120,
              child: Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            ),
            errorWidget: (context, url, error) =>
                Icon(Icons.error, color: Colors.blue),
            height: 90,
            width: 90,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.amber, size: 18),
              Text("${product.rating.rate} (${product.rating.count} reviews)"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text("${product.price} EGP"),
              Spacer(),
              IconButton(
                onPressed: onAddToCart,
                icon: ImageIcon(
                  color: Colors.blue.shade800,
                  AssetImage("assets/images/shopping-basket-add.png"),
                ),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
