import 'package:attendance_practice/core/components/background.dart';
import 'package:attendance_practice/core/dependency_injection/di_container.dart';
import 'package:attendance_practice/core/enum/state_status.enum.dart';
import 'package:attendance_practice/core/utils/guard.dart';
import 'package:attendance_practice/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:attendance_practice/features/auth/domain/models/login_model.dart';
import 'package:attendance_practice/features/auth/presentation/pages/initialpage.dart';
import 'package:attendance_practice/features/auth/presentation/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/global_widgets/snackbar.widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final DIContainer diContainer = DIContainer();

  late AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  void clearText() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: _authBloc,
        listener: _authBlocListener,
        builder: (context, state) {
          if (state.stateStatus == StateStatus.loading) {
            return _loadingWidget();
          }
          return Background(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2661FA),
                            fontSize: 36),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                          controller: _emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            hintText: "Enter a valid email",
                            labelText: "Email",
                            errorStyle: TextStyle(fontSize: 12.0),
                          ),
                          validator: (String? val) {
                            return Guard.againstInvalidEmail(val, 'Email');
                          }),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                          controller: _passwordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            hintText: "Enter a password",
                            labelText: "Password",
                            errorStyle: TextStyle(fontSize: 12.0),
                          ),
                          obscureText: true,
                          validator: (String? val) {
                            return Guard.againstEmptyString(val, 'Password');
                          }),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: const Text(
                        "Forgot your password?",
                        style:
                            TextStyle(fontSize: 12, color: Color(0XFF2661FA)),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          _login(context);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0)),
                            backgroundColor:
                                const Color.fromARGB(255, 255, 136, 34),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 255, 177, 41)),
                            padding: const EdgeInsets.all(0),
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: size.width * 0.5,
                          child: const Text(
                            "LOGIN",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                               MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                        value: _authBloc,
                                        child: const RegisterScreen(),
                                      ))
                                  )
                        },
                        child: const Text(
                          "Don't Have an Account? Sign up",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2661FA)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _authBlocListener(BuildContext context, AuthState state) {
    if (state.stateStatus == StateStatus.error) {
      SnackBarUtils.defualtSnackBar(state.errorMessage, context);
    }

    if (state.authUserModel != null) {
      SnackBarUtils.defualtSnackBar('Login Success!', context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider<AuthBloc>(
                          create: (BuildContext context) =>
                              diContainer.authBloc,
                        ),
                        // BlocProvider<TodoBloc>(
                        //     create: (BuildContext context) =>
                        //         diContainer.todoBloc)
                      ],
                      child: const InitialPage(
                     
                      ))),
          ModalRoute.withName('/'));
    }
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _authBloc.add(
        AuthLoginEvent(
          logInModel: LoginModel(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        ),
      );
    }
    clearText();
  }
}
