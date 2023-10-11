// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyNotification _$MyNotificationFromJson(Map<String, dynamic> json) =>
    MyNotification()
      ..id = json['_id'] as String?
      ..name = json['name'] as String?
      ..date =
          json['date'] == null ? null : DateTime.parse(json['date'] as String);

Map<String, dynamic> _$MyNotificationToJson(MyNotification instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('date', instance.date?.toIso8601String());
  return val;
}
