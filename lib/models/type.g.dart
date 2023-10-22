// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyType _$MyTypeFromJson(Map<String, dynamic> json) => MyType()
  ..id = json['_id'] as String?
  ..name = json['name'] as String?
  ..icon = json['icon'] as int?
  ..color = json['color'] as String?;

Map<String, dynamic> _$MyTypeToJson(MyType instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('icon', instance.icon);
  writeNotNull('color', instance.color);
  return val;
}
