import 'package:appwrite/appwrite.dart';
import 'package:attendance_practice/config.dart';
import 'package:attendance_practice/features/auth/data/datasource/auth_local.datasource.dart';
import 'package:attendance_practice/features/auth/data/datasource/auth_remote.datasource.dart';
import 'package:attendance_practice/features/auth/data/repository/auth_repository.dart';
import 'package:attendance_practice/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DIContainer {
  Client get _client => Client()
      .setEndpoint(Config.endpoint)
      .setProject(Config.projectId)
      .setSelfSigned(status: true);

  Account get _account => Account(_client);

  Databases get _databases => Databases(_client);

  
  FlutterSecureStorage get _secureStorage => const FlutterSecureStorage();
  //Local Datasoure
  AuthLocalDatasource get _authLocalDatasource =>
      AuthLocalDatasource(_secureStorage);
  //Remote Datasoure
  AuthRemoteDatasoure get _authRemoteDatasoure =>
      AuthRemoteDatasoure(_account, _databases);

  //Repository
  AuthRepository get _authRepository =>
      AuthRepository(_authRemoteDatasoure, _authLocalDatasource);

 //Bloc
  AuthBloc get authBloc => AuthBloc(_authRepository);


}
