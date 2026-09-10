
# BuyerMobileGoogleOidcStartRequest

Buyer-native Google OIDC start. The BUYER/MOBILE transport is selected by the server route.

## Properties

Name | Type
------------ | -------------
`mode` | string
`mobileE164` | string
`buyerType` | string
`companyName` | string
`termsAccepted` | boolean
`privacyAccepted` | boolean

## Example

```typescript
import type { BuyerMobileGoogleOidcStartRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "mode": null,
  "mobileE164": null,
  "buyerType": null,
  "companyName": null,
  "termsAccepted": null,
  "privacyAccepted": null,
} satisfies BuyerMobileGoogleOidcStartRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerMobileGoogleOidcStartRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


