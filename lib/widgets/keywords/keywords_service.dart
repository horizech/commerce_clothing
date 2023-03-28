import 'package:apiraiser/apiraiser.dart';
import 'package:shop/models/product.dart';

class KeywordsService {
  static Future<List<int>> getKeywordsList(int? collection) async {
    List<QuerySearchItem> conditions = [];

    if ((collection ?? 0) > 0) {
      conditions = [
        QuerySearchItem(
          name: "Collection",
          condition: ColumnCondition.equal,
          value: collection,
        )
      ];

      APIResult categoryProducts =
          await Apiraiser.data.getByConditions("Products", conditions);

      if (categoryProducts.success) {
        List<Product> products = (categoryProducts.data as List<dynamic>)
            .map((p) => Product.fromJson(p as Map<String, dynamic>))
            .toList();

        List<int> keywordsList = [];
        for (int i = 0; i < products.length; i++) {
          keywordsList.addAll(products[i].keywords!);
        }

        return keywordsList.toSet().toList();
      } else {
        return [];
      }
    } else {
      return [];
    }
  }
}
