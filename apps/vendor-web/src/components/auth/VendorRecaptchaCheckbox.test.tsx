import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { StrictMode, useRef, useState, type FormEvent } from 'react'
import { afterEach, describe, expect, test, vi } from 'vitest'

import { vendorBotEvidence, resetEnterpriseLoaderForTests } from '../../lib/recaptcha-enterprise'
import { VendorRecaptchaCheckbox, type VendorRecaptchaCheckboxRef } from './VendorRecaptchaCheckbox'

afterEach(() => {
  delete window.grecaptcha
  document.querySelectorAll('script[data-materyalph-recaptcha]').forEach((script) => script.remove())
  resetEnterpriseLoaderForTests()
  vi.unstubAllEnvs()
  vi.restoreAllMocks()
})

describe('VendorRecaptchaCheckbox lifecycle', () => {
  test('renders once after a delayed provider load in StrictMode and submits the active token', async () => {
    vi.stubEnv('VITE_RECAPTCHA_SITE_KEY', 'test-site')
    const readyCallbacks: Array<() => void> = []
    const reset = vi.fn()
    const renderWidget = vi.fn((_container: HTMLElement, _parameters: Record<string, unknown>) => 17)
    window.grecaptcha = {
      enterprise: {
        ready: (callback) => readyCallbacks.push(callback),
        render: renderWidget,
        reset,
      },
    }
    const submitted = vi.fn()

    function Harness() {
      const [token, setToken] = useState<string | null>(null)
      const checkboxRef = useRef<VendorRecaptchaCheckboxRef>(null)
      const submit = (event: FormEvent<HTMLFormElement>) => {
        event.preventDefault()
        submitted(vendorBotEvidence(token))
      }

      return (
        <form onSubmit={submit}>
          <VendorRecaptchaCheckbox ref={checkboxRef} action="vendor_login" onTokenChange={setToken} />
          <button type="submit">Continue</button>
          <button type="button" onClick={() => checkboxRef.current?.reset()}>Reset</button>
        </form>
      )
    }

    render(<StrictMode><Harness /></StrictMode>)
    expect(readyCallbacks).toHaveLength(2)
    readyCallbacks.forEach((callback) => callback())

    await waitFor(() => expect(renderWidget).toHaveBeenCalledOnce())
    const parameters = renderWidget.mock.calls[0]?.[1] as Record<string, unknown>
    ;(parameters.callback as (token: string) => void)('checkbox-token')
    expect(await screen.findByText('Security checkbox completed.')).toBeVisible()

    fireEvent.click(screen.getByRole('button', { name: 'Continue' }))
    expect(submitted).toHaveBeenCalledWith({ recaptchaToken: 'checkbox-token' })

    ;(parameters['expired-callback'] as () => void)()
    expect(reset).toHaveBeenCalledWith(17)
    await waitFor(() => expect(screen.getByText('Complete the security checkbox to continue.')).toBeVisible())
  })

  test('ignores provider callbacks after unmount', async () => {
    vi.stubEnv('VITE_RECAPTCHA_SITE_KEY', 'test-site')
    const renderWidget = vi.fn((_container: HTMLElement, _parameters: Record<string, unknown>) => 9)
    window.grecaptcha = {
      enterprise: {
        ready: (callback) => callback(),
        render: renderWidget,
        reset: vi.fn(),
      },
    }
    const onTokenChange = vi.fn()
    const view = render(<VendorRecaptchaCheckbox action="vendor_register" onTokenChange={onTokenChange} />)
    await waitFor(() => expect(renderWidget).toHaveBeenCalledOnce())
    const parameters = renderWidget.mock.calls[0]?.[1] as Record<string, unknown>

    view.unmount()
    onTokenChange.mockClear()
    ;(parameters.callback as (token: string) => void)('stale-token')
    ;(parameters['expired-callback'] as () => void)()

    expect(onTokenChange).not.toHaveBeenCalled()
  })
})
