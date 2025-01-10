part of 'sign_up_cubit.dart';

typedef SingUpErrorMessage = String;

/// Defines possible signup submission statuses. It is used to manipulate with
/// state, using Bloc, according to state. Therefore, when [success] we
/// can simply navigate user to main page and such.
enum SignUpSubmissionStatus {
  /// [SignUpSubmissionStatus.idle] indicates that user has not yet submitted
  /// signup form.
  idle,

  /// [SignUpSubmissionStatus.inProgress] indicates that user has submitted
  /// signup form and is currently waiting for response from backend.
  inProgress,

  /// [SignUpSubmissionStatus.success] indicates that user has successfully
  /// submitted signup form and is currently waiting for response from backend.
  success,

  /// [SignUpSubmissionStatus.emailAlreadyRegistered] indicates that email,
  /// provided by user, is occupied by another one in database.
  emailAlreadyRegistered,

  /// [SignUpSubmissionStatus.inProgress] indicates that user had no internet
  /// connection during network request.
  networkError,

  /// [SignUpSubmissionStatus.error] indicates something went wrong when user
  /// tried to sign up.
  error;

  bool get isSuccess => this == SignUpSubmissionStatus.success;
  bool get isLoading => this == SignUpSubmissionStatus.inProgress;
  bool get isEmailRegistered =>
      this == SignUpSubmissionStatus.emailAlreadyRegistered;
  bool get isNetworkError => this == SignUpSubmissionStatus.networkError;
  bool get isError =>
      this == SignUpSubmissionStatus.error ||
      isNetworkError ||
      isEmailRegistered;
}

class SignUpState extends Equatable {
  const SignUpState._({
    required this.submissionStatus,
    required this.email,
    required this.fullName,
    required this.userName,
    required this.password,
    required this.showPassword,
  });

  const SignUpState.initial()
      : this._(
          submissionStatus: SignUpSubmissionStatus.idle,
          email: const Email.unvalidated(),
          fullName: const FullName.unvalidated(),
          userName: const UserName.unvalidated(),
          password: const Password.unvalidated(),
          showPassword: false,
        );

  final SignUpSubmissionStatus submissionStatus;
  final Email email;
  final FullName fullName;
  final UserName userName;
  final Password password;
  final bool showPassword;

  @override
  List<Object?> get props =>
      [submissionStatus, email, fullName, userName, password, showPassword];

  SignUpState copyWith(
      {SignUpSubmissionStatus? submissionStatus,
      Email? email,
      FullName? fullName,
      UserName? userName,
      Password? password,
      bool? showPassword}) {
    return SignUpState._(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
    );
  }
}
