import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  String? errorMessage = '';
  bool isAdmin = false;
  String email = '';
  String username = '';
  String password = '';

  bool isLogin = true;

  Future<void> signIn() async {
    try {
      await Auth().signIn(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      //print(e.code!);
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> signUp() async {
    try {
      await Auth().signUp(
          email: email, password: password, name: username, isAdmin: isAdmin);
    } on FirebaseAuthException catch (e) {
      //print(e.message!);
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _errorMessage() {
    return errorMessage == ''
        ? const SizedBox(height: 8)
        : Column(
            children: [
              Text(
                errorMessage == '' ? '' : '$errorMessage',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 8),
            ],
          );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/chef.jpg"),
                        fit: BoxFit.cover)),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 15,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FittedBox(
                          child: Text(
                            isLogin
                                ? "Sign into your account"
                                : "Create a new account",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 23),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              !isLogin
                                  ? TextFormField(
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      style: const TextStyle(),
                                      decoration: const InputDecoration(
                                        labelText: "Username",
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                      ),
                                      onChanged: (val) => setState(() {
                                        username = val;
                                      }),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Username shouldn't be empty";
                                        }
                                        return null;
                                      },
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                style: const TextStyle(),
                                decoration: const InputDecoration(
                                  labelText: "Email",
                                  errorStyle: TextStyle(color: Colors.red),
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (val) => setState(() {
                                  email = val;
                                }),
                                validator: (value) {
                                  final emailRegExp = RegExp(
                                      r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                  if (value == null ||
                                      value.isEmpty ||
                                      !emailRegExp.hasMatch(value)) {
                                    return "Enter a valid email address";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                style: const TextStyle(),
                                decoration: InputDecoration(
                                  labelStyle: const TextStyle(),
                                  labelText: "Password",
                                  errorStyle:
                                      const TextStyle(color: Colors.red),
                                  suffixIcon: IconButton(
                                    //color: brownColor,
                                    icon: Icon(_passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                textInputAction: isLogin
                                    ? TextInputAction.done
                                    : TextInputAction.next,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: !_passwordVisible,
                                onChanged: (val) => setState(() {
                                  password = val;
                                }),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 6) {
                                    return "Password should be at least 6 characters";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              !isLogin
                                  ? TextFormField(
                                      textInputAction: isAdmin
                                          ? TextInputAction.next
                                          : TextInputAction.done,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: !_confirmPasswordVisible,
                                      style: const TextStyle(),
                                      decoration: InputDecoration(
                                        labelStyle: const TextStyle(),
                                        errorStyle:
                                            const TextStyle(color: Colors.red),
                                        labelText: "Confirm password",
                                        suffixIcon: IconButton(
                                          //color: brownColor,
                                          icon: Icon(_confirmPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              _confirmPasswordVisible =
                                                  !_confirmPasswordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.length < 6 ||
                                            value != password) {
                                          return "Password doesn't match";
                                        }
                                        return null;
                                      },
                                    )
                                  : const SizedBox(),
                              !isLogin
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Admin account",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16),
                                        ),
                                        Checkbox(
                                            checkColor: Colors.orange[50],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            value: isAdmin,
                                            onChanged: ((value) {
                                              setState(() {
                                                isAdmin = value!;
                                              });
                                            })),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        _errorMessage(),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.login_rounded),
                                  //style: primaryButtonStyle,
                                  onPressed: () {
                                    final form = _formKey.currentState;
                                    if (form!.validate()) {
                                      isLogin ? signIn() : signUp();
                                    }
                                  },
                                  label: Text(
                                      isLogin ? "Login" : "Create account"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: (() => setState(() {
                                isLogin = !isLogin;
                              })),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    style: const TextStyle(color: Colors.grey),
                                    text: isLogin
                                        ? "New user? "
                                        : "You have an account? "),
                                TextSpan(
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline),
                                    text: isLogin ? "Sign up" : "Login")
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
