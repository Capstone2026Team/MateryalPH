import { ResponseError } from '@materyalph/api-client-ts'
import { afterEach, describe, expect, test, vi } from 'vitest'

import { asValidationFailure, signOut } from './auth-api'

afterEach(() => vi.unstubAllGlobals())

describe('Vendor auth API errors', () => {
  test('retains only safe Laravel validation field messages', async () => {
    const error = new ResponseError(new Response(JSON.stringify({
      data: null,
      meta: {},
      errors: [{
        code: 'VALIDATION_FAILED',
        message: 'Review the highlighted fields and try again.',
        details: {
          full_name: ['Enter the Vendor Owner name.'],
          'bot_protection.recaptcha_token': ['Complete the security checkbox again.'],
          'unsafe field name!': ['Must not be retained.'],
          email: { internal: 'Must not be retained.' },
        },
      }],
    }), { status: 422, headers: { 'Content-Type': 'application/json' } }))

    await expect(asValidationFailure(error)).resolves.toEqual({
      message: 'Review the highlighted fields and try again.',
      fieldErrors: {
        full_name: ['Enter the Vendor Owner name.'],
        'bot_protection.recaptcha_token': ['Complete the security checkbox again.'],
      },
    })
  })

  test('does not treat unrelated API errors as validation details', async () => {
    const error = new ResponseError(new Response(JSON.stringify({
      data: null,
      meta: {},
      errors: [{ code: 'INTERNAL_ERROR', message: 'The request could not be completed.', details: { trace: ['hidden'] } }],
    }), { status: 500, headers: { 'Content-Type': 'application/json' } }))

    await expect(asValidationFailure(error)).resolves.toBeNull()
  })
})

describe('Vendor auth API transport', () => {
  test('logs out through the CSRF-protected credentialed browser endpoint', async () => {
    const fetchMock = vi.fn()
      .mockResolvedValueOnce(jsonResponse({
        data: { csrf_token: 'test-csrf-token' },
        meta: {},
        errors: [],
      }))
      .mockResolvedValueOnce(jsonResponse({
        data: { logged_out: true },
        meta: {},
        errors: [],
      }))
    vi.stubGlobal('fetch', fetchMock)

    await signOut()

    expect(fetchMock).toHaveBeenCalledTimes(2)
    expect(fetchMock.mock.calls[0]).toEqual([
      'http://localhost:8080/api/v1/auth/csrf',
      expect.objectContaining({ method: 'GET', credentials: 'include' }),
    ])
    expect(fetchMock.mock.calls[1]).toEqual([
      'http://localhost:8080/api/v1/auth/logout',
      expect.objectContaining({
        method: 'POST',
        credentials: 'include',
        headers: expect.objectContaining({ 'X-CSRF-Token': 'test-csrf-token' }),
      }),
    ])
  })
})

function jsonResponse(body: unknown): Response {
  return new Response(JSON.stringify(body), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  })
}
