
# MfaEnrollmentEnvelope


## Properties

Name | Type
------------ | -------------
`data` | [MfaEnrollmentEnvelopeAllOfData](MfaEnrollmentEnvelopeAllOfData.md)
`meta` | { [key: string]: any; }
`errors` | Array&lt;any&gt;

## Example

```typescript
import type { MfaEnrollmentEnvelope } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "data": null,
  "meta": null,
  "errors": null,
} satisfies MfaEnrollmentEnvelope

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as MfaEnrollmentEnvelope
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


