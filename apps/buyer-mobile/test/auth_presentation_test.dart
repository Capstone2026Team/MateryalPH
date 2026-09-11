import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/auth/auth_repository.dart';
import 'package:materyalph/auth/token_store.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/screens/buyer_home_screen.dart';
import 'package:materyalph/screens/login_screen.dart';
import 'package:materyalph/screens/password_recovery_screen.dart';
import 'package:materyalph/screens/register_screen.dart';
import 'package:materyalph/screens/verify_email_screen.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(430, 932),
  ]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'account forms reflow at $size, text $scale and open keyboard',
        (tester) async {
          await tester.binding.setSurfaceSize(size);
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(() {
            tester.platformDispatcher.clearTextScaleFactorTestValue();
            return tester.binding.setSurfaceSize(null);
          });
          final repository = AuthRepository(tokenStore: _MemoryTokens());
          final screens = [
            LoginScreen(
              authRepository: repository,
              onAuthenticated: () {},
              onRegister: () {},
              onForgotPassword: () {},
              onBack: () {},
            ),
            RegisterScreen(
              authRepository: repository,
              onVerificationRequired: (_) {},
              onGoogleRegister: () {},
              onLogin: () {},
              onBack: () {},
            ),
            VerifyEmailScreen(
              email: 'buyer@example.test',
              authRepository: repository,
              onVerified: () {},
              onBack: () {},
            ),
            PasswordRecoveryScreen(
              authRepository: repository,
              onComplete: () {},
              onBack: () {},
            ),
          ];
          for (final screen in screens) {
            await tester.pumpWidget(
              MaterialApp(
                theme: BuyerTheme.light,
                home: MediaQuery(
                  data: MediaQueryData(
                    size: size,
                    textScaler: TextScaler.linear(scale),
                    viewInsets: const EdgeInsets.only(bottom: 240),
                  ),
                  child: screen,
                ),
              ),
            );
            await tester.pump();
            expect(tester.takeException(), isNull);
            final submit = find.byType(FilledButton).last;
            await tester.ensureVisible(submit);
            await tester.pump();
            expect(submit.hitTestable(), findsOneWidget);
            expect(tester.getSize(submit).height, greaterThanOrEqualTo(48));
            await tester.pumpWidget(const SizedBox());
          }
        },
      );
    }
  }

  testWidgets('password visibility retains entry and has a named control', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: LoginScreen(
          authRepository: AuthRepository(tokenStore: _MemoryTokens()),
          onAuthenticated: () {},
          onRegister: () {},
          onForgotPassword: () {},
          onBack: () {},
        ),
      ),
    );
    final password = find.byType(TextFormField).last;
    await tester.enterText(password, 'ExamplePassword123');
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(find.byTooltip('Hide password'), findsOneWidget);
    expect(
      tester.widget<EditableText>(find.byType(EditableText).last).obscureText,
      isFalse,
    );
    expect(
      tester
          .widget<EditableText>(find.byType(EditableText).last)
          .controller
          .text,
      'ExamplePassword123',
    );
  });

  testWidgets('failed logout keeps account visible and offers retry', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: BuyerHomeScreen(
          onSignOut: () async => throw Exception('private server detail'),
        ),
      ),
    );
    await tester.tap(find.byTooltip('Sign out'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Sign-out could not finish'), findsOneWidget);
    expect(find.text('Buyer account connected'), findsOneWidget);
    expect(find.textContaining('private server detail'), findsNothing);
    expect(
      tester.widget<IconButton>(find.byType(IconButton).first).onPressed,
      isNotNull,
    );
  });

  test(
    'Google exchange maps account isolation without exposing provider message',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.invalid'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) => handler.reject(
            DioException(
              requestOptions: options,
              response: Response(
                requestOptions: options,
                statusCode: 403,
                data: {
                  'errors': [
                    {
                      'code': 'PORTAL_ACCESS_DENIED',
                      'message': 'private provider detail',
                    },
                  ],
                },
              ),
            ),
          ),
        ),
      );
      final repository = AuthRepository(
        tokenStore: _MemoryTokens(),
        apiClient: MateryalphApiClient(dio: dio),
      );
      await expectLater(
        repository.exchangeGoogleMobileCode('test-exchange'),
        throwsA(
          isA<BuyerAuthException>().having(
            (error) => error.message,
            'safe guidance',
            contains('Use a different Google account'),
          ),
        ),
      );
    },
  );
}

class _MemoryTokens implements TokenStore {
  @override
  Future<AuthTokens?> read() async => null;
  @override
  Future<void> write(AuthTokens value) async {}
  @override
  Future<void> clear() async {}
}
