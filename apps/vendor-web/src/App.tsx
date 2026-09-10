import { Button, Field, StatusMessage } from '@materyalph/web-ui'
import { ArrowRight } from 'lucide-react'
import { type FormEvent, type ReactNode, useEffect, useRef, useState } from 'react'
import { BrowserRouter, Link, Route, Routes, useNavigate, useSearchParams } from 'react-router-dom'

import './App.css'
import { BrandHeader } from './components/BrandHeader'
import { SiteFooter } from './components/SiteFooter'
import { RiskOtpPanel } from './components/auth/RiskOtpPanel'
import { VendorAuthShell } from './components/auth/VendorAuthShell'
import { VendorRecaptchaCheckbox, type VendorRecaptchaCheckboxRef } from './components/auth/VendorRecaptchaCheckbox'
import { asBotStepUpRequired, asValidationFailure, readableApiError, registerVendor, signIn, startGoogleSignIn, type RiskChallenge, type ValidationFieldErrors } from './lib/auth-api'
import { vendorBotEvidence, webCookieBotEvidence } from './lib/recaptcha-enterprise'
import {
  VendorAuthCallbackPage,
  VendorDashboardFoundation,
  VendorForgotPasswordPage,
  VendorGoogleRegisterPage,
  VendorMfaPage,
  VendorResetPasswordPage,
  VendorVerifyEmailPage,
} from './pages/AuthSupportPages'
import { VendorLandingPage } from './pages/VendorLandingPage'

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<VendorLandingPage />} />
        <Route path="/login" element={<LoginPage />} />
        <Route path="/register" element={<RegisterPage />} />
        <Route path="/register/google" element={<VendorGoogleRegisterPage />} />
        <Route path="/verify-email" element={<VendorVerifyEmailPage />} />
        <Route path="/forgot-password" element={<VendorForgotPasswordPage />} />
        <Route path="/reset-password" element={<VendorResetPasswordPage />} />
        <Route path="/auth/mfa" element={<VendorMfaPage />} />
        <Route path="/auth/callback" element={<VendorAuthCallbackPage />} />
        <Route path="/dashboard" element={<VendorDashboardFoundation />} />
        <Route path="/fees" element={<InfoPage title="Payments and fees"><FeesContent /></InfoPage>} />
        <Route path="/verification" element={<InfoPage title="Vendor verification"><VerificationContent /></InfoPage>} />
        <Route path="/opportunities" element={<InfoPage title="Marketplace opportunities"><OpportunitiesContent /></InfoPage>} />
        <Route path="/support" element={<InfoPage title="Vendor support"><SupportContent /></InfoPage>} />
        <Route path="/legal/:document" element={<InfoPage title="Legal and privacy"><LegalContent /></InfoPage>} />
        <Route path="*" element={<NotFound />} />
      </Routes>
    </BrowserRouter>
  )
}

function LoginPage() {
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const [useEmailCheck, setUseEmailCheck] = useState(false)
  const [captchaToken, setCaptchaToken] = useState<string | null>(null)
  const captchaRef = useRef<VendorRecaptchaCheckboxRef>(null)
  const [challenge, setChallenge] = useState<RiskChallenge | null>(null)
  const [pending, setPending] = useState<{ email: string; password: string } | null>(null)

  async function attempt(credentials: { email: string; password: string }, verified = false) {
    const evidence = verified
      ? webCookieBotEvidence()
      : vendorBotEvidence(captchaToken, useEmailCheck)
    const response = await signIn(credentials.email, credentials.password, evidence)
    if (response.data.mfaRequired) {
      navigate('/auth/mfa', {
        state: { mfaMode: response.data.mfaEnrollmentRequired ? 'enrollment' : 'challenge' },
      })
      return
    }

    navigate('/dashboard')
  }

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setBusy(true)
    setMessage(null)
    const data = new FormData(event.currentTarget)
    const credentials = { email: String(data.get('email')), password: String(data.get('password')) }
    setPending(credentials)
    try {
      await attempt(credentials)
    } catch (error) {
      const stepUp = await asBotStepUpRequired(error)
      if (stepUp) setChallenge(stepUp.challenge)
      else setMessage(await readableApiError(error))
    } finally {
      captchaRef.current?.reset()
      setBusy(false)
    }
  }

  const successMessage = searchParams.get('verified') === 'success'
    ? 'Email verified. You can now sign in.'
    : searchParams.get('reset') === 'success'
      ? 'Password updated. Sign in with your new password.'
      : null

  return (
    <VendorAuthShell title="Welcome back" description="Sign in to operate your verified store.">
      {challenge && pending
        ? <RiskOtpPanel challenge={challenge} email={pending.email} onCancel={() => { setChallenge(null); setPending(null) }} onVerified={() => attempt(pending, true)} />
        : <form className="auth-form" onSubmit={submit}>
            {successMessage && <StatusMessage tone="success">{successMessage}</StatusMessage>}
            {message && <StatusMessage tone="error">{message}</StatusMessage>}
            <Button className="w-full" variant="secondary" onClick={() => void startGoogleSignIn()} disabled={busy}>Continue with Google</Button>
            <div className="auth-divider"><span>or sign in with email</span></div>
            <Field label="Email address" name="email" type="email" autoComplete="email" required />
            <Field label="Password" name="password" type="password" autoComplete="current-password" required />
            <div className="form-row"><span>Access is protected by secure cookies.</span><Link to="/forgot-password">Forgot password?</Link></div>
            <button className="accessible-fallback" type="button" aria-pressed={useEmailCheck} onClick={() => { captchaRef.current?.reset(); setUseEmailCheck((value) => !value) }}>{useEmailCheck ? 'Email security check selected' : 'Use an email security check instead'}</button>
            {!useEmailCheck && <VendorRecaptchaCheckbox ref={captchaRef} action="vendor_login" disabled={busy} onTokenChange={setCaptchaToken} />}
            <Button className="w-full" type="submit" disabled={busy}>{busy ? 'Signing in…' : 'Sign in'} <ArrowRight aria-hidden="true" /></Button>
            <p className="auth-switch">New to MateryalPH? <Link to="/register">Register your store</Link></p>
          </form>}
    </VendorAuthShell>
  )
}

function RegisterPage() {
  const navigate = useNavigate()
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'error' | 'success'; text: string } | null>(null)
  const [fieldErrors, setFieldErrors] = useState<ValidationFieldErrors>({})
  const [validationFallback, setValidationFallback] = useState<string | null>(null)
  const [useEmailCheck, setUseEmailCheck] = useState(false)
  const [captchaToken, setCaptchaToken] = useState<string | null>(null)
  const captchaRef = useRef<VendorRecaptchaCheckboxRef>(null)
  const focusValidationOnRender = useRef(false)
  const [challenge, setChallenge] = useState<RiskChallenge | null>(null)
  const [pending, setPending] = useState<Parameters<typeof registerVendor>[0] | null>(null)

  useEffect(() => {
    if (!focusValidationOnRender.current) return
    focusValidationOnRender.current = false
    const firstField = registerValidationFocusOrder.find((field) => fieldErrors[field]?.length)
    const target = firstField ? registerValidationTargets[firstField] ?? 'registration-form-error' : 'registration-form-error'
    window.requestAnimationFrame(() => document.getElementById(target)?.focus())
  }, [fieldErrors])

  function clearFieldErrors(...fields: string[]) {
    if (!fields.some((field) => fieldErrors[field]?.length)) return
    const next = { ...fieldErrors }
    fields.forEach((field) => delete next[field])
    setFieldErrors(next)
    if (Object.keys(next).length === 0) setValidationFallback(null)
  }

  const fieldError = (field: string) => fieldErrors[field]?.[0] ?? ''
  const captchaErrors = [...new Set([
    ...(fieldErrors.bot_protection ?? []),
    ...(fieldErrors['bot_protection.recaptcha_token'] ?? []),
  ])]
  const validationMessage = validationFallback ? validationSummary(validationFallback, fieldErrors) : null
  const displayedMessage = validationMessage ? { tone: 'error' as const, text: validationMessage } : message

  async function attempt(request: Parameters<typeof registerVendor>[0], verified = false) {
    const evidence = verified
      ? webCookieBotEvidence()
      : vendorBotEvidence(captchaToken, useEmailCheck)
    await registerVendor(request, evidence)
    navigate(`/verify-email?email=${encodeURIComponent(request.email)}`)
  }

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setBusy(true)
    setMessage(null)
    setFieldErrors({})
    setValidationFallback(null)
    const data = new FormData(event.currentTarget)
    const request = {
      fullName: String(data.get('full_name')),
      email: String(data.get('email')),
      mobileE164: String(data.get('mobile')),
      businessName: String(data.get('business_name')),
      password: String(data.get('password')),
      passwordConfirmation: String(data.get('password_confirmation')),
      termsAccepted: true,
      privacyAccepted: true,
    } as Parameters<typeof registerVendor>[0]
    setPending(request)
    try {
      await attempt(request)
    } catch (error) {
      const stepUp = await asBotStepUpRequired(error)
      if (stepUp) setChallenge(stepUp.challenge)
      else {
        const validation = await asValidationFailure(error)
        if (validation) {
          focusValidationOnRender.current = true
          setValidationFallback(validation.message)
          setFieldErrors(validation.fieldErrors)
        } else {
          setMessage({ tone: 'error', text: await readableApiError(error) })
        }
      }
    } finally {
      captchaRef.current?.reset()
      setBusy(false)
    }
  }

  return (
    <VendorAuthShell title="Register your store" description="Create the Vendor Owner account first. Store activation follows a separate reviewed process.">
      {challenge && pending
        ? <RiskOtpPanel challenge={challenge} email={pending.email} onCancel={() => { setChallenge(null); setPending(null) }} onVerified={() => attempt(pending, true)} />
        : <form className="auth-form" onSubmit={submit}>
            {displayedMessage && <div id="registration-form-error" tabIndex={displayedMessage.tone === 'error' ? -1 : undefined}><StatusMessage tone={displayedMessage.tone}>{displayedMessage.text}</StatusMessage></div>}
            <Link className="button button--secondary" to="/register/google">Register with Google</Link>
            <div className="auth-divider"><span>or register with email</span></div>
            <Field error={fieldError('full_name')} label="Owner full name" name="full_name" autoComplete="name" maxLength={160} onChange={() => clearFieldErrors('full_name')} required />
            <Field error={fieldError('business_name')} label="Business or store name" name="business_name" autoComplete="organization" maxLength={180} onChange={() => clearFieldErrors('business_name')} required />
            <Field error={fieldError('email')} label="Email address" name="email" type="email" autoComplete="email" onChange={() => clearFieldErrors('email')} required />
            <Field error={fieldError('mobile_e164')} label="Mobile number" name="mobile" type="tel" autoComplete="tel" placeholder="+639171234567" pattern="\+[1-9][0-9]{7,14}" onChange={() => clearFieldErrors('mobile_e164')} required />
            <Field error={fieldError('password')} label="Password" name="password" type="password" autoComplete="new-password" minLength={12} hint="At least 12 characters with uppercase, lowercase, and a number." onChange={() => clearFieldErrors('password', 'password_confirmation')} required />
            <Field error={fieldError('password_confirmation')} label="Confirm password" name="password_confirmation" type="password" autoComplete="new-password" minLength={12} onChange={() => clearFieldErrors('password_confirmation', 'password')} required />
            <div className="grid gap-2">
              <label className="consent"><input aria-describedby={fieldError('terms_accepted') ? 'terms_accepted-error' : undefined} aria-invalid={fieldError('terms_accepted') ? true : undefined} id="terms_accepted" name="terms_accepted" type="checkbox" onChange={() => clearFieldErrors('terms_accepted')} required /><span>I accept the versioned <Link to="/legal/terms-of-service">Terms of Service</Link>.</span></label>
              {fieldError('terms_accepted') && <p className="text-sm text-status-error" id="terms_accepted-error" role="alert">{fieldError('terms_accepted')}</p>}
            </div>
            <div className="grid gap-2">
              <label className="consent"><input aria-describedby={fieldError('privacy_accepted') ? 'privacy_accepted-error' : undefined} aria-invalid={fieldError('privacy_accepted') ? true : undefined} id="privacy_accepted" name="privacy_accepted" type="checkbox" onChange={() => clearFieldErrors('privacy_accepted')} required /><span>I acknowledge the separate <Link to="/legal/privacy-notice">Privacy Notice</Link>.</span></label>
              {fieldError('privacy_accepted') && <p className="text-sm text-status-error" id="privacy_accepted-error" role="alert">{fieldError('privacy_accepted')}</p>}
            </div>
            <button className="accessible-fallback" type="button" aria-pressed={useEmailCheck} onClick={() => { captchaRef.current?.reset(); clearFieldErrors('bot_protection', 'bot_protection.recaptcha_token'); setUseEmailCheck((value) => !value) }}>{useEmailCheck ? 'Email security check selected' : 'Use an email security check instead'}</button>
            {!useEmailCheck && <VendorRecaptchaCheckbox ref={captchaRef} action="vendor_register" disabled={busy} id="vendor-registration-captcha" validationError={captchaErrors.join(' ')} onTokenChange={(token) => { setCaptchaToken(token); if (token) clearFieldErrors('bot_protection', 'bot_protection.recaptcha_token') }} />}
            <Button className="w-full" type="submit" disabled={busy}>{busy ? 'Creating account…' : 'Create Owner account'} <ArrowRight aria-hidden="true" /></Button>
            <p className="auth-switch">Already registered? <Link to="/login">Sign in</Link></p>
          </form>}
    </VendorAuthShell>
  )
}

const registerValidationTargets: Readonly<Record<string, string>> = {
  full_name: 'full_name',
  business_name: 'business_name',
  email: 'email',
  mobile_e164: 'mobile',
  password: 'password',
  password_confirmation: 'password_confirmation',
  terms_accepted: 'terms_accepted',
  privacy_accepted: 'privacy_accepted',
  bot_protection: 'vendor-registration-captcha',
  'bot_protection.recaptcha_token': 'vendor-registration-captcha',
}

const registerValidationFocusOrder = Object.keys(registerValidationTargets)

function validationSummary(fallback: string, fieldErrors: ValidationFieldErrors): string {
  const entries = Object.entries(fieldErrors)
  const unknownMessages = entries
    .filter(([field]) => !(field in registerValidationTargets))
    .flatMap(([, messages]) => messages)
  const messages = unknownMessages.length > 0 ? unknownMessages : entries.flatMap(([, values]) => values)
  return [...new Set(messages)].join(' ') || fallback
}

function InfoPage({ title, children }: { title: string; children: ReactNode }) {
  return (
    <>
      <BrandHeader />
      <main className="info-page" id="main-content">
        <h1>{title}</h1>
        {children}
        <Link className="button button--primary" to="/register">Register your store <ArrowRight aria-hidden="true" /></Link>
      </main>
      <SiteFooter />
    </>
  )
}

function FeesContent() {
  return <div className="info-copy"><p><strong>2% Vendor-paid monthly platform commission:</strong> assessed only on the approved completed-materials basis after Vendor discounts and excluding included materials VAT.</p><p>Buyer processing fees, Vendor commission liability, monthly settlement, withholding scenarios, refunds, and dispute adjustments remain separate records. Phase 1 uses TEST/DEMO finance configuration and does not enable live commerce.</p></div>
}

function VerificationContent() {
  return <div className="info-copy"><p>Activation requires an eligible Vendor Owner, verified email, store and business details, address, required private evidence, and an approved Admin review. Regulated product evidence is a later listing-level decision.</p><p>Exact requirements depend on Vendor classification and reviewed policy; the onboarding checklist shows what is required, optional, in review, or needs action.</p></div>
}

function OpportunitiesContent() {
  return <div className="info-copy"><p>Eligible Vendors can receive Item-Based orders from published listings and direct inquiries from Buyers for Project Work Packages.</p><p>MateryalPH does not provide a public Vendor RFQ bidding queue. A Work Package may have many inquiries but only one selected Vendor outcome.</p></div>
}

function SupportContent() {
  return <div className="info-copy"><p>Account recovery uses a short-lived, single-use email code. Never send passwords, OTPs, access tokens, payment details, or private documents through support messages.</p><p>If login is unavailable, use the recovery action on the sign-in page. Operational support routes will be added with their authorized workflow.</p></div>
}

function LegalContent() {
  return <div className="info-copy"><StatusMessage>Version metadata is served by the API. Final legal text and production approval remain a release gate.</StatusMessage><p>Terms acceptance and Privacy Notice acknowledgment are recorded separately with version, user, timestamp, and source.</p></div>
}

function NotFound() {
  return <InfoPage title="Page not found"><div className="info-copy"><p>The requested Vendor page is not available.</p><Link className="text-link" to="/">Return to the Vendor home page</Link></div></InfoPage>
}

export default App
