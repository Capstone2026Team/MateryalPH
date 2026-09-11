import { ResponseError } from '@materyalph/api-client-ts'
import { act, fireEvent, render, screen } from '@testing-library/react'
import { StrictMode } from 'react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, describe, expect, test, vi } from 'vitest'

import * as authApi from '../lib/auth-api'
import { recoveryCodesDocument } from '../lib/recovery-codes'
import { VendorDashboardFoundation, VendorMfaPage } from './AuthSupportPages'

vi.mock('../lib/auth-api', async (importOriginal) => {
  const actual = await importOriginal<typeof import('../lib/auth-api')>()
  return {
    ...actual,
    completeMfaChallenge: vi.fn(),
    confirmMfaEnrollment: vi.fn(),
    getMfaStatus: vi.fn(),
    getSession: vi.fn(),
    recoverMfaChallenge: vi.fn(),
    signOut: vi.fn(),
    startMfaEnrollment: vi.fn(),
  }
})

describe('Vendor MFA flow', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    vi.mocked(authApi.getSession).mockResolvedValue({ data: {} } as never)
  })

  test('renders a neutral state while resolving MFA and then chooses enrollment', async () => {
    let resolveStatus!: (value: never) => void
    vi.mocked(authApi.getMfaStatus).mockReturnValue(new Promise((resolve) => { resolveStatus = resolve }))

    renderMfa()

    expect(screen.getByRole('heading', { name: 'Checking your security setup' })).toBeVisible()
    expect(screen.queryByRole('heading', { name: 'Verify it is you' })).not.toBeInTheDocument()

    await act(async () => resolveStatus({ data: { mfaEnrollmentRequired: true } } as never))
    expect(await screen.findByRole('heading', { name: 'Secure your account' })).toBeVisible()
    expect(authApi.startMfaEnrollment).not.toHaveBeenCalled()
  })

  test('starts one enrollment by explicit intent in StrictMode and renders the QR locally', async () => {
    vi.mocked(authApi.startMfaEnrollment).mockResolvedValue({
      data: {
        secret: 'LOCALSETUPKEY',
        provisioningUri: 'otpauth://totp/MateryalPH%3AVendor?secret=LOCALSETUPKEY&issuer=MateryalPH&algorithm=SHA1&digits=6&period=30',
      },
    } as never)
    const fetchSpy = vi.spyOn(globalThis, 'fetch')

    renderMfa({ mfaMode: 'enrollment' }, true)
    expect(screen.getByRole('heading', { name: 'Secure your account' })).toBeVisible()
    expect(screen.queryByRole('heading', { name: 'Verify it is you' })).not.toBeInTheDocument()
    expect(authApi.startMfaEnrollment).not.toHaveBeenCalled()

    fireEvent.click(screen.getByRole('button', { name: 'Set up authenticator' }))

    expect(await screen.findByRole('img', { name: 'Authenticator setup QR code' })).toBeVisible()
    expect(authApi.startMfaEnrollment).toHaveBeenCalledOnce()
    expect(fetchSpy).not.toHaveBeenCalled()
    expect(screen.getByText("Can't scan the QR code?")).toBeVisible()
    expect(screen.getByText('LOCALSETUPKEY')).toBeVisible()
    expect(screen.getByRole('button', { name: 'Copy manual setup key' })).toBeEnabled()
  })

  test('routes a returning enrolled Vendor through challenge to the dashboard', async () => {
    vi.mocked(authApi.completeMfaChallenge).mockResolvedValue({ data: {} } as never)
    renderMfa({ mfaMode: 'challenge' })

    expect(screen.getByRole('heading', { name: 'Verify it is you' })).toBeVisible()
    expect(screen.queryByRole('button', { name: 'Set up authenticator' })).not.toBeInTheDocument()
    fireEvent.change(screen.getByLabelText(/Six-digit authenticator code/i), { target: { value: '123456' } })
    fireEvent.click(screen.getByRole('button', { name: 'Verify and continue' }))

    expect(await screen.findByRole('heading', { name: 'Dashboard reached' })).toBeVisible()
    expect(authApi.completeMfaChallenge).toHaveBeenCalledWith('123456')
  })

  test('associates an invalid authenticator response with the six-digit field', async () => {
    vi.mocked(authApi.completeMfaChallenge).mockRejectedValue(apiError(401, 'MFA_CODE_INVALID', 'The verification code is incorrect.'))
    renderMfa({ mfaMode: 'challenge' })

    const input = screen.getByLabelText(/Six-digit authenticator code/i)
    fireEvent.change(input, { target: { value: '123456' } })
    fireEvent.click(screen.getByRole('button', { name: 'Verify and continue' }))

    expect(await screen.findByText('The verification code is incorrect.')).toHaveAttribute('role', 'alert')
    expect(input).toHaveAttribute('aria-invalid', 'true')
    expect(input).toHaveAttribute('aria-describedby', 'code-error')
  })

  test('creates a local recovery-code download and requires acknowledgement before dashboard', async () => {
    const codes = ['AAAA-BBBB-CCCC', 'DDDD-EEEE-FFFF']
    vi.mocked(authApi.startMfaEnrollment).mockResolvedValue({
      data: { secret: 'LOCALSETUPKEY', provisioningUri: 'otpauth://totp/MateryalPH?secret=LOCALSETUPKEY' },
    } as never)
    vi.mocked(authApi.confirmMfaEnrollment).mockResolvedValue({ data: { recoveryCodes: codes } } as never)
    const createObjectUrl = vi.fn(() => 'blob:local-recovery-codes')
    const revokeObjectUrl = vi.fn()
    Object.defineProperty(URL, 'createObjectURL', { configurable: true, value: createObjectUrl })
    Object.defineProperty(URL, 'revokeObjectURL', { configurable: true, value: revokeObjectUrl })
    const clickSpy = vi.spyOn(HTMLAnchorElement.prototype, 'click').mockImplementation(() => undefined)

    renderMfa({ mfaMode: 'enrollment' })
    fireEvent.click(screen.getByRole('button', { name: 'Set up authenticator' }))
    await screen.findByRole('img', { name: 'Authenticator setup QR code' })
    fireEvent.change(screen.getByLabelText(/Six-digit authenticator code/i), { target: { value: '123456' } })
    fireEvent.click(screen.getByRole('button', { name: 'Verify and continue' }))

    expect(await screen.findByRole('heading', { name: 'Save your recovery codes' })).toBeVisible()
    const continueButton = screen.getByRole('button', { name: 'Continue to dashboard' })
    expect(continueButton).toBeDisabled()
    fireEvent.click(screen.getByRole('button', { name: 'Download .txt' }))
    expect(createObjectUrl).toHaveBeenCalledOnce()
    expect(revokeObjectUrl).toHaveBeenCalledWith('blob:local-recovery-codes')
    expect(clickSpy).toHaveBeenCalledOnce()

    const documentText = recoveryCodesDocument(codes)
    expect(documentText).toContain('MateryalPH Vendor Account Recovery Codes')
    expect(documentText).toContain('Each recovery code works once.')
    expect(documentText).toContain(codes.join('\n'))
    expect(documentText).not.toMatch(/password|secret|session|access token|refresh token|@/i)

    fireEvent.click(screen.getByLabelText('I saved these codes securely and offline.'))
    expect(continueButton).toBeEnabled()
    fireEvent.click(continueButton)
    expect(await screen.findByRole('heading', { name: 'Dashboard reached' })).toBeVisible()
  })

  test('surfaces a failed dashboard session check without redirecting', async () => {
    vi.mocked(authApi.getSession).mockRejectedValue(apiError(401, 'UNAUTHENTICATED', 'Your session has expired. Sign in again.'))

    render(
      <MemoryRouter initialEntries={['/dashboard']}>
        <Routes>
          <Route path="/dashboard" element={<VendorDashboardFoundation />} />
          <Route path="/login" element={<h1>Login page</h1>} />
        </Routes>
      </MemoryRouter>,
    )

    expect(await screen.findByRole('heading', { name: 'Session could not be restored' })).toBeVisible()
    expect(screen.getByText('Your session has expired. Sign in again.')).toHaveAttribute('role', 'alert')
    expect(screen.queryByRole('heading', { name: 'Login page' })).not.toBeInTheDocument()
    expect(screen.getByRole('link', { name: 'Return to sign in' })).toHaveAttribute('href', '/login')
  })

  test('calls the authoritative logout API once and leaves the dashboard on success', async () => {
    let completeLogout!: () => void
    vi.mocked(authApi.signOut).mockReturnValue(new Promise((resolve) => { completeLogout = () => resolve({} as never) }))

    renderDashboard()

    const signOutButton = await screen.findByRole('button', { name: 'Sign out' })
    fireEvent.click(signOutButton)
    expect(screen.getByRole('button', { name: 'Signing out…' })).toBeDisabled()
    fireEvent.click(screen.getByRole('button', { name: 'Signing out…' }))
    expect(authApi.signOut).toHaveBeenCalledOnce()

    await act(async () => completeLogout())
    expect(await screen.findByRole('heading', { name: 'Login page' })).toBeVisible()
    expect(screen.queryByRole('heading', { name: 'Welcome to your Vendor account' })).not.toBeInTheDocument()
  })

  test('keeps the authenticated dashboard visible and surfaces a safe logout failure', async () => {
    vi.mocked(authApi.signOut).mockRejectedValue(apiError(503, 'AUTH_LOGOUT_FAILED', 'Sign out could not be completed. Try again.'))

    renderDashboard()

    fireEvent.click(await screen.findByRole('button', { name: 'Sign out' }))
    expect(await screen.findByText('Sign out could not be completed. Try again.')).toHaveAttribute('role', 'alert')
    expect(screen.getByRole('heading', { name: 'Welcome to your Vendor account' })).toBeVisible()
    expect(screen.getByRole('button', { name: 'Sign out' })).toBeEnabled()
    expect(screen.queryByRole('heading', { name: 'Login page' })).not.toBeInTheDocument()
  })
})

function renderMfa(state?: { mfaMode: 'enrollment' | 'challenge' }, strict = false) {
  const tree = <MemoryRouter initialEntries={[{ pathname: '/auth/mfa', state }]}>
    <Routes>
      <Route path="/auth/mfa" element={<VendorMfaPage />} />
      <Route path="/dashboard" element={<h1>Dashboard reached</h1>} />
    </Routes>
  </MemoryRouter>

  return render(strict ? <StrictMode>{tree}</StrictMode> : tree)
}

function renderDashboard() {
  return render(
    <MemoryRouter initialEntries={['/dashboard']}>
      <Routes>
        <Route path="/dashboard" element={<VendorDashboardFoundation />} />
        <Route path="/login" element={<h1>Login page</h1>} />
      </Routes>
    </MemoryRouter>,
  )
}

function apiError(status: number, code: string, message: string): ResponseError {
  return new ResponseError(new Response(JSON.stringify({
    data: null,
    meta: {},
    errors: [{ code, message }],
  }), { status, headers: { 'Content-Type': 'application/json' } }))
}
