import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:money_tracker/models/transaction.dart';
import 'package:money_tracker/resources/user_simple_preferences.dart';
import '../global.dart';
import 'network_service.dart';

class TransactionService {
  final String _urlPrefix = NetworkService.getApiUrl();

  addNewTransaction(Transaction transaction) async {
    Map<String, dynamic> body = {'transaction': transaction};
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/transaction/addNewTransaction'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': UserSimplePreferences.accessToken
      },
      body: jsonEncode(body),
    );
    return json.decode(res.body);
  }

  updateTransaction(Transaction transaction) async {
    Map<String, dynamic> body = {'transaction': transaction};
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/transaction/updateTransaction'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': UserSimplePreferences.accessToken
      },
      body: jsonEncode(body),
    );
    return json.decode(res.body);
  }
}
