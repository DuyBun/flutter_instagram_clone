import 'package:bloc/bloc.dart';

class ManagePasswordCubit extends Cubit<bool> {
  ManagePasswordCubit() : super(true);

  void changeScreen({required bool showForgotPassword}) =>
      emit(showForgotPassword);
}
