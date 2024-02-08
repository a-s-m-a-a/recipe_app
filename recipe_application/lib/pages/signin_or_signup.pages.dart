import 'package:flutter/material.dart';
import 'package:recipe_application/pages/login.pages.dart';
import 'package:recipe_application/pages/register.pages.dart';
import 'package:recipe_application/reusable_widgets/reusable_widgits.dart';
import 'package:recipe_application/utils/images.utils.dart';

class SigniniOrSignup extends StatefulWidget {
  const SigniniOrSignup({super.key});

  @override
  State<SigniniOrSignup> createState() => _SigniniOrSignupState();
}

class _SigniniOrSignupState extends State<SigniniOrSignup> {
  late double width = MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
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
            const Text(
              "cooking done the easy way",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  reusableButton(width, 60, "Register", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()));
                  }),
                  reusableButton(width, 60, "Sign In", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  }),
                ],
              ),
            ),
          ],
        )),
      )),
    );
  }
}
