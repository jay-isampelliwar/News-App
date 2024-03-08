import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:news_app/features/auth/view/registration.dart';
import 'package:news_app/provider/auth_provider.dart';
import 'package:news_app/utils/utils.dart';
import 'package:news_app/utils/validator.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  const Text(
                    "Login ",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Please login to continue",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) {
                      return Validate.validateEmail(email!);
                    },
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Consumer<AuthenticationProvider>(
                    builder: (context, auth, child) {
                      return ValueListenableBuilder(
                        valueListenable: auth.flag,
                        builder: (context, value, child) {
                          return TextFormField(
                            obscureText: auth.flag.value,
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (password) {
                              return Validate.password(password!);
                            },
                            decoration: InputDecoration(
                              labelText: "Password",
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  auth.toggleFlag();
                                },
                                child: Icon(auth.flag.value
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: height * 0.04),
                  Consumer<AuthenticationProvider>(
                      builder: (context, auth, child) {
                    return AppCustomButton(
                      loading: auth.loginLoading,
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();

                          var (status, message) =
                              await auth.login(email, password);

                          if (status) {
                            showSnackbar(context, message);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          } else {
                            showSnackbar(context, message);
                          }
                        }
                      },
                      title: "Login",
                    );
                  }),
                  SizedBox(height: height * 0.02),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text("OR"),
                      ),
                      Expanded(
                        child: Divider(thickness: 1),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          // decoration: TextDecoration.underline,
                          // color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          const TextSpan(
                            text: "Don't have an account?",
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationScreen(),
                                  ),
                                );
                              },
                            text: " Register",
                            style: TextStyle(
                              // decoration: TextDecoration.underline,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class AppCustomButton extends StatelessWidget {
  AppCustomButton(
      {super.key,
      required this.loading,
      required this.onTap,
      required this.title});

  final VoidCallback onTap;
  final String title;
  bool loading;
  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: height * 0.014),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Align(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
