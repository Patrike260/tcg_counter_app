import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/legal_screen.dart';
import '../../l10n/l10n.dart';
import 'auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;

  // WICHTIG: Setze hier deine Web-Client-ID aus der Google Cloud Console ein!
  // (Endet auf .apps.googleusercontent.com)
  static const String _webClientId = '325150772614-5s2a6912lk9tvmdk94gslod5ss4mnq15.apps.googleusercontent.com';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.enterEmailPassword)),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(authRepositoryProvider);
      if (_isSignUp) {
        await repo.signUp(email: email, password: password);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.registrationSuccess)),
          );
        }
      } else {
        await repo.signInWithPassword(email: email, password: password);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.errorWithDetails(e)), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    await _runOAuth(
      () => ref.read(authRepositoryProvider).signInWithGoogle(
            webClientId: _webClientId,
          ),
      (error) => context.l10n.googleLoginFailed(error),
    );
  }

  Future<void> _loginWithDiscord() async {
    await _runOAuth(
      () => ref.read(authRepositoryProvider).signInWithDiscord(),
      (error) => context.l10n.discordLoginFailed(error),
    );
  }

  Future<void> _loginWithGithub() async {
    await _runOAuth(
      () => ref.read(authRepositoryProvider).signInWithGithub(),
      (error) => context.l10n.githubLoginFailed(error),
    );
  }

  Future<void> _runOAuth(
    Future<void> Function() action,
    String Function(Object error) errorMessage,
  ) async {
    setState(() => _isLoading = true);
    try {
      await action();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage(e)), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.style, size: 64, color: Colors.deepPurpleAccent),
                const SizedBox(height: 16),
                Text(
                  _isSignUp ? l10n.createAccount : l10n.loginTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: l10n.email, border: const OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: l10n.password, border: const OutlineInputBorder()),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(_isSignUp ? l10n.register : l10n.signIn),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => setState(() => _isSignUp = !_isSignUp),
                  child: Text(_isSignUp ? l10n.alreadyHaveAccount : l10n.noAccountYet),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(l10n.or, style: const TextStyle(color: Colors.grey)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _loginWithGoogle,
                  icon: const Icon(Icons.account_circle, color: Colors.redAccent),
                  label: Text(l10n.continueWithGoogle),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _SocialAuthButton(
                        onPressed: _isLoading ? null : _loginWithDiscord,
                        icon: const _DiscordMark(),
                        label: l10n.continueWithDiscord,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SocialAuthButton(
                        onPressed: _isLoading ? null : _loginWithGithub,
                        icon: const _GithubMark(),
                        label: l10n.continueWithGithub,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LegalScreen()),
                    );
                  },
                  child: Text(
                    l10n.legalAcceptHint,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialAuthButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final String label;

  const _SocialAuthButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, height: 1.2),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscordMark extends StatelessWidget {
  const _DiscordMark();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(26, 20),
      painter: _DiscordMarkPainter(),
    );
  }
}

class _DiscordMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5865F2)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.12, size.height * 0.22)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.05,
        size.width * 0.78,
        size.height * 0.05,
        size.width * 0.88,
        size.height * 0.22,
      )
      ..cubicTo(
        size.width * 0.96,
        size.height * 0.62,
        size.width * 0.90,
        size.height * 0.92,
        size.width * 0.72,
        size.height,
      )
      ..lineTo(size.width * 0.62, size.height * 0.86)
      ..cubicTo(
        size.width * 0.66,
        size.height * 0.84,
        size.width * 0.70,
        size.height * 0.81,
        size.width * 0.73,
        size.height * 0.77,
      )
      ..cubicTo(
        size.width * 0.68,
        size.height * 0.80,
        size.width * 0.32,
        size.height * 0.80,
        size.width * 0.27,
        size.height * 0.77,
      )
      ..cubicTo(
        size.width * 0.30,
        size.height * 0.81,
        size.width * 0.34,
        size.height * 0.84,
        size.width * 0.38,
        size.height * 0.86,
      )
      ..lineTo(size.width * 0.28, size.height)
      ..cubicTo(
        size.width * 0.10,
        size.height * 0.92,
        size.width * 0.04,
        size.height * 0.62,
        size.width * 0.12,
        size.height * 0.22,
      )
      ..close();
    canvas.drawPath(path, paint);

    final eye = Paint()..color = Colors.white;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.36, size.height * 0.48),
        width: size.width * 0.14,
        height: size.height * 0.22,
      ),
      eye,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.64, size.height * 0.48),
        width: size.width * 0.14,
        height: size.height * 0.22,
      ),
      eye,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GithubMark extends StatelessWidget {
  const _GithubMark();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomPaint(
      size: const Size(22, 22),
      painter: _GithubMarkPainter(
        color: isDark ? Colors.white : const Color(0xFF24292F),
      ),
    );
  }
}

class _GithubMarkPainter extends CustomPainter {
  final Color color;

  _GithubMarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.50, 0)
      ..cubicTo(
        size.width * 0.22,
        0,
        0,
        size.height * 0.22,
        0,
        size.height * 0.50,
      )
      ..cubicTo(
        0,
        size.height * 0.73,
        size.width * 0.15,
        size.height * 0.92,
        size.width * 0.36,
        size.height,
      )
      ..cubicTo(
        size.width * 0.38,
        size.height * 0.99,
        size.width * 0.40,
        size.height * 0.97,
        size.width * 0.40,
        size.height * 0.94,
      )
      ..lineTo(size.width * 0.40, size.height * 0.82)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.85,
        size.width * 0.22,
        size.height * 0.75,
        size.width * 0.22,
        size.height * 0.75,
      )
      ..cubicTo(
        size.width * 0.20,
        size.height * 0.68,
        size.width * 0.16,
        size.height * 0.66,
        size.width * 0.16,
        size.height * 0.66,
      )
      ..cubicTo(
        size.width * 0.11,
        size.height * 0.63,
        size.width * 0.17,
        size.height * 0.63,
        size.width * 0.17,
        size.height * 0.63,
      )
      ..cubicTo(
        size.width * 0.23,
        size.height * 0.63,
        size.width * 0.26,
        size.height * 0.69,
        size.width * 0.26,
        size.height * 0.69,
      )
      ..cubicTo(
        size.width * 0.32,
        size.height * 0.79,
        size.width * 0.41,
        size.height * 0.76,
        size.width * 0.44,
        size.height * 0.74,
      )
      ..cubicTo(
        size.width * 0.45,
        size.height * 0.71,
        size.width * 0.47,
        size.height * 0.69,
        size.width * 0.50,
        size.height * 0.68,
      )
      ..cubicTo(
        size.width * 0.37,
        size.height * 0.67,
        size.width * 0.23,
        size.height * 0.62,
        size.width * 0.23,
        size.height * 0.41,
      )
      ..cubicTo(
        size.width * 0.23,
        size.height * 0.35,
        size.width * 0.25,
        size.height * 0.30,
        size.width * 0.29,
        size.height * 0.26,
      )
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.25,
        size.width * 0.26,
        size.height * 0.18,
        size.width * 0.30,
        size.height * 0.10,
      )
      ..cubicTo(
        size.width * 0.30,
        size.height * 0.10,
        size.width * 0.38,
        size.height * 0.08,
        size.width * 0.50,
        size.height * 0.16,
      )
      ..cubicTo(
        size.width * 0.62,
        size.height * 0.13,
        size.width * 0.70,
        size.height * 0.10,
        size.width * 0.70,
        size.height * 0.10,
      )
      ..cubicTo(
        size.width * 0.74,
        size.height * 0.18,
        size.width * 0.72,
        size.height * 0.25,
        size.width * 0.71,
        size.height * 0.26,
      )
      ..cubicTo(
        size.width * 0.75,
        size.height * 0.30,
        size.width * 0.77,
        size.height * 0.35,
        size.width * 0.77,
        size.height * 0.41,
      )
      ..cubicTo(
        size.width * 0.77,
        size.height * 0.62,
        size.width * 0.63,
        size.height * 0.67,
        size.width * 0.50,
        size.height * 0.68,
      )
      ..cubicTo(
        size.width * 0.54,
        size.height * 0.70,
        size.width * 0.57,
        size.height * 0.74,
        size.width * 0.57,
        size.height * 0.80,
      )
      ..lineTo(size.width * 0.57, size.height * 0.94)
      ..cubicTo(
        size.width * 0.57,
        size.height * 0.97,
        size.width * 0.59,
        size.height * 0.99,
        size.width * 0.61,
        size.height,
      )
      ..cubicTo(
        size.width * 0.82,
        size.height * 0.92,
        size.width,
        size.height * 0.73,
        size.width,
        size.height * 0.50,
      )
      ..cubicTo(
        size.width,
        size.height * 0.22,
        size.width * 0.78,
        0,
        size.width * 0.50,
        0,
      )
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _GithubMarkPainter oldDelegate) => oldDelegate.color != color;
}