import 'package:json_annotation/json_annotation.dart';
part 'transaction.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Transaction {
  @JsonKey(name: '_id')
  String? id;
  double? amount;
  String? type;
  String? category;
  DateTime? date;
  String? description;

  Transaction();

  void clear() {
    transaction = Transaction();
  }

  bool isEmpty() {
    return id == null &&
        amount == null &&
        type == null &&
        category == null &&
        date == null &&
        description == null;
  }

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

Transaction transaction = Transaction();
