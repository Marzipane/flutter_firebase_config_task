import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_config/entities/app_entity.dart';

class Utility {
  Future<AppEntity> parseJsonConfig(String rawJson) async {
    final Map<String, dynamic> parsed =
        await compute(decodeJsonWithCompute, rawJson);
    final appEntity = AppEntity.fromJson(parsed);
    return appEntity;
  }

  static Map<String, dynamic> decodeJsonWithCompute(String rawJson) {
    return jsonDecode(rawJson);
  }
}
