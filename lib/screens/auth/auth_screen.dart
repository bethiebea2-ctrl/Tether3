import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/app_build_info.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  bool _signUp = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final auth = context.read<AuthProvider>();
    final err = _signUp
        ? await auth.signUp(
            email: _email.text,
            password: _password.text,
            displayName: _name.text,
          )
        : await auth.signIn(
            email: _email.text,
            password: _password.text,
          );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = err;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BethColours.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Tether', style: BethTypography.heading?.copyWith(fontSize: 32)),
                  const SizedBox(height: 4),
                  Text(
                    AppBuildInfo.fullLabel,
                    style: BethTypography.caption?.copyWith(
                      color: BethColours.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _signUp
                        ? 'Create your account to connect your household.'
                        : 'Welcome back. Sign in to continue.',
                    style: BethTypography.bodySmall?.copyWith(color: BethColours.textMuted),
                  ),
                  const SizedBox(height: 24),
                  if (_signUp)
                    TextField(
                      controller: _name,
                      decoration: const InputDecoration(
                        labelText: 'Display name',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  if (_signUp) const SizedBox(height: 12),
                  TextField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _password,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    onSubmitted: (_) => _busy ? null : _submit(),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ],
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _busy ? null : _submit,
                    child: _busy
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_signUp ? 'Create account' : 'Sign in'),
                  ),
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () => setState(() {
                              _signUp = !_signUp;
                              _error = null;
                            }),
                    child: Text(_signUp ? 'Already have an account? Sign in' : 'New here? Create account'),
                  ),
                  const SizedBox(height: 16),
                  Builder(
                    builder: (context) {
                      final hint = context.watch<AuthProvider>().webSessionHint;
                      if (hint == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          hint,
                          style: BethTypography.caption?.copyWith(color: BethColours.textMuted),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  Text(
                    'Phase 2A uses local-only credentials until a cloud backend is chosen.',
                    style: BethTypography.caption?.copyWith(color: BethColours.textMuted),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
