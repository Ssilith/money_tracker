import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:money_tracker/models/type.dart';
import 'package:money_tracker/resources/user_simple_preferences.dart';
import '../global.dart';
import 'network_service.dart';

class TypeService {
  final String _urlPrefix = NetworkService.getApiUrl();

  addNewType(MyType type) async {
    Map<String, dynamic> body = {'type': type};
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/type/addNewType'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': UserSimplePreferences.accessToken
      },
      body: jsonEncode(body),
    );
    return json.decode(res.body);
  }

  getTypes(String userId) async {
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/type/$userId/getTypes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': UserSimplePreferences.accessToken
      },
    );
    Map<String, dynamic> cat = json.decode(res.body);
    return List<MyType>.from(cat['type'].map((u) => (MyType.fromJson(u))));
  }

  Future<List<String>> getTypesNames(String userId) async {
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/type/$userId/getTypesNames'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': UserSimplePreferences.accessToken
      },
    );
    Map<String, dynamic> cat = json.decode(res.body);
    if (cat['type'] == null) {
      return [];
    }
    return List<String>.from(cat['type'].map((u) => (u.toString())));
  }

  getTypeIdByName(String name) async {
    Map<String, dynamic> body = {'name': name};
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/type/getTypeIdByName'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': UserSimplePreferences.accessToken
      },
      body: jsonEncode(body),
    );
    Map<String, dynamic> categories = json.decode(res.body);
    return categories;
  }
}
