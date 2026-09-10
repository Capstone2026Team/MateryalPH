
# BotStepUpErrorEnvelope


## Properties

Name | Type
------------ | -------------
`data` | object
`meta` | { [key: string]: any; }
`errors` | [Array&lt;BotStepUpErrorEnvelopeAllOfErrors&gt;](BotStepUpErrorEnvelopeAllOfErrors.md)

## Example

```typescript
import type { BotStepUpErrorEnvelope } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "data": null,
  "meta": null,
  "errors": null,
} satisfies BotStepUpErrorEnvelope

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BotStepUpErrorEnvelope
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


