import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/auth/controller/auth_controller.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/colors.dart';

class OtpScreen extends ConsumerWidget {
  const OtpScreen({
    super.key,
    required this.verificationId,
  });

  final String verificationId;

  static const route = '/otp/screen';

  void verifyOTP(BuildContext context, String userOTP, WidgetRef ref) {
    ref
        .read(authControllerProvider)
        .verifyOtp(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying your number'),
        backgroundColor: backgroundColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 25,
          ),
          const Text('We have sent an SMS with a code'),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.5,
                child: TextField(
                  onChanged: (value) {
                    if (value.length == 6) {
                      verifyOTP(context, value.trim(), ref);
                    }
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: '-  -  -  -  -  -',
                    hintStyle: TextStyle(
                      textBaseline: TextBaseline.alphabetic,
                      fontSize: 35,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
