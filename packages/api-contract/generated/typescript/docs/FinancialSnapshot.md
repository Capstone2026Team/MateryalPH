
# FinancialSnapshot

Immutable FIN money snapshot; every amount is integer centavos.

## Properties

Name | Type
------------ | -------------
`id` | string
`orderId` | string
`environment` | string
`materialsGrossCentavos` | number
`vendorDiscountCentavos` | number
`materialsVatCentavos` | number
`deliveryCentavos` | number
`processingFeeCentavos` | number
`nrpcCentavos` | number
`buyerTotalCentavos` | number
`calculationHash` | string

## Example

```typescript
import type { FinancialSnapshot } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "orderId": null,
  "environment": null,
  "materialsGrossCentavos": null,
  "vendorDiscountCentavos": null,
  "materialsVatCentavos": null,
  "deliveryCentavos": null,
  "processingFeeCentavos": null,
  "nrpcCentavos": null,
  "buyerTotalCentavos": null,
  "calculationHash": null,
} satisfies FinancialSnapshot

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FinancialSnapshot
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


