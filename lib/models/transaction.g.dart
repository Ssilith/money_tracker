// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction()
  ..id = json['_id'] as String?
  ..amount = (json['amount'] as num?)?.toDouble()
  ..type = json['type'] as String?
  ..category = json['category'] as String?
  ..date = json['date'] == null ? null : DateTime.parse(json['date'] as String)
  ..description = json['description'] as String?;

Map<String, dynamic> _$TransactionToJson(Transaction instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('amount', instance.amount);
  writeNotNull('type', instance.type);
  writeNotNull('category', instance.category);
  writeNotNull('date', instance.date?.toIso8601String());
  writeNotNull('description', instance.description);
  return val;
}
