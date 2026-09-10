import type { ReactNode } from 'react'

export function StatusMessage({ children, tone = 'info' }: { children: ReactNode; tone?: 'info' | 'error' | 'success' }) {
  const toneClass = tone === 'error'
    ? 'border-status-error/30 bg-red-50 text-red-900'
    : tone === 'success'
      ? 'border-status-success/30 bg-green-50 text-green-900'
      : 'border-status-info/30 bg-blue-50 text-blue-900'

  return <div className={`rounded-surface border px-4 py-3 text-sm ${toneClass}`} role={tone === 'error' ? 'alert' : 'status'}>{children}</div>
}
