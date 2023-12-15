import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:attendance_practice/config.dart';
import 'package:attendance_practice/features/grocery/domain/grocery_title.models/add_title.model.dart';
import 'package:attendance_practice/features/grocery/domain/grocery_title.models/delete_title.model.dart';
import 'package:attendance_practice/features/grocery/domain/grocery_title.models/grocery_title.model.dart';
import 'package:attendance_practice/features/grocery/domain/grocery_title.models/update_title.model.dart';

class TitleGroceryRemoteDatasource {
  late Databases _databases;

  TitleGroceryRemoteDatasource(Databases databases) {
    _databases = databases;
  }

  Future<String> addTitleGrocery(
      AddTitleGroceryModel addSubjectTitleDetailsModel) async {
    final String subjectTitle = ID.unique();
    final docs = await _databases.createDocument(
      databaseId: Config.userdbId,
      collectionId: Config.subjectDetailsId,
      documentId: subjectTitle,
      data: {
        'id': subjectTitle,
        'title': addSubjectTitleDetailsModel.title,
        'subjectCode': addSubjectTitleDetailsModel.subjectCode,
        'userId': addSubjectTitleDetailsModel.userId,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
    return docs.$id;
  }

  Future<List<GroceryTitleModel>> getTitleGrocery(String userId) async {
    final docs = await _databases.listDocuments(
      databaseId: Config.userdbId,
      collectionId: Config.subjectDetailsId,
    queries: [Query.equal('userId', userId)]);

    return docs.documents
        .map((e) => GroceryTitleModel.fromJson({...e.data, 'id': e.$id}))
        .toList();
  }

  Future<Unit> deleteTitleGrocery(
      DeleteTitleGroceryModel deleteSubjectTitleModel) async {
    await _databases.deleteDocument(
      databaseId: Config.userdbId,
      collectionId: Config.subjectDetailsId,
      documentId: deleteSubjectTitleModel.id,
    );
    return unit;
  }

  Future<String> updateTitleGrocery(
      UpdateTitleGroceryModel updateTitleSubjectModel) async {
    final docs = await _databases.updateDocument(
        databaseId: Config.userdbId,
        collectionId: Config.subjectDetailsId,
          documentId: updateTitleSubjectModel.id,
        data: {
          'id': updateTitleSubjectModel.id,
          'title': updateTitleSubjectModel.title,
          'subjectCode': updateTitleSubjectModel.subjectCode,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
    return docs.$id;
  }
}
