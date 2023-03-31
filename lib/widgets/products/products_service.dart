import 'package:apiraiser/apiraiser.dart';

import 'package:flutter/foundation.dart';
import 'package:shop/models/product.dart';
import 'package:shop/widgets/variations/variation_types.dart';

class ProductService {
  static Future<List<Product>> getProducts(
    List<int>? collections,
    Map<int, List<int>>? selectedVariationsValues,
    int? selectedKeywordId,
    String? name,
    Map<String, dynamic>? meta,
  ) async {
    Apiraiser.validateAuthentication();
    List<Product> products = [];

    try {
      Map<String, dynamic> jsonQuery = {
        "collections": "null",
        "name": "null",
        "filters": "null",
        "keywords": "null",
        "meta": "null",
      };
      if (collections != null &&
          collections.isNotEmpty &&
          collections[0] != 0) {
        jsonQuery["collections"] = "ARRAY$collections";
      }

      debugPrint(jsonQuery["collections"]);
      if (name != null && name.isNotEmpty) {
        jsonQuery["name"] = "'$name'";
      }

//"ARRAY[${1,2,3}]";

      List<String> filters = [];

      if (selectedVariationsValues!.isNotEmpty) {
        if (selectedVariationsValues[VariationTypes.size.index] != null &&
            selectedVariationsValues[VariationTypes.size.index]!.isNotEmpty) {
          String sizes = "";
          sizes =
              selectedVariationsValues[VariationTypes.size.index]!.join(",");
          debugPrint(sizes);
          // jsonQuery["sizes"] = "ARRAY[$sizes]";
          filters.add('"1": "{$sizes}"');
        }
        if (selectedVariationsValues[VariationTypes.color.index] != null &&
            selectedVariationsValues[VariationTypes.color.index]!.isNotEmpty) {
          String colors = "";
          colors =
              selectedVariationsValues[VariationTypes.color.index]!.join(",");
          debugPrint(colors);
          // jsonQuery["colors"] = "ARRAY[$colors]";
          filters.add('"2": "{$colors}"');
        }
      }
      if (filters.isNotEmpty) {
        // SELECT * FROM find_products(null, 'pla', '{"Color": "{8, 9, 10}"}'::JSONB, ARRAY[1]);
        jsonQuery["filters"] = "'{${filters.join(',')}}'::jsonb";
      }

      if (selectedKeywordId != null && selectedKeywordId > 0) {
        jsonQuery["keywords"] = "ARRAY[$selectedKeywordId]";
      }
      if (meta != null && meta.isNotEmpty) {
        String metaStr = meta.keys
            .map((key) {
              return '"$key": ${meta[key]}';
            })
            .toList()
            .join(', ');

        jsonQuery["meta"] = "'{$metaStr}'::JSONB";
      }

      APIResult functionResult =
          await Apiraiser.function.excuteFunction(1, jsonQuery);
      if (functionResult.success &&
          (functionResult.data as List<dynamic>).isNotEmpty) {
        products = (functionResult.data as List<dynamic>)
            .map((p) => Product.fromJson(p as Map<String, dynamic>))
            .toList();

        return products;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
