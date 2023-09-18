// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Budget _$BudgetFromJson(Map<String, dynamic> json) => Budget()
  ..id = json['_id'] as String?
  ..amount = (json['amount'] as num?)?.toDouble()
  ..startDate = json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String)
  ..endDate =
      json['endDate'] == null ? null : DateTime.parse(json['endDate'] as String)
  ..income = json['income'] as bool?;

Map<String, dynamic> _$BudgetToJson(Budget instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('amount', instance.amount);
  writeNotNull('startDate', instance.startDate?.toIso8601String());
  writeNotNull('endDate', instance.endDate?.toIso8601String());
  writeNotNull('income', instance.income);
  return val;
}
