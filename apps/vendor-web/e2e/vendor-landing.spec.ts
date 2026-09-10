import { expect, test } from '@playwright/test'

test('Vendor landing remains usable, truthful, and responsive', async ({ page }) => {
  await page.goto('/')

  await expect(page.getByRole('heading', { name: 'Turn project demand into dependable store growth.' })).toBeVisible()

  const skipLink = page.getByRole('link', { name: 'Skip to content' })
  await page.keyboard.press('Tab')
  await expect(skipLink).toBeFocused()
  await expect(skipLink).toBeVisible()

  const navigation = page.getByRole('navigation', { name: 'Vendor portal' })
  const menuButton = page.getByRole('button', { name: 'Open navigation' })
  const viewport = page.viewportSize()
  expect(viewport).not.toBeNull()

  if ((viewport?.width ?? 0) <= 1120) {
    await expect(menuButton).toBeVisible()
    await expect(navigation).toBeHidden()
    const menuBounds = await page.locator('.menu-button').boundingBox()
    expect(menuBounds?.width).toBeGreaterThanOrEqual(44)
    expect(menuBounds?.height).toBeGreaterThanOrEqual(44)
    await menuButton.click()
    const closeButton = page.getByRole('button', { name: 'Close navigation' })
    await expect(closeButton).toHaveAttribute('aria-expanded', 'true')
    await expect(navigation).toBeVisible()
    await closeButton.click()
    await expect(navigation).toBeHidden()
  } else {
    await expect(menuButton).toBeHidden()
    await expect(navigation).toBeVisible()
  }

  await expect(page.locator('#site-navigation a[href="/login"]')).toHaveAttribute('href', '/login')
  await expect(page.locator('#site-navigation a[href="/register"]')).toHaveAttribute('href', '/register')

  const primaryCta = page.locator('.hero__actions').getByRole('link', { name: 'Register your store' })
  await expect(primaryCta).toHaveAttribute('href', '/register')
  const primaryCtaBounds = await primaryCta.boundingBox()
  expect(primaryCtaBounds?.height).toBeGreaterThanOrEqual(44)
  await expect(page.getByRole('link', { name: 'Start registration' })).toHaveAttribute('href', '/register')

  const fees = page.locator('#payments-fees')
  await expect(fees.getByRole('heading', { name: 'Plain-language payments and fees, before you commit' })).toBeVisible()
  await expect(fees.getByText(/approved Vendor-paid platform commission is/)).toContainText('2%')
  await expect(fees.getByText(/Third-party processing fees are distinct/)).toContainText('not assigned an invented percentage')
  await expect(fees.getByText('TEST/DEMO only')).toBeVisible()

  const faq = page.locator('details').filter({ hasText: 'When is the 2% commission charged?' })
  await faq.getByText('When is the 2% commission charged?', { exact: true }).click()
  await expect(faq).toHaveAttribute('open', '')
  await expect(faq.getByText(/included in monthly Vendor billing/)).toBeVisible()

  const overflow = await page.evaluate(() => Math.max(
    document.documentElement.scrollWidth - document.documentElement.clientWidth,
    document.body.scrollWidth - document.body.clientWidth,
  ))
  expect(overflow).toBeLessThanOrEqual(1)

  await page.getByRole('link', { name: 'Start registration' }).click()
  await expect(page).toHaveURL(/\/register$/)
  await expect(page.getByRole('heading', { name: 'Register your store' })).toBeVisible()
})
