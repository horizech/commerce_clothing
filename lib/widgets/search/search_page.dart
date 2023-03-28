import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import 'package:shop/widgets/appbar/custom_appbar.dart';
import 'package:shop/widgets/products/products_list.dart';
import 'package:shop/widgets/products/products_service.dart';

class SearchPage extends StatelessWidget {
  final String query;
  final int? collection;
  const SearchPage({Key? key, required this.query, this.collection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Text("Search result for $query"),
            FutureBuilder<List<Product>>(
              future: ProductService.getProducts([], {}, null, query, {}),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 150,
                            width: 1000,
                            child: Container(color: Colors.grey[200]),
                          ),
                        );
                      },
                      itemCount: 6,
                    ),
                  );
                }
                return snapshot.hasData
                    ? ProductsList(
                        products: snapshot.data!,
                      )
                    : const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
