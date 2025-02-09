import 'dart:async';

import 'package:aqui_oh_mobile/api.dart';
import 'package:flutter/material.dart';
import 'package:aqui_oh_mobile/details.dart';
import 'package:aqui_oh_mobile/messages.dart';
import 'package:aqui_oh_mobile/login.dart';
import 'package:aqui_oh_mobile/signup.dart';
import 'package:aqui_oh_mobile/home.dart';
import 'package:aqui_oh_mobile/profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _secureStorage = const FlutterSecureStorage();
  StreamSubscription<String>? _globalAccessTokenSubscription;
  StreamSubscription<String>? _globalRefreshTokenSubscription;
  UserGrants? _grants;

  @override
  void initState() {
    super.initState();
    _secureStorage.read(key: "jwt_access").then((value) {
      if (value != null && value != "") {
        globalAccessToken.value = value;
      }
    });
    _secureStorage.read(key: "jwt_refresh").then((value) {
      if (value != null && value != "") {
        globalRefreshToken.value = value;
      }
    });
    _globalAccessTokenSubscription = globalAccessToken.listen((token) {
      final newGrants = UserGrants.parse(token);
      if (_grants != newGrants) {
        setState(() {
          _grants = newGrants;
        });
      }
      _secureStorage.write(key: "jwt_access", value: token);
    });
    _globalRefreshTokenSubscription = globalRefreshToken.listen((token) {
      _secureStorage.write(key: "jwt_refresh", value: token);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _globalAccessTokenSubscription?.cancel();
    _globalRefreshTokenSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aqui Oh',
      onGenerateRoute: (settings) {
        final Uri uri = Uri.parse(settings.name!);
        if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'details') {
          final id = uri.pathSegments[1];
          return MaterialPageRoute(
            builder: (context) => DetailsScreen(id: id),
          );
        } else if (uri.pathSegments.length == 3 &&
            uri.pathSegments[0] == 'details' &&
            uri.pathSegments[2] == 'messages') {
          final id = uri.pathSegments[1];
          return MaterialPageRoute(
            builder: (context) => MessagesScreen(id: id),
          );
        }
        return null;
      },
      home: _grants == null ? LoginScreen() : HomeScreen(user: _grants!,),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(user: _grants!),
        '/profile': (context) => ProfileScreen(),
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
