# materyalph_api_client.api.SystemApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getApiHealth**](SystemApi.md#getapihealth) | **GET** /health | 


# **getApiHealth**
> HealthEnvelope getApiHealth()



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getSystemApi();

try {
    final response = api.getApiHealth();
    print(response);
} on DioException catch (e) {
    print('Exception when calling SystemApi->getApiHealth: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**HealthEnvelope**](HealthEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

