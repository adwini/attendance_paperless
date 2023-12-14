import 'package:attendance_practice/core/components/background.dart';
import 'package:attendance_practice/core/dependency_injection/di_container.dart';
import 'package:attendance_practice/core/enum/state_status.enum.dart';
import 'package:attendance_practice/core/global_widgets/snackbar.widget.dart';
import 'package:attendance_practice/core/utils/guard.dart';
import 'package:attendance_practice/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:attendance_practice/features/auth/domain/models/register_model.dart';
import 'package:attendance_practice/features/auth/presentation/pages/homepage.dart';
import 'package:attendance_practice/features/auth/presentation/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final DIContainer diContainer = DIContainer();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  late AuthBloc _authBloc;
  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
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
                        "REGISTER",
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                            errorStyle: TextStyle(fontSize: 12.0),
                            hintText: "Enter your first name",
                            labelText: "First Name"),
                        validator: (val) {
                          return Guard.againstEmptyString(val, 'First Name');
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                            errorStyle: TextStyle(fontSize: 12.0),
                            hintText: "Enter your last name",
                            labelText: "Last Name"),
                        validator: (val) {
                          return Guard.againstEmptyString(val, 'First Name');
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _emailController,
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(fontSize: 12.0),
                          hintText: "Enter a valid email",
                          labelText: "Email",
                        ),
                        validator: (val) {
                          return Guard.againstInvalidEmail(val, 'Email');
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(fontSize: 12.0),
                          hintText: "Password at least 8 characters",
                          labelText: "Password",
                        ),
                        validator: (val) {
                          return Guard.againstEmptyString(val, 'Password');
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _confirmController,
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(fontSize: 12.0),
                          hintText: "Confirm your Password",
                          labelText: "Confirm Password",
                        ),
                        validator: (String? val) {
                          return Guard.againstNotMatch(
                              val, _passwordController.text, 'Password');
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          _register(context);
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
                            "REGISTER",
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
                          Navigator.pop(context)
                        },
                        child: const Text(
                          "Already Have an Account? Sign in",
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
      SnackBarUtils.defualtSnackBar('Success!', context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MultiBlocProvider(
              providers: [
                BlocProvider<AuthBloc>(
                  create: (BuildContext context) => diContainer.authBloc,
                ),
                // BlocProvider<TodoBloc>(
                //   create: (BuildContext context) => diContainer.todoBloc,
                // ),
              ],
              child: Home(
                authUserModel: state.authUserModel!,
              ),
            ),
          ),
          ModalRoute.withName('/'));
    }
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _register(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _authBloc.add(AuthRegisterEvent(
          registerModel: RegisterModel(
              email: _emailController.text,
              password: _passwordController.text,
              confirmPassword: _confirmController.text,
              firstName: _firstNameController.text,
              lastName: _lastNameController.text)));
    }
  }
}
