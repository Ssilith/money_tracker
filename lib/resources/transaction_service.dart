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

  getLastTenTransactionsForUser(String userId) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': UserSimplePreferences.accessToken
    };

    final http.Response res = await client.get(
        Uri.parse(
            '$_urlPrefix/transaction/$userId/getLastTenTransactionsForUser'),
        headers: headers);
    Map<String, dynamic> decodedBody = json.decode(res.body);

    if (!decodedBody['success']) [];
    return decodedBody['transaction'];
  }

  getAllTransactionsForUser(String userId) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': UserSimplePreferences.accessToken
    };

    final http.Response res = await client.get(
        Uri.parse('$_urlPrefix/transaction/$userId/getAllTransactionsForUser'),
        headers: headers);
    Map<String, dynamic> decodedBody = json.decode(res.body);

    if (!decodedBody['success']) [];
    return decodedBody['transactions'];
  }

  getLastWeekTopCategories(String userId) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': UserSimplePreferences.accessToken
    };

    final http.Response res = await client.get(
        Uri.parse('$_urlPrefix/transaction/$userId/getLastWeekTopCategories'),
        headers: headers);
    Map<String, dynamic> decodedBody = json.decode(res.body);

    if (!decodedBody['success']) return [];
    return decodedBody;
  }

  getBiggestTransactionAmount(String userId) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': UserSimplePreferences.accessToken
    };

    final http.Response res = await client.get(
        Uri.parse(
            '$_urlPrefix/transaction/$userId/getBiggestTransactionAmount'),
        headers: headers);
    Map<String, dynamic> decodedBody = json.decode(res.body);

    if (!decodedBody['success']) return [];
    return Transaction.fromJson(decodedBody['transaction']);
  }

  getMonthlySummary(String userId) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': UserSimplePreferences.accessToken
    };

    final http.Response res = await client.get(
        Uri.parse('$_urlPrefix/transaction/$userId/getMonthlySummary'),
        headers: headers);
    Map<String, dynamic> decodedBody = json.decode(res.body);

    if (!decodedBody['success']) return [];
    return decodedBody['summary'];
  }

  getYearlySummary(String userId) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': UserSimplePreferences.accessToken
    };

    final http.Response res = await client.get(
        Uri.parse('$_urlPrefix/transaction/$userId/getYearlySummary'),
        headers: headers);
    Map<String, dynamic> decodedBody = json.decode(res.body);

    if (!decodedBody['success']) return [];
    return decodedBody['summary'];
  }

  getMonthlySummaryCostAndIncome(String userId) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': UserSimplePreferences.accessToken
    };

    final http.Response res = await client.get(
        Uri.parse(
            '$_urlPrefix/transaction/$userId/getMonthlySummaryCostAndIncome'),
        headers: headers);
    Map<String, dynamic> decodedBody = json.decode(res.body);

    if (!decodedBody['success']) return [];
    return decodedBody['summary'];
  }

  getYearlySummaryAndTransactions(String userId) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': UserSimplePreferences.accessToken
    };

    final http.Response res = await client.get(
        Uri.parse(
            '$_urlPrefix/transaction/$userId/getYearlySummaryAndTransactions'),
        headers: headers);
    Map<String, dynamic> decodedBody = json.decode(res.body);

    if (!decodedBody['success']) return [];
    return decodedBody;
  }
}
