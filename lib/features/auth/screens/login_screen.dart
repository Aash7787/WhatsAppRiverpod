import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/utils/utils.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/widgets/custom_button.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/auth/controller/auth_controller.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const route = '/login/screen';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController phoneController;

  Country? country;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController()..text = '03030765463';
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (value) {
        setState(() {
          country = value;
        });
      },
    );
  }

  void sendPhoneNumber() {
    var phoneNumber = phoneController.text.trim();
    setState(() {
      isLoading = true;
    });

    if (country != null && phoneNumber.isNotEmpty) {
      // log(phoneNumber, name: LoginScreen.route);
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    } else {
      showSnackBar(context, text: 'Please enter a phone number');
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text(
          'Enter your phone number',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: edgeInsetsSymmetricHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 2,
            ),
            const Text(
              'WhatsApp will need to verify your phone number.',
              textAlign: TextAlign.center,
            ),
            const Spacer(
              flex: 1,
            ),
            TextButton(
              onPressed: pickCountry,
              child: const Text('Pick Country'),
            ),
            const Spacer(
              flex: 1,
            ),
            Row(
              children: [
                // if (country != null) Text('+${country!.phoneCode}'),
                country != null
                    ? Text('+${country!.phoneCode}')
                    : const Text('🧮'),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 70,
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    decoration: const InputDecoration(
                      // labelText: 'Phone',
                      // prefixText: 'pHONE',

                      hintText: 'phone number',
                    ),
                  ),
                ),
                const Spacer(
                  flex: 10,
                )
              ],
            ),
            const Spacer(
              flex: 20,
            ),
            SizedBox(
              width: 100,
              child: Builder(
                builder: (context) {
                  if (isLoading) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return CustomButton(
                      text: 'Next',
                      onPressed: sendPhoneNumber,
                    );
                  }
                },
              ),
            ),
            const Spacer(
              flex: 2,
            )
          ],
        ),
      ),
    );
  }
}
