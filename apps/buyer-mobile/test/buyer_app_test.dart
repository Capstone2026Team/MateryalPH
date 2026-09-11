import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/auth/auth_repository.dart';
import 'package:materyalph/auth/deep_link_source.dart';
import 'package:materyalph/auth/token_store.dart';
import 'package:materyalph/main.dart';
import 'package:materyalph/onboarding/onboarding_repository.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  for (final size in const [
    Size(320, 568),
    Size(375, 667),
    Size(390, 844),
    Size(844, 390),
    Size(768, 1024),
  ]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('onboarding reflows at $size with text scale $scale', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(size);
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(() {
          tester.platformDispatcher.clearTextScaleFactorTestValue();
          return tester.binding.setSurfaceSize(null);
        });
        await tester.pumpWidget(
          BuyerApp(
            authRepository: AuthRepository(tokenStore: _MemoryTokenStore()),
            onboardingRepository: _MemoryOnboardingRepository(),
            deepLinkSource: _MemoryDeepLinkSource(),
          ),
        );
        await tester.pumpAndSettle();
        for (var page = 1; page <= 3; page++) {
          expect(tester.takeException(), isNull);
          expect(
            find.bySemanticsLabel('Onboarding page $page of 3'),
            findsOneWidget,
          );
          final action = find.text(page == 3 ? 'Get Started' : 'Next');
          await tester.ensureVisible(action);
          await tester.tap(action);
          await tester.pumpAndSettle();
        }
        expect(find.textContaining('Welcome to'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }

  test(
    'stored tokens do not create an authenticated session while offline',
    () async {
      final tokenStore = _MemoryTokenStore()
        ..tokens = const AuthTokens(
          accessToken: 'stored-access-token',
          refreshToken: 'stored-refresh-token',
        );
      final client = MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.invalid')),
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) => handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
                error: const SocketException('offline'),
              ),
            ),
          ),
        ],
      );

      final restored = await AuthRepository(
        tokenStore: tokenStore,
        apiClient: client,
      ).restoreSession();

      expect(restored, isFalse);
      expect(tokenStore.tokens, isNotNull);
    },
  );

  testWidgets(
    'failed cold-start Google exchange shows a safe message on Welcome',
    (tester) async {
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
      await tester.pumpWidget(
        BuyerApp(
          authRepository: AuthRepository(
            tokenStore: _MemoryTokenStore(),
            apiClient: MateryalphApiClient(dio: dio),
          ),
          onboardingRepository: _MemoryOnboardingRepository(complete: true),
          deepLinkSource: _MemoryDeepLinkSource(
            Uri.parse('materyalph://auth/callback?exchange_code=test-exchange'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Welcome to'), findsOneWidget);
      expect(
        find.textContaining('Use a different Google account'),
        findsOneWidget,
      );
      expect(find.textContaining('private provider detail'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('first unauthenticated launch opens three-step onboarding', (
    tester,
  ) async {
    final onboarding = _MemoryOnboardingRepository();
    await tester.pumpWidget(
      BuyerApp(
        authRepository: AuthRepository(tokenStore: _MemoryTokenStore()),
        onboardingRepository: onboarding,
        deepLinkSource: _MemoryDeepLinkSource(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Source Smart, Build Fast'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    expect(find.bySemanticsLabel('Onboarding page 1 of 3'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Find Suppliers Near Your Site'), findsOneWidget);
    expect(find.bySemanticsLabel('Onboarding page 2 of 3'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Plan Every Phase, Track Every Peso'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(onboarding.completeValue, isTrue);
    expect(find.textContaining('Welcome to'), findsOneWidget);
  });

  testWidgets('Skip completes onboarding from the first page', (tester) async {
    final onboarding = _MemoryOnboardingRepository();
    await tester.pumpWidget(
      BuyerApp(
        authRepository: AuthRepository(tokenStore: _MemoryTokenStore()),
        onboardingRepository: onboarding,
        deepLinkSource: _MemoryDeepLinkSource(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(onboarding.completeValue, isTrue);
    expect(find.textContaining('Welcome to'), findsOneWidget);
  });

  testWidgets('returning unauthenticated launch opens Welcome', (tester) async {
    await tester.pumpWidget(
      BuyerApp(
        authRepository: AuthRepository(tokenStore: _MemoryTokenStore()),
        onboardingRepository: _MemoryOnboardingRepository(complete: true),
        deepLinkSource: _MemoryDeepLinkSource(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Welcome to'), findsOneWidget);
    expect(find.text('Create buyer account'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
  });

  testWidgets('Welcome actions open Buyer login and registration', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      BuyerApp(
        authRepository: AuthRepository(tokenStore: _MemoryTokenStore()),
        onboardingRepository: _MemoryOnboardingRepository(complete: true),
        deepLinkSource: _MemoryDeepLinkSource(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Already have an account? Sign in'));
    await tester.tap(find.text('Already have an account? Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Login to your account'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.textContaining('security check'), findsNothing);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Create buyer account'));
    await tester.tap(find.text('Create buyer account'));
    await tester.pumpAndSettle();
    expect(find.text('Start sourcing with confidence'), findsOneWidget);
    expect(find.text('Sign up with Google'), findsOneWidget);
  });

  testWidgets('onboarding reflows on a compact 375 by 667 surface', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(375, 667));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      BuyerApp(
        authRepository: AuthRepository(tokenStore: _MemoryTokenStore()),
        onboardingRepository: _MemoryOnboardingRepository(),
        deepLinkSource: _MemoryDeepLinkSource(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Source Smart, Build Fast'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

final class _MemoryDeepLinkSource implements DeepLinkSource {
  _MemoryDeepLinkSource([this.initialLink]);
  final Uri? initialLink;
  @override
  Future<Uri?> getInitialLink() async => initialLink;

  @override
  Stream<Uri> get links => const Stream.empty();
}

final class _MemoryTokenStore implements TokenStore {
  AuthTokens? tokens;

  @override
  Future<void> clear() async => tokens = null;

  @override
  Future<AuthTokens?> read() async => tokens;

  @override
  Future<void> write(AuthTokens value) async => tokens = value;
}

final class _MemoryOnboardingRepository implements OnboardingRepository {
  _MemoryOnboardingRepository({bool complete = false})
    : completeValue = complete;

  bool completeValue;

  @override
  Future<void> complete() async => completeValue = true;

  @override
  Future<bool> isComplete() async => completeValue;
}
