import 'package:apiraiser/apiraiser.dart';

import 'package:shop/models/collection.dart';

class CategoryService {
  static Future<List<Collection>> getCategories(
    int limit,
    int? parent,
  ) async {
    APIResult result;

    if (parent == null) {
      List<QuerySearchItem> conditions = [
        QuerySearchItem(
          name: "Parent",
          condition: ColumnCondition.equal,
          value: parent,
        )
      ];

      result = await Apiraiser.data.getByConditions("Categories", conditions);

      // if (result.success) {
      //   List<int> parentIds = (result.data as List<dynamic>)
      //       .map((x) => (x as Map<String, dynamic>)['Id'] as int)
      //       .toList();
      //   conditions = [
      //     {
      //       'Name': "Parent",
      //       'Condition': 3,
      //       'Value': parentIds,
      //     }
      //   ];

      //   result = await Apiraiser.table
      //       .getByConditions("Categories", token, conditions);
      // }
    } else {
      List<QuerySearchItem> conditions = [
        QuerySearchItem(
          name: "Parent",
          condition: ColumnCondition.equal,
          value: parent,
        )
      ];

      result = await Apiraiser.data.getByConditions("Categories", conditions);

      // result = await Apiraiser.data.get("Categories", token, limit);
    }

    List<Collection> collection = (result.data as List<dynamic>)
        .map((c) => Collection.fromJson(c as Map<String, dynamic>))
        .toList();
    if (result.success) {
      return collection;
    } else {
      return [];
    }
  }
}
