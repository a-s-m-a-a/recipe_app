import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/reusable_widgets/reusableTextFormField.dart';
import 'package:recipe_application/reusable_widgets/reusable_button.dart';
import 'package:recipe_application/reusable_widgets/reusable_richtext.dart';
import 'package:recipe_application/reusable_widgets/scrollable_widget.dart';

import 'package:recipe_application/utils/colors.utils.dart';
import 'package:recipe_application/utils/images.utils.dart';
import 'package:recipe_application/viewModel/app_auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double width = MediaQuery.of(context).size.width;
  late double height = MediaQuery.of(context).size.height;
  GlobalKey<FormState>? _formKey;
  var imageResult;
  var refresnce;
  var uploadResult;
  String? imageURL;
  bool isCliked = false;
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
                child: Container(
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
                    child: WidgetScrollable(isColumn: true, widgets: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Column(
                              children: [
                                Image(image: AssetImage(ImagesPath.logo)),
                                const Text(
                                  "Register",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Stack(children: [
                                        (imageURL != null && isCliked == true)
                                            ? CircleAvatar(
                                                radius: 64,
                                                backgroundImage: NetworkImage(
                                                    imageURL.toString()))
                                            : const CircleAvatar(
                                                radius: 64,
                                                backgroundImage: NetworkImage(
                                                    "https://banner2.cleanpng.com/20181231/fta/kisspng-computer-icons-user-profile-portable-network-graph-circle-svg-png-icon-free-download-5-4714-onli-5c2a3809d6e8e6.1821006915462707298803.jpg"),
                                              ),
                                        Positioned(
                                          bottom: -10,
                                          left: 20,
                                          child: IconButton(
                                            onPressed: () async {
                                              OverlayLoadingProgress.start();
                                              isCliked = true;

                                              imageResult = await FilePicker
                                                  .platform
                                                  .pickFiles(
                                                      type: FileType.image,
                                                      withData: true);

                                              refresnce =
                                                  FirebaseStorage.instance.ref(
                                                      'reciepes/${imageResult?.files.first.name}');

                                              if (imageResult
                                                      ?.files.first.bytes !=
                                                  null) {
                                                uploadResult =
                                                    await refresnce.putData(
                                                        imageResult!
                                                            .files.first.bytes!,
                                                        SettableMetadata(
                                                            contentType:
                                                                'image/png'));

                                                if (uploadResult.state ==
                                                    TaskState.success) {
                                                  imageURL = await refresnce
                                                      .getDownloadURL();
                                                }
                                              }
                                              setState(() {});
                                              OverlayLoadingProgress.stop();
                                            },
                                            icon: Icon(Icons.add_a_photo,
                                                color: hexStringToColor(
                                                    "#F45B00")),
                                          ),
                                        )
                                      ]),
                                      ReusableTextFormField(
                                          controller:
                                              authProvider.nameController!,
                                          icon: Icons.person,
                                          isPasswordType: false,
                                          lableText: "Full Name",
                                          validateText: "Enter your name"),
                                      ReusableTextFormField(
                                          controller:
                                              authProvider.emailController!,
                                          icon: Icons.email,
                                          isPasswordType: false,
                                          lableText: "Email Address",
                                          validateText: "Enter your Email"),
                                      ReusableTextFormField(
                                          controller:
                                              authProvider.passwordController!,
                                          icon: Icons.password,
                                          isPasswordType: true,
                                          lableText: "Password",
                                          validateText: "Enter your Password"),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: ButtonWidget(
                                      isForAuth: true,
                                      width: width,
                                      hight: 50,
                                      text: "Register",
                                      onTap: () {
                                        authProvider.signUp(context, _formKey,
                                            imageURL.toString());
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
              floatingActionButton:
                  (MediaQuery.of(context).viewInsets.bottom == 0)
                      ? RichTextWidget(num: 2, text: const [
                          "Already have an account? ",
                          "Sign In"
                        ], colors: [
                          Colors.white,
                          hexStringToColor("#F45B00")
                        ], function: [
                          () {},
                          () {
                            authProvider.openLoginpage(context, _formKey);
                          }
                        ])
                      : null,
            ));
  }
}
