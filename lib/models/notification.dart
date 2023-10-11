import 'package:json_annotation/json_annotation.dart';
part 'notification.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class MyNotification {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  DateTime? date;

  MyNotification();

  void clear() {
    notification = MyNotification();
  }

  bool isEmpty() {
    return id == null && name == null && date == null;
  }

  factory MyNotification.fromJson(Map<String, dynamic> json) =>
      _$MyNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$MyNotificationToJson(this);
}

MyNotification notification = MyNotification();
