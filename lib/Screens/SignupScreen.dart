// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:summarization_system/Screens/HomeScreen.dart';
import 'package:summarization_system/Screens/LoginScreen.dart';
import 'package:summarization_system/Services/UserServices.dart';
import 'package:summarization_system/Utils/MainColors.dart';

import '../Utils/ButtonStyle.dart';
import '../Utils/Fonts.dart';
import '../Utils/TextFieldStyle.dart';
import '../Utils/TextStyle.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool _isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Colors.black12,
        child: Stack(
          children: [
            Container(
              width: widthScreen,
              height: heightScreen,
              child: Stack(
                children: [
                  // صورة الخلفية
                  Image.asset(
                    "assets/images/welcomeScreenBackground.jpg",
                    fit: BoxFit.cover,
                    width: widthScreen,
                    height: heightScreen,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 2,
                        sigmaY: 2,
                      ), // تمويه على المحورين
                      child: Container(
                        height: heightScreen,
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
                    height: heightScreen * 0.82,
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
                    height: heightScreen * 0.82,
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
                    height: heightScreen * 0.82,
                  ),
                ),
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                height: heightScreen * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(30),
                  height: heightScreen,
                  width: widthScreen,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 5),
                          Container(
                            width: widthScreen * 0.2,
                            child: Image.asset("assets/images/ProjectLogo.png"),
                          ),

                          SizedBox(height: 30),
                          nameTextField(MainColors.mainColor),
                          SizedBox(height: 20),
                          numberTextField(MainColors.mainColor),
                          SizedBox(height: 20),
                          emailTextField(MainColors.mainColor),
                          SizedBox(height: 20),
                          passwordTextField(MainColors.mainColor),
                          SizedBox(height: 50),
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
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        UserServices()
                                            .SignUp(
                                              emailController.text.trim(),
                                              passwordController.text.trim(),
                                              nameController.text,
                                              numberController.text,
                                            )
                                            .then((value) {
                                              if (value != null ||
                                                  value != "") {
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
                                                });
                                              } else {
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              }
                                            });
                                      }
                                      ;
                                    },
                            child:
                                _isLoading == true
                                    ? Center(
                                      child: SpinKitThreeBounce(
                                        size: 30,
                                        color: MainColors.mainColor,
                                      ),
                                    )
                                    : Text(
                                      "Sign up",
                                      style: Text_Style.textStyleBold(
                                        Colors.white,
                                        20,
                                      ),
                                    ),
                          ),
                          SizedBox(height: 30),
                          Container(
                            width: widthScreen * 0.35,
                            child: Divider(color: Colors.black54, height: 1),
                          ),
                          InkResponse(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 50,
                              width: widthScreen,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account?",
                                    style: Text_Style.textStyleNormal(
                                      Colors.black.withOpacity(0.6),
                                      16,
                                    ),
                                  ),

                                  Text(
                                    " Login",
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField nameTextField(Color color) {
    return TextFormField(
      style: Text_Style.textStyleNormal(Colors.black, 18),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return "please enter your name !!!";
        }
        RegExp regex = RegExp(r'^[a-zA-Z]+$');
        if (!regex.hasMatch(value)) {
          return 'Name should contain letters only!';
        }
        return null;
      },

      enabled: !_isLoading,
      controller: nameController,
      obscureText: false,
      decoration: TextFieldStyle().primaryTextField(
        "Name",
        Icon(Icons.account_box_rounded),
        color,
      ),
    );
  }

  TextFormField numberTextField(Color color) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      validator: (value) {
        if (value!.isEmpty) {
          return "please enter your phone number!!!";
        }
        if (value.length != 10) {
          return 'Phone number should be 10 digits long';
        }
        if (!value.startsWith('05')) {
          return 'Please enter a valid phone number';
        }

        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(10),
      ],
      style: Text_Style.textStyleNormal(Colors.black, 18),
      enabled: !_isLoading,
      controller: numberController,
      obscureText: false,
      decoration: TextFieldStyle().primaryTextField(
        "Phone Number",
        Icon(Icons.phone),
        color,
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
      style: Text_Style.textStyleNormal(Colors.black, 18),
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
        return null;
      },
      style: Text_Style.textStyleNormal(Colors.black, 18),
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
