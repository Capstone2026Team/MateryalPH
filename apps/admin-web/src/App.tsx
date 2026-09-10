import { Button, Field, StatusMessage } from '@materyalph/web-ui'
import { ArrowRight, ShieldCheck } from 'lucide-react'
import { type FormEvent, useEffect, useMemo, useState } from 'react'
import { BrowserRouter, Link, Route, Routes, useNavigate, useSearchParams } from 'react-router-dom'

import { AdminAuthShell } from './components/AdminAuthShell'
import { acceptAdminInvitation, getSession, readableApiError, signInAdmin } from './lib/auth-api'
import { AdminForgotPasswordPage, AdminMfaPage, AdminResetPasswordPage } from './pages/AuthSupportPages'
import './App.css'

function App() {
  return <BrowserRouter><Routes><Route path="/" element={<AdminLogin />} /><Route path="/login" element={<AdminLogin />} /><Route path="/accept-invite" element={<AcceptInvite />} /><Route path="/forgot-password" element={<AdminForgotPasswordPage />} /><Route path="/reset-password" element={<AdminResetPasswordPage />} /><Route path="/auth/mfa" element={<AdminMfaPage />} /><Route path="/workspace" element={<WorkspaceEmpty />} /><Route path="*" element={<AdminLogin />} /></Routes></BrowserRouter>
}

function AdminLogin() {
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setBusy(true); setMessage(null)
    const data = new FormData(event.currentTarget)
    try {
      const response = await signInAdmin(String(data.get('email')), String(data.get('password')))
      navigate(response.data.mfaRequired ? '/auth/mfa' : '/workspace')
    } catch (error) { setMessage(await readableApiError(error)) }
    finally { setBusy(false) }
  }

  const successMessage = searchParams.get('reset') === 'success' ? 'Password updated. Sign in with your new password.' : null
  return <AdminAuthShell title="Welcome back" description="Sign in with your invited Admin account."><form onSubmit={submit}>{successMessage && <StatusMessage tone="success">{successMessage}</StatusMessage>}{message && <StatusMessage tone="error">{message}</StatusMessage>}<Field label="Email address" name="email" type="email" autoComplete="email" required /><Field label="Password" name="password" type="password" autoComplete="current-password" required /><div className="admin-help"><span>Access attempts are audited.</span><Link to="/forgot-password">Forgot password?</Link></div><Button className="w-full" type="submit" disabled={busy}>{busy ? 'Verifying access…' : 'Sign in securely'} <ArrowRight aria-hidden="true" /></Button></form><p className="admin-footnote">Admin accounts are invitation-only. There is no public registration route.</p></AdminAuthShell>
}

function AcceptInvite() {
  const [searchParams] = useSearchParams()
  const navigate = useNavigate()
  const token = useMemo(() => searchParams.get('token') ?? '', [searchParams])
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'error' | 'success'; text: string } | null>(null)
  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setBusy(true); setMessage(null)
    const data = new FormData(event.currentTarget)
    try {
      await acceptAdminInvitation({ token, fullName: String(data.get('full_name')), password: String(data.get('password')), passwordConfirmation: String(data.get('password_confirmation')) })
      setMessage({ tone: 'success', text: 'Admin account created. Continue to sign in and enroll multi-factor authentication.' })
      window.setTimeout(() => navigate('/login'), 1200)
    } catch (error) { setMessage({ tone: 'error', text: await readableApiError(error) }) }
    finally { setBusy(false) }
  }
return <AdminAuthShell title="Accept your Admin invitation" description="This one-time link creates an invited staff identity. Multi-factor enrollment is required next.">{token ? <form onSubmit={submit}>{message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}<Field label="Full name" name="full_name" autoComplete="name" required /><Field label="Password" name="password" type="password" autoComplete="new-password" minLength={14} hint="At least 14 characters with uppercase, lowercase, and a number." required /><Field label="Confirm password" name="password_confirmation" type="password" autoComplete="new-password" minLength={14} required /><label className="admin-consent"><input type="checkbox" required /> I accept the versioned Terms of Service.</label><label className="admin-consent"><input type="checkbox" required /> I acknowledge the separate Privacy Notice.</label><Button className="w-full" type="submit" disabled={busy}>{busy ? 'Creating account…' : 'Create Admin account'}</Button></form> : <><StatusMessage tone="error">The invitation token is missing. Open the complete link from your invitation email.</StatusMessage><Link className="admin-return admin-return--centered" to="/login">Return to sign in</Link></>}</AdminAuthShell>
}

function WorkspaceEmpty() {
  const navigate = useNavigate(); const [ready, setReady] = useState(false)
  useEffect(() => { let active = true; void getSession().then(() => { if (active) setReady(true) }).catch(() => navigate('/login', { replace: true })); return () => { active = false } }, [navigate])
  return <main className="workspace-empty"><img src="/brand/materyalph-logo.png" alt="MateryalPH Admin Portal" /><div><ShieldCheck aria-hidden="true" /><h1>{ready ? 'Admin foundation ready' : 'Checking your session…'}</h1><p>{ready ? 'Your identity is authenticated. Operational review queues are introduced in their approved later phases; no placeholder decisions are available here.' : 'Securely restoring your Admin session.'}</p><Link className="admin-return" to="/login">Return to sign in</Link></div></main>
}

export default App
