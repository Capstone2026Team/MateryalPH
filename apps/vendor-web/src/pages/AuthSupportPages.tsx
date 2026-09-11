import { Button, Field, PhoneField, StatusMessage } from '@materyalph/web-ui'
import { Copy, Download, LogOut, ShieldCheck } from 'lucide-react'
import { QRCodeSVG } from 'qrcode.react'
import { type FormEvent, useEffect, useRef, useState } from 'react'
import { Link, useLocation, useNavigate, useSearchParams } from 'react-router-dom'

import { RiskOtpPanel } from '../components/auth/RiskOtpPanel'
import { VendorAuthShell } from '../components/auth/VendorAuthShell'
import { VendorRecaptchaCheckbox, type VendorRecaptchaCheckboxRef } from '../components/auth/VendorRecaptchaCheckbox'
import {
  asBotStepUpRequired,
  completeMfaChallenge,
  confirmMfaEnrollment,
  getMfaStatus,
  getSession,
  readableApiError,
  recoverMfaChallenge,
  requestPasswordRecovery,
  resendVendorVerification,
  resetPassword,
  signOut,
  startGoogleRegistration,
  startGoogleSignIn,
  startMfaEnrollment,
  verifyVendorEmail,
  type RiskChallenge,
} from '../lib/auth-api'
import { vendorBotEvidence, webCookieBotEvidence } from '../lib/recaptcha-enterprise'
import { downloadRecoveryCodes } from '../lib/recovery-codes'

type Enrollment = { secret: string; provisioningUri: string }
type MfaMode = 'resolving' | 'enrollment' | 'challenge'

export function VendorMfaPage() {
  const navigate = useNavigate()
  const location = useLocation()
  const [mode, setMode] = useState<MfaMode>(() => mfaModeFromLocationState(location.state))
  const [busy, setBusy] = useState(false)
  const [recoveryMode, setRecoveryMode] = useState(false)
  const [enrollment, setEnrollment] = useState<Enrollment | null>(null)
  const [recoveryCodes, setRecoveryCodes] = useState<string[] | null>(null)
  const [message, setMessage] = useState<string | null>(null)
  const [savedRecoveryCodes, setSavedRecoveryCodes] = useState(false)
  const [copyFeedback, setCopyFeedback] = useState<string | null>(null)

  useEffect(() => {
    if (mode !== 'resolving') return
    let active = true
    void (async () => {
      try {
        const status = await getMfaStatus()
        if (active) setMode(status.data.mfaEnrollmentRequired ? 'enrollment' : 'challenge')
      } catch (error) {
        if (active) setMessage(await readableApiError(error))
      }
    })()
    return () => { active = false }
  }, [mode])

  async function beginEnrollment() {
    if (busy || enrollment) return
    setBusy(true)
    setMessage(null)
    try {
      const result = await startMfaEnrollment()
      setEnrollment({ secret: result.data.secret, provisioningUri: result.data.provisioningUri })
    } catch (error) {
      setMessage(await readableApiError(error))
    } finally {
      setBusy(false)
    }
  }

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setBusy(true); setMessage(null)
    const data = new FormData(event.currentTarget)
    try {
      const response = recoveryMode
        ? await recoverMfaChallenge(String(data.get('recovery_code')))
        : enrollment
          ? await confirmMfaEnrollment(String(data.get('code')))
          : await completeMfaChallenge(String(data.get('code')))
      const codes = response.data.recoveryCodes
      if (codes?.length) setRecoveryCodes(codes)
      else navigate('/dashboard', { replace: true })
    } catch (error) { setMessage(await readableApiError(error)) }
    finally { setBusy(false) }
  }

  async function copyToClipboard(value: string, successMessage: string) {
    try {
      await navigator.clipboard.writeText(value)
      setCopyFeedback(successMessage)
    } catch {
      setCopyFeedback('Copy was unavailable. Select and copy the value manually.')
    }
  }

  if (recoveryCodes) return <VendorAuthShell title="Save your recovery codes" description="Each code works once. Store this replacement set offline; MateryalPH will not show it again.">
    <StatusMessage>Keep these codes somewhere only you can access. They can unlock your account if you lose your authenticator.</StatusMessage>
    <div className="recovery-codes" aria-label="One-time recovery codes">{recoveryCodes.map((code) => <code key={code}>{code}</code>)}</div>
    <div className="recovery-actions">
      <Button variant="secondary" onClick={() => void copyToClipboard(recoveryCodes.join('\n'), 'Recovery codes copied.')}><Copy aria-hidden="true" /> Copy all codes</Button>
      <Button variant="secondary" onClick={() => downloadRecoveryCodes(recoveryCodes)}><Download aria-hidden="true" /> Download .txt</Button>
    </div>
    {copyFeedback && <StatusMessage>{copyFeedback}</StatusMessage>}
    <label className="consent recovery-acknowledgement"><input type="checkbox" checked={savedRecoveryCodes} onChange={(event) => setSavedRecoveryCodes(event.currentTarget.checked)} /><span>I saved these codes securely and offline.</span></label>
    <Button className="w-full" disabled={!savedRecoveryCodes} onClick={() => navigate('/dashboard', { replace: true })}>Continue to dashboard</Button>
  </VendorAuthShell>

  if (mode === 'resolving') return <VendorAuthShell title="Checking your security setup" description="MateryalPH is determining the required security step for this sign-in."><StatusMessage tone={message ? 'error' : 'info'}>{message ?? 'Loading your security step…'}</StatusMessage></VendorAuthShell>

  if (mode === 'enrollment' && !enrollment) return <VendorAuthShell title="Secure your account" description="Vendor Owners and Store Managers must enroll an authenticator before portal access.">
    {message && <StatusMessage tone="error">{message}</StatusMessage>}
    <div className="mfa-introduction"><ShieldCheck aria-hidden="true" /><p>Set up an authenticator app to continue. The setup key remains protected until you choose to begin.</p></div>
    <Button className="w-full" disabled={busy} onClick={() => void beginEnrollment()}>{busy ? 'Preparing setup…' : 'Set up authenticator'}</Button>
    <Link className="auth-cancel" to="/login">Cancel and sign in again</Link>
  </VendorAuthShell>

  return <VendorAuthShell title={mode === 'enrollment' ? 'Scan with your authenticator app' : 'Verify it is you'} description={mode === 'enrollment' ? 'Scan the code, then enter the current six-digit code from your authenticator app.' : 'Enter the current code from your authenticator app.'}>
    <form className="auth-form" onSubmit={submit}>
      {mode === 'enrollment' && enrollment && <div className="totp-setup">
        <ol className="auth-steps"><li>Open your authenticator and choose to add an account.</li><li>Scan this QR code or enter the manual key below.</li><li>Enter the current six-digit code to finish setup.</li></ol><div className="totp-qr"><QRCodeSVG value={enrollment.provisioningUri} size={208} level="M" marginSize={4} title="Authenticator setup QR code" role="img" /></div>
        <div className="manual-setup"><h3>Can't scan the QR code?</h3><p>Enter this setup key manually.</p><div><code>{enrollment.secret}</code><Button variant="secondary" aria-label="Copy manual setup key" onClick={() => void copyToClipboard(enrollment.secret, 'Setup key copied.')}><Copy aria-hidden="true" /> Copy</Button></div></div>
        {copyFeedback && <StatusMessage>{copyFeedback}</StatusMessage>}
      </div>}
      {recoveryMode ? <Field error={message ?? ''} label="Recovery code" name="recovery_code" autoComplete="one-time-code" required /> : <Field error={message ?? ''} label="Six-digit authenticator code" name="code" inputMode="numeric" autoComplete="one-time-code" pattern="[0-9]{6}" maxLength={6} required />}
      <Button className="w-full" type="submit" disabled={busy}>{busy ? 'Verifying…' : 'Verify and continue'}</Button>
      {mode === 'challenge' && <Button className="w-full" variant="quiet" onClick={() => { setRecoveryMode((value) => !value); setMessage(null) }}>{recoveryMode ? 'Use authenticator code' : 'Use a recovery code'}</Button>}
      <Link className="auth-cancel" to="/login">Cancel and sign in again</Link>
    </form>
  </VendorAuthShell>
}

function mfaModeFromLocationState(state: unknown): MfaMode {
  if (typeof state === 'object' && state !== null && 'mfaMode' in state) {
    if (state.mfaMode === 'enrollment' || state.mfaMode === 'challenge') return state.mfaMode
  }
  return 'resolving'
}

export function VendorForgotPasswordPage() {
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const [useEmailCheck, setUseEmailCheck] = useState(false)
  const [captchaToken, setCaptchaToken] = useState<string | null>(null)
  const captchaRef = useRef<VendorRecaptchaCheckboxRef>(null)
  const [challenge, setChallenge] = useState<RiskChallenge | null>(null)
  const [email, setEmail] = useState('')

  async function attempt(address: string, verified = false) {
    const evidence = verified
      ? webCookieBotEvidence()
      : vendorBotEvidence(captchaToken, useEmailCheck)
    await requestPasswordRecovery(address, evidence)
    setChallenge(null)
    setMessage('If that account exists, a six-digit recovery code is being delivered. Continue to reset your password.')
  }

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setBusy(true)
    setMessage(null)
    const address = String(new FormData(event.currentTarget).get('email'))
    setEmail(address)
    try {
      await attempt(address)
    } catch (error) {
      const stepUp = await asBotStepUpRequired(error)
      if (stepUp) setChallenge(stepUp.challenge)
      else setMessage(await readableApiError(error))
    } finally {
      captchaRef.current?.reset()
      setBusy(false)
    }
  }

  return <VendorAuthShell title="Recover your account" description="We will send a short-lived, single-use code to the account email.">
    {challenge
      ? <RiskOtpPanel challenge={challenge} email={email} onCancel={() => setChallenge(null)} onVerified={() => attempt(email, true)} />
      : <form className="auth-form" onSubmit={submit}>
          {message && <StatusMessage>{message}</StatusMessage>}
          <Field label="Email address" name="email" type="email" autoComplete="email" required />
          <button className="accessible-fallback" type="button" aria-pressed={useEmailCheck} onClick={() => { captchaRef.current?.reset(); setUseEmailCheck((value) => !value) }}>{useEmailCheck ? 'Email security check selected' : 'Use an email security check instead'}</button>
          {!useEmailCheck && <VendorRecaptchaCheckbox ref={captchaRef} action="vendor_password_recovery" disabled={busy} onTokenChange={setCaptchaToken} />}
          <Button className="w-full" type="submit" disabled={busy}>{busy ? 'Requesting…' : 'Send recovery code'}</Button>
          <Link className="auth-cancel" to="/reset-password">I already have a code</Link>
          <Link className="auth-cancel" to="/login">Back to sign in</Link>
        </form>}
  </VendorAuthShell>
}

export function VendorResetPasswordPage() {
  const navigate = useNavigate(); const [searchParams] = useSearchParams(); const [busy, setBusy] = useState(false); const [message, setMessage] = useState<string | null>(null)
  async function submit(event: FormEvent<HTMLFormElement>) { event.preventDefault(); setBusy(true); setMessage(null); const data = new FormData(event.currentTarget); try { await resetPassword(String(data.get('email')), String(data.get('code')), String(data.get('password')), String(data.get('password_confirmation'))); navigate('/login?reset=success', { replace: true }) } catch (error) { setMessage(await readableApiError(error)) } finally { setBusy(false) } }
  return <VendorAuthShell title="Set a new password" description="The recovery code expires after ten minutes and cannot be reused."><form className="auth-form" onSubmit={submit}>{message && <StatusMessage tone="error">{message}</StatusMessage>}<Field label="Email address" name="email" type="email" defaultValue={searchParams.get('email') ?? ''} autoComplete="email" required /><Field label="Six-digit recovery code" name="code" inputMode="numeric" autoComplete="one-time-code" pattern="[0-9]{6}" maxLength={6} required /><Field label="New password" name="password" type="password" autoComplete="new-password" minLength={12} hint="At least 12 characters with uppercase, lowercase, and a number." required /><Field label="Confirm new password" name="password_confirmation" type="password" autoComplete="new-password" minLength={12} required /><Button className="w-full" type="submit" disabled={busy}>{busy ? 'Updating…' : 'Update password'}</Button></form></VendorAuthShell>
}

export function VendorVerifyEmailPage() {
  const navigate = useNavigate(); const [searchParams] = useSearchParams(); const email = searchParams.get('email') ?? ''; const [busy, setBusy] = useState(false); const [message, setMessage] = useState<string | null>(null)
  async function submit(event: FormEvent<HTMLFormElement>) { event.preventDefault(); setBusy(true); setMessage(null); const data = new FormData(event.currentTarget); try { await verifyVendorEmail(String(data.get('email')), String(data.get('code'))); navigate('/login?verified=success', { replace: true }) } catch (error) { setMessage(await readableApiError(error)) } finally { setBusy(false) } }
  async function resend() { setBusy(true); try { await resendVendorVerification(email); setMessage('A new code was requested. Check your email; resend limits still apply.') } catch (error) { setMessage(await readableApiError(error)) } finally { setBusy(false) } }
  return <VendorAuthShell title="Verify your email" description="Enter the six-digit code sent after registration."><form className="auth-form" onSubmit={submit}>{message && <StatusMessage>{message}</StatusMessage>}<Field label="Email address" name="email" type="email" defaultValue={email} autoComplete="email" required /><Field label="Verification code" name="code" inputMode="numeric" autoComplete="one-time-code" pattern="[0-9]{6}" maxLength={6} required /><Button className="w-full" type="submit" disabled={busy}>{busy ? 'Verifying…' : 'Verify email'}</Button><Button className="w-full" variant="quiet" onClick={() => void resend()} disabled={busy || !email}>Request another code</Button></form></VendorAuthShell>
}

export function VendorGoogleRegisterPage() {
  const [busy, setBusy] = useState(false); const [message, setMessage] = useState<string | null>(null)
  async function submit(event: FormEvent<HTMLFormElement>) { event.preventDefault(); setBusy(true); setMessage(null); const data = new FormData(event.currentTarget); try { await startGoogleRegistration({ mobileE164: String(data.get('mobile')), businessName: String(data.get('business_name')) }) } catch (error) { setMessage(await readableApiError(error)); setBusy(false) } }
  return <VendorAuthShell title="Register with Google" description="Provide the Vendor details Google does not supply before continuing to its secure consent screen."><form className="auth-form" onSubmit={submit}>{message && <StatusMessage tone="error">{message}</StatusMessage>}<Field label="Business or store name" name="business_name" autoComplete="organization" maxLength={180} required /><PhoneField label="Mobile number" name="mobile" required /><label className="consent"><input type="checkbox" required /><span>I accept the versioned <Link to="/legal/terms-of-service">Terms of Service</Link>.</span></label><label className="consent"><input type="checkbox" required /><span>I acknowledge the separate <Link to="/legal/privacy-notice">Privacy Notice</Link>.</span></label><Button className="w-full" type="submit" disabled={busy}>{busy ? 'Opening Google…' : 'Continue with Google'}</Button></form></VendorAuthShell>
}

export function VendorDashboardFoundation() {
  const navigate = useNavigate()
  const [ready, setReady] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const [logoutBusy, setLogoutBusy] = useState(false)
  const [logoutError, setLogoutError] = useState<string | null>(null)
  useEffect(() => {
    let active = true
    void getSession()
      .then(() => { if (active) setReady(true) })
      .catch(async (error) => { if (active) setMessage(await readableApiError(error)) })
    return () => { active = false }
  }, [])

  async function logout() {
    if (logoutBusy) return
    setLogoutBusy(true)
    setLogoutError(null)
    try {
      await signOut()
      setReady(false)
      navigate('/login?logout=success', { replace: true })
    } catch (error) {
      setLogoutError(await readableApiError(error))
      setLogoutBusy(false)
    }
  }

  return <main className="dashboard-foundation">
    <header className="dashboard-foundation__header">
      <img src="/brand/materyalph-logo.png" alt="MateryalPH Vendor Portal" />
      {ready && <Button variant="secondary" disabled={logoutBusy} onClick={() => void logout()}><LogOut aria-hidden="true" />{logoutBusy ? 'Signing out…' : 'Sign out'}</Button>}
    </header>
    <div><ShieldCheck aria-hidden="true" /><h1>{ready ? 'Welcome to your Vendor account' : message ? 'Session could not be restored' : 'Checking your session…'}</h1><p>{ready ? 'You are securely signed in. Your account is ready; store verification and activation are separate steps and are not available in this workspace yet.' : message ? 'Your authenticated Vendor session could not be confirmed.' : 'Securely restoring your Vendor session.'}</p>{ready && <dl className="foundation-details"><div><dt>Account access</dt><dd>Signed in</dd></div><div><dt>Store verification</dt><dd>Not available here yet</dd></div></dl>}{logoutError && <StatusMessage tone="error">{logoutError}</StatusMessage>}{message && <><StatusMessage tone="error">{message}</StatusMessage><Link className="button button--primary" to="/login">Return to sign in</Link></>}</div>
  </main>
}

export function VendorAuthCallbackPage() {
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const [retryBusy, setRetryBusy] = useState(false)
  const [retryError, setRetryError] = useState<string | null>(null)
  async function retryGoogle() {
    setRetryBusy(true); setRetryError(null)
    try { await startGoogleSignIn() }
    catch (error) { setRetryError(await readableApiError(error)); setRetryBusy(false) }
  }
  const callbackFailed = searchParams.get('status') !== 'success'
  const errorMessage = callbackFailed
    ? googleCallbackErrorMessage(searchParams.get('code'))
    : null
  useEffect(() => {
    if (callbackFailed) return
    void getSession().then(() => navigate('/dashboard', { replace: true })).catch(() => navigate('/login', { replace: true }))
  }, [callbackFailed, navigate])

  if (errorMessage) {
    return <VendorAuthShell title="Google sign-in could not continue" description="Your existing MateryalPH identity is still protected."><StatusMessage tone="error">{errorMessage}</StatusMessage><div className="callback-actions"><Link className="button button--primary w-full" to="/login">Back to Vendor sign in</Link><Button variant="secondary" disabled={retryBusy} onClick={() => void retryGoogle()}>{retryBusy ? 'Opening Google…' : 'Use a different Google account'}</Button><Link className="auth-cancel" to="/register">Register a Vendor account</Link></div>{retryError && <StatusMessage tone="error">{retryError}</StatusMessage>}</VendorAuthShell>
  }

  return <VendorAuthShell title="Completing sign in" description="MateryalPH is validating your secure session."><StatusMessage>Finishing Google sign-in…</StatusMessage></VendorAuthShell>
}

function googleCallbackErrorMessage(code: string | null): string {
  const messages: Record<string, string> = {
    PORTAL_ACCESS_DENIED: 'This Google account belongs to a different MateryalPH account type and cannot sign in to the Vendor portal.',
    ACCOUNT_NOT_FOUND: 'No MateryalPH Vendor account is linked to this Google account.',
    OIDC_STATE_INVALID: 'This sign-in request has expired. Start again to securely continue with Google.',
    OIDC_EXCHANGE_FAILED: 'Google sign-in could not finish. Try again or sign in with your email.',
    OIDC_TOKEN_INVALID: 'We could not verify this Google sign-in. Please start again.',
    OIDC_KEYS_UNAVAILABLE: 'Google sign-in is temporarily unavailable. Try again shortly or use email sign-in.',
    OIDC_NOT_CONFIGURED: 'Google sign-in is currently unavailable. You can continue with email instead.',
    access_denied: 'Google sign-in was cancelled. You can try again whenever you are ready.',
    CONSENT_REQUIRED: 'Accept the Terms of Service and Privacy Notice before creating a Vendor account with Google.',
  }

  return code && messages[code]
    ? messages[code]
    : 'Google sign-in could not be completed. Return to Vendor sign in and try again.'
}
