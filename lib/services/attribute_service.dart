import 'package:apiraiser/apiraiser.dart';

import 'package:flutter/foundation.dart';

class AttributeService {
  static Future<List<dynamic>> getAttributeValuesByCollection(
      int collection) async {
    try {
      Map<String, dynamic> jsonQuery = {
        "collection": collection,
      };

      APIResult functionResult =
          await Apiraiser.function.excuteFunction(2, jsonQuery);
      if (functionResult.success &&
          (functionResult.data as List<dynamic>).isNotEmpty) {
        return functionResult.data as List<dynamic>;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
