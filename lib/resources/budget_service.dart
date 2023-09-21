import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:money_tracker/models/budget.dart';
import 'package:money_tracker/resources/user_simple_preferences.dart';
import '../global.dart';
import 'network_service.dart';

class BudgetService {
  final String _urlPrefix = NetworkService.getApiUrl();

  addNewBudget(Budget budget, String userId) async {
    Map<String, dynamic> body = {'budget': budget};
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/budget/$userId/addNewBudget'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': UserSimplePreferences.accessToken
      },
      body: jsonEncode(body),
    );
    return json.decode(res.body);
  }

  updateBudget(Budget budget) async {
    Map<String, dynamic> body = {'budget': budget};
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/budget/updateBudget'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': UserSimplePreferences.accessToken
      },
      body: jsonEncode(body),
    );
    return json.decode(res.body);
  }

  getCurrentBudget(String userId) async {
    final http.Response res = await client.get(
      Uri.parse('$_urlPrefix/budget/$userId/getCurrentBudget'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': UserSimplePreferences.accessToken
      },
    );
    Map<String, dynamic> names = json.decode(res.body);
    return names;
  }
}
