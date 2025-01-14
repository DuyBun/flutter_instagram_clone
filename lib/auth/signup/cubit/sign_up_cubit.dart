import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_fields/form_fields.dart';
import 'package:shared/shared.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const SignUpState.initial());

  final UserRepository _userRepository;

  void changePasswordVisibility() => emit(
        state.copyWith(showPassword: !state.showPassword),
      );

  void onEmailChanged(String newValue) {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final shouldValidate = previousEmailState.invalid;
    final newEmailState = shouldValidate
        ? Email.validated(
            newValue,
          )
        : Email.unvalidated(
            newValue,
          );

    final newScreenState = state.copyWith(
      email: newEmailState,
    );

    emit(newScreenState);
  }

  void onEmailUnfocused() {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final previousEmailValue = previousEmailState.value;

    final newEmailState = Email.validated(
      previousEmailValue,
    );
    final newScreenState = previousScreenState.copyWith(
      email: newEmailState,
    );
    emit(newScreenState);
  }

  void onPasswordChanged(String newValue) {
    final previousScreenState = state;
    final previousPasswordState = previousScreenState.password;
    final shouldValidate = previousPasswordState.invalid;
    final newPasswordState = shouldValidate
        ? Password.validated(
            newValue,
          )
        : Password.unvalidated(
            newValue,
          );

    final newScreenState = state.copyWith(
      password: newPasswordState,
    );

    emit(newScreenState);
  }

  void onPasswordUnfocused() {
    final previousScreenState = state;
    final previousPasswordState = previousScreenState.password;
    final previousPasswordValue = previousPasswordState.value;

    final newPasswordState = Password.validated(
      previousPasswordValue,
    );
    final newScreenState = previousScreenState.copyWith(
      password: newPasswordState,
    );
    emit(newScreenState);
  }

  void onFullNameChanged(String newValue) {
    final previousScreenState = state;
    final previousFullNameState = previousScreenState.fullName;
    final shouldValidate = previousFullNameState.invalid;
    final newFullNameState = shouldValidate
        ? FullName.validated(
            newValue,
          )
        : FullName.unvalidated(
            newValue,
          );

    final newScreenState = state.copyWith(
      fullName: newFullNameState,
    );

    emit(newScreenState);
  }

  void onFullNameUnfocused() {
    final previousScreenState = state;
    final previousFullNameState = previousScreenState.fullName;
    final previousFullNameValue = previousFullNameState.value;

    final newFullNameState = FullName.validated(
      previousFullNameValue,
    );
    final newScreenState = previousScreenState.copyWith(
      fullName: newFullNameState,
    );
    emit(newScreenState);
  }

  void onUserNameChanged(String newValue) {
    final previousScreenState = state;
    final previousUserNameState = previousScreenState.userName;
    final shouldValidate = previousUserNameState.invalid;
    final newSurnameState = shouldValidate
        ? UserName.validated(
            newValue,
          )
        : UserName.unvalidated(
            newValue,
          );

    final newScreenState = state.copyWith(
      userName: newSurnameState,
    );

    emit(newScreenState);
  }

  void onUserNameUnfocused() {
    final previousScreenState = state;
    final previousUserNameState = previousScreenState.userName;
    final previousUserNameValue = previousUserNameState.value;

    final newUserNameState = UserName.validated(
      previousUserNameValue,
    );
    final newScreenState = previousScreenState.copyWith(
      userName: newUserNameState,
    );
    emit(newScreenState);
  }

  Future<void> onSubmit({
    File? avatarFile,
  }) async {
    final email = Email.validated(state.email.value);
    final password = Password.validated(state.password.value);
    final fullName = FullName.validated(state.fullName.value);
    final userName = UserName.validated(state.userName.value);
    final isFormValid =
        FormzValid([email, password, fullName, userName]).isFormValid;

    final newState = state.copyWith(
      email: email,
      password: password,
      fullName: fullName,
      userName: userName,
      submissionStatus: isFormValid ? SignUpSubmissionStatus.inProgress : null,
    );

    emit(newState);

    if (!isFormValid) return;

    try {
      String? imageUrlResponse;
      // if (avatarFile != null) {
      //   final imageBytes =
      //       await PickImage().imageBytes(file: File(avatarFile.path));
      //   final avatarsStorage = Supabase.instance.client.storage.from('avatars');
      //
      //   final fileExt = avatarFile.path.split('.').last.toLowerCase();
      //   final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      //   final filePath = fileName;
      //   await avatarsStorage.uploadBinary(
      //     filePath,
      //     imageBytes,
      //     fileOptions: FileOptions(
      //       contentType: 'image/$fileExt',
      //       cacheControl: '360000',
      //     ),
      //   );
      //   imageUrlResponse = await avatarsStorage.createSignedUrl(
      //     filePath,
      //     60 * 60 * 24 * 365 * 10,
      //   );
      // }

      // final pushToken = await _notificationsClient.fetchToken();

      await _userRepository.signUpWithPassword(
        email: email.value,
        password: password.value,
        fullName: fullName.value,
        username: userName.value,
      );

      if (isClosed) return;
      emit(state.copyWith(submissionStatus: SignUpSubmissionStatus.success));
    } catch (e, stackTrace) {
      _errorFormatter(e, stackTrace);
    }
  }

  /// Defines method to format error. It is used to format error in order to
  /// show it to user.
  void _errorFormatter(Object e, StackTrace stackTrace) {
    addError(e, stackTrace);

    final submissionStatus = switch (e) {
      SignUpWithPasswordFailure(:final AuthException error) => switch (
            error.statusCode?.parse) {
          HttpStatus.badRequest =>
            SignUpSubmissionStatus.emailAlreadyRegistered,
          HttpStatus.unprocessableEntity =>
            SignUpSubmissionStatus.emailAlreadyRegistered,

          _ => SignUpSubmissionStatus.error
        },
      _ => SignUpSubmissionStatus.idle
    };

    final newState = state.copyWith(
      submissionStatus: submissionStatus,
    );
    emit(newState);
  }
}
