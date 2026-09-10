
# AdminInvitationRequest


## Properties

Name | Type
------------ | -------------
`token` | string
`fullName` | string
`password` | string
`passwordConfirmation` | string
`termsAccepted` | boolean
`privacyAccepted` | boolean

## Example

```typescript
import type { AdminInvitationRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "token": null,
  "fullName": null,
  "password": null,
  "passwordConfirmation": null,
  "termsAccepted": null,
  "privacyAccepted": null,
} satisfies AdminInvitationRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminInvitationRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


