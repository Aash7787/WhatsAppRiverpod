import 'package:flutter/material.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/widgets/custom_button.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/auth/screens/login_screen.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/colors.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  static const route = '/landing/screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: edgeInsetsSymmetricHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Welcome to WhatsApp',
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              Image.asset(
                'assets/bg.png',
                color: tabColor,
              ),
              const Text(
                'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
                textAlign: TextAlign.center,
                style: TextStyle(color: greyColor),
              ),
              CustomButton(
                text: 'AGREE AND CONTINUE',
                onPressed: () =>
                    Navigator.pushNamed(context, LoginScreen.route),
              )
            ],
          ),
        ),
      ),
    );
  }
}
