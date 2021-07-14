import 'package:family_live_spots/screens/auth/auth_view.dart';
import 'package:family_live_spots/screens/auth/edit_profile_view.dart';
import 'package:family_live_spots/screens/auth/sign_in.dart';
import 'package:family_live_spots/screens/auth/sign_up.dart';
import 'package:family_live_spots/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/tab_view.dart';
import 'utility/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/sign-in': (_) => SignIn(),
        '/sign-up': (_) => SignUp(),
        '/home': (_) => TabView(),
        '/places': (_) => TabView(
              activeTab: 1,
            ),
        '/map': (_) => TabView(
              activeTab: 2,
            ),
        '/history': (_) => TabView(
              activeTab: 3,
            ),
        '/settings': (_) => TabView(
              activeTab: 4,
            ),
      },
      theme: ThemeData(
          primaryColor: Constans.primary_color,
          appBarTheme: AppBarTheme(centerTitle: true),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all(Constans.primary_color))),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Constans.primary_color)))),
      home: AuthService.isLoggedIn ? TabView() : SignIn(),
    );
  }
}
