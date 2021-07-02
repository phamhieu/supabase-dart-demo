import 'package:demoapp/components/alert_modal.dart';
import 'package:demoapp/components/supabase_auth_state.dart';
import 'package:demoapp/screens/profile_screen.dart';
import 'package:demoapp/utils/constants.dart';
import 'package:demoapp/utils/supabase.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  var signingInWithOAuthProvider = false;

  @override
  void onUnauthenticated() {
    Navigator.of(context).pushReplacementNamed(SIGNIN_SCREEN);
  }

  @override
  void onAuthenticated(Session session) {
    final title = 'Welcome ${Supabase.client.auth.currentUser!.email}';
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ProfileScreen(title);
        },
      ),
    );
  }

  @override
  void onErrorAuthenticating(String message) {
    alertModal.show(context, title: 'Sign in failed', message: message);
  }

  @override
  void onPasswordRecovery(Session session) {
    // TODO: show password change screen
    throw UnimplementedError();
  }

  @override
  void onResumed() {
    if (signingInWithOAuthProvider && !deeplinkReceived) {
      /// User pressed the back button of the browswer to come back to the app
      onErrorAuthenticating('Could not authenticate');
    }
    signingInWithOAuthProvider = false;
    deeplinkReceived = false;
    super.onResumed();
  }
}
