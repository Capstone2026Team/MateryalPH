
# FeeAssessment

Vendor commission liability, separate from buyer processing fees and monthly settlement.

## Properties

Name | Type
------------ | -------------
`id` | string
`orderId` | string
`commissionBasisCentavos` | number
`commissionBasisPoints` | number
`earnedCentavos` | number
`state` | string

## Example

```typescript
import type { FeeAssessment } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "orderId": null,
  "commissionBasisCentavos": null,
  "commissionBasisPoints": null,
  "earnedCentavos": null,
  "state": null,
} satisfies FeeAssessment

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FeeAssessment
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


