import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/widgets/error_wid.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/widgets/loading_wid.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/auth/controller/auth_controller.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/landing/screens/landing_screen.dart';
import 'package:flutter_whatsaap_clone_riverpod/firebase_options.dart';
import 'package:flutter_whatsaap_clone_riverpod/routers/router.dart';
import 'package:flutter_whatsaap_clone_riverpod/screens/mobile/mobile_screen_layout.dart';

import 'shared/colors.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
  Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  static const _title = 'Whats app Ui';

  @override
  Widget build(BuildContext context, ref) {
    return MaterialApp(
      title: _title,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ),
      ),
      onGenerateRoute: generateRoute,
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              log(user.toString());
              if (user == null) {
                return const LandingScreen();
              }
              return const MobileScreenLayout();
            },
            error: (error, stackTrace) {
              return const ErrorWid();
            },
            loading: () => const LoadingWid(),
          ),
      // home: const CustomBottomBar(),
      // const ResponsiveLayout(
      //   mobileScreenLayout: MobileScreenLayout(),
      //   webScreenLayout: WebScreenLayout(),
      // ),
    );
  }
}
