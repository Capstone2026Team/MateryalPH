import { expect, test } from '@playwright/test'

const surfaces = [
  { portal: 'Vendor', base: 'http://127.0.0.1:4173', routes: ['/login', '/register', '/register/google', '/verify-email', '/forgot-password', '/reset-password', '/auth/mfa'] },
  { portal: 'Admin', base: 'http://127.0.0.1:4174', routes: ['/login', '/accept-invite', '/accept-invite?token=layout-test-only', '/forgot-password', '/reset-password', '/auth/mfa'] },
]

for (const surface of surfaces) {
  for (const route of surface.routes) {
    test(`${surface.portal} ${route} reflows and keeps keyboard controls reachable`, async ({ page }) => {
      await page.route('**/api/v1/**', (request) => request.fulfill({
        status: 503, contentType: 'application/json',
        body: JSON.stringify({ data: null, meta: {}, errors: [{ code: 'UNAVAILABLE', message: 'The service is temporarily unavailable.' }] }),
      }))
      await page.emulateMedia({ reducedMotion: 'reduce' })
      await page.goto(`${surface.base}${route}`)
      await expect(page.locator('main')).toBeVisible()
      await expect(page.locator('h2')).toBeVisible()
      const overflow = await page.evaluate(() => document.documentElement.scrollWidth - document.documentElement.clientWidth)
      expect(overflow).toBeLessThanOrEqual(1)
      await page.keyboard.press('Tab')
      const focused = page.locator(':focus')
      await expect(focused).toBeVisible()
      expect(await focused.evaluate((element) => getComputedStyle(element).outlineStyle)).not.toBe('none')
      if (surface.portal === 'Admin') {
        await expect(page.locator('script[src*="recaptcha"]')).toHaveCount(0)
        await expect(page.getByText('Use an email security check instead')).toHaveCount(0)
      }
    })
  }
}
