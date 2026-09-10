# materyalph_api_client.model.AuthEnvelopeAllOfData

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**user** | [**UserIdentity**](UserIdentity.md) |  | [optional] 
**sessionId** | **String** |  | [optional] 
**accessToken** | **String** |  | [optional] 
**refreshToken** | **String** |  | [optional] 
**accessExpiresIn** | **int** |  | [optional] 
**refreshExpiresIn** | **int** |  | [optional] 
**mfaSetupRequired** | **bool** |  | [optional] 
**mfaRequired** | **bool** |  | [optional] 
**mfaEnrollmentRequired** | **bool** |  | [optional] 
**challengeExpiresIn** | **int** |  | [optional] 
**recoveryCodes** | **BuiltList&lt;String&gt;** | Present only immediately after enrollment or recovery; store offline because these values are not returned again. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


