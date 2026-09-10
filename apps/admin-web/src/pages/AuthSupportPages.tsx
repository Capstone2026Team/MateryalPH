import { Button, Field, StatusMessage } from '@materyalph/web-ui'
import { ShieldCheck } from 'lucide-react'
import { type FormEvent, useEffect, useState } from 'react'
import { Link, useNavigate, useSearchParams } from 'react-router-dom'

import { AdminAuthShell } from '../components/AdminAuthShell'
import {
  completeMfaChallenge,
  confirmMfaEnrollment,
  getMfaStatus,
  readableApiError,
  recoverMfaChallenge,
  requestPasswordRecovery,
  resetPassword,
  startMfaEnrollment,
} from '../lib/auth-api'

type Enrollment = { secret: string; provisioningUri: string }

export function AdminMfaPage() {
  const navigate = useNavigate(); const [loading, setLoading] = useState(true); const [busy, setBusy] = useState(false); const [recoveryMode, setRecoveryMode] = useState(false); const [enrollment, setEnrollment] = useState<Enrollment | null>(null); const [recoveryCodes, setRecoveryCodes] = useState<string[] | null>(null); const [message, setMessage] = useState<string | null>(null)
  useEffect(() => { let active = true; void (async () => { try { const status = await getMfaStatus(); if (status.data.mfaEnrollmentRequired) { const result = await startMfaEnrollment(); if (active) setEnrollment({ secret: result.data.secret, provisioningUri: result.data.provisioningUri }) } } catch (error) { if (active) setMessage(await readableApiError(error)) } finally { if (active) setLoading(false) } })(); return () => { active = false } }, [])
  async function submit(event: FormEvent<HTMLFormElement>) { event.preventDefault(); setBusy(true); setMessage(null); const data = new FormData(event.currentTarget); try { const response = recoveryMode ? await recoverMfaChallenge(String(data.get('recovery_code'))) : enrollment ? await confirmMfaEnrollment(String(data.get('code'))) : await completeMfaChallenge(String(data.get('code'))); const codes = response.data.recoveryCodes; if (codes?.length) setRecoveryCodes(codes); else navigate('/workspace', { replace: true }) } catch (error) { setMessage(await readableApiError(error)) } finally { setBusy(false) } }
  if (recoveryCodes) return <AdminAuthShell title="Save your recovery codes" description="Each code works once. Store this replacement set offline; it will not be shown again."><div className="recovery-codes" aria-label="One-time recovery codes">{recoveryCodes.map((code) => <code key={code}>{code}</code>)}</div><Button className="w-full" onClick={() => navigate('/workspace', { replace: true })}>I saved these codes</Button></AdminAuthShell>
  return <AdminAuthShell title={enrollment ? 'Secure your Admin account' : 'Verify it is you'} description={enrollment ? 'All Admin accounts require an authenticator before portal access.' : 'Enter the current code from your authenticator app.'}>{loading ? <StatusMessage>Loading your security step…</StatusMessage> : <form onSubmit={submit}>{message && <StatusMessage tone="error">{message}</StatusMessage>}{enrollment && !recoveryMode && <div className="enrollment-secret"><ShieldCheck aria-hidden="true" /><p>Add this account in your authenticator app, then enter its six-digit code.</p><code>{enrollment.secret}</code><details><summary>Manual provisioning address</summary><code>{enrollment.provisioningUri}</code></details></div>}{recoveryMode ? <Field label="Recovery code" name="recovery_code" autoComplete="one-time-code" required /> : <Field label="Six-digit authenticator code" name="code" inputMode="numeric" autoComplete="one-time-code" pattern="[0-9]{6}" maxLength={6} required />}<Button className="w-full" type="submit" disabled={busy}>{busy ? 'Verifying…' : enrollment ? 'Enroll and continue' : 'Verify and continue'}</Button>{!enrollment && <Button className="w-full" variant="quiet" onClick={() => { setRecoveryMode((value) => !value); setMessage(null) }}>{recoveryMode ? 'Use authenticator code' : 'Use a recovery code'}</Button>}<Link className="admin-return admin-return--centered" to="/login">Cancel and sign in again</Link></form>}</AdminAuthShell>
}

export function AdminForgotPasswordPage() {
  const [busy, setBusy] = useState(false); const [message, setMessage] = useState<string | null>(null)
  async function submit(event: FormEvent<HTMLFormElement>) { event.preventDefault(); setBusy(true); const data = new FormData(event.currentTarget); try { await requestPasswordRecovery(String(data.get('email'))); setMessage('If that invited account exists, a six-digit recovery code has been sent.') } catch (error) { setMessage(await readableApiError(error)) } finally { setBusy(false) } }
  return <AdminAuthShell title="Recover Admin access" description="A short-lived, single-use code is sent only to an existing invited account."><form onSubmit={submit}>{message && <StatusMessage>{message}</StatusMessage>}<Field label="Email address" name="email" type="email" autoComplete="email" required /><Button className="w-full" type="submit" disabled={busy}>{busy ? 'Requesting…' : 'Send recovery code'}</Button><Link className="admin-return admin-return--centered" to="/reset-password">I already have a code</Link><Link className="admin-return admin-return--centered" to="/login">Back to sign in</Link></form></AdminAuthShell>
}

export function AdminResetPasswordPage() {
  const navigate = useNavigate(); const [searchParams] = useSearchParams(); const [busy, setBusy] = useState(false); const [message, setMessage] = useState<string | null>(null)
  async function submit(event: FormEvent<HTMLFormElement>) { event.preventDefault(); setBusy(true); setMessage(null); const data = new FormData(event.currentTarget); try { await resetPassword(String(data.get('email')), String(data.get('code')), String(data.get('password')), String(data.get('password_confirmation'))); navigate('/login?reset=success', { replace: true }) } catch (error) { setMessage(await readableApiError(error)) } finally { setBusy(false) } }
  return <AdminAuthShell title="Set a new password" description="Changing the password revokes prior sessions."><form onSubmit={submit}>{message && <StatusMessage tone="error">{message}</StatusMessage>}<Field label="Email address" name="email" type="email" defaultValue={searchParams.get('email') ?? ''} autoComplete="email" required /><Field label="Six-digit recovery code" name="code" inputMode="numeric" autoComplete="one-time-code" pattern="[0-9]{6}" maxLength={6} required /><Field label="New password" name="password" type="password" autoComplete="new-password" minLength={14} required /><Field label="Confirm new password" name="password_confirmation" type="password" autoComplete="new-password" minLength={14} required /><Button className="w-full" type="submit" disabled={busy}>{busy ? 'Updating…' : 'Update password'}</Button></form></AdminAuthShell>
}
