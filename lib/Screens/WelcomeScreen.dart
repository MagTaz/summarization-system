import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:summarization_system/Screens/LoginScreen.dart';
import 'package:summarization_system/Screens/SignupScreen.dart';
import 'package:summarization_system/Utils/MainColors.dart';
import 'package:summarization_system/Utils/TextStyle.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.1),
      body: Stack(
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
                      sigmaX: 7,
                      sigmaY: 7,
                    ), // تمويه على المحورين
                    child: Container(
                      height: heightScreen / 2,
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
                        Colors.black38,
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
          SafeArea(
            child: Column(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text.rich(
                    TextSpan(
                      text: 'Welcome to \n',
                      style: Text_Style.textStyleNormal(Colors.white, 35),

                      children: [
                        TextSpan(
                          text: 'Summarization System \n'.toUpperCase(),
                          style: Text_Style.textStyleBold(
                            MainColors.mainColor,
                            40,
                          ),
                        ),
                        TextSpan(
                          text: 'Highlight, Summarize, Save.',
                          style: Text_Style.textStyleNormal(Colors.white70, 21),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: MainColors.mainColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Text(
                          "Login",
                          style: Text_Style.textStyleBold(
                            MainColors.mainColor,
                            20,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return SignupScreen();
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20,
                              spreadRadius: 2,
                              color: Colors.black38,
                            ),
                          ],
                          color: MainColors.mainColor,
                          border: Border.all(
                            color: MainColors.mainColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Text(
                          "Join Now",
                          style: Text_Style.textStyleBold(Colors.white, 20),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
