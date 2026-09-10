
# MaterialPriceObservation

Public Tier 2 ordinary listing observation; never transaction-price evidence.

## Properties

Name | Type
------------ | -------------
`id` | string
`runId` | string
`environment` | string
`datasetId` | string
`vendorId` | string
`listingVariantId` | string
`comparableGroupVersionId` | string
`observedAt` | Date
`localSnapshotDate` | Date
`ordinaryPayableCentavos` | number
`normalizedPhpPrice` | string
`eligibilityVersion` | string

## Example

```typescript
import type { MaterialPriceObservation } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "runId": null,
  "environment": null,
  "datasetId": null,
  "vendorId": null,
  "listingVariantId": null,
  "comparableGroupVersionId": null,
  "observedAt": null,
  "localSnapshotDate": null,
  "ordinaryPayableCentavos": null,
  "normalizedPhpPrice": null,
  "eligibilityVersion": null,
} satisfies MaterialPriceObservation

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as MaterialPriceObservation
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


