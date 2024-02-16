import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/reusable_widgets/reusableTextFormField.dart';
import 'package:recipe_application/reusable_widgets/reusable_button.dart';
import 'package:recipe_application/reusable_widgets/scrollable_widget.dart';
import 'package:recipe_application/utils/images.utils.dart';

import '../viewModel/app_auth_provider.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late double width = MediaQuery.of(context).size.width;
  late double height = MediaQuery.of(context).size.height;
  GlobalKey<FormState>? _formKey;

  String? error;
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    Provider.of<AppAuthprovider>(context, listen: false).providerInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppAuthprovider>(
        builder: (context, authProvider, child) => Scaffold(
              body: SafeArea(
                bottom: false,
                child: WidgetScrollable(isColumn: true, widgets: [
                  Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImagesPath.background),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Column(
                              children: [
                                Image(image: AssetImage(ImagesPath.logo)),
                                const Text(
                                  "Enter Your Email and we will send you a password rest link",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(children: [
                                    ReusableTextFormField(
                                        controller:
                                            authProvider.emailController!,
                                        icon: Icons.email,
                                        isPasswordType: false,
                                        lableText: "Email Address",
                                        validateText: "Enter Your email"),
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: ButtonWidget(
                                      isForAuth: true,
                                      width: width,
                                      hight: 50,
                                      text: "Reset PAssword",
                                      onTap: () {
                                        authProvider.passwordReset(
                                            context, _formKey);
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ));
  }
}
