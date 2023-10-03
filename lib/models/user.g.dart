// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..id = json['_id'] as String?
  ..name = json['name'] as String?
  ..surname = json['surname'] as String?
  ..email = json['email'] as String?
  ..telephone = json['telephone'] as String?
  ..token = json['token'] as String?
  ..permissions = json['permissions'] as bool?
  ..onboard = json['onboard'] as bool?
  ..transactionId =
      (json['transactionId'] as List<dynamic>).map((e) => e as String).toList()
  ..budgetId =
      (json['budgetId'] as List<dynamic>).map((e) => e as String).toList()
  ..notificationId =
      (json['notificationId'] as List<dynamic>).map((e) => e as String).toList()
  ..categoryId =
      (json['categoryId'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('surname', instance.surname);
  writeNotNull('email', instance.email);
  writeNotNull('telephone', instance.telephone);
  writeNotNull('token', instance.token);
  writeNotNull('permissions', instance.permissions);
  writeNotNull('onboard', instance.onboard);
  val['transactionId'] = instance.transactionId;
  val['budgetId'] = instance.budgetId;
  val['notificationId'] = instance.notificationId;
  val['categoryId'] = instance.categoryId;
  return val;
}
