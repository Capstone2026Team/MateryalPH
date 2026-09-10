
# AuthEnvelopeAllOfData


## Properties

Name | Type
------------ | -------------
`user` | [UserIdentity](UserIdentity.md)
`sessionId` | string
`accessToken` | string
`refreshToken` | string
`accessExpiresIn` | number
`refreshExpiresIn` | number
`mfaSetupRequired` | boolean
`mfaRequired` | boolean
`mfaEnrollmentRequired` | boolean
`challengeExpiresIn` | number
`recoveryCodes` | Array&lt;string&gt;

## Example

```typescript
import type { AuthEnvelopeAllOfData } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "user": null,
  "sessionId": null,
  "accessToken": null,
  "refreshToken": null,
  "accessExpiresIn": null,
  "refreshExpiresIn": null,
  "mfaSetupRequired": null,
  "mfaRequired": null,
  "mfaEnrollmentRequired": null,
  "challengeExpiresIn": null,
  "recoveryCodes": null,
} satisfies AuthEnvelopeAllOfData

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AuthEnvelopeAllOfData
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


