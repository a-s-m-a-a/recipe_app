import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/reusable_widgets/reusableTextFormField.dart';
import 'package:recipe_application/reusable_widgets/reusable_button.dart';
import 'package:recipe_application/utils/colors.utils.dart';
import 'package:recipe_application/viewModel/app_auth_provider.dart';
import 'package:file_picker/file_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var imageResult;
  var refresnce;
  var uploadResult;
  String? imageURL;
  bool isCliked = false;

  @override
  void initState() {
    Provider.of<AppAuthprovider>(context, listen: false).providerInit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppAuthprovider>(
      builder: (context, appAuthProvider, child) => Column(
        children: [
          Stack(children: [
            (isCliked == false && appAuthProvider.imageURL != null)
                ? CircleAvatar(
                    radius: 64,
                    backgroundImage:
                        NetworkImage(appAuthProvider.imageURL.toString()))
                : (imageURL != null && isCliked == true)
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(imageURL.toString()))
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

                  imageResult = await FilePicker.platform
                      .pickFiles(type: FileType.image, withData: true);

                  refresnce = FirebaseStorage.instance
                      .ref('reciepes/${imageResult?.files.first.name}');

                  if (imageResult?.files.first.bytes != null) {
                    uploadResult = await refresnce.putData(
                        imageResult!.files.first.bytes!,
                        SettableMetadata(contentType: 'image/png'));

                    if (uploadResult.state == TaskState.success) {
                      imageURL = await refresnce.getDownloadURL();
                    }
                  }
                  setState(() {});
                  OverlayLoadingProgress.stop();
                },
                icon:
                    Icon(Icons.add_a_photo, color: hexStringToColor("#F45B00")),
              ),
            )
          ]),
          ReusableTextFormField(
              controller: appAuthProvider.nameController!,
              icon: Icons.person,
              isPasswordType: false,
              lableText: 'Edit your name',
              validateText: 'Edit your name'),
          ButtonWidget(
              isForAuth: false,
              width: MediaQuery.of(context).size.width,
              hight: 50,
              text: "Supmit Edit",
              onTap: () async {
                String name = appAuthProvider.nameController!.text;
                appAuthProvider.updateUserprofile(name, imageURL!);
              }),
        ],
      ),
    );
  }
}
