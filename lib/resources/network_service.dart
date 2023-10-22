import 'package:flutter/foundation.dart';

class NetworkService {
  static String getApiUrl() {
    if (kReleaseMode) {
      return "";
    } else {
      return "http://192.168.1.105:8080"; //1.105 108.107
    }
  }
}
