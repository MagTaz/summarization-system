// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:summarization_system/Screens/HomeScreen.dart';
import 'package:summarization_system/Screens/SignupScreen.dart';
import 'package:summarization_system/Services/UserServices.dart';
import 'package:summarization_system/Utils/MainColors.dart';
import 'package:summarization_system/Widgets/LoginAnimation.dart';
import '../Utils/ButtonStyle.dart';
import '../Utils/Fonts.dart';
import '../Utils/TextFieldStyle.dart';
import '../Utils/TextStyle.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              child: Image.asset("assets/images/welcomeScreenBackground.jpg"),
            ),
            Container(
              width: width,
              height: height,
              child: Stack(
                children: [
                  // صورة الخلفية
                  Image.asset(
                    "assets/images/welcomeScreenBackground.jpg",
                    fit: BoxFit.cover,
                    width: width,
                    height: height,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5,
                        sigmaY: 5,
                      ), // تمويه على المحورين
                      child: Container(
                        height: height / 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black38,
                              Colors.black45,
                              Colors.black87,
                            ],
                          ),
                        ), // شفافية لإظهار التأثير
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          MainColors.mainColor.withValues(alpha: 0.8),
                          Colors.black38,
                          Colors.black45,
                          Colors.black87,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(width: width, child: const LoginAnimation()),
            Row(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 8, 153, 0),
                      borderRadius: BorderRadius.only(
                        // topRight: Radius.circular(10),
                      ),
                    ),

                    width: 60,
                    height: height * 0.66,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: MainColors.mainColor,
                      borderRadius: BorderRadius.only(
                        // topRight: Radius.circular(10),
                      ),
                    ),

                    width: 60,
                    height: height * 0.66,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: MainColors.secondColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                      ),
                    ),

                    width: 60,
                    height: height * 0.66,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                clipBehavior: Clip.hardEdge,
                height: height * 0.64,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 5,
                      color: Colors.black54,
                      blurRadius: 10,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                  ),
                  color: Colors.white,
                ),
                child: Container(
                  height: height,
                  width: width,
                  child: Form(
                    key: _formKey,
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(40),
                            child: Column(
                              children: [
                                Container(
                                  width: width * 0.2,
                                  child: Image.asset(
                                    "assets/images/ProjectLogo.png",
                                  ),
                                ),
                                SizedBox(height: 20),
                                emailTextField(MainColors.mainColor),
                                SizedBox(height: 30),
                                passwordTextField(MainColors.mainColor),
                                SizedBox(height: 30),
                                ElevatedButton(
                                  style: Button_Style.buttonStyle(
                                    context,
                                    MainColors.mainColor,
                                    12,
                                  ),
                                  onPressed:
                                      _isLoading == true
                                          ? null
                                          : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              UserServices()
                                                  .Login(
                                                    emailController.text.trim(),
                                                    passwordController.text
                                                        .trim(),
                                                  )
                                                  .then((value) {
                                                    if (value != null) {
                                                      Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  HomeScreen(),
                                                        ),
                                                        ((route) => false),
                                                      );
                                                      setState(() {
                                                        _isLoading = false;
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            backgroundColor:
                                                                Colors.green,
                                                            content: Text(
                                                              "You are logged in",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });

                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _isLoading = false;
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            backgroundColor:
                                                                Colors.red,
                                                            content: Text(
                                                              "invalid password or email",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                    }
                                                  });
                                            }
                                          },
                                  child:
                                      _isLoading == true
                                          ? Center(
                                            child: SpinKitThreeBounce(
                                              size: 30,
                                              color: Colors.blue,
                                            ),
                                          )
                                          : Text(
                                            "Login",
                                            style: Text_Style.textBoldStyle,
                                          ),
                                ),
                                SizedBox(height: 30),
                                Container(
                                  width: width * 0.35,
                                  child: Divider(
                                    color: Colors.black54,
                                    height: 1,
                                  ),
                                ),
                                InkResponse(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignupScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    width: width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Don't have an account?",
                                          style: Text_Style.textStyleNormal(
                                            Colors.black.withOpacity(0.8),
                                            16,
                                          ),
                                        ),
                                        Text(
                                          " Sign up",
                                          style: Text_Style.textStyleBold(
                                            MainColors.mainColor,
                                            16,
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

  TextFormField emailTextField(Color color) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter an email';
        } else if (!RegExp(
          r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
        ).hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      style: TextStyle(fontFamily: Fonts.PrimaryFont),
      enabled: !_isLoading,
      controller: emailController,
      obscureText: false,
      decoration: TextFieldStyle().primaryTextField(
        "Email",
        Icon(Icons.email),
        color,
      ),
    );
  }

  TextFormField passwordTextField(Color color) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Empty Password";
        }
        if (value.length < 6) {
          return "password should be 6";
        }
        return null;
      },
      style: TextStyle(fontFamily: Fonts.PrimaryFont),
      enabled: !_isLoading,
      controller: passwordController,
      obscureText: true,
      decoration: TextFieldStyle().primaryTextField(
        "Password",
        Icon(Icons.lock),
        color,
      ),
    );
  }
}
