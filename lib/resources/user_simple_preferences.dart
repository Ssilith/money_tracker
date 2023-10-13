import 'package:money_tracker/resources/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static late SharedPreferences _preferences;

  static const _keyFilters = 'widgets';
  static const _keyFilters2 = 'currency';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static String get accessToken => _preferences.getString('accessToken') ?? "";

  static set accessToken(String value) =>
      _preferences.setString('accessToken', value);

  static removeAccessToken() => _preferences.remove('accessToken');

  static String get refreshToken =>
      _preferences.getString('refreshToken') ?? "";

  static set refreshToken(String value) {
    _preferences.setString('refreshToken', value);
    UserService().isAuthenticated.value = true;
  }

  static removeRefreshToken() {
    _preferences.remove('refreshToken');
    UserService().isAuthenticated.value = false;
  }

  static Future setChosenWidgets(List<String> widgets) async =>
      await _preferences.setStringList(_keyFilters, widgets);
  static List<String>? getChosenWidgets() =>
      _preferences.getStringList(_keyFilters);

  static Future setChosenCurrency(List<String> currency) async =>
      await _preferences.setStringList(_keyFilters2, currency);
  static List<String>? getChosenCurrency() =>
      _preferences.getStringList(_keyFilters2);
}
