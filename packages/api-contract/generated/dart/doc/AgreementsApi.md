# materyalph_api_client.api.AgreementsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**listCurrentAgreements**](AgreementsApi.md#listcurrentagreements) | **GET** /agreements/current | 


# **listCurrentAgreements**
> AgreementListEnvelope listCurrentAgreements()



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getAgreementsApi();

try {
    final response = api.listCurrentAgreements();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AgreementsApi->listCurrentAgreements: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AgreementListEnvelope**](AgreementListEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

