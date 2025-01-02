// ignore_for_file: public_member_api_docs

enum EnumEnv {
  supabaseUrl('SUPABASE_URL'),
  supabaseAnonKey('SUPABASE_ANON_KEY'),
  powerSyncUrl('POWERSYNC_URL'),
  webClientId('WEB_CLIENT_ID'),
  androidClientId('ANDROID_CLIENT_ID');

  const EnumEnv(this.value);

  final String value;
}
