import 'package:ea_proyecto_flutter/api/services/auth_service.dart';
import 'package:ea_proyecto_flutter/api/services/userService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ea_proyecto_flutter/widgets/button.dart';
import 'package:ea_proyecto_flutter/widgets/text_field.dart';
import 'package:flutter_pw_validator/Resource/Strings.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/login_screen.dart';
import 'package:ea_proyecto_flutter/widgets/square_tile.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, this.onTap});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class CatalanStrings implements FlutterPwValidatorStrings {
  final Locale locale;

  CatalanStrings(this.locale);
  @override
  final String atLeast = '- Carácters com a mínim';
  @override
  final String uppercaseLetters = '- Lletres majuscules';
  @override
  final String numericCharacters = '- Números';
  @override
  final String lowercaseLetters = '- Lletres míniscules';
  @override
  final String normalLetters = '- Lletres normals';
  @override
  final String specialCharacters = '- Caracteres especiales';
}

class EnglishStrings implements FlutterPwValidatorStrings {
  final Locale locale;

  EnglishStrings(this.locale);
  @override
  final String atLeast = '- Characters at least';
  @override
  final String uppercaseLetters = '- Uppercase Letters';
  @override
  final String numericCharacters = '- Numbers';
  @override
  final String lowercaseLetters = '- Lowercase Letters';
  @override
  final String normalLetters = '- Normal Letters';
  @override
  final String specialCharacters = '- Special characters';
}

class SpanishStrings implements FlutterPwValidatorStrings {
  final Locale locale;

  SpanishStrings(this.locale);

  @override
  final String atLeast = '- Caracteres como mínimo';
  @override
  final String uppercaseLetters = '- Letras mayúsculas';
  @override
  final String numericCharacters = '- Números';
  @override
  final String lowercaseLetters = '- Letras mínisculas';
  @override
  final String normalLetters = '- Letras normales';
  @override
  final String specialCharacters = '- Caracteres especiales';
}

class AppStrings {
  static FlutterPwValidatorStrings getStrings(Locale locale) {
    switch (locale.languageCode) {
      case 'ca':
        return CatalanStrings(locale);
      case 'es':
        return SpanishStrings(locale);
      case 'en':
        return EnglishStrings(locale);
      // Añadir casos para otros idiomas si es necesario
      default:
        return CatalanStrings(locale); // Otras cadenas por defecto
    }
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  // api controller
  bool passwordValid = false;
  bool termsAndConditionsAccepted = false;
  bool termsAndConditionsVisible = false;
  final UserApiService userApiService = UserApiService();
  final usernameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final GlobalKey<FlutterPwValidatorState> pwValidatorKey =
      GlobalKey<FlutterPwValidatorState>();
  Widget _buildTermsAndConditions() {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: _closeTermsAndConditions,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Agrega aquí tus widgets para mostrar los términos y condiciones
            // Puedes usar Text, RichText, etc.
          ],
        ),
      ),
    );
  }

  void _closeTermsAndConditions() {
    setState(() {
      termsAndConditionsVisible = false;
    });
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Términos y Condiciones'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.acceptTermsMessage)
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // text editing controllers

    Future<void> _registerUser() async {
      if (usernameTextController.text.isEmpty ||
          emailTextController.text.isEmpty ||
          passwordTextController.text.isEmpty ||
          confirmPasswordTextController.text.isEmpty) {
        // Muestra un mensaje de error si algún campo está vacío
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(AppLocalizations.of(context)!.complete),
          ),
        );
        return; // Sale de la función si algún campo está vacío
      } else {
        if (passwordTextController.text != confirmPasswordTextController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(AppLocalizations.of(context)!.coincide),
            ),
          );
          return;
        }
        if (!termsAndConditionsAccepted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(AppLocalizations.of(context)!.acceptTermsMessage),
            ),
          );
          return;
        }
        if (!passwordValid) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(AppLocalizations.of(context)!.requirements),
            ),
          );
          return;
        }

        try {
          userApiService.registerUser(
            username: usernameTextController.text,
            email: emailTextController.text,
            password: passwordTextController.text,
          );

          // Si la solicitud fue exitosa (código 200)
          // Registro exitoso, redirige a la pantalla de inicio de sesión
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        } catch (e) {
          // Maneja errores de conexión o cualquier otra excepción
          print('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(e.toString()),
            ),
          );
        }
      }
    }

    final locale = Localizations.localeOf(context);
    final strings = AppStrings.getStrings(locale);
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //logo
                    const Icon(
                      Icons.app_registration_outlined,
                      color: Color.fromRGBO(0, 125, 204, 1.0),
                      size: 100,
                    ),

                    const SizedBox(height: 35),

                    //welcome back message
                    Text(
                      AppLocalizations.of(context)!.completeForm,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 30),

                    //username textfield
                    MyTextField(
                        controller: usernameTextController,
                        hintText: AppLocalizations.of(context)!.usernameHint,
                        obscureText: false),

                    const SizedBox(height: 25),

                    //email textfield
                    MyTextField(
                        controller: emailTextController,
                        hintText: AppLocalizations.of(context)!.emailHint,
                        obscureText: false),

                    const SizedBox(height: 25),

                    //password textfield
                    MyTextField(
                      controller: passwordTextController,
                      obscureText: true,
                      hintText: AppLocalizations.of(context)!.passwordHint,
                    ),

                    const SizedBox(height: 25),

                    //confirm password textfield
                    MyTextField(
                        controller: confirmPasswordTextController,
                        hintText: AppLocalizations.of(context)!.confirmPassword,
                        obscureText: true),
                    FlutterPwValidator(
                      key: pwValidatorKey,
                      controller: passwordTextController,
                      defaultColor: Colors.red,
                      successColor: Colors.green,
                      failureColor: Colors.red,
                      minLength: 8,
                      uppercaseCharCount: 1,
                      numericCharCount: 3,
                      lowercaseCharCount: 2,
                      width: 400,
                      height: 125,
                      strings: strings,
                      onSuccess: () {
                        setState(() {
                          passwordValid = true;
                        });
                      },
                      onFail: () {
                        setState(() {
                          passwordValid = false;
                        });
                      },
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Checkbox(
                          value: termsAndConditionsAccepted,
                          onChanged: (value) {
                            setState(() {
                              termsAndConditionsAccepted = value ?? false;
                            });
                          },
                        ),
                        InkWell(
                          onTap: _showTermsAndConditions,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Text(
                              AppLocalizations.of(context)!.acceptTerms,
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                      onTap: _registerUser,
                      text: AppLocalizations.of(context)!.register,
                    ),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              AppLocalizations.of(context)!.continueWith,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    //google button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // google button
                        SquareTile(
                            onTap: () async {
                              try {
                                final user =
                                    await AuthService.signInWithGoogle();
                                if (user != null && mounted) {
                                  try {
                                    await userApiService.registerGoogleUser(
                                        username: user.email!.split('@')[0],
                                        email: user.email!,
                                        password: user.uid,
                                        image: user.photoURL ??
                                            'https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png');
                                    // Si la solicitud fue exitosa (código 200)
                                    // Registro exitoso, redirige a la pantalla de inicio de sesión
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(e.toString()),
                                      ),
                                    );
                                  }
                                }
                              } on FirebaseAuthException catch (e) {
                                print(e);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                      e.message ?? 'Unknown error occurred'),
                                ));
                              } catch (e) {
                                print(e);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(e.toString())));
                              }
                            },
                            imagePath: 'assets/images/google.png'),
                      ],
                    ),

                    const SizedBox(height: 20),

                    //go to login page
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.account,
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          child: Text(
                            AppLocalizations.of(context)!.signInButton,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
