// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
class AddGroceryModel {
  final String firstName;
  final String lastName;
  final String gender;
  final String course;
  final String year_level;
  final String? subjectId;

  AddGroceryModel({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.course,
    required this.year_level,
    this.subjectId,
  });
}
