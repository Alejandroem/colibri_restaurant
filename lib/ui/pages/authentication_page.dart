import 'dart:async';
import 'dart:developer';

import 'package:colibri_shared/application/providers/address_providers.dart';
import 'package:colibri_shared/application/providers/authentication_providers.dart';
import 'package:colibri_shared/application/providers/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';


class AuthenticationPage extends ConsumerStatefulWidget {
  const AuthenticationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<AuthenticationPage> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController smsCodeController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'GT');
  String phoneNumber = '';
  bool listenerAdded = false;
  TextEditingController emailController = TextEditingController();

  StreamSubscription<String>? verificationStatusSubscription;

  @override
  Widget build(BuildContext context) {
    if (!listenerAdded) {
      emailController.addListener(() {
        ref.watch(authErrorMessage.notifier).state = "";
      });
      listenerAdded = true;
    }
    final authenticationService = ref.read(authenticationServiceProvider);
    verificationStatusSubscription ??=
        authenticationService.getVerificationStatus().listen((value) {
      if (value == "verification_completed") {
        final addressService = ref.read(addressServiceProvider);
        final newAddress = ref.read(newAddressInProcess);

        if (newAddress != null && newAddress.userId == '') {
          final authenticationService = ref.read(authenticationServiceProvider);
          authenticationService.getAuthenticatedUserId().then(
            (userid) {
              addressService.create(
                newAddress.copyWith(userId: userid!),
              );
            },
          );
        }
      }
      if (value == "verification_failed") {
        ref.watch(authErrorMessage.notifier).state =
            "Verification failed, please try again";
      }
    });
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Image.asset(
                'assets/images/logo.png',
                height: 84,
                width: 84,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 350,
                child: SizedBox(
                  height: 350,
                  child: Column(
                    children: [
                      if (!ref.watch(isLogin))
                        Container(
                          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          child: TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              hintText: 'Enter your email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      const SizedBox(height: 16),
                      StreamBuilder<String?>(
                          stream: ref
                              .watch(authenticationServiceProvider)
                              .getVerificationStatus(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data == "code_sent") {
                              return TextFormField(
                                controller: smsCodeController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'SMS Code',
                                  hintText: 'Enter the SMS code',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  ref.watch(authErrorMessage.notifier).state =
                                      "";
                                },
                              );
                            }
                            return Container(
                              padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              child: InternationalPhoneNumberInput(
                                searchBoxDecoration: const InputDecoration(
                                  hintText: 'Search country',
                                  // no border
                                  border: InputBorder.none,
                                ),
                                inputDecoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Phone number',
                                ),
                                onInputChanged: (PhoneNumber number) {
                                  log(number.phoneNumber ?? "");
                                  phoneNumber = number.phoneNumber ?? "";
                                  ref.watch(authErrorMessage.notifier).state =
                                      "";
                                },
                                onInputValidated: (bool value) {
                                  log(value.toString());
                                },
                                selectorConfig: const SelectorConfig(
                                  selectorType:
                                      PhoneInputSelectorType.BOTTOM_SHEET,
                                  useBottomSheetSafeArea: true,
                                ),
                                ignoreBlank: false,
                                autoValidateMode: AutovalidateMode.disabled,
                                selectorTextStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                initialValue: number,
                                textFieldController: phoneNumberController,
                                formatInput: true,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        signed: true, decimal: true),
                                inputBorder: const OutlineInputBorder(),
                                onSaved: (PhoneNumber number) {
                                  log('On Saved: $number');
                                },
                              ),
                            );
                          }),
                      const SizedBox(height: 32),
                      Text(
                        "With phone number you won't need to remember a password, we will send you a code to verify your phone number.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 12,
                        ),
                      ),
                      if (ref.watch(authErrorMessage)?.isNotEmpty ?? false)
                        Text(
                          ref.watch(authErrorMessage).toString(),
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      const SizedBox(height: 16),
                      StreamBuilder<String?>(
                          stream: ref
                              .watch(authenticationServiceProvider)
                              .getVerificationStatus(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data == "code_sent") {
                              return OutlinedButton(
                                onPressed: () async {
                                  try {
                                    await authenticationService
                                        .verifyPhoneNumber(
                                      smsCodeController.text,
                                    );
                                  } catch (e) {
                                    ref.watch(authErrorMessage.notifier).state =
                                        e.toString();
                                  }
                                },
                                child: const Text('Verify'),
                              );
                            }
                            return OutlinedButton(
                              onPressed: () async {
                                if (ref.read(isLogin)) {
                                  final profileServe =
                                      ref.read(profileServiceProvider);
                                  final userProfile = await profileServe.readBy(
                                    "phoneNumber",
                                    phoneNumber,
                                  );
                                  if (userProfile.isEmpty) {
                                    ref.watch(authErrorMessage.notifier).state =
                                        'User not found';
                                    return;
                                  }
                                } else {
                                  //phone number should not be empty
                                  if (phoneNumber.isEmpty &&
                                      phoneNumber.length < 5) {
                                    ref.watch(authErrorMessage.notifier).state =
                                        'Phone number is required';
                                    return;
                                  }
                                  //email should not be empty
                                  if (emailController.text.isEmpty) {
                                    ref.watch(authErrorMessage.notifier).state =
                                        'Email is required';
                                    return;
                                  }
                                }
                                await authenticationService
                                    .authenticateWithPhoneNumber(
                                  phoneNumber,
                                  emailController.text,
                                );
                              },
                              child: const Text('Submit'),
                            );
                          }),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          final isLoginState = ref.read(isLogin.notifier);
                          isLoginState.state = !isLoginState.state;
                        },
                        child: ref.watch(isLogin)
                            ? const Text(
                                'Don\'t have an account? Sign up',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              )
                            : const Text(
                                'Already have an account? Log in',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
