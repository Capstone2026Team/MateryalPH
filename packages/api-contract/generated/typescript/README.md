# @materyalph/api-client-ts@1.0.0-phase.1

A TypeScript SDK client for the localhost API.

## Usage

First, install the SDK from npm.

```bash
npm install @materyalph/api-client-ts --save
```

Next, try it out.


```ts
import {
  Configuration,
  AgreementsApi,
} from '@materyalph/api-client-ts';
import type { ListCurrentAgreementsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new AgreementsApi();

  try {
    const data = await api.listCurrentAgreements();
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```


## Documentation

### API Endpoints

All URIs are relative to */api/v1*

| Class | Method | HTTP request | Description
| ----- | ------ | ------------ | -------------
*AgreementsApi* | [**listCurrentAgreements**](docs/AgreementsApi.md#listcurrentagreements) | **GET** /agreements/current | 
*AuthenticationApi* | [**acceptAdminInvitation**](docs/AuthenticationApi.md#acceptadmininvitation) | **POST** /auth/admin-invitations/accept | 
*AuthenticationApi* | [**completeGoogleOidc**](docs/AuthenticationApi.md#completegoogleoidc) | **GET** /auth/google/callback | 
*AuthenticationApi* | [**completeMfaChallenge**](docs/AuthenticationApi.md#completemfachallenge) | **POST** /auth/mfa/challenge | 
*AuthenticationApi* | [**confirmMfaEnrollment**](docs/AuthenticationApi.md#confirmmfaenrollment) | **POST** /auth/mfa/enrollment/confirm | 
*AuthenticationApi* | [**exchangeBuyerMobileGoogleCode**](docs/AuthenticationApi.md#exchangebuyermobilegooglecode) | **POST** /mobile/auth/google/exchange | 
*AuthenticationApi* | [**getBuyerMobileSession**](docs/AuthenticationApi.md#getbuyermobilesession) | **GET** /mobile/auth/session | 
*AuthenticationApi* | [**getMfaChallengeStatus**](docs/AuthenticationApi.md#getmfachallengestatus) | **GET** /auth/mfa/status | 
*AuthenticationApi* | [**getSession**](docs/AuthenticationApi.md#getsession) | **GET** /auth/session | 
*AuthenticationApi* | [**issueWebCsrfToken**](docs/AuthenticationApi.md#issuewebcsrftoken) | **GET** /auth/csrf | 
*AuthenticationApi* | [**login**](docs/AuthenticationApi.md#loginoperation) | **POST** /auth/login | 
*AuthenticationApi* | [**loginBuyerMobile**](docs/AuthenticationApi.md#loginbuyermobile) | **POST** /mobile/auth/login | 
*AuthenticationApi* | [**logout**](docs/AuthenticationApi.md#logout) | **POST** /auth/logout | 
*AuthenticationApi* | [**logoutBuyerMobile**](docs/AuthenticationApi.md#logoutbuyermobile) | **POST** /mobile/auth/logout | 
*AuthenticationApi* | [**recoverMfaChallenge**](docs/AuthenticationApi.md#recovermfachallenge) | **POST** /auth/mfa/recovery | 
*AuthenticationApi* | [**refreshBuyerMobileSession**](docs/AuthenticationApi.md#refreshbuyermobilesession) | **POST** /mobile/auth/refresh | 
*AuthenticationApi* | [**refreshSession**](docs/AuthenticationApi.md#refreshsession) | **POST** /auth/refresh | 
*AuthenticationApi* | [**registerAccount**](docs/AuthenticationApi.md#registeraccount) | **POST** /auth/register | 
*AuthenticationApi* | [**registerBuyerMobile**](docs/AuthenticationApi.md#registerbuyermobile) | **POST** /mobile/auth/register | 
*AuthenticationApi* | [**requestBuyerMobilePasswordRecovery**](docs/AuthenticationApi.md#requestbuyermobilepasswordrecovery) | **POST** /mobile/auth/password/forgot | 
*AuthenticationApi* | [**requestPasswordRecovery**](docs/AuthenticationApi.md#requestpasswordrecovery) | **POST** /auth/password/forgot | 
*AuthenticationApi* | [**resendBotChallenge**](docs/AuthenticationApi.md#resendbotchallengeoperation) | **POST** /auth/bot-challenges/{challenge_id}/resend | 
*AuthenticationApi* | [**resendBuyerMobileBotChallenge**](docs/AuthenticationApi.md#resendbuyermobilebotchallenge) | **POST** /mobile/auth/bot-challenges/{challenge_id}/resend | 
*AuthenticationApi* | [**resendBuyerMobileEmailVerification**](docs/AuthenticationApi.md#resendbuyermobileemailverification) | **POST** /mobile/auth/verify-email/resend | 
*AuthenticationApi* | [**resendEmailVerification**](docs/AuthenticationApi.md#resendemailverification) | **POST** /auth/verify-email/resend | 
*AuthenticationApi* | [**resetBuyerMobilePassword**](docs/AuthenticationApi.md#resetbuyermobilepassword) | **POST** /mobile/auth/password/reset | 
*AuthenticationApi* | [**resetPassword**](docs/AuthenticationApi.md#resetpassword) | **POST** /auth/password/reset | 
*AuthenticationApi* | [**startBuyerMobileGoogleOidc**](docs/AuthenticationApi.md#startbuyermobilegoogleoidc) | **POST** /mobile/auth/google/start | 
*AuthenticationApi* | [**startGoogleOidc**](docs/AuthenticationApi.md#startgoogleoidc) | **POST** /auth/google/start | 
*AuthenticationApi* | [**startMfaEnrollment**](docs/AuthenticationApi.md#startmfaenrollment) | **POST** /auth/mfa/enrollment | 
*AuthenticationApi* | [**verifyBotChallenge**](docs/AuthenticationApi.md#verifybotchallengeoperation) | **POST** /auth/bot-challenges/{challenge_id}/verify | 
*AuthenticationApi* | [**verifyBuyerMobileBotChallenge**](docs/AuthenticationApi.md#verifybuyermobilebotchallenge) | **POST** /mobile/auth/bot-challenges/{challenge_id}/verify | 
*AuthenticationApi* | [**verifyBuyerMobileEmail**](docs/AuthenticationApi.md#verifybuyermobileemail) | **POST** /mobile/auth/verify-email | 
*AuthenticationApi* | [**verifyEmail**](docs/AuthenticationApi.md#verifyemailoperation) | **POST** /auth/verify-email | 
*SystemApi* | [**getApiHealth**](docs/SystemApi.md#getapihealth) | **GET** /health | 


### Models

- [AccountType](docs/AccountType.md)
- [AdminInvitationRequest](docs/AdminInvitationRequest.md)
- [Agreement](docs/Agreement.md)
- [AgreementListEnvelope](docs/AgreementListEnvelope.md)
- [ApiError](docs/ApiError.md)
- [AuthEnvelope](docs/AuthEnvelope.md)
- [AuthEnvelopeAllOfData](docs/AuthEnvelopeAllOfData.md)
- [BotProofEnvelope](docs/BotProofEnvelope.md)
- [BotProofEnvelopeAllOfData](docs/BotProofEnvelopeAllOfData.md)
- [BotStepUpErrorEnvelope](docs/BotStepUpErrorEnvelope.md)
- [BotStepUpErrorEnvelopeAllOfErrors](docs/BotStepUpErrorEnvelopeAllOfErrors.md)
- [BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails](docs/BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails.md)
- [BuyerMobileGoogleOidcStartRequest](docs/BuyerMobileGoogleOidcStartRequest.md)
- [BuyerMobileLoginRequest](docs/BuyerMobileLoginRequest.md)
- [BuyerMobilePasswordRecoveryRequest](docs/BuyerMobilePasswordRecoveryRequest.md)
- [BuyerMobileRefreshRequest](docs/BuyerMobileRefreshRequest.md)
- [BuyerMobileRegisterRequest](docs/BuyerMobileRegisterRequest.md)
- [CsrfEnvelope](docs/CsrfEnvelope.md)
- [CsrfEnvelopeAllOfData](docs/CsrfEnvelopeAllOfData.md)
- [EmailRequest](docs/EmailRequest.md)
- [ErrorEnvelope](docs/ErrorEnvelope.md)
- [FeeAssessment](docs/FeeAssessment.md)
- [FinancialSnapshot](docs/FinancialSnapshot.md)
- [GoogleMobileExchangeRequest](docs/GoogleMobileExchangeRequest.md)
- [GoogleOidcStartRequest](docs/GoogleOidcStartRequest.md)
- [HealthEnvelope](docs/HealthEnvelope.md)
- [HealthEnvelopeAllOfData](docs/HealthEnvelopeAllOfData.md)
- [LoginRequest](docs/LoginRequest.md)
- [MaterialPriceObservation](docs/MaterialPriceObservation.md)
- [MfaCodeRequest](docs/MfaCodeRequest.md)
- [MfaEnrollmentEnvelope](docs/MfaEnrollmentEnvelope.md)
- [MfaEnrollmentEnvelopeAllOfData](docs/MfaEnrollmentEnvelopeAllOfData.md)
- [MfaRecoveryRequest](docs/MfaRecoveryRequest.md)
- [MfaStatusEnvelope](docs/MfaStatusEnvelope.md)
- [MfaStatusEnvelopeAllOfData](docs/MfaStatusEnvelopeAllOfData.md)
- [PasswordRecoveryRequest](docs/PasswordRecoveryRequest.md)
- [PasswordResetRequest](docs/PasswordResetRequest.md)
- [RegisterRequest](docs/RegisterRequest.md)
- [RegistrationEnvelope](docs/RegistrationEnvelope.md)
- [RegistrationEnvelopeAllOfData](docs/RegistrationEnvelopeAllOfData.md)
- [ResendBotChallengeRequest](docs/ResendBotChallengeRequest.md)
- [SuccessEnvelope](docs/SuccessEnvelope.md)
- [UserIdentity](docs/UserIdentity.md)
- [VendorBotProtectionEvidence](docs/VendorBotProtectionEvidence.md)
- [VerifyBotChallengeRequest](docs/VerifyBotChallengeRequest.md)
- [VerifyEmailRequest](docs/VerifyEmailRequest.md)

### Authorization


Authentication schemes defined for the API:
<a id="passportBearer"></a>
#### passportBearer


- **Type**: HTTP Bearer Token authentication (JWT)
<a id="accessCookie"></a>
#### accessCookie


- **Type**: API key
- **API key parameter name**: `mp_access`
- **Location**: 
<a id="mfaChallengeCookie"></a>
#### mfaChallengeCookie


- **Type**: API key
- **API key parameter name**: `mp_mfa_challenge`
- **Location**: 
<a id="botProofCookie"></a>
#### botProofCookie


- **Type**: API key
- **API key parameter name**: `mp_bot_proof`
- **Location**: 
<a id="webCsrf"></a>
#### webCsrf


- **Type**: API key
- **API key parameter name**: `X-CSRF-Token`
- **Location**: HTTP header

## About

This TypeScript SDK client supports the [Fetch API](https://fetch.spec.whatwg.org/)
and is automatically generated by the
[OpenAPI Generator](https://openapi-generator.tech) project:

- API version: `1.0.0-phase.1`
- Package version: `1.0.0-phase.1`
- Generator version: `7.25.0`
- Build package: `org.openapitools.codegen.languages.TypeScriptFetchClientCodegen`

The generated npm module supports the following:

- Environments
  * Node.js
  * Webpack
  * Browserify
- Language levels
  * ES5 - you must have a Promises/A+ library installed
  * ES6
- Module systems
  * CommonJS
  * ES6 module system


## Development

### Building

To build the TypeScript source code, you need to have Node.js and npm installed.
After cloning the repository, navigate to the project directory and run:

```bash
npm install
npm run build
```

### Publishing

Once you've built the package, you can publish it to npm:

```bash
npm publish
```

## License

[]()
