import 'package:flutter/foundation.dart';

class NetworkService {
  static String getApiUrl() {
    if (kReleaseMode) {
      return "";
    } else {
      return "http://192.168.108.107:8080"; //1.105 162.107
    }
  }
}
