import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/user_simple_preferences.dart';
import '../global.dart';
import 'network_service.dart';

class UserService {
  static final UserService _instance = UserService._();

  //Private constructor for singleton use
  UserService._() {
    if (UserSimplePreferences.refreshToken != '') isAuthenticated.value = true;
  }

  factory UserService() => _instance;

  final String _urlPrefix = NetworkService.getApiUrl();
  final ValueNotifier<bool> isAuthenticated = ValueNotifier(false);

  //AUTH
  Future<bool> login(
      String email, String password, BuildContext context) async {
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/authenticate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept-Language': Localizations.localeOf(context).toString()
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    Map<String, dynamic> decodedBody = jsonDecode(res.body);

    if (decodedBody['success']) {
      UserSimplePreferences.accessToken = decodedBody['accessToken']!;
      UserSimplePreferences.refreshToken = decodedBody['refreshToken']!;
      await getUserData();
    }

    return decodedBody['success'];
  }

  Future<String?> confirmIdentity(
      BuildContext context, String email, String password) async {
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/confirmIdentity'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept-Language': Localizations.localeOf(context).toString(),
        'Authorization': UserSimplePreferences.accessToken,
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    Map<String, dynamic> decodedBody = jsonDecode(res.body);

    if (decodedBody['success']) return decodedBody['verificationToken'];

    return null;
  }

  Future<bool> logout(BuildContext context) async {
    final http.Response res = await client
        .delete(Uri.parse('$_urlPrefix/logout'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept-Language': Localizations.localeOf(context).toString(),
      'authorization': UserSimplePreferences.accessToken,
      'refreshToken': UserSimplePreferences.refreshToken
    });

    Map<String, dynamic> decodedBody = jsonDecode(res.body);
    if (decodedBody['success']) {
      UserSimplePreferences.removeAccessToken();
      UserSimplePreferences.removeRefreshToken();
      user.clear();
    }
    return decodedBody['success'];
  }

  refreshToken() async {
    final http.Response res = await client
        .post(Uri.parse('$_urlPrefix/refreshToken'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'refreshToken': UserSimplePreferences.refreshToken
    });

    var response = json.decode(res.body);
    if (response['success']) {
      UserSimplePreferences.accessToken = response['accessToken'];
    }

    return response['success'];
  }

  Future<bool> sendResetPwdEmail(BuildContext context, String email) async {
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/sendResetPwdEmail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept-Language': Localizations.localeOf(context).toString()
      },
      body: jsonEncode(<String, String>{
        "email": email,
      }),
    );

    Map<String, dynamic> decodedBody = jsonDecode(res.body);
    return decodedBody['success'];
  }

  //OTHER
  //this method required user to confirm his identity
  //verificationToken is the token that can be obtained from /confirmIdentity endpoint
  addUser(
    BuildContext context,
    User newUser,
    String password,
  ) async {
    Map<String, dynamic> body = {'newUser': newUser.toJson()};
    body['newUser']['password'] = password;

    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/addUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept-Language': Localizations.localeOf(context).toString(),
        'Authorization': UserSimplePreferences.accessToken,
      },
      body: jsonEncode(body),
    );
    return json.decode(res.body);
  }

  updateUserInfo([User? updateUser]) async {
    Map<String, dynamic> body = {'updatedUser': updateUser ?? user};

    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/updateUserInfo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': UserSimplePreferences.accessToken
      },
      body: jsonEncode(body),
    );
    return json.decode(res.body);
  }

  Future<bool> getUserData() async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': UserSimplePreferences.accessToken
    };

    final http.Response res = await client
        .get(Uri.parse('$_urlPrefix/getUserInfo'), headers: headers);
    Map<String, dynamic> decodedBody = json.decode(res.body);

    if (decodedBody['success']) {
      user = User.fromJson(decodedBody['user']);
    }

    return decodedBody['success'];
  }

  Future<List<User>> getUsersForAdmin(
      [String sort = "UserView.alphabetic"]) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': UserSimplePreferences.accessToken,
      'Sort': sort
    };

    final http.Response res = await client
        .get(Uri.parse('$_urlPrefix/getUsersForAdmin'), headers: headers);

    Map<String, dynamic> decodedBody = json.decode(res.body);
    if (!decodedBody['success']) return [];

    return List<User>.from(decodedBody['users'].map((u) => User.fromJson(u)));
  }

  resetUserPassword(String password) async {
    Map<String, dynamic> body = {'email': user.email, 'password': password};
    final http.Response res =
        await client.post(Uri.parse('$_urlPrefix/resetPassword'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': UserSimplePreferences.accessToken,
            },
            body: jsonEncode(body));
    return json.decode(res.body);
  }

  getUserId(String email) async {
    Map<String, dynamic> body = {'email': email};
    final http.Response res =
        await client.post(Uri.parse('$_urlPrefix/getUserId'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': UserSimplePreferences.accessToken,
            },
            body: jsonEncode(body));
    Map<String, dynamic> userId = json.decode(res.body);
    return userId["id"];
  }

  Future<List<User>> getUserToAdmin(String adminId) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': UserSimplePreferences.accessToken
    };

    final http.Response res = await client.get(
        Uri.parse('$_urlPrefix/$adminId/getUserToAdmin'),
        headers: headers);
    Map<String, dynamic> decodedBody = json.decode(res.body);

    if (decodedBody['success']) {
      return List<User>.from(decodedBody['users'].map((u) => User.fromJson(u)));
    }

    return decodedBody['success'];
  }
}
