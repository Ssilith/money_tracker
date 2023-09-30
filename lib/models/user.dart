import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class User {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  String? surname;
  String? email;
  String? telephone;
  String? token;
  bool? permissions;
  bool? onboard;
  double? account;
  List<String> transactionId;
  List<String> budgetId;
  List<String> notificationId;
  List<String> categoryId;

  User()
      : transactionId = [],
        budgetId = [],
        categoryId = [],
        notificationId = [];

  void clear() {
    user = User();
  }

  bool isEmpty() {
    return id == null &&
        name == null &&
        surname == null &&
        email == null &&
        telephone == null &&
        token == null &&
        permissions == null &&
        onboard == null &&
        account == null &&
        transactionId.isEmpty &&
        budgetId.isEmpty &&
        categoryId.isEmpty &&
        notificationId.isEmpty;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

User user = User();
