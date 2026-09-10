
# BuyerMobilePasswordRecoveryRequest

Buyer-native password recovery. The BUYER/MOBILE transport is selected by the server route and contains no CAPTCHA evidence.

## Properties

Name | Type
------------ | -------------
`email` | string
`riskProofToken` | string

## Example

```typescript
import type { BuyerMobilePasswordRecoveryRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "email": null,
  "riskProofToken": null,
} satisfies BuyerMobilePasswordRecoveryRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerMobilePasswordRecoveryRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


