# AgreementsApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**listCurrentAgreements**](AgreementsApi.md#listcurrentagreements) | **GET** /agreements/current |  |



## listCurrentAgreements

> AgreementListEnvelope listCurrentAgreements()



### Example

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

### Parameters

This endpoint does not need any parameter.

### Return type

[**AgreementListEnvelope**](AgreementListEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Effective agreement metadata. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

