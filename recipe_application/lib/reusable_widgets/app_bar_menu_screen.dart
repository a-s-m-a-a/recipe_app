import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/reusable_widgets/profile.dart';
import 'package:recipe_application/reusable_widgets/reusable_richtext.dart';
import 'package:recipe_application/utils/colors.utils.dart';
import 'package:recipe_application/utils/images.utils.dart';
import 'package:recipe_application/viewModel/app_auth_provider.dart';

class AppBarMenuScreen extends StatefulWidget {
  const AppBarMenuScreen({super.key});

  @override
  State<AppBarMenuScreen> createState() => _AppBarMenuScreenState();
}

class _AppBarMenuScreenState extends State<AppBarMenuScreen> {
  String name = FirebaseAuth.instance.currentUser?.displayName ?? "";
  @override
  Widget build(BuildContext context) {
    return Consumer<AppAuthprovider>(
      builder: (context, appAuthProvider, child) => AppBar(
        leading: Stack(children: [
          appAuthProvider.imageURL != null
              ? CircleAvatar(
                  radius: 64,
                  backgroundImage:
                      NetworkImage(appAuthProvider.imageURL.toString()))
              : const CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(
                      "https://banner2.cleanpng.com/20181231/fta/kisspng-computer-icons-user-profile-portable-network-graph-circle-svg-png-icon-free-download-5-4714-onli-5c2a3809d6e8e6.1821006915462707298803.jpg"),
                ),
        ]),
        title: Column(
          children: [
            Text(name),
          ],
        ),
      ),
    );
  }
}
