import 'package:http/retry.dart';
import 'package:http/http.dart' as http;
import 'package:money_tracker/resources/user_service.dart';
import 'package:money_tracker/resources/user_simple_preferences.dart';
import '../global.dart';
import '../models/user.dart';

class InitializationService {
  static Future<void> initializeApp() async {
    await UserSimplePreferences.init();

    client = RetryClient(http.Client(),
        retries: 1,
        when: (response) => response.statusCode == 401,
        onRetry: (req, res, retryCount) async {
          bool res = await UserService().refreshToken();

          if (!res) {
            UserSimplePreferences.removeAccessToken();
            UserSimplePreferences.removeRefreshToken();
            user.clear();
            return;
          }

          req.headers['Authorization'] = UserSimplePreferences.accessToken;
        });

    if (UserService().isAuthenticated.value) {
      await UserService().getUserData();
    }
  }
}
