import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';

final getIt = GetIt.instance;

void setupDependencyInjection({required AppFlavor appFlavor}) {
  getIt.registerSingleton(appFlavor);
}
