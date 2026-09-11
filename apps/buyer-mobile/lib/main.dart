import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'auth/auth_repository.dart';
import 'auth/deep_link_source.dart';
import 'auth/token_store.dart';
import 'design_system/theme.dart';
import 'onboarding/onboarding_repository.dart';
import 'screens/buyer_home_screen.dart';
import 'screens/google_signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/password_recovery_screen.dart';
import 'screens/register_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/verify_email_screen.dart';
import 'screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BuyerApp());
}

class BuyerApp extends StatefulWidget {
  const BuyerApp({
    super.key,
    this.authRepository,
    this.onboardingRepository,
    this.deepLinkSource,
  });

  final AuthRepository? authRepository;
  final OnboardingRepository? onboardingRepository;
  final DeepLinkSource? deepLinkSource;

  @override
  State<BuyerApp> createState() => _BuyerAppState();
}

enum _AppStage {
  splash,
  onboarding,
  welcome,
  login,
  register,
  googleSignup,
  verifyEmail,
  passwordRecovery,
  home,
}

class _BuyerAppState extends State<BuyerApp> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  late final AuthRepository _authRepository;
  late final OnboardingRepository _onboardingRepository;
  late final DeepLinkSource _deepLinkSource;
  StreamSubscription<Uri>? _linkSubscription;
  _AppStage _stage = _AppStage.splash;
  String _verificationEmail = '';
  String? _lastExchangeCode;

  @override
  void initState() {
    super.initState();
    _authRepository =
        widget.authRepository ?? AuthRepository(tokenStore: SecureTokenStore());
    _onboardingRepository =
        widget.onboardingRepository ?? SharedPreferencesOnboardingRepository();
    _deepLinkSource = widget.deepLinkSource ?? AppLinksDeepLinkSource();
    _linkSubscription = _deepLinkSource.links.listen(_handleDeepLink);
    _bootstrap();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final initialLink = await _deepLinkSource.getInitialLink();
    if (initialLink != null && _isOidcCallback(initialLink)) {
      await _handleDeepLink(initialLink);
      return;
    }

    final results = await Future.wait([
      _authRepository.restoreSession(),
      _onboardingRepository.isComplete(),
    ]);
    if (!mounted) return;
    final authenticated = results[0];
    final onboardingComplete = results[1];
    setState(() {
      _stage = authenticated
          ? _AppStage.home
          : onboardingComplete
          ? _AppStage.welcome
          : _AppStage.onboarding;
    });
  }

  Future<void> _completeOnboarding() async {
    await _onboardingRepository.complete();
    if (mounted) setState(() => _stage = _AppStage.welcome);
  }

  Future<void> _signOut() async {
    await _authRepository.logout();
    if (mounted) setState(() => _stage = _AppStage.welcome);
  }

  Future<void> _startGoogleSignIn(
    BuildContext context, {
    bool signUp = false,
    String? mobileE164,
    String? buyerType,
    String? companyName,
  }) async {
    try {
      final authorizationUri = await _authRepository.startGoogleSignIn(
        signUp: signUp,
        mobileE164: mobileE164,
        buyerType: buyerType,
        companyName: companyName,
        termsAccepted: signUp,
        privacyAccepted: signUp,
      );
      final opened = await launchUrl(
        authorizationUri,
        mode: LaunchMode.externalApplication,
      );
      if (!opened && context.mounted) {
        _showMessage(context, 'Google sign-in could not be opened.');
      }
    } on BuyerAuthException catch (error) {
      if (context.mounted) _showMessage(context, error.message);
    } catch (_) {
      if (context.mounted) {
        _showMessage(
          context,
          'Google sign-in could not be opened. Try again or use email sign-in.',
        );
      }
    }
  }

  bool _isOidcCallback(Uri uri) =>
      uri.scheme == 'materyalph' &&
      uri.host == 'auth' &&
      uri.path == '/callback' &&
      uri.queryParameters.containsKey('exchange_code');

  Future<void> _handleDeepLink(Uri uri) async {
    if (!_isOidcCallback(uri)) return;
    final code = uri.queryParameters['exchange_code'];
    if (code == null || code == _lastExchangeCode) return;
    _lastExchangeCode = code;
    if (mounted) setState(() => _stage = _AppStage.splash);
    try {
      await _authRepository.exchangeGoogleMobileCode(code);
      if (mounted) setState(() => _stage = _AppStage.home);
    } on BuyerAuthException catch (error) {
      if (!mounted) return;
      setState(() => _stage = _AppStage.welcome);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showMessage(context, error.message);
      });
    }
  }

  void _showMessage(BuildContext context, String message) {
    _messengerKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messengerKey,
      title: 'MateryalPH Buyer',
      debugShowCheckedModeBanner: false,
      theme: BuyerTheme.light,
      home: Builder(
        builder: (context) {
          final reduceMotion = MediaQuery.disableAnimationsOf(context);
          return AnimatedSwitcher(
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 180),
            child: KeyedSubtree(
              key: ValueKey(_stage),
              child: _screenForStage(context),
            ),
          );
        },
      ),
    );
  }

  Widget _screenForStage(BuildContext context) {
    switch (_stage) {
      case _AppStage.splash:
        return const SplashScreen();
      case _AppStage.onboarding:
        return OnboardingScreen(onComplete: _completeOnboarding);
      case _AppStage.welcome:
        return WelcomeScreen(
          onLogin: () => setState(() => _stage = _AppStage.login),
          onRegister: () => setState(() => _stage = _AppStage.register),
          onGoogle: () => _startGoogleSignIn(context),
        );
      case _AppStage.login:
        return LoginScreen(
          onGoogle: () => _startGoogleSignIn(context),
          authRepository: _authRepository,
          onAuthenticated: () => setState(() => _stage = _AppStage.home),
          onRegister: () => setState(() => _stage = _AppStage.register),
          onForgotPassword: () =>
              setState(() => _stage = _AppStage.passwordRecovery),
          onBack: () => setState(() => _stage = _AppStage.welcome),
        );
      case _AppStage.register:
        return RegisterScreen(
          authRepository: _authRepository,
          onVerificationRequired: (email) => setState(() {
            _verificationEmail = email;
            _stage = _AppStage.verifyEmail;
          }),
          onGoogleRegister: () =>
              setState(() => _stage = _AppStage.googleSignup),
          onLogin: () => setState(() => _stage = _AppStage.login),
          onBack: () => setState(() => _stage = _AppStage.welcome),
        );
      case _AppStage.googleSignup:
        return GoogleSignupScreen(
          onStart:
              ({
                required String mobileE164,
                required String buyerType,
                String? companyName,
              }) => _startGoogleSignIn(
                context,
                signUp: true,
                mobileE164: mobileE164,
                buyerType: buyerType,
                companyName: companyName,
              ),
          onBack: () => setState(() => _stage = _AppStage.register),
        );
      case _AppStage.verifyEmail:
        return VerifyEmailScreen(
          email: _verificationEmail,
          authRepository: _authRepository,
          onVerified: () => setState(() => _stage = _AppStage.login),
          onBack: () => setState(() => _stage = _AppStage.register),
        );
      case _AppStage.passwordRecovery:
        return PasswordRecoveryScreen(
          authRepository: _authRepository,
          onComplete: () => setState(() => _stage = _AppStage.login),
          onBack: () => setState(() => _stage = _AppStage.login),
        );
      case _AppStage.home:
        return BuyerHomeScreen(onSignOut: _signOut);
    }
  }
}
