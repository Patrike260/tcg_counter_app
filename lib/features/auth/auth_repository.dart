import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/supabase_constants.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(supabase);
});

// Liefert den aktuellen Auth-Status (eingeloggt oder nicht)
final authStateProvider = StreamProvider<AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  User? get currentUser => _client.auth.currentUser;

  // E-Mail & Passwort Registrierung
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  // E-Mail & Passwort Login
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Google Sign-In (Plattform-übergreifend für Web & Android)
  Future<void> signInWithGoogle({required String webClientId}) async {
    if (kIsWeb) {
      // Im Browser mit fester Weiterleitungsadresse
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? Uri.base.origin + Uri.base.path : null,
      );
    } else {
      // Auf Android über natives Google Sign-In via ID-Token
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return; // Abgebrochen

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        throw Exception('Kein ID-Token von Google erhalten.');
      }

      await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    }
  }

  // Abmelden
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Löscht das Konto serverseitig (DSGVO) und beendet die Sitzung.
  Future<void> deleteAccount() async {
    await _client.rpc('delete_user_account');
    try {
      await signOut();
    } catch (_) {
      // Nach der Löschung kann die Session bereits ungültig sein.
    }
  }
}