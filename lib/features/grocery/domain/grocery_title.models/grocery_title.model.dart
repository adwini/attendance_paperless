
// ignore_for_file: public_member_api_docs, sort_constructors_first
class GroceryTitleModel {
  final String id;
  final String title;
  final String subjectCode;
  String? createdAt;
  GroceryTitleModel({
    required this.id,
    required this.title,
    required this.subjectCode,
    this.createdAt,
  });

 
  factory GroceryTitleModel.fromJson(Map<String, dynamic> map) {
    return GroceryTitleModel(
      id: map['id'] as String,
      title: map['title'] as String,
      subjectCode: map['subjectCode'] as String,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }

}
