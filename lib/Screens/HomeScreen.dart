import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:summarization_system/Screens/ExtactHighlightText.dart';
import 'package:summarization_system/Screens/ExtractTextFromImage.dart';
import 'package:summarization_system/Screens/WelcomeScreen.dart';
import 'package:summarization_system/Utils/MainColors.dart';
import 'package:summarization_system/Utils/TextStyle.dart';
import 'package:summarization_system/Widgets/LoginAnimation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _HomeScreenState extends State<HomeScreen> {
  final User? user = _auth.currentUser;

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
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
                      sigmaX: 5,
                      sigmaY: 5,
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
                        MainColors.mainColor.withValues(alpha: 0.8),
                        Colors.black38,
                        Colors.black45,
                        Colors.blue.withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: Container(width: widthScreen, child: const LoginAnimation()),
          ),

          Align(
            // alignment: Alignment.bottomCenter,
            child: Container(
              height: heightScreen * 0.8,
              width: widthScreen,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 80),
                  InkResponse(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExtactHighlightText(),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            width: widthScreen * 0.4,
                            height: 260,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                              ),

                              gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 1, 106, 5),
                                  const Color.fromARGB(255, 1, 198, 103),
                                ],
                              ),
                            ),
                            child: Column(children: [
                               
                              ],
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(20),
                          width: widthScreen,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: [
                                const Color.fromARGB(255, 1, 106, 5),
                                const Color.fromARGB(255, 1, 198, 103),
                              ],
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: 0.2,
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  child: Lottie.asset(
                                    "assets/animation/extractPdf.json",
                                    repeat: true,
                                    reverse: true,

                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Extract Text",
                                    style: Text_Style.textStyleBold(
                                      Colors.black87,
                                      20,
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  Text(
                                    "Upload a PDF file with highlighted text to extract only the important content, titles, or keywords automatically.",
                                    textAlign: TextAlign.center,
                                    style: Text_Style.textStyleNormal(
                                      Colors.black87,
                                      16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkResponse(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExtractTextFromImageScreen(),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            width: widthScreen * 0.4,
                            height: 260,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                              ),

                              gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 0, 187, 255),
                                  const Color.fromARGB(255, 1, 70, 135),
                                ],
                              ),
                            ),
                            child: Column(children: [
                               
                              ],
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(20),
                          width: widthScreen,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: [
                                const Color.fromARGB(255, 0, 187, 255),
                                const Color.fromARGB(255, 0, 132, 255),
                              ],
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: 0.5,
                                child: Container(
                                  width: 250,
                                  height: 200,
                                  child: Lottie.asset(
                                    "assets/animation/extractTextFormImage.json",
                                    repeat: true,
                                    reverse: true,

                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Image to Text",
                                    style: Text_Style.textStyleBold(
                                      Colors.black87,
                                      20,
                                    ),
                                  ),

                                  SizedBox(height: 20),

                                  Text(
                                    "Upload an image containing text and extract readable content instantly using smart OCR technology.",
                                    textAlign: TextAlign.center,
                                    style: Text_Style.textStyleNormal(
                                      Colors.black87,
                                      16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 20,
            child: SafeArea(
              child: PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      enabled: false,
                      child: Text(
                        "${user!.displayName}",
                        style: Text_Style.textStyleBold(Colors.black45, 16),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Sign out",
                            style: Text_Style.textStyleNormal(
                              MainColors.mainColor,
                              15,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.logout,
                            color: MainColors.mainColor.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 'logout') {
                    _auth.signOut();
                    setState(() {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomeScreen(),
                        ),
                        ((route) => false),
                      );
                    });
                  }
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: MainColors.mainColor,
                    child: Center(
                      child: Text(
                        user!.displayName.toString()[0],
                        style: Text_Style.textStyleBold(Colors.white, 20),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
