
# RegisterRequest

Vendor web registration. The WEB transport is selected by the server route.

## Properties

Name | Type
------------ | -------------
`fullName` | string
`email` | string
`mobileE164` | string
`password` | string
`passwordConfirmation` | string
`businessName` | string
`termsAccepted` | boolean
`privacyAccepted` | boolean
`botProtection` | [VendorBotProtectionEvidence](VendorBotProtectionEvidence.md)

## Example

```typescript
import type { RegisterRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "fullName": null,
  "email": null,
  "mobileE164": null,
  "password": null,
  "passwordConfirmation": null,
  "businessName": null,
  "termsAccepted": null,
  "privacyAccepted": null,
  "botProtection": null,
} satisfies RegisterRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as RegisterRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


