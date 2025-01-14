import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/app/app.dart';
import 'package:flutter_instagram_clone/auth/auth.dart';
import 'package:flutter_instagram_clone/l10n/l10n.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    context.customReversedAdaptiveColor(
        light: AppColors.red, dark: AppColors.black);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: const AppTheme().theme,
      darkTheme: const AppDarkTheme().theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            AppSnackbar(
              key: snackbarKey,
            ),
          ],
        );
      },
      home: const AuthPage(),
    );
  }
}
