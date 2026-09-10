import { AccountType, AuthenticationApi, Configuration, ResponseError } from '@materyalph/api-client-ts'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'

async function withWebAuthApi<T>(operation: (api: AuthenticationApi) => Promise<T>): Promise<T> {
  const bootstrap = new AuthenticationApi(new Configuration({ basePath, credentials: 'include' }))
  const csrf = await bootstrap.issueWebCsrfToken()
  const api = new AuthenticationApi(new Configuration({ basePath, credentials: 'include', apiKey: csrf.data.csrfToken }))
  return operation(api)
}

export function signInAdmin(email: string, password: string) {
  return withWebAuthApi((api) => api.login({ loginRequest: { email, password, portal: AccountType.Admin } }))
}

export function acceptAdminInvitation(input: { token: string; fullName: string; password: string; passwordConfirmation: string }) {
  return withWebAuthApi((api) => api.acceptAdminInvitation({ adminInvitationRequest: { ...input, termsAccepted: true, privacyAccepted: true } }))
}

export function getMfaStatus() {
  return new AuthenticationApi(new Configuration({ basePath, credentials: 'include' })).getMfaChallengeStatus()
}

export function getSession() {
  return new AuthenticationApi(new Configuration({ basePath, credentials: 'include' })).getSession()
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

export function requestPasswordRecovery(email: string) {
  return withWebAuthApi((api) => api.requestPasswordRecovery({
    passwordRecoveryRequest: { email, portal: AccountType.Admin },
  }))
}

export function resetPassword(email: string, code: string, password: string, passwordConfirmation: string) {
  return withWebAuthApi((api) => api.resetPassword({ passwordResetRequest: { email, code, password, passwordConfirmation } }))
}

export async function readableApiError(error: unknown): Promise<string> {
  if (error instanceof ResponseError) {
    const payload: unknown = await error.response.clone().json().catch(() => null)
    if (typeof payload === 'object' && payload !== null && 'errors' in payload && Array.isArray(payload.errors)) {
      const first = payload.errors[0] as { message?: unknown } | undefined
      if (typeof first?.message === 'string') return first.message
    }
  }
  return error instanceof Error ? error.message : 'The request could not be completed. Check your connection and try again.'
}
