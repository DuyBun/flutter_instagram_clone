import 'package:env/env.dart';
import 'package:flutter_instagram_clone/app/app.dart';
import 'package:flutter_instagram_clone/bootstrap.dart';
import 'package:flutter_instagram_clone/firebase_options_dev.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared/shared.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:token_storage/token_storage.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  bootstrap(
    (powerSyncRepository) async {
      final androidClientId =
          getIt<AppFlavor>().getEnv(EnumEnv.androidClientId);
      final webClientId = getIt<AppFlavor>().getEnv(EnumEnv.webClientId);

      final googleSignIn = GoogleSignIn(
        clientId: androidClientId,
        serverClientId: webClientId,
      );
      final tokenStorage = InMemoryTokenStorage();
      final supabaseAuthenticationClient = SupabaseAuthenticationClient(
        powerSyncRepository: powerSyncRepository,
        tokenStorage: tokenStorage,
        googleSignIn: googleSignIn,
      );
      final userRepository =
          UserRepository(authenticationClient: supabaseAuthenticationClient);
      return App(
        userRepository: userRepository,
        user: await userRepository.user.first,
      );
    },
    appFlavor: AppFlavor.development(),
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
