export function recoveryCodesDocument(codes: readonly string[]): string {
  return [
    'MateryalPH Vendor Account Recovery Codes',
    '',
    'Each recovery code works once.',
    'Store these codes securely and offline.',
    '',
    ...codes,
    '',
  ].join('\n')
}

export function downloadRecoveryCodes(codes: readonly string[]): void {
  const url = URL.createObjectURL(new Blob([recoveryCodesDocument(codes)], { type: 'text/plain;charset=utf-8' }))
  try {
    const link = document.createElement('a')
    link.href = url
    link.download = 'MateryalPH-Recovery-Codes.txt'
    link.click()
  } finally {
    URL.revokeObjectURL(url)
  }
}
