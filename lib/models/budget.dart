import 'package:json_annotation/json_annotation.dart';
part 'budget.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Budget {
  @JsonKey(name: '_id')
  String? id;
  double? amount;
  DateTime? startDate;
  DateTime? endDate;

  Budget();

  void clear() {
    budget = Budget();
  }

  bool isEmpty() {
    return id == null && amount == null && startDate == null && endDate == null;
  }

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);

  Map<String, dynamic> toJson() => _$BudgetToJson(this);
}

Budget budget = Budget();
