// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
class GroceryItemModel {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final String course;
  final String year_level;
  bool isPresent;

  GroceryItemModel({
    this.isPresent = false,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.course,
    required this.year_level,
  });
  factory GroceryItemModel.fromJson(Map<String, dynamic> json) {
    return GroceryItemModel(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        gender: json['gender'],
        course: json['course'],
        isPresent: json['isPresent'],
        year_level: json['year_level']);
  }
}
