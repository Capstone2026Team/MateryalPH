import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:dio/dio.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

import 'token_store.dart';

final class AuthRepository {
  AuthRepository({
    required TokenStore tokenStore,
    MateryalphApiClient? apiClient,
  }) : _tokenStore = tokenStore,
       _client =
           apiClient ??
           MateryalphApiClient(
             basePathOverride: const String.fromEnvironment(
               'API_BASE_URL',
               defaultValue: 'http://10.0.2.2:8080/api/v1',
             ),
           );

  final TokenStore _tokenStore;
  final MateryalphApiClient _client;

  AuthenticationApi get _authentication => _client.getAuthenticationApi();

  Future<bool> restoreSession() async {
    final tokens = await _tokenStore.read();
    if (tokens == null) {
      return false;
    }

    _client.setBearerAuth('passportBearer', tokens.accessToken);
    try {
      await _authentication.getBuyerMobileSession();
      return true;
    } on DioException catch (error) {
      return error.response?.statusCode == 401
          ? _refresh(tokens.refreshToken)
          : false;
    } catch (_) {
      // Fail closed when the server cannot validate a stored session. The
      // encrypted tokens remain available for a later online revalidation.
      return false;
    }
  }

  Future<void> login({
    required String email,
    required String password,
    String? proof,
  }) async {
    try {
      final response = await _authentication.loginBuyerMobile(
        buyerMobileLoginRequest: BuyerMobileLoginRequest(
          (builder) => builder
            ..email = email.trim().toLowerCase()
            ..password = password
            ..riskProofToken = proof,
        ),
      );
      await _saveTokens(response.data?.data);
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error));
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String mobileE164,
    required String password,
    required String buyerType,
    String? companyName,
    String? proof,
  }) async {
    try {
      await _authentication.registerBuyerMobile(
        buyerMobileRegisterRequest: BuyerMobileRegisterRequest(
          (builder) => builder
            ..fullName = fullName.trim()
            ..riskProofToken = proof
            ..email = email.trim().toLowerCase()
            ..mobileE164 = mobileE164.trim()
            ..password = password
            ..passwordConfirmation = password
            ..buyerType = buyerType
            ..companyName = companyName?.trim()
            ..termsAccepted = BuyerMobileRegisterRequestTermsAcceptedEnum.true_
            ..privacyAccepted =
                BuyerMobileRegisterRequestPrivacyAcceptedEnum.true_,
        ),
      );
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error));
    }
  }

  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      await _authentication.verifyBuyerMobileEmail(
        verifyEmailRequest: VerifyEmailRequest(
          (builder) => builder
            ..email = email.trim().toLowerCase()
            ..code = code,
        ),
      );
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error));
    }
  }

  Future<void> resendVerification(String email) async {
    try {
      await _authentication.resendBuyerMobileEmailVerification(
        emailRequest: EmailRequest(
          (builder) => builder.email = email.trim().toLowerCase(),
        ),
      );
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error));
    }
  }

  Future<Uri> startGoogleSignIn({
    bool signUp = false,
    String? mobileE164,
    String? buyerType,
    String? companyName,
    bool termsAccepted = false,
    bool privacyAccepted = false,
  }) async {
    try {
      final response = await _authentication.startBuyerMobileGoogleOidc(
        buyerMobileGoogleOidcStartRequest: BuyerMobileGoogleOidcStartRequest(
          (builder) => builder
            ..mode = signUp
                ? BuyerMobileGoogleOidcStartRequestModeEnum.SIGN_UP
                : BuyerMobileGoogleOidcStartRequestModeEnum.SIGN_IN
            ..mobileE164 = mobileE164?.trim()
            ..buyerType = buyerType
            ..companyName = companyName?.trim()
            ..termsAccepted = termsAccepted
            ..privacyAccepted = privacyAccepted,
        ),
      );
      final value = response.data?.data['authorization_url']?.value;
      final uri = value is String ? Uri.tryParse(value) : null;
      if (uri == null || uri.scheme != 'https') {
        throw const BuyerAuthException(
          'Google sign-in could not be opened safely.',
        );
      }
      return uri;
    } on BuyerAuthException {
      rethrow;
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error, google: true));
    }
  }

  Future<void> exchangeGoogleMobileCode(String exchangeCode) async {
    try {
      final response = await _authentication.exchangeBuyerMobileGoogleCode(
        googleMobileExchangeRequest: GoogleMobileExchangeRequest(
          (builder) => builder.exchangeCode = exchangeCode,
        ),
      );
      await _saveTokens(response.data?.data);
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error, google: true));
    }
  }

  Future<void> requestPasswordRecovery(String email, {String? proof}) async {
    try {
      await _authentication.requestBuyerMobilePasswordRecovery(
        buyerMobilePasswordRecoveryRequest: BuyerMobilePasswordRecoveryRequest(
          (builder) => builder
            ..email = email.trim().toLowerCase()
            ..riskProofToken = proof,
        ),
      );
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    try {
      await _authentication.resetBuyerMobilePassword(
        passwordResetRequest: PasswordResetRequest(
          (builder) => builder
            ..email = email.trim().toLowerCase()
            ..code = code
            ..password = password
            ..passwordConfirmation = password,
        ),
      );
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error));
    }
  }

  Future<void> logout() async {
    try {
      await _authentication.logoutBuyerMobile();
    } catch (_) {
      // Local sign-out must remain available when the network is unavailable.
    } finally {
      _client.removeBearerAuth('passportBearer');
      await _tokenStore.clear();
    }
  }

  Future<String> verifyRiskChallenge(
    BuyerRiskChallenge challenge,
    String email,
    String code,
  ) async {
    try {
      final response = await _authentication.verifyBuyerMobileBotChallenge(
        challengeId: challenge.id,
        verifyBotChallengeRequest: VerifyBotChallengeRequest(
          (b) => b
            ..email = email.trim().toLowerCase()
            ..code = code,
        ),
      );
      final token = response.data?.data['step_up_token']?.value;
      if (token is! String || token.isEmpty) {
        throw const BuyerAuthException(
          'Verification did not complete. Please try again.',
        );
      }
      return token;
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error));
    }
  }

  Future<void> resendRiskChallenge(
    BuyerRiskChallenge challenge,
    String email,
  ) async {
    try {
      await _authentication.resendBuyerMobileBotChallenge(
        challengeId: challenge.id,
        resendBotChallengeRequest: ResendBotChallengeRequest(
          (b) => b.email = email.trim().toLowerCase(),
        ),
      );
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error));
    }
  }

  Future<bool> _refresh(String refreshToken) async {
    try {
      final response = await _authentication.refreshBuyerMobileSession(
        buyerMobileRefreshRequest: BuyerMobileRefreshRequest(
          (builder) => builder.refreshToken = refreshToken,
        ),
      );
      await _saveTokens(response.data?.data);
      return true;
    } catch (_) {
      _client.removeBearerAuth('passportBearer');
      await _tokenStore.clear();
      return false;
    }
  }

  Future<void> _saveTokens(BuiltMap<String, JsonObject?>? data) async {
    final accessToken = data?['access_token']?.value;
    final refreshToken = data?['refresh_token']?.value;
    if (accessToken is! String || refreshToken is! String) {
      throw const BuyerAuthException(
        'The server returned an incomplete session. Please try again.',
      );
    }

    await _tokenStore.write(
      AuthTokens(accessToken: accessToken, refreshToken: refreshToken),
    );
    _client.setBearerAuth('passportBearer', accessToken);
  }

  String _messageFrom(DioException error, {bool google = false}) {
    final body = error.response?.data;
    if (body is Map<String, dynamic>) {
      final errors = body['errors'];
      if (errors is List && errors.isNotEmpty) {
        final first = errors.first;
        if (first is Map &&
            first['code'] == 'BOT_STEP_UP_REQUIRED' &&
            first['details'] is Map) {
          final details = first['details'] as Map;
          final id = details['challenge_id'];
          final expiry = details['expires_at'];
          final resend = details['resend_after_seconds'];
          if (id is String && expiry is String && resend is int) {
            throw BuyerRiskChallenge(id, expiry, resend);
          }
        }
        if (google && first is Map) {
          const messages = {
            'PORTAL_ACCESS_DENIED':
                'This Google account belongs to another MateryalPH account type. Use a different Google account for Buyer access.',
            'ACCOUNT_NOT_FOUND':
                'No Buyer account is linked to this Google account. Create a Buyer account or choose a different Google account.',
            'OIDC_STATE_INVALID':
                'This Google sign-in request expired. Start sign-in again.',
            'OIDC_EXCHANGE_CODE_INVALID':
                'This Google sign-in request expired. Start sign-in again.',
            'OIDC_KEYS_UNAVAILABLE':
                'Google sign-in is temporarily unavailable. Try again shortly or use email sign-in.',
            'OIDC_NOT_CONFIGURED':
                'Google sign-in is currently unavailable. Use email sign-in to continue.',
          };
          return messages[first['code']] ??
              'Google sign-in could not finish. Try again or use email sign-in.';
        }
        if (first is Map && first['message'] is String) {
          return first['message'] as String;
        }
      }
    }

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'MateryalPH is unavailable right now. Check your connection and try again.';
    }

    return 'We could not complete that request. Please try again.';
  }
}

final class BuyerRiskChallenge extends BuyerAuthException {
  const BuyerRiskChallenge(this.id, this.expiresAt, this.resendAfterSeconds)
    : super(
        'Confirm this request using the risk-verification code from your email.',
      );
  final String id;
  final String expiresAt;
  final int resendAfterSeconds;
}

class BuyerAuthException implements Exception {
  const BuyerAuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
