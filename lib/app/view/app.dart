import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/app/app.dart';
import 'package:flutter_instagram_clone/app/view/app_view.dart';
import 'package:user_repository/user_repository.dart';

final snackbarKey = GlobalKey<AppSnackbarState>();

class App extends StatelessWidget {
  const App({
    required this.userRepository,
    required this.user,
    super.key,
  });

  final User user;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: userRepository,
      child: BlocProvider(
        create: (context) => AppBloc(
            user: user,
            userRepository: userRepository,),
          child: const AppView(),),
    );
  }
}

void openSnackbar(SnackbarMessage message,
    {bool clearIfQueue = false, bool undismissable = false,}) {
  snackbarKey.currentState
      ?.post(message, clearIfQueue: clearIfQueue, undismissable: undismissable);
}

void closeSnackbars() => snackbarKey.currentState?.closeAll();
