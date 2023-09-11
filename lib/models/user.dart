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
  String? status;
  String? permissions;
  String? tutorial;
  List<String> transactionId;
  List<String> budgetId;
  List<String> notificationId;

  User()
      : transactionId = [],
        budgetId = [],
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
        status == null &&
        permissions == null &&
        tutorial == null &&
        transactionId.isEmpty &&
        budgetId.isEmpty &&
        notificationId.isEmpty;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

User user = User();
