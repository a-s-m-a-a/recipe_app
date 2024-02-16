import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/utils/colors.utils.dart';
import 'package:recipe_application/viewModel/app_auth_provider.dart';

class ReusableTextFormField extends StatefulWidget {
  final bool isPasswordType;
  final IconData icon;
  final String lableText;
  final String validateText;
  final TextEditingController controller;
  const ReusableTextFormField(
      {required this.controller,
      required this.icon,
      required this.isPasswordType,
      required this.lableText,
      required this.validateText,
      super.key});

  @override
  State<ReusableTextFormField> createState() => _ReusableTextFormFieldState();
}

class _ReusableTextFormFieldState extends State<ReusableTextFormField> {
  @override
  void initState() {
    Provider.of<AppAuthprovider>(context, listen: false).providerInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppAuthprovider>(
        builder: (context, authProvider, child) => Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return widget.validateText;
                  }
                  return null;
                },
                controller: widget.controller,
                obscureText:
                    widget.isPasswordType ? authProvider.obsecuretext : false,
                enableSuggestions: widget.isPasswordType,
                autocorrect: widget.isPasswordType,
                cursorColor: Colors.orange,
                keyboardType: widget.isPasswordType
                    ? TextInputType.visiblePassword
                    : TextInputType.emailAddress,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  suffixIcon: widget.isPasswordType
                      ? InkWell(
                          onTap: () => authProvider.toggelObsecure(),
                          child: Icon(
                            authProvider.obsecuretext
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.edit, color: Colors.white),
                  prefixIcon: Icon(
                    widget.icon,
                    color: Colors.white,
                  ),
                  labelText: widget.lableText,
                  labelStyle: TextStyle(
                      color: hexStringToColor("#F45B00"),
                      fontWeight: FontWeight.bold),
                  filled: false,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
              ),
            ));
  }
}
