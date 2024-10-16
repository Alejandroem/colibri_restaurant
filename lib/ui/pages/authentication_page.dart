import 'package:colibri_shared/application/providers/authentication_providers.dart';
import 'package:colibri_shared/application/providers/storage_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationPage extends ConsumerStatefulWidget {
  const AuthenticationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthenticationPageState();
}

class _AuthenticationPageState extends ConsumerState<AuthenticationPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool listenerAdded = false;
  bool _obscurePassword = true; // State variable to track password visibility

  @override
  Widget build(BuildContext context) {
    if (!listenerAdded) {
      emailController.addListener(() {
        ref.read(authErrorMessage.notifier).state = "";
      });
      passwordController.addListener(() {
        ref.read(authErrorMessage.notifier).state = "";
      });
      listenerAdded = true;
    }

    final authenticationService = ref.read(authenticationServiceProvider);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            // To prevent overflow when keyboard is open
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 64),
                Text(
                  FlutterI18n.translate(context, "welcome"),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                ref.watch(isLogin)
                    ? Text(
                        FlutterI18n.translate(context, "loginText"),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        FlutterI18n.translate(context, "registerText"),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/logo.png'),
                      radius: 30,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  child: Column(
                    children: [
                      // Email Input Field
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                FlutterI18n.translate(context, "hintEmail"),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Password Input Field with Visibility Toggle
                      Container(
                        padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                FlutterI18n.translate(context, "hintPassword"),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (ref.watch(authErrorMessage)?.isNotEmpty ?? false)
                        Text(
                          ref.watch(authErrorMessage).toString(),
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () async {
                          final email = emailController.text.trim();
                          final password = passwordController.text;
                          if (email.isEmpty || password.isEmpty) {
                            ref.read(authErrorMessage.notifier).state =
                                FlutterI18n.translate(
                                    context, "errorEmptyCredentials");
                            return;
                          }
                          try {
                            if (ref.read(isLogin)) {
                              // Sign in with email and password
                              await authenticationService
                                  .authenticateWithEmailAndPassword(
                                email,
                                password,
                              );
                            } else {
                              // Register with email and password
                              await authenticationService
                                  .registerWithEmailAndPassword(
                                email,
                                password,
                                null,
                              );
                            }
                            // Navigate to the next screen or handle successful authentication
                          } catch (e) {
                            ref.read(authErrorMessage.notifier).state =
                                e.toString();
                          }
                        },
                        child: ref.watch(isLogin)
                            ? Text(FlutterI18n.translate(context, "login"))
                            : Text(FlutterI18n.translate(context, "register")),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          final isLoginState = ref.read(isLogin.notifier);
                          isLoginState.state = !isLoginState.state;
                        },
                        child: ref.watch(isLogin)
                            ? Text(
                                FlutterI18n.translate(context, "toggleSignup"),
                                style: const TextStyle(
                                  color: Colors.blue,
                                ),
                              )
                            : Text(
                                FlutterI18n.translate(context, "toggleLogin"),
                                style: const TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                      ),
                      if (ref.read(isLogin))
                        TextButton(
                          onPressed: () {
                            // Navigate to password reset page or implement password reset logic
                          },
                          child: Text(
                            FlutterI18n.translate(context, "forgotPassword"),
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Text(
                      FlutterI18n.translate(context, "version"),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    // Add a switch locale button between es and en
                    Spacer(),
                    TextButton(
                      onPressed: () async {
                        final localStorage =
                            ref.read(localStorageServiceProvider);
                        final currentLocale =
                            FlutterI18n.currentLocale(context);
                        final newLocale = currentLocale?.languageCode == 'en'
                            ? Locale('es')
                            : Locale('en');
                        await FlutterI18n.refresh(context, newLocale);
                        await FlutterI18n.refresh(context, newLocale);

                        // Save the selected locale to SharedPreferences
                        localStorage.save(
                          'selectedLocale',
                          newLocale.languageCode,
                        );

                        setState(
                            () {}); // Force rebuild to reflect locale change
                      },
                      child: Text(
                        FlutterI18n.currentLocale(context)?.languageCode == 'en'
                            ? 'ES'
                            : 'EN',
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
