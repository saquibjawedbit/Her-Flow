import 'package:flutter/material.dart';
import 'package:her_flow/components/models/product_model.dart';
import 'package:her_flow/screens/marketplace/components/product_card.dart';

class Marketplacescreen extends StatelessWidget {
  const Marketplacescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Marketplace"),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 32,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            _searchBar(),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2 / 3.2,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final product = items[index];
                  return ProductCard(productModel: product);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  TextField _searchBar() {
    return TextField(
      keyboardType: TextInputType.name,
      autocorrect: true,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Search',
        labelStyle: const TextStyle(color: Colors.black), // Label text color

        prefixIcon:
            const Icon(Icons.search, color: Colors.black), // Search icon

        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
