
# PasswordRecoveryRequest

Vendor/Admin browser password recovery. The WEB transport is selected by the server route.

## Properties

Name | Type
------------ | -------------
`email` | string
`portal` | string
`botProtection` | [VendorBotProtectionEvidence](VendorBotProtectionEvidence.md)

## Example

```typescript
import type { PasswordRecoveryRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "email": null,
  "portal": null,
  "botProtection": null,
} satisfies PasswordRecoveryRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PasswordRecoveryRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


