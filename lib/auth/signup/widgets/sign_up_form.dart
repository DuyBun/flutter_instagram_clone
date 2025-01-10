import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/auth/signup/widgets/sign_up_button.dart';
import 'package:flutter_instagram_clone/auth/signup/widgets/widgets.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmailFormField(),
        SizedBox(height: AppSpacing.md,),
        FullNameFormField(),
        SizedBox(height: AppSpacing.md,),
        UserNameFormField(),
        SizedBox(height: AppSpacing.md,),
        PasswordFormField(),
        SizedBox(height: AppSpacing.xlg,),
        SignUpButton(),
      ],
    );
  }
}
