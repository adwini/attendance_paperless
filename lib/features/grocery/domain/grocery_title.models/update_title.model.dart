// ignore_for_file: public_member_api_docs, sort_constructors_first
class UpdateTitleGroceryModel {
  final String id;
  final String title;
  final String subjectCode;
  String? updatedAt;
  UpdateTitleGroceryModel({
    required this.id,
    required this.title,
    required this.subjectCode,
    this.updatedAt,
  });

}
