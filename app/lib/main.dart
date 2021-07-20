import 'package:family_live_spots/screens/auth/auth_view.dart';
import 'package:family_live_spots/screens/auth/edit_profile_view.dart';
import 'package:family_live_spots/screens/auth/sign_in.dart';
import 'package:family_live_spots/screens/auth/sign_up.dart';
import 'package:family_live_spots/services/auth_service.dart';
import 'package:family_live_spots/utility/env.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/tab_view.dart';
import 'screens/onboarding/onboarding_view.dart';
import 'screens/give_access_view.dart';
import 'utility/constants.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

/// Receive events from BackgroundGeolocation in Headless state.
void backgroundGeolocationHeadlessTask(bg.HeadlessEvent headlessEvent) async {
  print('📬 --> $headlessEvent');

  switch (headlessEvent.name) {
    case bg.Event.BOOT:
      bg.State state = await bg.BackgroundGeolocation.state;
      print("📬 didDeviceReboot: ${state.didDeviceReboot}");
      break;
    case bg.Event.TERMINATE:
      try {
        bg.Location location =
            await bg.BackgroundGeolocation.getCurrentPosition(samples: 1);
        print("[getCurrentPosition] Headless: $location");
      } catch (error) {
        print("[getCurrentPosition] Headless ERROR: $error");
      }
      break;
    case bg.Event.HEARTBEAT:
      /* DISABLED getCurrentPosition on heartbeat
      try {
        bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(samples: 1);
        print('[getCurrentPosition] Headless: $location');
      } catch (error) {
        print('[getCurrentPosition] Headless ERROR: $error');
      }
      */
      break;
    case bg.Event.LOCATION:
      bg.Location location = headlessEvent.event;
      print(location);
      break;
    case bg.Event.MOTIONCHANGE:
      bg.Location location = headlessEvent.event;
      print(location);
      break;
    case bg.Event.GEOFENCE:
      bg.GeofenceEvent geofenceEvent = headlessEvent.event;
      print(geofenceEvent);
      break;
    case bg.Event.GEOFENCESCHANGE:
      bg.GeofencesChangeEvent event = headlessEvent.event;
      print(event);
      break;
    case bg.Event.SCHEDULE:
      bg.State state = headlessEvent.event;
      print(state);
      break;
    case bg.Event.ACTIVITYCHANGE:
      bg.ActivityChangeEvent event = headlessEvent.event;
      print(event);
      break;
    case bg.Event.HTTP:
      bg.HttpEvent response = headlessEvent.event;
      print(response);
      break;
    case bg.Event.POWERSAVECHANGE:
      bool enabled = headlessEvent.event;
      print(enabled);
      break;
    case bg.Event.CONNECTIVITYCHANGE:
      bg.ConnectivityChangeEvent event = headlessEvent.event;
      print(event);
      break;
    case bg.Event.ENABLEDCHANGE:
      bool enabled = headlessEvent.event;
      print(enabled);
      break;
    case bg.Event.AUTHORIZATION:
      bg.AuthorizationEvent event = headlessEvent.event;
      print(event);
      bg.BackgroundGeolocation.setConfig(bg.Config(url: ENV.LOCATION_API));
      break;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Register BackgroundGeolocation headless-task.
  bg.BackgroundGeolocation.registerHeadlessTask(
      backgroundGeolocationHeadlessTask);
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
        '/onboarding': (_) => OnBoardingView(),
        '/home': (_) => TabView(),
        '/give-access': (_) => GiveAccessView(),
        '/members': (_) => TabView(
              activeTab: 0,
            ),
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
      home: AuthService.isLoggedIn ? TabView() : OnBoardingView(),
    );
  }
}
