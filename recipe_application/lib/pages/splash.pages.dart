import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_application/pages/home.pages.dart';
import 'package:recipe_application/pages/signin_or_signup.pages.dart';
import 'package:recipe_application/utils/images.utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  StreamSubscription<User?>? _listener;
  @override
  void initState() {
    super.initState();
    initSplash();
  }

  void initSplash() async {
    await Future.delayed(const Duration(seconds: 2));
    _listener = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SigniniOrSignup()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    });
  }

  @override
  void dispose() {
    _listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(ImagesPath.background),
          fit: BoxFit.cover,
        )),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(60.0),
              child: Image(image: AssetImage(ImagesPath.logo)),
            ),
            const CircularProgressIndicator(),
          ],
        )),
      ),
    ));
  }
}
