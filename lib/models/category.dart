import 'package:json_annotation/json_annotation.dart';
part 'category.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Category {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  String? color;

  Category();

  void clear() {
    category = Category();
  }

  bool isEmpty() {
    return id == null && name == null && color == null;
  }

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

Category category = Category();
