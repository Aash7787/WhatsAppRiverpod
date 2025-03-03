import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/widgets/error_wid.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/widgets/loading_wid.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/auth/screens/login_screen.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/auth/screens/otp_screen.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/auth/screens/user_information_screen.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/landing/screens/landing_screen.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/select_contacts/screens/select_contacts_screen.dart';

import '../features/chat/screens/mobile_chat_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  return switch (settings.name) {
    LandingScreen.route => CupertinoPageRoute(
        builder: (context) => const LandingScreen(),
      ),
    LoginScreen.route => CupertinoPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    OtpScreen.route => CupertinoPageRoute(
        builder: (context) =>
            // final verificationId = settings.arguments as String;
            OtpScreen(verificationId: settings.arguments as String),
      ),
    UserInformationScreen.route => CupertinoPageRoute(
        builder: (context) => const UserInformationScreen(),
      ),
    SelectContactsScreen.route => CupertinoPageRoute(
        builder: (context) => const SelectContactsScreen(),
      ),
    MobileChatScreen.route => CupertinoPageRoute(
        builder: (context) {
          final (:name, :uid) =
              settings.arguments as ({String name, String uid});
          return MobileChatScreen(
            name: name,
            uid: uid,
          );
        },
      ),
    LoadingWid.route => CupertinoPageRoute(
        builder: (context) => const LoadingWid(),
      ),
    ErrorWid.route => MaterialPageRoute(
        builder: (context) => const ErrorWid(),
      ),
    _ => MaterialPageRoute(
        builder: (context) => const ErrorWid(),
      )
  };
}
