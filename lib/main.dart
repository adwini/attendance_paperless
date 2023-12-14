import 'package:attendance_practice/core/dependency_injection/di_container.dart';
import 'package:attendance_practice/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:attendance_practice/features/auth/presentation/pages/initialpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DIContainer diContainer = DIContainer();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance',
      debugShowCheckedModeBanner: false,

      home: MultiBlocProvider(
        providers: [ 
          BlocProvider<AuthBloc>( 
            create: (BuildContext context) => diContainer.authBloc,
          )
        ],
        child: const InitialPage(),
      ),
    );
  }
}
