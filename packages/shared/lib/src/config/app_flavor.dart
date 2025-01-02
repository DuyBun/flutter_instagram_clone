// ignore_for_file: public_member_api_docs

import 'package:env/env.dart';

enum Flavor { development, staging, production }

sealed class AppEnv {
  const AppEnv();

  String getEnv(EnumEnv enumEnv);
}

class AppFlavor extends AppEnv{
  const AppFlavor._({required this.flavor});

  factory AppFlavor.development() =>
      const AppFlavor._(flavor: Flavor.development);
  factory AppFlavor.staging() =>
      const AppFlavor._(flavor: Flavor.staging);
  factory AppFlavor.production() =>
      const AppFlavor._(flavor: Flavor.production);

  final Flavor flavor;

  @override
  String getEnv(EnumEnv enumEnv) => switch(enumEnv) {
    EnumEnv.supabaseUrl => switch(flavor) {
      Flavor.development => EnvDev.supabaseUrl,
      Flavor.production => EnvProd.supabaseUrl,
      Flavor.staging => EnvStg.supabaseUrl,
    },
    EnumEnv.supabaseAnonKey => switch(flavor) {
      Flavor.development => EnvDev.supabaseAnonKey,
      Flavor.production => EnvProd.supabaseAnonKey,
      Flavor.staging => EnvStg.supabaseAnonKey,
    },
    EnumEnv.powerSyncUrl => switch(flavor) {
      Flavor.development => EnvDev.powerSyncUrl,
      Flavor.production => EnvProd.powerSyncUrl,
      Flavor.staging => EnvStg.powerSyncUrl,
    },
    EnumEnv.webClientId => switch(flavor) {
      Flavor.development => EnvDev.webClientId,
      Flavor.production => EnvProd.webClientId,
      Flavor.staging => EnvStg.webClientId,
    },
    EnumEnv.androidClientId => switch(flavor) {
    Flavor.development => EnvDev.androidClientId,
    Flavor.production => EnvProd.androidClientId,
    Flavor.staging => EnvStg.androidClientId,
    },
  };
}
