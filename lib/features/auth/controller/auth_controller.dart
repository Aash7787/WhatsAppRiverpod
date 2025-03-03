import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/auth/repository/auth_repository.dart';
import 'package:flutter_whatsaap_clone_riverpod/models/user_model.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
},);

class AuthController {
  final AuthRepository authRepository;
  final Ref ref;

  AuthController(this.ref, {required this.authRepository});
  void signInWithPhone(BuildContext context, String phoneNumber) {
    // log('signInWithPhone,$phoneNumber');
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOtp(BuildContext context, String verificationId, String userOTP) {
    authRepository.verifyOtp(context,
        verificationId: verificationId, userOTP: userOTP);
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic) {
    authRepository.saveUserDataToFirebase(context,
        name: name, profilePic: profilePic, ref: ref);
  }

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  Stream<UserModel> userDataById(String userId){
    return authRepository.userData(userId);
  }
}
