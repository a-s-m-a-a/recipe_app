import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:recipe_application/model/user_profile.model.dart';
import 'package:recipe_application/pages/home.pages.dart';
import 'package:recipe_application/pages/login.pages.dart';
import 'package:recipe_application/pages/register.pages.dart';
import 'package:recipe_application/reusable_widgets/toast_message.dart';
import 'package:recipe_application/utils/toast_message_status.dart';

class AppAuthprovider extends ChangeNotifier {
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? nameController;
  bool obsecuretext = false;
  String? _imagURL;
  String? get imageURL => _imagURL;
  String? _name;
  String? get name => _name;
  List<UserProfile>? userProfile;

  void providerInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
  }

  void providerDespose(GlobalKey<FormState>? formKey) {
    formKey = null;
    emailController = null;
    passwordController = null;
    nameController = null;
    obsecuretext = false;
  }

  void openRegisterpage(BuildContext context, GlobalKey<FormState>? formKey) {
    providerDespose(formKey);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const RegisterPage()));
  }

  void openLoginpage(BuildContext context, GlobalKey<FormState>? formKey) {
    providerDespose(formKey);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  Future<void> signUp(
    BuildContext context,
    GlobalKey<FormState>? formKey,
    String imageURL,
  ) async {
    try {
      if (formKey?.currentState?.validate() ?? false) {
        OverlayLoadingProgress.start();
        UserCredential credentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController!.text,
                password: passwordController!.text);
        if (credentials.user != null) {
          await credentials.user?.updateDisplayName(nameController!.text);
          OverlayLoadingProgress.stop();
          providerDespose(formKey);
          if (context.mounted) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          }
        }
        addNewUserprofile(imageURL);
        OverlayLoadingProgress.stop();
      }
    } catch (e) {
      OverlayLoadingProgress.stop();
    }
  }

  Future updateUserprofile(String userName, String image) async {
    await FirebaseAuth.instance.currentUser?.updateDisplayName(userName);
    setNewUserPhotoURL(image);
    notifyListeners();
  }

  Future passwordReset(
      BuildContext context, GlobalKey<FormState>? formKey) async {
    try {
      if (formKey?.currentState?.validate() ?? false) {
        OverlayLoadingProgress.start();
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController!.text);

        OverlayLoadingProgress.stop();
        providerDespose(formKey);
        OverlayToastMessage.show(
          widget: const ToastMessageWidget(
            message: "Password reset link sent! Chick your Email",
            toastMessageStatus: ToastMessageStatus.success,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      OverlayLoadingProgress.stop();
      OverlayToastMessage.show(
          widget: ToastMessageWidget(
        message: e.message.toString(),
        toastMessageStatus: ToastMessageStatus.faild,
      ));
    }
  }

  Future addNewUserprofile(String imageURL) async {
    await FirebaseFirestore.instance.collection('userProfile').add({
      'imageUrl': imageURL,
      'userId': FirebaseAuth.instance.currentUser?.uid ?? "",
    });
    notifyListeners();
  }

  Future setNewUserPhotoURL(String image) async {
    var result = await FirebaseFirestore.instance
        .collection('userProfile')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (result.docs.isNotEmpty) {
      userProfile = List<UserProfile>.from(
          result.docs.map((doc) => UserProfile.fromJson(doc.data(), doc.id)));
      userProfile?[0].imageUrl = image;
    }
    notifyListeners();
  }

  Future getUserPhotoURL() async {
    var result = await FirebaseFirestore.instance
        .collection('userProfile')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (result.docs.isNotEmpty) {
      userProfile = List<UserProfile>.from(
          result.docs.map((doc) => UserProfile.fromJson(doc.data(), doc.id)));
      _imagURL = userProfile?[0].imageUrl;
    } else {
      _imagURL = '';
    }
    notifyListeners();
  }

  Future<void> signIn(
      BuildContext context, GlobalKey<FormState>? formKey) async {
    try {
      if (formKey?.currentState?.validate() ?? false) {
        OverlayLoadingProgress.start();
        UserCredential credentials = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController!.text,
                password: passwordController!.text);
        if (credentials.user != null) {
          OverlayLoadingProgress.stop();
          providerDespose(formKey);
          OverlayToastMessage.show(
            widget: const ToastMessageWidget(
              message: "You Login Successfully ",
              toastMessageStatus: ToastMessageStatus.success,
            ),
          );
          if (context.mounted) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          }
        }
        OverlayLoadingProgress.stop();
      }
    } on FirebaseAuthException catch (e) {
      OverlayLoadingProgress.stop();
      if (e.code == "user-not-found") {
        OverlayToastMessage.show(
            widget: const ToastMessageWidget(
          message: "user not found ",
          toastMessageStatus: ToastMessageStatus.faild,
        ));
      } else if (e.code == "user-disabled") {
        OverlayToastMessage.show(
            widget: const ToastMessageWidget(
          message: "You are disabled",
          toastMessageStatus: ToastMessageStatus.faild,
        ));
      } else if (e.code == "invalid-email") {
        OverlayToastMessage.show(
            widget: const ToastMessageWidget(
          message: "This email isn't exist",
          toastMessageStatus: ToastMessageStatus.faild,
        ));
      } else if (e.code == "wrong-password") {
        OverlayToastMessage.show(
            widget: const ToastMessageWidget(
          message: "wrong password",
          toastMessageStatus: ToastMessageStatus.faild,
        ));
      }
    } catch (e) {
      OverlayLoadingProgress.stop();
    }
  }

  void toggelObsecure() {
    obsecuretext = !obsecuretext;
    notifyListeners();
  }

  void signOut(BuildContext context) async {
    OverlayLoadingProgress.start();
    await Future.delayed(const Duration(seconds: 1));
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginPage()));
    }
    OverlayLoadingProgress.stop();
  }
}
