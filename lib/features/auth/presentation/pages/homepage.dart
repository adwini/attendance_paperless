import 'package:attendance_practice/features/auth/domain/models/auth_user.model.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.authUserModel});
    final AuthUserModel authUserModel;


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}