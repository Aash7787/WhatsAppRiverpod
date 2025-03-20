import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/constants/network_images.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/repositories/common_firebase_storage_repository.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/utils/utils.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/auth/screens/otp_screen.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/auth/screens/user_information_screen.dart';
import 'package:flutter_whatsaap_clone_riverpod/models/user_model.dart';
import 'package:flutter_whatsaap_clone_riverpod/screens/mobile/mobile_screen_layout.dart';

import '../../../common/constants/firebase_string/collections.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
      auth: FirebaseAuth.instance, fireStore: FirebaseFirestore.instance),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;

  AuthRepository({required this.auth, required this.fireStore});

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    log(phoneNumber);
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw Exception('verification Failed');
        },
        codeSent: (verificationId, forceResendingToken) async {
          await Navigator.pushNamed(context, OtpScreen.route,
              arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, text: e.toString());
    }
  }

  void verifyOtp(BuildContext context,
      {required String verificationId, required String userOTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserInformationScreen.route,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, text: e.toString());
    }
  }

  void saveUserDataToFirebase(BuildContext context,
      {required String name,
      required File? profilePic,
      required Ref ref}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = NetworkImages.personImage;
      log(uid);
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepository)
            .storeFileToFirebase('profilePic/$uid', profilePic);
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber.toString(),
          groupId: []);

      await fireStore.collection(users).doc(uid).set(user.toMap());
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => const MobileScreenLayout(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, text: e.toString());
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await fireStore.collection(users).doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Stream<UserModel> userData(String userId) {
    return fireStore.collection(users).doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await fireStore
        .collection(users)
        .doc(auth.currentUser!.uid)
        .update({'isOnline': isOnline});
  }
}
