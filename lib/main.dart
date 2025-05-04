import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:summarization_system/Screens/HomeScreen.dart';
import 'package:summarization_system/Screens/WelcomeScreen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
Future<void> main() async {
  late final FirebaseApp app;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDodjGQ5_xFAOu3y43dlW4CQ5TZZSbv6B8",
      appId: "1:731966373776:android:31246fc0b3ee6a0b2fbd15",
      messagingSenderId: "731966373776",
      projectId: "summarization-system",
    ),
  );
  app = await Firebase.initializeApp();

  runApp(const MyApp());
}

final User? user = _auth.currentUser;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home:
      // (user != null && user!.email!.isNotEmpty)
      //     ? HomeScreen()
      //     : WelcomeScreen(),
      AnimatedSplashScreen(
        splashIconSize: 200,
        splashTransition: SplashTransition.scaleTransition,
        splash: CircleAvatar(
          radius: 200,
          child: Image.asset(
            "assets/images/ProjectLogo.png",
            fit: BoxFit.cover,
          ),
        ),
        nextScreen:
            (user?.displayName != null && user?.displayName != "")
                ? HomeScreen()
                : WelcomeScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
