import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:attendance_practice/config.dart';
import 'package:attendance_practice/features/grocery/domain/models/add_grocery.model.dart';
import 'package:attendance_practice/features/grocery/domain/models/delete_grocery.model.dart';
import 'package:attendance_practice/features/grocery/domain/models/grocery.model.dart';
import 'package:attendance_practice/features/grocery/domain/models/update_grocery.model.dart';

class GroceryRemoteDatasource {
  late Databases _databases;

  GroceryRemoteDatasource(Databases databases) {
    _databases = databases;
  }

  Future<String> addGrocery(AddGroceryModel addStudentModel) async {
    final String studentId = ID.unique();
    final docs = await _databases.createDocument(
      databaseId: Config.userdbId,
      collectionId: Config.studentsId,
      documentId: studentId,
      data: {
        'id': studentId,
        'firstName': addStudentModel.firstName,
        'lastName': addStudentModel.lastName,
        'gender': addStudentModel.gender,
        'course': addStudentModel.course,
        'year_level': addStudentModel.year_level,
        'subjectId': addStudentModel.subjectId,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
    return docs.$id;
  }

  Future<List<GroceryItemModel>> getGrocery(String subjectId) async {
    final docs = await _databases.listDocuments(
        databaseId: Config.userdbId,
        collectionId: Config.studentsId,
        queries: [Query.equal('subjectId', subjectId)]);
    return docs.documents
        .map((e) => GroceryItemModel.fromJson({...e.data, 'id': e.$id}))
        .toList();
  }

  Future<Unit> deleteGrocery(DeleteGroceryModel deleteStudentModel) async {
    await _databases.deleteDocument(
      databaseId: Config.userdbId,
      collectionId: Config.studentsId,
      documentId: deleteStudentModel.id,
    );
    return unit;
  }

  Future<String> updateGrocery(UpdateGroceryModel updateStudentModel) async {
    final docs = await _databases.updateDocument(
        databaseId: Config.userdbId,
        collectionId: Config.studentsId,
        documentId: updateStudentModel.id,
        data: {
          'id': updateStudentModel.id,
          'firstName': updateStudentModel.firstName,
          'lastName': updateStudentModel.lastName,
          'gender': updateStudentModel.gender,
          'course': updateStudentModel.course,
          'year_level': updateStudentModel.year_level,
          'subjectId': updateStudentModel.id,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
    return docs.$id;
  }
}
