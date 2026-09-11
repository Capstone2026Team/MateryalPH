import { ResponseError } from '@materyalph/api-client-ts'
import { act, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { afterEach, beforeEach, describe, expect, test, vi } from 'vitest'

import App from './App'
import * as authApi from './lib/auth-api'
import { resetEnterpriseLoaderForTests } from './lib/recaptcha-enterprise'

vi.mock('./lib/auth-api', async (importOriginal) => {
  const actual = await importOriginal<typeof import('./lib/auth-api')>()
  return { ...actual, registerVendor: vi.fn(), signIn: vi.fn() }
})

describe('Vendor public portal', () => {
  beforeEach(() => {
    window.history.replaceState({}, '', '/')
    vi.mocked(authApi.registerVendor).mockReset()
    vi.mocked(authApi.signIn).mockReset()
  })

  afterEach(() => {
    delete window.grecaptcha
    resetEnterpriseLoaderForTests()
    vi.unstubAllEnvs()
    vi.restoreAllMocks()
  })

  test('renders the approved opportunity, verification, and fee disclosures', () => {
    render(<App />)

    expect(screen.getByRole('heading', { name: 'Build your store’s next chapter.' })).toBeVisible()
    fireEvent.click(screen.getByText('What does Vendor verification provide?'))
    expect(screen.getByText(/Tier 1 supplier is a directory presence only/i)).toBeVisible()
    expect(screen.getByText('2% monthly')).toBeVisible()
    expect(screen.queryByText(/TEST\/DEMO only/i)).not.toBeInTheDocument()
    expect(screen.getAllByRole('link', { name: /register your store/i }).at(0)).toHaveAttribute('href', '/register')
    expect(screen.getAllByRole('link', { name: 'Sign in' })[0]).toHaveAttribute('href', '/login')
  })

  test('exposes operable navigation and FAQ controls', () => {
    render(<App />)

    const menu = screen.getByRole('button', { name: 'Open navigation' })
    fireEvent.click(menu)
    expect(menu).toHaveAttribute('aria-expanded', 'true')
    expect(screen.getByRole('navigation', { name: 'Vendor portal' })).toHaveClass('site-nav--open')

    const faqSummary = screen.getByText('When is the 2% commission charged?')
    const details = faqSummary.closest('details')
    expect(details).not.toBeNull()
    fireEvent.click(faqSummary)
    expect(details).toHaveAttribute('open')
  })

  test('serves a real registration route from the primary CTA', () => {
    render(<App />)
    const registrationLink = screen.getAllByRole('link', { name: /register your store/i }).at(0)
    expect(registrationLink).toBeDefined()
    fireEvent.click(registrationLink!)

    expect(screen.getByRole('heading', { name: 'Register your store' })).toBeVisible()
    expect(screen.getByRole('button', { name: /create owner account/i })).toBeEnabled()
    expect(screen.getByRole('link', { name: 'Register with Google' })).toHaveAttribute('href', '/register/google')
  })

  test('shows a friendly portal-isolation error after a denied Google callback', () => {
    window.history.replaceState({}, '', '/auth/callback?status=error&code=PORTAL_ACCESS_DENIED')
    render(<App />)

    expect(screen.getByRole('heading', { name: 'Google sign-in could not continue' })).toBeVisible()
    expect(screen.getByText(/belongs to a different MateryalPH account type/i)).toBeVisible()
    expect(screen.getByRole('link', { name: 'Back to Vendor sign in' })).toHaveAttribute('href', '/login')
    expect(screen.queryByText('PORTAL_ACCESS_DENIED')).not.toBeInTheDocument()
  })

  test('password visibility does not clear the entered password', () => {
    window.history.replaceState({}, '', '/login')
    render(<App />)
    const password = screen.getByLabelText(/^Password/i, { selector: 'input' })
    fireEvent.change(password, { target: { value: 'ExamplePassword123' } })
    fireEvent.click(screen.getByRole('button', { name: 'Show password' }))
    expect(password).toHaveAttribute('type', 'text')
    expect(password).toHaveValue('ExamplePassword123')
    fireEvent.click(screen.getByRole('button', { name: 'Hide password' }))
    expect(password).toHaveAttribute('type', 'password')
  })

  test.each(['ACCOUNT_NOT_FOUND', 'OIDC_STATE_INVALID', 'OIDC_KEYS_UNAVAILABLE', 'access_denied', 'unknown-internal-detail'])('Google callback %s offers safe recovery actions', (code) => {
    window.history.replaceState({}, '', `/auth/callback?status=error&code=${code}`)
    render(<App />)
    expect(screen.getByRole('link', { name: 'Back to Vendor sign in' })).toHaveAttribute('href', '/login')
    expect(screen.getByRole('link', { name: 'Register a Vendor account' })).toHaveAttribute('href', '/register')
    expect(screen.getByRole('button', { name: 'Use a different Google account' })).toBeEnabled()
    expect(screen.queryByText(code, { exact: true })).not.toBeInTheDocument()
  })

  test.each([
    [true, 'Secure your account'],
    [false, 'Verify it is you'],
  ])('routes the backend MFA enrollment flag %s to the correct state', async (mfaEnrollmentRequired, expectedHeading) => {
    vi.mocked(authApi.signIn).mockResolvedValue({
      data: { mfaRequired: true, mfaEnrollmentRequired },
    } as never)
    const renderWidget = installRecaptcha()

    window.history.replaceState({}, '', '/login')
    render(<App />)
    await waitFor(() => expect(renderWidget).toHaveBeenCalledOnce())
    const widgetParameters = renderWidget.mock.calls[0]?.[1] as Record<string, unknown>
    act(() => (widgetParameters.callback as (token: string) => void)('checkbox-token'))
    fireEvent.change(screen.getByLabelText(/Email address/i), { target: { value: 'vendor@example.test' } })
    fireEvent.change(screen.getByLabelText(/^Password/i), { target: { value: 'SecurePassword1' } })
    fireEvent.click(screen.getByRole('button', { name: /sign in/i }))

    expect(await screen.findByRole('heading', { name: expectedHeading })).toBeVisible()
    expect(authApi.signIn).toHaveBeenCalledWith(
      'vendor@example.test',
      'SecurePassword1',
      { recaptchaToken: 'checkbox-token' },
    )
  })

  test('maps registration validation details to every visible control and retains unknown errors', async () => {
    vi.mocked(authApi.registerVendor).mockRejectedValue(validationError({
      full_name: ['Enter the Vendor Owner name.'],
      business_name: ['Enter the business or store name.'],
      email: ['Enter a valid email address.'],
      mobile_e164: ['Enter a mobile number in international format.'],
      password: ['Use uppercase, lowercase, and a number.'],
      password_confirmation: ['The password confirmation does not match.'],
      terms_accepted: ['Accept the Terms of Service.'],
      privacy_accepted: ['Acknowledge the Privacy Notice.'],
      bot_protection: ['Complete Vendor verification.'],
      'bot_protection.recaptcha_token': ['The security checkbox expired.'],
      future_registration_field: ['Review the additional registration requirement.'],
    }))
    const renderWidget = installRecaptcha()

    window.history.replaceState({}, '', '/register')
    render(<App />)
    await completeRegistrationForm(renderWidget)
    fireEvent.click(screen.getByRole('button', { name: /create owner account/i }))

    await waitFor(() => expect(authApi.registerVendor).toHaveBeenCalledOnce())
    const fullName = screen.getByLabelText(/Owner full name/i)
    expect(fullName).toHaveAttribute('aria-invalid', 'true')
    expect(fullName).toHaveAttribute('aria-describedby', 'full_name-error')
    expect(screen.getByText('Enter the Vendor Owner name.')).toHaveAttribute('role', 'alert')

    for (const [label, message] of [
      [/Business or store name/i, 'Enter the business or store name.'],
      [/Email address/i, 'Enter a valid email address.'],
      [/Mobile number/i, 'Enter a mobile number in international format.'],
      [/^Password/i, 'Use uppercase, lowercase, and a number.'],
      [/Confirm password/i, 'The password confirmation does not match.'],
    ] as const) {
      expect(screen.getByLabelText(label, { selector: 'input' })).toHaveAttribute('aria-invalid', 'true')
      expect(screen.getByText(message)).toHaveAttribute('role', 'alert')
    }

    const terms = screen.getByLabelText(/I accept the versioned/i)
    const privacy = screen.getByLabelText(/I acknowledge the separate/i)
    expect(terms).toHaveAttribute('aria-invalid', 'true')
    expect(terms).toHaveAttribute('aria-describedby', 'terms_accepted-error')
    expect(privacy).toHaveAttribute('aria-invalid', 'true')
    expect(privacy).toHaveAttribute('aria-describedby', 'privacy_accepted-error')
    expect(screen.getByText('Accept the Terms of Service.')).toHaveAttribute('role', 'alert')
    expect(screen.getByText('Acknowledge the Privacy Notice.')).toHaveAttribute('role', 'alert')

    const captcha = document.getElementById('vendor-registration-captcha')
    expect(captcha).toHaveAttribute('aria-invalid', 'true')
    expect(captcha).toHaveTextContent('Complete Vendor verification.')
    expect(captcha).toHaveTextContent('The security checkbox expired.')
    expect(screen.getByText('Review the additional registration requirement.')).toBeVisible()
    await waitFor(() => expect(document.activeElement).toBe(fullName))

    fireEvent.change(fullName, { target: { value: 'Updated Vendor Owner' } })
    expect(screen.queryByText('Enter the Vendor Owner name.')).not.toBeInTheDocument()
    expect(screen.getByText('Enter a valid email address.')).toBeVisible()
  })

  test('submits the completed reCAPTCHA token and leaves no stale errors after registration', async () => {
    vi.mocked(authApi.registerVendor).mockResolvedValue(undefined as never)
    const renderWidget = installRecaptcha()

    window.history.replaceState({}, '', '/register')
    render(<App />)
    await completeRegistrationForm(renderWidget)
    fireEvent.click(screen.getByRole('button', { name: /create owner account/i }))

    await waitFor(() => expect(screen.getByRole('heading', { name: 'Verify your email' })).toBeVisible())
    expect(authApi.registerVendor).toHaveBeenCalledWith(
      expect.objectContaining({
        fullName: 'Vendor Owner',
        businessName: 'Sample Supply',
        mobileE164: '+639171234567',
      }),
      { recaptchaToken: 'checkbox-token' },
    )
    expect(screen.queryByText(/Review the highlighted fields/i)).not.toBeInTheDocument()
  })
})

function installRecaptcha() {
  vi.stubEnv('VITE_RECAPTCHA_SITE_KEY', 'test-site')
  const renderWidget = vi.fn((_container: HTMLElement, _parameters: Record<string, unknown>) => 31)
  window.grecaptcha = {
    enterprise: {
      ready: (callback) => callback(),
      render: renderWidget,
      reset: vi.fn(),
    },
  }
  return renderWidget
}

async function completeRegistrationForm(renderWidget: ReturnType<typeof installRecaptcha>) {
  await waitFor(() => expect(renderWidget).toHaveBeenCalledOnce())
  const parameters = renderWidget.mock.calls[0]?.[1] as Record<string, unknown>
  act(() => (parameters.callback as (token: string) => void)('checkbox-token'))

  fireEvent.change(screen.getByLabelText(/Owner full name/i), { target: { value: 'Vendor Owner' } })
  fireEvent.change(screen.getByLabelText(/Business or store name/i), { target: { value: 'Sample Supply' } })
  fireEvent.change(screen.getByLabelText(/Email address/i), { target: { value: 'vendor@example.test' } })
  fireEvent.change(screen.getByLabelText(/Mobile number/i, { selector: 'input' }), { target: { value: '+639171234567' } })
  fireEvent.change(screen.getByLabelText(/^Password/i), { target: { value: 'SecurePassword1' } })
  fireEvent.change(screen.getByLabelText(/^Confirm password/i, { selector: 'input' }), { target: { value: 'SecurePassword1' } })
  fireEvent.click(screen.getByLabelText(/I accept the versioned/i))
  fireEvent.click(screen.getByLabelText(/I acknowledge the separate/i))
}

function validationError(details: Record<string, string[]>): ResponseError {
  return new ResponseError(new Response(JSON.stringify({
    data: null,
    meta: {},
    errors: [{ code: 'VALIDATION_FAILED', message: 'Review the highlighted fields and try again.', details }],
  }), { status: 422, headers: { 'Content-Type': 'application/json' } }))
}
