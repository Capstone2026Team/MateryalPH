# AuthenticationApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**acceptAdminInvitation**](AuthenticationApi.md#acceptadmininvitation) | **POST** /auth/admin-invitations/accept |  |
| [**completeGoogleOidc**](AuthenticationApi.md#completegoogleoidc) | **GET** /auth/google/callback |  |
| [**completeMfaChallenge**](AuthenticationApi.md#completemfachallenge) | **POST** /auth/mfa/challenge |  |
| [**confirmMfaEnrollment**](AuthenticationApi.md#confirmmfaenrollment) | **POST** /auth/mfa/enrollment/confirm |  |
| [**exchangeBuyerMobileGoogleCode**](AuthenticationApi.md#exchangebuyermobilegooglecode) | **POST** /mobile/auth/google/exchange |  |
| [**getBuyerMobileSession**](AuthenticationApi.md#getbuyermobilesession) | **GET** /mobile/auth/session |  |
| [**getMfaChallengeStatus**](AuthenticationApi.md#getmfachallengestatus) | **GET** /auth/mfa/status |  |
| [**getSession**](AuthenticationApi.md#getsession) | **GET** /auth/session |  |
| [**issueWebCsrfToken**](AuthenticationApi.md#issuewebcsrftoken) | **GET** /auth/csrf |  |
| [**login**](AuthenticationApi.md#loginoperation) | **POST** /auth/login |  |
| [**loginBuyerMobile**](AuthenticationApi.md#loginbuyermobile) | **POST** /mobile/auth/login |  |
| [**logout**](AuthenticationApi.md#logout) | **POST** /auth/logout |  |
| [**logoutBuyerMobile**](AuthenticationApi.md#logoutbuyermobile) | **POST** /mobile/auth/logout |  |
| [**recoverMfaChallenge**](AuthenticationApi.md#recovermfachallenge) | **POST** /auth/mfa/recovery |  |
| [**refreshBuyerMobileSession**](AuthenticationApi.md#refreshbuyermobilesession) | **POST** /mobile/auth/refresh |  |
| [**refreshSession**](AuthenticationApi.md#refreshsession) | **POST** /auth/refresh |  |
| [**registerAccount**](AuthenticationApi.md#registeraccount) | **POST** /auth/register |  |
| [**registerBuyerMobile**](AuthenticationApi.md#registerbuyermobile) | **POST** /mobile/auth/register |  |
| [**requestBuyerMobilePasswordRecovery**](AuthenticationApi.md#requestbuyermobilepasswordrecovery) | **POST** /mobile/auth/password/forgot |  |
| [**requestPasswordRecovery**](AuthenticationApi.md#requestpasswordrecovery) | **POST** /auth/password/forgot |  |
| [**resendBotChallenge**](AuthenticationApi.md#resendbotchallengeoperation) | **POST** /auth/bot-challenges/{challenge_id}/resend |  |
| [**resendBuyerMobileBotChallenge**](AuthenticationApi.md#resendbuyermobilebotchallenge) | **POST** /mobile/auth/bot-challenges/{challenge_id}/resend |  |
| [**resendBuyerMobileEmailVerification**](AuthenticationApi.md#resendbuyermobileemailverification) | **POST** /mobile/auth/verify-email/resend |  |
| [**resendEmailVerification**](AuthenticationApi.md#resendemailverification) | **POST** /auth/verify-email/resend |  |
| [**resetBuyerMobilePassword**](AuthenticationApi.md#resetbuyermobilepassword) | **POST** /mobile/auth/password/reset |  |
| [**resetPassword**](AuthenticationApi.md#resetpassword) | **POST** /auth/password/reset |  |
| [**startBuyerMobileGoogleOidc**](AuthenticationApi.md#startbuyermobilegoogleoidc) | **POST** /mobile/auth/google/start |  |
| [**startGoogleOidc**](AuthenticationApi.md#startgoogleoidc) | **POST** /auth/google/start |  |
| [**startMfaEnrollment**](AuthenticationApi.md#startmfaenrollment) | **POST** /auth/mfa/enrollment |  |
| [**verifyBotChallenge**](AuthenticationApi.md#verifybotchallengeoperation) | **POST** /auth/bot-challenges/{challenge_id}/verify |  |
| [**verifyBuyerMobileBotChallenge**](AuthenticationApi.md#verifybuyermobilebotchallenge) | **POST** /mobile/auth/bot-challenges/{challenge_id}/verify |  |
| [**verifyBuyerMobileEmail**](AuthenticationApi.md#verifybuyermobileemail) | **POST** /mobile/auth/verify-email |  |
| [**verifyEmail**](AuthenticationApi.md#verifyemailoperation) | **POST** /auth/verify-email |  |



## acceptAdminInvitation

> RegistrationEnvelope acceptAdminInvitation(adminInvitationRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { AcceptAdminInvitationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  const body = {
    // AdminInvitationRequest
    adminInvitationRequest: ...,
  } satisfies AcceptAdminInvitationRequest;

  try {
    const data = await api.acceptAdminInvitation(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **adminInvitationRequest** | [AdminInvitationRequest](AdminInvitationRequest.md) |  | |

### Return type

[**RegistrationEnvelope**](RegistrationEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Admin identity created; MFA enrollment is the next required step. |  -  |
| **410** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## completeGoogleOidc

> completeGoogleOidc(state, code)



Browser requests accepting text/html receive a safe branded error page on callback failure. JSON requests retain the canonical error envelope. No callback parameters are reflected into the HTML page.

### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { CompleteGoogleOidcRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new AuthenticationApi();

  const body = {
    // string
    state: state_example,
    // string
    code: code_example,
  } satisfies CompleteGoogleOidcRequest;

  try {
    const data = await api.completeGoogleOidc(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **state** | `string` |  | [Defaults to `undefined`] |
| **code** | `string` |  | [Defaults to `undefined`] |

### Return type

`void` (Empty response body)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `text/html`, `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **302** | Validated OIDC redirect to a web portal with HttpOnly cookies, to the Buyer app with a two-minute one-time exchange code, or to an allowlisted web portal callback with a stable error code for an expected identity/access denial. |  -  |
| **401** | Safe callback failure; HTML for browser navigation and the canonical error envelope for JSON clients. |  -  |
| **403** | Safe callback failure; HTML for browser navigation and the canonical error envelope for JSON clients. |  -  |
| **404** | Safe callback failure; HTML for browser navigation and the canonical error envelope for JSON clients. |  -  |
| **422** | Safe callback failure; HTML for browser navigation and the canonical error envelope for JSON clients. |  -  |
| **503** | Safe callback failure; HTML for browser navigation and the canonical error envelope for JSON clients. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## completeMfaChallenge

> AuthEnvelope completeMfaChallenge(mfaCodeRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { CompleteMfaChallengeRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: mfaChallengeCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  const body = {
    // MfaCodeRequest
    mfaCodeRequest: ...,
  } satisfies CompleteMfaChallengeRequest;

  try {
    const data = await api.completeMfaChallenge(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **mfaCodeRequest** | [MfaCodeRequest](MfaCodeRequest.md) |  | |

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

[mfaChallengeCookie](../README.md#mfaChallengeCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | TOTP verified and Passport session issued. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **429** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## confirmMfaEnrollment

> AuthEnvelope confirmMfaEnrollment(mfaCodeRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { ConfirmMfaEnrollmentRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: mfaChallengeCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  const body = {
    // MfaCodeRequest
    mfaCodeRequest: ...,
  } satisfies ConfirmMfaEnrollmentRequest;

  try {
    const data = await api.confirmMfaEnrollment(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **mfaCodeRequest** | [MfaCodeRequest](MfaCodeRequest.md) |  | |

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

[mfaChallengeCookie](../README.md#mfaChallengeCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | MFA enrolled, Passport session issued, and replacement recovery codes shown once. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **409** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## exchangeBuyerMobileGoogleCode

> AuthEnvelope exchangeBuyerMobileGoogleCode(googleMobileExchangeRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { ExchangeBuyerMobileGoogleCodeRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new AuthenticationApi();

  const body = {
    // GoogleMobileExchangeRequest
    googleMobileExchangeRequest: ...,
  } satisfies ExchangeBuyerMobileGoogleCodeRequest;

  try {
    const data = await api.exchangeBuyerMobileGoogleCode(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **googleMobileExchangeRequest** | [GoogleMobileExchangeRequest](GoogleMobileExchangeRequest.md) |  | |

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | One-time mobile exchange consumed and Passport session returned without browser cookies |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getBuyerMobileSession

> AuthEnvelope getBuyerMobileSession()



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { GetBuyerMobileSessionRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AuthenticationApi(config);

  try {
    const data = await api.getBuyerMobileSession();
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Current Buyer identity from the Bearer token |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getMfaChallengeStatus

> MfaStatusEnvelope getMfaChallengeStatus()



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { GetMfaChallengeStatusRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: mfaChallengeCookie
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  try {
    const data = await api.getMfaChallengeStatus();
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**MfaStatusEnvelope**](MfaStatusEnvelope.md)

### Authorization

[mfaChallengeCookie](../README.md#mfaChallengeCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Current privileged-login MFA requirement. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **429** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getSession

> AuthEnvelope getSession()



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { GetSessionRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  try {
    const data = await api.getSession();
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Current identity. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## issueWebCsrfToken

> CsrfEnvelope issueWebCsrfToken()



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { IssueWebCsrfTokenRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new AuthenticationApi();

  try {
    const data = await api.issueWebCsrfToken();
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**CsrfEnvelope**](CsrfEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Token body plus the non-HttpOnly mp_csrf cookie. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## login

> AuthEnvelope login(loginRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { LoginOperationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  const body = {
    // LoginRequest
    loginRequest: ...,
  } satisfies LoginOperationRequest;

  try {
    const data = await api.login(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **loginRequest** | [LoginRequest](LoginRequest.md) |  | |

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Web receives HttpOnly cookies; privileged web roles receive an MFA challenge cookie before any session is issued. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | The requested auth operation requires a short-lived email risk-verification step. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |
| **429** | Safe structured error with X-Correlation-ID response header. |  -  |
| **503** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## loginBuyerMobile

> AuthEnvelope loginBuyerMobile(buyerMobileLoginRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { LoginBuyerMobileRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new AuthenticationApi();

  const body = {
    // BuyerMobileLoginRequest
    buyerMobileLoginRequest: ...,
  } satisfies LoginBuyerMobileRequest;

  try {
    const data = await api.loginBuyerMobile(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **buyerMobileLoginRequest** | [BuyerMobileLoginRequest](BuyerMobileLoginRequest.md) |  | |

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Native Passport access and refresh tokens returned in the response body; no browser authentication cookie is issued. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | The requested auth operation requires a short-lived email risk-verification step. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |
| **429** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## logout

> SuccessEnvelope logout()



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { LogoutRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  try {
    const data = await api.logout();
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Session revoked and cookies expired. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## logoutBuyerMobile

> SuccessEnvelope logoutBuyerMobile()



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { LogoutBuyerMobileRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AuthenticationApi(config);

  try {
    const data = await api.logoutBuyerMobile();
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Native Passport session revoked without issuing browser cookies |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## recoverMfaChallenge

> AuthEnvelope recoverMfaChallenge(mfaRecoveryRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { RecoverMfaChallengeRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: mfaChallengeCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  const body = {
    // MfaRecoveryRequest
    mfaRecoveryRequest: ...,
  } satisfies RecoverMfaChallengeRequest;

  try {
    const data = await api.recoverMfaChallenge(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **mfaRecoveryRequest** | [MfaRecoveryRequest](MfaRecoveryRequest.md) |  | |

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

[mfaChallengeCookie](../README.md#mfaChallengeCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Single-use recovery code consumed, Passport session issued, and all recovery codes replaced. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **429** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## refreshBuyerMobileSession

> AuthEnvelope refreshBuyerMobileSession(buyerMobileRefreshRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { RefreshBuyerMobileSessionRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new AuthenticationApi();

  const body = {
    // BuyerMobileRefreshRequest
    buyerMobileRefreshRequest: ...,
  } satisfies RefreshBuyerMobileSessionRequest;

  try {
    const data = await api.refreshBuyerMobileSession(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **buyerMobileRefreshRequest** | [BuyerMobileRefreshRequest](BuyerMobileRefreshRequest.md) |  | |

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Native refresh token family rotated and replacement tokens returned in the body |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## refreshSession

> AuthEnvelope refreshSession()



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { RefreshSessionRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  try {
    const data = await api.refreshSession();
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**AuthEnvelope**](AuthEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Refresh token family rotated. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## registerAccount

> RegistrationEnvelope registerAccount(registerRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { RegisterAccountRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  const body = {
    // RegisterRequest
    registerRequest: ...,
  } satisfies RegisterAccountRequest;

  try {
    const data = await api.registerAccount(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **registerRequest** | [RegisterRequest](RegisterRequest.md) |  | |

### Return type

[**RegistrationEnvelope**](RegistrationEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Restricted account; email verification is required. |  -  |
| **409** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | The requested auth operation requires a short-lived email risk-verification step. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |
| **429** | Safe structured error with X-Correlation-ID response header. |  -  |
| **503** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## registerBuyerMobile

> RegistrationEnvelope registerBuyerMobile(buyerMobileRegisterRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { RegisterBuyerMobileRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new AuthenticationApi();

  const body = {
    // BuyerMobileRegisterRequest
    buyerMobileRegisterRequest: ...,
  } satisfies RegisterBuyerMobileRequest;

  try {
    const data = await api.registerBuyerMobile(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **buyerMobileRegisterRequest** | [BuyerMobileRegisterRequest](BuyerMobileRegisterRequest.md) |  | |

### Return type

[**RegistrationEnvelope**](RegistrationEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Restricted Buyer account; email verification is required. |  -  |
| **403** | The requested auth operation requires a short-lived email risk-verification step. |  -  |
| **409** | Safe structured error with X-Correlation-ID response header. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |
| **429** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## requestBuyerMobilePasswordRecovery

> SuccessEnvelope requestBuyerMobilePasswordRecovery(buyerMobilePasswordRecoveryRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { RequestBuyerMobilePasswordRecoveryRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new AuthenticationApi();

  const body = {
    // BuyerMobilePasswordRecoveryRequest
    buyerMobilePasswordRecoveryRequest: ...,
  } satisfies RequestBuyerMobilePasswordRecoveryRequest;

  try {
    const data = await api.requestBuyerMobilePasswordRecovery(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **buyerMobilePasswordRecoveryRequest** | [BuyerMobilePasswordRecoveryRequest](BuyerMobilePasswordRecoveryRequest.md) |  | |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Generic anti-enumeration response |  -  |
| **403** | The requested auth operation requires a short-lived email risk-verification step. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |
| **429** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## requestPasswordRecovery

> SuccessEnvelope requestPasswordRecovery(passwordRecoveryRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { RequestPasswordRecoveryRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  const body = {
    // PasswordRecoveryRequest
    passwordRecoveryRequest: ...,
  } satisfies RequestPasswordRecoveryRequest;

  try {
    const data = await api.requestPasswordRecovery(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **passwordRecoveryRequest** | [PasswordRecoveryRequest](PasswordRecoveryRequest.md) |  | |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Generic anti-enumeration response. |  -  |
| **403** | The requested auth operation requires a short-lived email risk-verification step. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |
| **429** | Safe structured error with X-Correlation-ID response header. |  -  |
| **503** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## resendBotChallenge

> SuccessEnvelope resendBotChallenge(challengeId, resendBotChallengeRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { ResendBotChallengeOperationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  const body = {
    // string
    challengeId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ResendBotChallengeRequest
    resendBotChallengeRequest: ...,
  } satisfies ResendBotChallengeOperationRequest;

  try {
    const data = await api.resendBotChallenge(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **challengeId** | `string` |  | [Defaults to `undefined`] |
| **resendBotChallengeRequest** | [ResendBotChallengeRequest](ResendBotChallengeRequest.md) |  | |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Generic anti-enumeration resend response. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |
| **429** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## resendBuyerMobileBotChallenge

> SuccessEnvelope resendBuyerMobileBotChallenge(challengeId, resendBotChallengeRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { ResendBuyerMobileBotChallengeRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new AuthenticationApi();

  const body = {
    // string
    challengeId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ResendBotChallengeRequest
    resendBotChallengeRequest: ...,
  } satisfies ResendBuyerMobileBotChallengeRequest;

  try {
    const data = await api.resendBuyerMobileBotChallenge(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **challengeId** | `string` |  | [Defaults to `undefined`] |
| **resendBotChallengeRequest** | [ResendBotChallengeRequest](ResendBotChallengeRequest.md) |  | |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Generic anti-enumeration resend response |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |
| **429** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## resendBuyerMobileEmailVerification

> SuccessEnvelope resendBuyerMobileEmailVerification(emailRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { ResendBuyerMobileEmailVerificationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new AuthenticationApi();

  const body = {
    // EmailRequest
    emailRequest: ...,
  } satisfies ResendBuyerMobileEmailVerificationRequest;

  try {
    const data = await api.resendBuyerMobileEmailVerification(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **emailRequest** | [EmailRequest](EmailRequest.md) |  | |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Generic anti-enumeration response |  -  |
| **429** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## resendEmailVerification

> SuccessEnvelope resendEmailVerification(emailRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { ResendEmailVerificationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  const body = {
    // EmailRequest
    emailRequest: ...,
  } satisfies ResendEmailVerificationRequest;

  try {
    const data = await api.resendEmailVerification(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **emailRequest** | [EmailRequest](EmailRequest.md) |  | |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Generic anti-enumeration response. |  -  |
| **429** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## resetBuyerMobilePassword

> SuccessEnvelope resetBuyerMobilePassword(passwordResetRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { ResetBuyerMobilePasswordRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new AuthenticationApi();

  const body = {
    // PasswordResetRequest
    passwordResetRequest: ...,
  } satisfies ResetBuyerMobilePasswordRequest;

  try {
    const data = await api.resetBuyerMobilePassword(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **passwordResetRequest** | [PasswordResetRequest](PasswordResetRequest.md) |  | |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Buyer password changed and prior sessions revoked |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## resetPassword

> SuccessEnvelope resetPassword(passwordResetRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { ResetPasswordRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  const body = {
    // PasswordResetRequest
    passwordResetRequest: ...,
  } satisfies ResetPasswordRequest;

  try {
    const data = await api.resetPassword(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **passwordResetRequest** | [PasswordResetRequest](PasswordResetRequest.md) |  | |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Password changed and prior sessions revoked. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## startBuyerMobileGoogleOidc

> SuccessEnvelope startBuyerMobileGoogleOidc(buyerMobileGoogleOidcStartRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { StartBuyerMobileGoogleOidcRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new AuthenticationApi();

  const body = {
    // BuyerMobileGoogleOidcStartRequest
    buyerMobileGoogleOidcStartRequest: ...,
  } satisfies StartBuyerMobileGoogleOidcRequest;

  try {
    const data = await api.startBuyerMobileGoogleOidc(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **buyerMobileGoogleOidcStartRequest** | [BuyerMobileGoogleOidcStartRequest](BuyerMobileGoogleOidcStartRequest.md) |  | |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Short-lived Buyer authorization URL using PKCE and nonce |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |
| **503** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## startGoogleOidc

> SuccessEnvelope startGoogleOidc(googleOidcStartRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { StartGoogleOidcRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  const body = {
    // GoogleOidcStartRequest
    googleOidcStartRequest: ...,
  } satisfies StartGoogleOidcRequest;

  try {
    const data = await api.startGoogleOidc(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **googleOidcStartRequest** | [GoogleOidcStartRequest](GoogleOidcStartRequest.md) |  | |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Short-lived authorization URL using PKCE and nonce. |  -  |
| **503** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## startMfaEnrollment

> MfaEnrollmentEnvelope startMfaEnrollment()



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { StartMfaEnrollmentRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: mfaChallengeCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  try {
    const data = await api.startMfaEnrollment();
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**MfaEnrollmentEnvelope**](MfaEnrollmentEnvelope.md)

### Authorization

[mfaChallengeCookie](../README.md#mfaChallengeCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | One-time authenticator secret and provisioning URI. The secret is never logged or persisted in plaintext. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **409** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## verifyBotChallenge

> BotProofEnvelope verifyBotChallenge(challengeId, verifyBotChallengeRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { VerifyBotChallengeOperationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  const body = {
    // string
    challengeId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VerifyBotChallengeRequest
    verifyBotChallengeRequest: ...,
  } satisfies VerifyBotChallengeOperationRequest;

  try {
    const data = await api.verifyBotChallenge(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **challengeId** | `string` |  | [Defaults to `undefined`] |
| **verifyBotChallengeRequest** | [VerifyBotChallengeRequest](VerifyBotChallengeRequest.md) |  | |

### Return type

[**BotProofEnvelope**](BotProofEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Vendor risk OTP verified; the proof is returned only in an HttpOnly cookie. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |
| **429** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## verifyBuyerMobileBotChallenge

> BotProofEnvelope verifyBuyerMobileBotChallenge(challengeId, verifyBotChallengeRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { VerifyBuyerMobileBotChallengeRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new AuthenticationApi();

  const body = {
    // string
    challengeId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VerifyBotChallengeRequest
    verifyBotChallengeRequest: ...,
  } satisfies VerifyBuyerMobileBotChallengeRequest;

  try {
    const data = await api.verifyBuyerMobileBotChallenge(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **challengeId** | `string` |  | [Defaults to `undefined`] |
| **verifyBotChallengeRequest** | [VerifyBotChallengeRequest](VerifyBotChallengeRequest.md) |  | |

### Return type

[**BotProofEnvelope**](BotProofEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Buyer email risk OTP verified and one-time proof returned in the response body |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |
| **429** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## verifyBuyerMobileEmail

> SuccessEnvelope verifyBuyerMobileEmail(verifyEmailRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { VerifyBuyerMobileEmailRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new AuthenticationApi();

  const body = {
    // VerifyEmailRequest
    verifyEmailRequest: ...,
  } satisfies VerifyBuyerMobileEmailRequest;

  try {
    const data = await api.verifyBuyerMobileEmail(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **verifyEmailRequest** | [VerifyEmailRequest](VerifyEmailRequest.md) |  | |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Buyer email ownership verified |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## verifyEmail

> SuccessEnvelope verifyEmail(verifyEmailRequest)



### Example

```ts
import {
  Configuration,
  AuthenticationApi,
} from '@materyalph/api-client-ts';
import type { VerifyEmailOperationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AuthenticationApi(config);

  const body = {
    // VerifyEmailRequest
    verifyEmailRequest: ...,
  } satisfies VerifyEmailOperationRequest;

  try {
    const data = await api.verifyEmail(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **verifyEmailRequest** | [VerifyEmailRequest](VerifyEmailRequest.md) |  | |

### Return type

[**SuccessEnvelope**](SuccessEnvelope.md)

### Authorization

[webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Email ownership verified. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

