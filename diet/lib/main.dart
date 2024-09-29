import 'package:diet/authwrap.dart';
import 'package:diet/design/homepage_design.dart';
import 'package:diet/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('app');

  // Gemini.init(apiKey: 'AIzaSyCcLWJMgkqSXzYNF_ND9qWY1RIhiHYUDKU');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
        // ),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        home: const authwrap2()
        // const ImgNutritionAI(
        //   title: 'ai image',
        // )
        );
  }
}

final ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xFF647DEE),
  hintColor: const Color(0xFF7F53AC),
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
  ),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    buttonColor: const Color(0xFF647DEE),
  ),
);

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasData) {
//           // User is logged in, now check if profile is complete using Hive
//           var profileBox = Hive.box('app');
//           bool isProfileComplete =
//               profileBox.get('isProfileComplete', defaultValue: false);

//           // If profile is complete, show dashboard, else show profile setup
//           if (isProfileComplete) {
//             return HomePage(); // Show dashboard
//           } else {
//             return const UserProfileSetup(); // Navigate to profile setup if incomplete
//           }
//         } else {
//           return const LandingPage(); // User is not logged in
//         }
//       },
//     );
//   }
// }
