import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AuthenticationApi
void main() {
  final instance = MateryalphApiClient().getAuthenticationApi();

  group(AuthenticationApi, () {
    //Future<RegistrationEnvelope> acceptAdminInvitation(AdminInvitationRequest adminInvitationRequest) async
    test('test acceptAdminInvitation', () async {
      // TODO
    });

    // Browser requests accepting text/html receive a safe branded error page on callback failure. JSON requests retain the canonical error envelope. No callback parameters are reflected into the HTML page.
    //
    //Future completeGoogleOidc(String state, String code) async
    test('test completeGoogleOidc', () async {
      // TODO
    });

    //Future<AuthEnvelope> completeMfaChallenge(MfaCodeRequest mfaCodeRequest) async
    test('test completeMfaChallenge', () async {
      // TODO
    });

    //Future<AuthEnvelope> confirmMfaEnrollment(MfaCodeRequest mfaCodeRequest) async
    test('test confirmMfaEnrollment', () async {
      // TODO
    });

    //Future<AuthEnvelope> exchangeBuyerMobileGoogleCode(GoogleMobileExchangeRequest googleMobileExchangeRequest) async
    test('test exchangeBuyerMobileGoogleCode', () async {
      // TODO
    });

    //Future<AuthEnvelope> getBuyerMobileSession() async
    test('test getBuyerMobileSession', () async {
      // TODO
    });

    //Future<MfaStatusEnvelope> getMfaChallengeStatus() async
    test('test getMfaChallengeStatus', () async {
      // TODO
    });

    //Future<AuthEnvelope> getSession() async
    test('test getSession', () async {
      // TODO
    });

    //Future<CsrfEnvelope> issueWebCsrfToken() async
    test('test issueWebCsrfToken', () async {
      // TODO
    });

    //Future<AuthEnvelope> login(LoginRequest loginRequest) async
    test('test login', () async {
      // TODO
    });

    //Future<AuthEnvelope> loginBuyerMobile(BuyerMobileLoginRequest buyerMobileLoginRequest) async
    test('test loginBuyerMobile', () async {
      // TODO
    });

    //Future<SuccessEnvelope> logout() async
    test('test logout', () async {
      // TODO
    });

    //Future<SuccessEnvelope> logoutBuyerMobile() async
    test('test logoutBuyerMobile', () async {
      // TODO
    });

    //Future<AuthEnvelope> recoverMfaChallenge(MfaRecoveryRequest mfaRecoveryRequest) async
    test('test recoverMfaChallenge', () async {
      // TODO
    });

    //Future<AuthEnvelope> refreshBuyerMobileSession(BuyerMobileRefreshRequest buyerMobileRefreshRequest) async
    test('test refreshBuyerMobileSession', () async {
      // TODO
    });

    //Future<AuthEnvelope> refreshSession() async
    test('test refreshSession', () async {
      // TODO
    });

    //Future<RegistrationEnvelope> registerAccount(RegisterRequest registerRequest) async
    test('test registerAccount', () async {
      // TODO
    });

    //Future<RegistrationEnvelope> registerBuyerMobile(BuyerMobileRegisterRequest buyerMobileRegisterRequest) async
    test('test registerBuyerMobile', () async {
      // TODO
    });

    //Future<SuccessEnvelope> requestBuyerMobilePasswordRecovery(BuyerMobilePasswordRecoveryRequest buyerMobilePasswordRecoveryRequest) async
    test('test requestBuyerMobilePasswordRecovery', () async {
      // TODO
    });

    //Future<SuccessEnvelope> requestPasswordRecovery(PasswordRecoveryRequest passwordRecoveryRequest) async
    test('test requestPasswordRecovery', () async {
      // TODO
    });

    //Future<SuccessEnvelope> resendBotChallenge(String challengeId, ResendBotChallengeRequest resendBotChallengeRequest) async
    test('test resendBotChallenge', () async {
      // TODO
    });

    //Future<SuccessEnvelope> resendBuyerMobileBotChallenge(String challengeId, ResendBotChallengeRequest resendBotChallengeRequest) async
    test('test resendBuyerMobileBotChallenge', () async {
      // TODO
    });

    //Future<SuccessEnvelope> resendBuyerMobileEmailVerification(EmailRequest emailRequest) async
    test('test resendBuyerMobileEmailVerification', () async {
      // TODO
    });

    //Future<SuccessEnvelope> resendEmailVerification(EmailRequest emailRequest) async
    test('test resendEmailVerification', () async {
      // TODO
    });

    //Future<SuccessEnvelope> resetBuyerMobilePassword(PasswordResetRequest passwordResetRequest) async
    test('test resetBuyerMobilePassword', () async {
      // TODO
    });

    //Future<SuccessEnvelope> resetPassword(PasswordResetRequest passwordResetRequest) async
    test('test resetPassword', () async {
      // TODO
    });

    //Future<SuccessEnvelope> startBuyerMobileGoogleOidc(BuyerMobileGoogleOidcStartRequest buyerMobileGoogleOidcStartRequest) async
    test('test startBuyerMobileGoogleOidc', () async {
      // TODO
    });

    //Future<SuccessEnvelope> startGoogleOidc(GoogleOidcStartRequest googleOidcStartRequest) async
    test('test startGoogleOidc', () async {
      // TODO
    });

    //Future<MfaEnrollmentEnvelope> startMfaEnrollment() async
    test('test startMfaEnrollment', () async {
      // TODO
    });

    //Future<BotProofEnvelope> verifyBotChallenge(String challengeId, VerifyBotChallengeRequest verifyBotChallengeRequest) async
    test('test verifyBotChallenge', () async {
      // TODO
    });

    //Future<BotProofEnvelope> verifyBuyerMobileBotChallenge(String challengeId, VerifyBotChallengeRequest verifyBotChallengeRequest) async
    test('test verifyBuyerMobileBotChallenge', () async {
      // TODO
    });

    //Future<SuccessEnvelope> verifyBuyerMobileEmail(VerifyEmailRequest verifyEmailRequest) async
    test('test verifyBuyerMobileEmail', () async {
      // TODO
    });

    //Future<SuccessEnvelope> verifyEmail(VerifyEmailRequest verifyEmailRequest) async
    test('test verifyEmail', () async {
      // TODO
    });

  });
}
