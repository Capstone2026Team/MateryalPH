import { expect, test } from '@playwright/test'

test('phone selection preserves the national number and submits one international value', async ({ page }) => {
  await page.goto('/register/google')
  const country = page.getByRole('combobox', { name: 'Mobile number country code' })
  const number = page.getByRole('textbox', { name: 'Mobile number' })
  await expect(country).toHaveValue('PH')
  await expect(number).toHaveValue('')
  await number.fill('0917 123 4567')
  await expect(page.locator('input[name="mobile"]')).toHaveValue('+639171234567')
  await country.selectOption('SG')
  await number.fill('91234567')
  await expect(page.locator('input[name="mobile"]')).toHaveValue('+6591234567')
  await number.fill('+44 7700 900123')
  await expect(country).toHaveValue('GB')
  await expect(number).toHaveValue('7700900123')
  expect(await number.evaluate((input: HTMLInputElement) => input.checkValidity())).toBe(true)
  expect((await country.boundingBox())!.height).toBeGreaterThanOrEqual(44)
  expect(await page.evaluate(() => document.documentElement.scrollWidth - innerWidth)).toBeLessThanOrEqual(1)
})

test('Vendor and Admin share logo spacing, column geometry and heading alignment', async ({ page }) => {
  const measurements = []
  for (const url of ['http://127.0.0.1:4173/login', 'http://127.0.0.1:4174/login']) {
    await page.route('**/api/v1/**', route => route.fulfill({ status: 503, contentType: 'application/json', body: '{"data":null,"meta":{},"errors":[]}' }))
    await page.goto(url)
    await page.evaluate(() => document.fonts.ready)
    const brand = page.locator('a:visible').filter({ has: page.locator('img[src="/brand/materyalph-logo.png"]') }).first()
    const logo = await brand.locator('img').boundingBox()
    const label = await brand.locator('span > span').boundingBox()
    const heading = await page.locator('h1').boundingBox()
    measurements.push({ logo, label, heading })
  }
  const [vendor, admin] = measurements
  expect(vendor.logo!.width).toBe(48)
  expect(admin.logo!.width).toBe(48)
  expect(vendor.label!.x - vendor.logo!.x - vendor.logo!.width).toBe(12)
  expect(admin.label!.x - admin.logo!.x - admin.logo!.width).toBe(12)
  expect(admin.heading!.x).toBeCloseTo(vendor.heading!.x, 0)
  expect(admin.heading!.y).toBeCloseTo(vendor.heading!.y, 0)
  expect(admin.heading!.width).toBeCloseTo(vendor.heading!.width, 0)
})
