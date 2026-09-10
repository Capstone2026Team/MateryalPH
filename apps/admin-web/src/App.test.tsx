import { fireEvent, render, screen } from '@testing-library/react'
import { beforeEach, describe, expect, test } from 'vitest'

import App from './App'

describe('Admin authentication portal', () => {
  beforeEach(() => window.history.replaceState({}, '', '/login'))

  test('keeps Admin access invitation-only', () => {
    render(<App />)

    expect(screen.getByRole('heading', { name: 'Welcome back' })).toBeVisible()
    expect(screen.getByText(/invitation-only/i)).toBeVisible()
    expect(screen.queryByRole('link', { name: /register/i })).not.toBeInTheDocument()
    expect(screen.getByRole('button', { name: /sign in securely/i })).toBeEnabled()
  })

  test('connects password recovery to a real route', () => {
    render(<App />)
    fireEvent.click(screen.getByRole('link', { name: 'Forgot password?' }))

    expect(screen.getByRole('heading', { name: /recover admin access/i })).toBeVisible()
    expect(screen.getByRole('textbox', { name: /email address/i })).toBeRequired()
  })
})
