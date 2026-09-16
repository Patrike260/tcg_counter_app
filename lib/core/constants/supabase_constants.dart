import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConstants {
  static const String fallbackUrl = 'https://hurxjtybfubckwjbxami.supabase.co';
  static const String fallbackAnonKey =
      'sb_publishable_R_cgy5PLn49nEMMzFl7M4A_hONI4cCN';

  static String get supabaseUrl {
    if (kIsWeb) return fallbackUrl;
    try {
      return dotenv.env['SUPABASE_URL'] ?? fallbackUrl;
    } catch (_) {
      return fallbackUrl;
    }
  }

  static String get supabaseAnonKey {
    if (kIsWeb) return fallbackAnonKey;
    try {
      return dotenv.env['SUPABASE_ANON_KEY'] ?? fallbackAnonKey;
    } catch (_) {
      return fallbackAnonKey;
    }
  }
}

final supabase = Supabase.instance.client;