
# MfaStatusEnvelopeAllOfData


## Properties

Name | Type
------------ | -------------
`mfaRequired` | boolean
`mfaEnrollmentRequired` | boolean

## Example

```typescript
import type { MfaStatusEnvelopeAllOfData } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "mfaRequired": null,
  "mfaEnrollmentRequired": null,
} satisfies MfaStatusEnvelopeAllOfData

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as MfaStatusEnvelopeAllOfData
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


