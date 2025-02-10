import 'dart:async';

import 'package:aqui_oh_mobile/models/user.dart';
import 'package:aqui_oh_mobile/services/api.dart';
import 'package:aqui_oh_mobile/views/app.dart';
import 'package:aqui_oh_mobile/views/reclamacao.dart';
import 'package:flutter/material.dart';
import 'package:aqui_oh_mobile/views/login.dart';
import 'package:aqui_oh_mobile/views/signup.dart';
import 'package:aqui_oh_mobile/views/home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyAppState extends State<MyApp> {
  final _secureStorage = const FlutterSecureStorage();
  StreamSubscription<String>? _globalAccessTokenSubscription;
  StreamSubscription<String>? _globalRefreshTokenSubscription;
  User? _user;

  @override
  void initState() {
    super.initState();
    _secureStorage.read(key: "jwt_access").then((value) {
      if (value != null && value != "") {
        ApiService.globalAccessToken.value = value;
      }
    });
    _secureStorage.read(key: "jwt_refresh").then((value) {
      if (value != null && value != "") {
        ApiService.globalRefreshToken.value = value;
      }
    });
    _globalAccessTokenSubscription = ApiService.globalAccessToken.listen((token) {
      final newGrants = User.parse(token);
      if (_user != newGrants) {
        setState(() {
          _user = newGrants;
        });
      }
      _secureStorage.write(key: "jwt_access", value: token);
    });
    _globalRefreshTokenSubscription = ApiService.globalRefreshToken.listen((token) {
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
        if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'reclamacao') {
          final id = uri.pathSegments[1];
          return MaterialPageRoute(
            builder: (context) => ReclamacaoScreen(id: id, user: _user!,),
          );
        }
        return null;
      },
      home: _user == null ? LoginScreen() : HomeScreen(user: _user!,),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(user: _user!),
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
