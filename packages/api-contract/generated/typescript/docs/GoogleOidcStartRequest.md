
# GoogleOidcStartRequest

Vendor/Admin browser Google OIDC start. The WEB transport is selected by the server route.

## Properties

Name | Type
------------ | -------------
`portal` | string
`mode` | string
`mobileE164` | string
`businessName` | string
`termsAccepted` | boolean
`privacyAccepted` | boolean

## Example

```typescript
import type { GoogleOidcStartRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "portal": null,
  "mode": null,
  "mobileE164": null,
  "businessName": null,
  "termsAccepted": null,
  "privacyAccepted": null,
} satisfies GoogleOidcStartRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as GoogleOidcStartRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


