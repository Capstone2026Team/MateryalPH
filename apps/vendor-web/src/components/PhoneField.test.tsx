import { PhoneField } from '@materyalph/web-ui'
import { fireEvent, render, screen } from '@testing-library/react'
import { expect, test } from 'vitest'

function setup() {
  const view = render(<form><PhoneField name="mobile" required /></form>)
  return {
    number: screen.getByRole('textbox', { name: /Mobile number/ }),
    country: screen.getByRole('combobox', { name: 'Mobile number country code' }),
    submitted: () => new FormData(view.container.querySelector('form')!).get('mobile'),
  }
}

test('defaults to Philippines with an empty number and normalizes local entry', () => {
  const { number, country, submitted } = setup()
  expect(country).toHaveValue('PH')
  expect(number).toHaveValue('')
  expect(number).toBeInvalid()
  fireEvent.change(number, { target: { value: '0917 123 4567' } })
  expect(submitted()).toBe('+639171234567')
  expect(number).toBeValid()
  fireEvent.change(number, { target: { value: '' } })
  expect(submitted()).toBe('')
  expect(country).toHaveValue('PH')
})

test('changing country retains national entry and updates submitted calling code', () => {
  const { number, country, submitted } = setup()
  fireEvent.change(number, { target: { value: '91234567' } })
  fireEvent.change(country, { target: { value: 'SG' } })
  expect(number).toHaveValue('91234567')
  expect(submitted()).toBe('+6591234567')
})

test('international paste separates the prefix and selects the main shared-code country', () => {
  const { number, country, submitted } = setup()
  fireEvent.change(number, { target: { value: '+1 (415) 555-0123' } })
  expect(country).toHaveValue('US')
  expect(number).toHaveValue('4155550123')
  expect(submitted()).toBe('+14155550123')
  fireEvent.change(country, { target: { value: 'CA' } })
  fireEvent.change(number, { target: { value: '+1 416 555 0123' } })
  expect(country).toHaveValue('CA')
})

test('invalid prefixes and letters do not silently become a different contact number', () => {
  const { number, submitted } = setup()
  for (const value of ['+999123456789', '917abc1234567', '9171234567890123456']) {
    fireEvent.change(number, { target: { value } })
    expect(number).toBeInvalid()
    if (value.includes('+') || value.includes('abc')) expect(submitted()).toBe('')
  }
})
