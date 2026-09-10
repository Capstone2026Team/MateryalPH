import { defineConfig } from '@playwright/test'

const viewports = [
  { name: 'chromium-320', width: 320, height: 568 },
  { name: 'chromium-1920', width: 1920, height: 1080 },
  { name: 'chromium-1440', width: 1440, height: 1000 },
  { name: 'chromium-1280', width: 1280, height: 900 },
  { name: 'chromium-1024', width: 1024, height: 768 },
  { name: 'chromium-768', width: 768, height: 1024 },
  { name: 'chromium-390', width: 390, height: 844 },
  { name: 'chromium-375', width: 375, height: 812 },
] as const

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: Boolean(process.env.CI),
  retries: process.env.CI ? 2 : 0,
  workers: 2,
  reporter: [
    ['list'],
    ['html', { open: 'never' }],
  ],
  outputDir: 'test-results',
  use: {
    baseURL: 'http://127.0.0.1:4173',
    browserName: 'chromium',
    colorScheme: 'light',
    screenshot: 'only-on-failure',
    trace: 'retain-on-failure',
  },
  projects: viewports.map(({ name, width, height }) => ({
    name,
    use: {
      viewport: { width, height },
      hasTouch: width <= 390,
      isMobile: width <= 390,
    },
  })),
  webServer: [{
    command: 'npm run preview -- --host 127.0.0.1 --port 4173',
    url: 'http://127.0.0.1:4173',
    reuseExistingServer: !process.env.CI,
    timeout: 120_000,
  }, {
    command: 'npm --prefix ../admin-web run preview -- --host 127.0.0.1 --port 4174',
    url: 'http://127.0.0.1:4174',
    reuseExistingServer: !process.env.CI,
    timeout: 120_000,
  }],
})
