
# BuyerMobileRegisterRequest

Buyer-native registration. The BUYER/MOBILE transport is selected by the server route and contains no CAPTCHA evidence.

## Properties

Name | Type
------------ | -------------
`fullName` | string
`email` | string
`mobileE164` | string
`password` | string
`passwordConfirmation` | string
`buyerType` | string
`companyName` | string
`termsAccepted` | boolean
`privacyAccepted` | boolean
`riskProofToken` | string

## Example

```typescript
import type { BuyerMobileRegisterRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "fullName": null,
  "email": null,
  "mobileE164": null,
  "password": null,
  "passwordConfirmation": null,
  "buyerType": null,
  "companyName": null,
  "termsAccepted": null,
  "privacyAccepted": null,
  "riskProofToken": null,
} satisfies BuyerMobileRegisterRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerMobileRegisterRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


