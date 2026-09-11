import { useId, useState } from 'react'

import { phoneCountries } from './phone-countries'

export interface PhoneFieldProps {
  id?: string
  name: string
  label?: string
  error?: string
  required?: boolean
  disabled?: boolean
  onChange?: (value: string) => void
}

/** Submits one E.164 value while keeping the calling code out of editable text. */
export function PhoneField({ id: suppliedId, name, label = 'Mobile number', error, required, disabled, onChange }: PhoneFieldProps) {
  const generatedId = useId()
  const id = suppliedId ?? generatedId
  const [region, setRegion] = useState('PH')
  const [number, setNumber] = useState('')
  const [inputError, setInputError] = useState<string>()
  const country = phoneCountries.find(item => item.region === region)!
  const national = region === 'PH' && /^09\d{9}$/.test(number) ? number.slice(1) : number
  const value = national && !inputError ? `+${country.callingCode}${national}` : ''
  const control = 'min-h-12 min-w-0 w-full rounded-control border bg-surface-primary px-3 text-base font-normal text-text-strong focus:border-focus-ring focus:ring-2 focus:ring-focus-ring/20 disabled:opacity-50'

  function update(raw: string) {
    let invalid = /[^0-9+\s().-]/.test(raw) || /.+\+/.test(raw.trim())
    let nextCountry = country
    let digits = raw.replace(/[^0-9]/g, '')
    if (raw.trim().startsWith('+')) {
      const matching = phoneCountries.filter(item => digits.startsWith(item.callingCode))
        .sort((a, b) => b.callingCode.length - a.callingCode.length)
      nextCountry = matching.find(item => item.region === region) ?? matching.find(item => item.mainCountry) ?? matching[0] ?? country
      if (!matching.length) invalid = true
      if (matching.length) {
        digits = digits.slice(nextCountry.callingCode.length)
        setRegion(nextCountry.region)
      }
    }
    setNumber(invalid ? raw : digits)
    setInputError(invalid ? 'Choose a country code and enter a valid mobile number.' : undefined)
    const normalized = nextCountry.region === 'PH' && /^09\d{9}$/.test(digits) ? digits.slice(1) : digits
    onChange?.(normalized && !invalid ? `+${nextCountry.callingCode}${normalized}` : '')
  }

  return <div className="grid gap-2 text-sm font-semibold text-text-strong">
    <label htmlFor={id}>{label} {required && <span className="text-status-error" aria-hidden="true">*</span>}</label>
    <div className="grid grid-cols-1 sm:grid-cols-[minmax(0,1fr)_minmax(0,1.3fr)] gap-2">
      <select aria-label={`${label} country code`} autoComplete="tel-country-code" className={`${control} border-border-default`} disabled={disabled} value={region} onChange={event => {
        const next = phoneCountries.find(item => item.region === event.target.value)!
        setRegion(next.region)
        onChange?.(number && !inputError ? `+${next.callingCode}${next.region === 'PH' && /^09\d{9}$/.test(number) ? number.slice(1) : number}` : '')
      }}>
        {phoneCountries.map(item => <option key={item.region} value={item.region}>+{item.callingCode} · {item.name}</option>)}
      </select>
      <input id={id} type="tel" inputMode="tel" autoComplete="tel-national" className={`${control} ${error || inputError ? 'border-status-error' : 'border-border-default'}`} placeholder={region === 'PH' ? '917 123 4567' : 'Mobile number'} value={number} onChange={event => update(event.target.value)} required={required} disabled={disabled} pattern={`[0-9]{${Math.max(1, 8 - country.callingCode.length)},${15 - country.callingCode.length}}`} aria-describedby={`${id}-description`} aria-invalid={Boolean(error || inputError)} />
    </div>
    <input type="hidden" name={name} value={value} disabled={disabled} />
    <span id={`${id}-description`} className={`text-sm font-normal ${error || inputError ? 'text-status-error' : 'text-text-secondary'}`} role={error || inputError ? 'alert' : undefined}>{error ?? inputError ?? (region === 'PH' ? 'Enter your number without +63. A leading 0 is accepted.' : 'Enter your number without the country code.')}</span>
  </div>
}
