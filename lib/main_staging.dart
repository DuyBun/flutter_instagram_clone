import 'package:api_repository/api_repository.dart';
import 'package:flutter_instagram_clone/app/app.dart';
import 'package:flutter_instagram_clone/bootstrap.dart';
import 'package:flutter_instagram_clone/firebase_options_stg.dart';
import 'package:shared/shared.dart';

void main() {
  const apiRepository = ApiRepository();
  bootstrap(() {
    return const App(apiRepository: apiRepository);
  },
    appFlavor: AppFlavor.staging(),
    options: DefaultFirebaseOptions.currentPlatform
  );
}