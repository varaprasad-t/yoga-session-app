import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AssetLoader {
  static Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  static Future<List<String>> loadAssets(List<String> paths) async {
    return await Future.wait(paths.map(loadAsset));
  }
}
