import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:money_tracker/global.dart';
import 'package:money_tracker/models/category.dart';
import 'package:money_tracker/resources/user_simple_preferences.dart';
import 'network_service.dart';

class CategoryService {
  final String _urlPrefix = NetworkService.getApiUrl();

  addCategory(Category cat) async {
    Map<String, dynamic> body = {'category': cat};
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/category/addCategory'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': UserSimplePreferences.accessToken
      },
      body: jsonEncode(body),
    );
    Map<String, dynamic> categories = json.decode(res.body);
    return categories;
  }

  updateCategory(String id, Category cat) async {
    Map<String, dynamic> body = {'id': id, 'category': cat};
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/category/updateCategory'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': UserSimplePreferences.accessToken
      },
      body: jsonEncode(body),
    );
    Map<String, dynamic> categories = json.decode(res.body);
    return categories;
  }

  getCategories(String userId) async {
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/category/$userId/getCategories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': UserSimplePreferences.accessToken
      },
    );
    Map<String, dynamic> cat = json.decode(res.body);
    if (!cat['success']) return [];

    return List<Category>.from(
        cat['category'].map((u) => Category.fromJson(u)));
  }

  Future<List<String>> getCategoriesNames(String userId) async {
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/category/$userId/getCategoriesNames'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': UserSimplePreferences.accessToken
      },
    );
    Map<String, dynamic> names = json.decode(res.body);
    return List<String>.from(names['category'].map((u) => u.toString()));
  }

  getCategoryIdByName(String name) async {
    Map<String, dynamic> body = {'name': name};
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/category/getCategoryIdByName'),
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
