import {
  AccountType,
  AuthenticationApi,
  Configuration,
  ResponseError,
  type VendorBotProtectionEvidence,
  type RegisterRequest,
} from '@materyalph/api-client-ts'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'

export async function withWebAuthApi<T>(operation: (api: AuthenticationApi) => Promise<T>): Promise<T> {
  const bootstrap = new AuthenticationApi(new Configuration({ basePath, credentials: 'include' }))
  const csrf = await bootstrap.issueWebCsrfToken()
  const csrfToken = csrf.data.csrfToken
  const api = new AuthenticationApi(new Configuration({
    basePath,
    credentials: 'include',
    apiKey: csrfToken,
  }))

  return operation(api)
}

export type RiskChallenge = { id: string; expiresAt: string; resendAfterSeconds: number }

export type ValidationFieldErrors = Readonly<Record<string, readonly string[]>>

export type ValidationFailure = {
  message: string
  fieldErrors: ValidationFieldErrors
}

export class BotStepUpRequired extends Error {
  constructor(public readonly challenge: RiskChallenge) {
    super('Email risk verification is required.')
    this.name = 'BotStepUpRequired'
  }
}

export async function signIn(email: string, password: string, botProtection?: VendorBotProtectionEvidence) {
  return withWebAuthApi((api) => api.login({
    loginRequest: { email, password, portal: AccountType.Vendor, botProtection: botProtection ?? null },
  }))
}

export function getMfaStatus() {
  return new AuthenticationApi(new Configuration({ basePath, credentials: 'include' })).getMfaChallengeStatus()
}

export function getSession() {
  return new AuthenticationApi(new Configuration({ basePath, credentials: 'include' })).getSession()
}

export function signOut() {
  return withWebAuthApi((api) => api.logout())
}

export function startMfaEnrollment() {
  return withWebAuthApi((api) => api.startMfaEnrollment())
}

export function confirmMfaEnrollment(code: string) {
  return withWebAuthApi((api) => api.confirmMfaEnrollment({ mfaCodeRequest: { code } }))
}

export function completeMfaChallenge(code: string) {
  return withWebAuthApi((api) => api.completeMfaChallenge({ mfaCodeRequest: { code } }))
}

export function recoverMfaChallenge(recoveryCode: string) {
  return withWebAuthApi((api) => api.recoverMfaChallenge({ mfaRecoveryRequest: { recoveryCode } }))
}

export function requestPasswordRecovery(email: string, botProtection?: VendorBotProtectionEvidence) {
  return withWebAuthApi((api) => api.requestPasswordRecovery({
    passwordRecoveryRequest: {
      email,
      portal: AccountType.Vendor,
      botProtection: botProtection ?? null,
    },
  }))
}

export function verifyRiskChallenge(challengeId: string, email: string, code: string) {
  return withWebAuthApi((api) => api.verifyBotChallenge({
    challengeId,
    verifyBotChallengeRequest: { email, code },
  }))
}

export function resendRiskChallenge(challengeId: string, email: string) {
  return withWebAuthApi((api) => api.resendBotChallenge({
    challengeId,
    resendBotChallengeRequest: { email },
  }))
}

export function resetPassword(email: string, code: string, password: string, passwordConfirmation: string) {
  return withWebAuthApi((api) => api.resetPassword({ passwordResetRequest: { email, code, password, passwordConfirmation } }))
}

export function verifyVendorEmail(email: string, code: string) {
  return withWebAuthApi((api) => api.verifyEmail({ verifyEmailRequest: { email, code } }))
}

export function resendVendorVerification(email: string) {
  return withWebAuthApi((api) => api.resendEmailVerification({ emailRequest: { email } }))
}

export async function startGoogleRegistration(input: { mobileE164: string; businessName: string }) {
  const response = await withWebAuthApi((api) => api.startGoogleOidc({
    googleOidcStartRequest: {
      portal: AccountType.Vendor,
      mode: 'SIGN_UP',
      mobileE164: input.mobileE164,
      businessName: input.businessName,
      termsAccepted: true,
      privacyAccepted: true,
    },
  }))
  const authorizationUrl = response.data.authorization_url
  if (typeof authorizationUrl !== 'string') throw new Error('Google registration did not return a destination.')
  window.location.assign(authorizationUrl)
}

export async function registerVendor(request: Omit<RegisterRequest, 'botProtection'>, botProtection?: VendorBotProtectionEvidence) {
  return withWebAuthApi((api) => api.registerAccount({
    registerRequest: { ...request, botProtection: botProtection ?? null },
  }))
}

export async function startGoogleSignIn() {
  const response = await withWebAuthApi((api) => api.startGoogleOidc({
    googleOidcStartRequest: { portal: AccountType.Vendor, mode: 'SIGN_IN' },
  }))
  const authorizationUrl = response.data.authorization_url
  if (typeof authorizationUrl !== 'string') throw new Error('Google sign-in did not return a destination.')
  window.location.assign(authorizationUrl)
}

export async function readableApiError(error: unknown): Promise<string> {
  if (error instanceof ResponseError) {
    const payload: unknown = await error.response.clone().json().catch(() => null)
    const first = firstApiError(payload)
    if (first && typeof first.message === 'string') return first.message
  }
  if (error instanceof Error) return error.message
  return 'The request could not be completed. Check your connection and try again.'
}

export async function asValidationFailure(error: unknown): Promise<ValidationFailure | null> {
  if (!(error instanceof ResponseError) || error.response.status !== 422) return null
  const payload: unknown = await error.response.clone().json().catch(() => null)
  const first = firstApiError(payload)
  if (!first || first.code !== 'VALIDATION_FAILED' || typeof first.message !== 'string') return null

  return {
    message: first.message,
    fieldErrors: safeValidationFieldErrors(first.details),
  }
}

export async function asBotStepUpRequired(error: unknown): Promise<BotStepUpRequired | null> {
  if (!(error instanceof ResponseError) || error.response.status !== 403) return null
  const payload: unknown = await error.response.clone().json().catch(() => null)
  if (!isBotStepUpEnvelope(payload)) return null
  const first = payload.errors[0]
  if (first?.code !== 'BOT_STEP_UP_REQUIRED') return null
  const { challenge_id: id, expires_at: expiresAt, resend_after_seconds: resendAfterSeconds } = first.details
  if (typeof id !== 'string' || typeof expiresAt !== 'string' || typeof resendAfterSeconds !== 'number') return null
  return new BotStepUpRequired({ id, expiresAt, resendAfterSeconds })
}

function isApiErrorEnvelope(value: unknown): value is { errors: Array<{ message: string }> } {
  return typeof value === 'object' && value !== null && 'errors' in value && Array.isArray(value.errors)
}

function firstApiError(value: unknown): { code?: unknown; message?: unknown; details?: unknown } | null {
  if (!isApiErrorEnvelope(value)) return null
  const first: unknown = value.errors[0]
  return typeof first === 'object' && first !== null ? first : null
}

function safeValidationFieldErrors(details: unknown): ValidationFieldErrors {
  if (typeof details !== 'object' || details === null || Array.isArray(details)) return {}

  const fieldErrors: Record<string, readonly string[]> = Object.create(null) as Record<string, readonly string[]>
  for (const [field, value] of Object.entries(details)) {
    if (!/^[A-Za-z0-9_.-]{1,128}$/.test(field) || !Array.isArray(value)) continue
    const messages = value.filter((message): message is string => typeof message === 'string' && message.trim() !== '')
    if (messages.length > 0) fieldErrors[field] = messages
  }

  return fieldErrors
}

function isBotStepUpEnvelope(value: unknown): value is {
  errors: Array<{ code: string; details: { challenge_id: unknown; expires_at: unknown; resend_after_seconds: unknown } }>
} {
  if (!isApiErrorEnvelope(value)) return false
  const first = value.errors[0]
  return typeof first === 'object' && first !== null && 'code' in first && 'details' in first
    && typeof first.details === 'object' && first.details !== null
}
