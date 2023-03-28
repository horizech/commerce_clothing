import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class SearchService {
  static Future<List<Product>> getProductsByQuery(String? query) async {
    List<QuerySearchItem> conditions = [];

    if (query != null) {
      conditions = [
        QuerySearchItem(
          name: "Name",
          condition: ColumnCondition.equal,
          caseSensitive: false,
          value: query,
        )
      ];

      try {
        APIResult productsResult =
            await Apiraiser.data.getByConditions("Products", conditions);
        List<Product> products = (productsResult.data as List<dynamic>)
            .map((p) => Product.fromJson(p as Map<String, dynamic>))
            .toList();
        return products;
      } catch (e) {
        debugPrint(e.toString());
      }
      return [];
    } else {
      return [];
    }
  }
}
