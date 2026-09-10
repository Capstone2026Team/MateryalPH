import { afterEach, describe, expect, test, vi } from 'vitest'
import {
  renderVendorCheckbox,
  resetEnterpriseLoaderForTests,
  vendorBotEvidence,
  webCookieBotEvidence,
} from './recaptcha-enterprise'

afterEach(() => {
  delete window.grecaptcha
  document.querySelectorAll('script[data-materyalph-recaptcha]').forEach((script) => script.remove())
  resetEnterpriseLoaderForTests()
  vi.unstubAllEnvs()
  vi.restoreAllMocks()
})

describe('Enterprise checkbox evidence', () => {
  test('renders an explicit action-bound checkbox and clears its token on reset', async () => {
    vi.stubEnv('VITE_RECAPTCHA_SITE_KEY', 'test-site')
    const reset = vi.fn()
    const render = vi.fn((_container: HTMLElement, _value: Record<string, unknown>) => {
      return 7
    })
    window.grecaptcha = { enterprise: { ready: (callback) => callback(), render, reset } }
    const onToken = vi.fn()
    const handle = await renderVendorCheckbox(document.createElement('div'), 'vendor_login', {
      onToken,
      onError: vi.fn(),
    })

    const parameters = render.mock.calls[0]?.[1] as Record<string, unknown>
    expect(render).toHaveBeenCalledOnce()
    expect(parameters).toMatchObject({ sitekey: 'test-site', action: 'vendor_login' })
    ;(parameters.callback as (token: string) => void)('checkbox-token')
    expect(onToken).toHaveBeenLastCalledWith('checkbox-token')

    handle.reset()
    expect(reset).toHaveBeenCalledWith(7)
    expect(onToken).toHaveBeenLastCalledWith(null)
  })

  test('expiration and provider errors reset and clear the checkbox', async () => {
    vi.stubEnv('VITE_RECAPTCHA_SITE_KEY', 'test-site')
    const reset = vi.fn()
    const render = vi.fn((_container: HTMLElement, _value: Record<string, unknown>) => {
      return 3
    })
    window.grecaptcha = {
      enterprise: {
        ready: (callback) => callback(),
        render,
        reset,
      },
    }
    const onToken = vi.fn()
    const onError = vi.fn()
    await renderVendorCheckbox(document.createElement('div'), 'vendor_register', { onToken, onError })

    const parameters = render.mock.calls[0]?.[1] as Record<string, unknown>
    ;(parameters['expired-callback'] as () => void)()
    expect(reset).toHaveBeenLastCalledWith(3)
    expect(onToken).toHaveBeenLastCalledWith(null)

    ;(parameters['error-callback'] as () => void)()
    expect(reset).toHaveBeenCalledTimes(2)
    expect(onError).toHaveBeenCalledOnce()
  })

  test('requires a checkbox token unless the accessible fallback is selected', () => {
    expect(vendorBotEvidence('checkbox-token')).toEqual({ recaptchaToken: 'checkbox-token' })
    expect(vendorBotEvidence(null, true)).toEqual({ requestEmailStepUp: true })
    expect(() => vendorBotEvidence(null)).toThrow('Complete the security checkbox')
    expect(webCookieBotEvidence()).toEqual({})
  })
})
