
# VendorBotProtectionEvidence

Vendor web only. Supply a checkbox token or explicitly request the accessible email fallback. After successful email risk verification, an empty object is permitted because the one-time proof is carried in the HttpOnly mp_bot_proof cookie.

## Properties

Name | Type
------------ | -------------
`recaptchaToken` | string
`requestEmailStepUp` | boolean

## Example

```typescript
import type { VendorBotProtectionEvidence } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "recaptchaToken": null,
  "requestEmailStepUp": null,
} satisfies VendorBotProtectionEvidence

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorBotProtectionEvidence
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


