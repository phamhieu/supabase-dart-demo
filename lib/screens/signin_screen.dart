import 'package:demoapp/components/auth_state.dart';
import 'package:demoapp/utils/supabase.dart';
import 'package:flutter/material.dart';
import 'package:demoapp/screens/profile_screen.dart';
import 'package:demoapp/components/alert_modal.dart';
import 'package:demoapp/utils/constants.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:supabase/supabase.dart' hide Column;
import 'package:url_launcher/url_launcher.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends AuthState<SignInScreen> {
  final RoundedLoadingButtonController _signInEmailController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _googleSignInController =
      RoundedLoadingButtonController();
  var email = '';
  var password = '';

  void _onSignInPress(BuildContext context) async {
    final response =
        await Supabase.client.auth.signIn(email: email, password: password);
    if (response.error != null) {
      alertModal.show(context,
          title: 'Sign in failed', message: response.error!.message);
      _signInEmailController.reset();
    } else {
      final title = 'Welcome ${response.data!.user!.email}';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ProfileScreen(title);
          },
        ),
      );
    }
  }

  void _googleSigninPressed(BuildContext context) async {
    signingInWithOAuthProvider = true;
    final res = await Supabase.client.auth.signIn(
      provider: Provider.google,
      options:
          AuthOptions(redirectTo: 'io.supabase.flutterdemo://login-callback'),
    );
    await launch(res.url!);
  }

  @override
  void onErrorAuthenticating(String message) {
    super.onErrorAuthenticating(message);
    _googleSignInController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Sign in'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 25.0),
            TextField(
              onChanged: (value) => setState(() {
                email = value;
              }),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter your email address',
              ),
            ),
            SizedBox(height: 15.0),
            TextField(
              onChanged: (value) => setState(() {
                password = value;
              }),
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 15.0),
            RoundedLoadingButton(
              color: Colors.green,
              child: const Text(
                'Sign in',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              controller: _signInEmailController,
              onPressed: () {
                _onSignInPress(context);
              },
            ),
            SizedBox(height: 15.0),
            TextButton(
              child: const Text("Forgot your password ?"),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(PASSWORDRECOVER_SCREEN);
              },
            ),
            TextButton(
              child: const Text("Don’t have an Account ? Sign up"),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(SIGNUP_SCREEN);
              },
            ),
            SizedBox(height: 15.0),
            RoundedLoadingButton(
              color: Colors.green,
              child: const Text(
                'Google Login',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              controller: _googleSignInController,
              onPressed: () {
                _googleSigninPressed(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
