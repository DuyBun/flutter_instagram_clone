import 'package:app_ui/app_ui.dart';
import 'package:env/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/app/app.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared/shared.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GoogleSignInButton(),
            SizedBox(
              height: 12,
            ),
            LogoutButton(),
          ],
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  Future<void> _googleSignIn() async {
    final webClientId = getIt<AppFlavor>().getEnv(EnumEnv.webClientId);
    final androidClientId = getIt<AppFlavor>().getEnv(EnumEnv.androidClientId);

    final googleSignIn = GoogleSignIn(
      clientId: androidClientId,
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;
    if (googleAuth == null) {
      throw Exception('Google sign in was canceled');
    }

    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw Exception('No Access Token found!');
    }

    if (idToken == null) {
      throw Exception('No ID Token found!');
    }

    await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tappable.scaled(

      backgroundColor: context.theme.focusColor,
      onTap: () async {
        // try {
        //   await _googleSignIn();
        // } catch (error, stackTrace) {
        //   logE(
        //     'Failed to login with Google.',
        //     error: error,
        //     stackTrace: stackTrace,
        //   );
        // }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs + AppSpacing.xxs,
        ),
        child: Text(
          'Google sign in',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _logout() => Supabase.instance.client.auth.signOut();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final session = snapshot.data?.session;
          if (session == null) return const SizedBox.shrink();
          return ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            label: Text(
              'Log out',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.apply(color: Colors.red),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
