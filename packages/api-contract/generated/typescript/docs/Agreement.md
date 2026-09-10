
# Agreement


## Properties

Name | Type
------------ | -------------
`id` | string
`code` | string
`title` | string
`audience` | string
`version` | number
`contentUri` | string
`effectiveAt` | Date

## Example

```typescript
import type { Agreement } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "code": null,
  "title": null,
  "audience": null,
  "version": null,
  "contentUri": null,
  "effectiveAt": null,
} satisfies Agreement

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as Agreement
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


