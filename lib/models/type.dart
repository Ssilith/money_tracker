import 'package:json_annotation/json_annotation.dart';
part 'type.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class MyType {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  int? icon;
  String? color;

  MyType();

  void clear() {
    type = MyType();
  }

  bool isEmpty() {
    return id == null && name == null && icon == null && color == null;
  }

  factory MyType.fromJson(Map<String, dynamic> json) => _$MyTypeFromJson(json);

  Map<String, dynamic> toJson() => _$MyTypeToJson(this);
}

MyType type = MyType();
