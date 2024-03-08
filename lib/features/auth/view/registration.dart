import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:news_app/features/auth/view/login.dart';
import 'package:news_app/utils/validator.dart';
import 'package:provider/provider.dart';

import '../../../provider/auth_provider.dart';
import '../../../utils/utils.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                    "Registration",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // SizedBox(height: height * 0.01),
                  const Text(
                    "Please register to continue",
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
                      return Validate.name(email!);
                    },
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: "First Name",
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) {
                      return Validate.name(email!);
                    },
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: "Last Name",
                    ),
                  ),
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
                      loading: auth.registrationLoading,
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          String firstName = firstNameController.text.trim();
                          String lastName = lastNameController.text.trim();
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();

                          var (status, message) = await auth.registration(
                              firstName, lastName, email, password);

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
                      title: "Register",
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
                            text: "Already have an account?",
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                            text: " Login",
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
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
}
