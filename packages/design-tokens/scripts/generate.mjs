import { mkdir, readFile, writeFile } from 'node:fs/promises'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const packageRoot = resolve(dirname(fileURLToPath(import.meta.url)), '..')
const repositoryRoot = resolve(packageRoot, '../..')
const tokens = JSON.parse(await readFile(resolve(packageRoot, 'tokens.json'), 'utf8'))
const generatedHeader = '/* @generated from tokens.json — do not edit directly. */'

const rootVariables = [
  ...Object.entries(tokens.color).map(([name, value]) => `  --mp-color-${name}: ${value};`),
  `  --mp-font-sans: ${tokens.font.sans};`,
  ...Object.entries(tokens.text).flatMap(([name, value]) => [
    `  --mp-text-${name}: ${value.size};`,
    `  --mp-leading-${name}: ${value.lineHeight};`,
    `  --mp-font-weight-${name}: ${value.weight};`,
  ]),
  ...Object.entries(tokens.radius).map(([name, value]) => `  --mp-radius-${name}: ${value};`),
  ...Object.entries(tokens.shadow).map(([name, value]) => `  --mp-shadow-${name}: ${value};`),
]

const themeVariables = [
  ...Object.keys(tokens.color).map((name) => `  --color-${name}: var(--mp-color-${name});`),
  '  --font-sans: var(--mp-font-sans);',
  ...Object.keys(tokens.text).flatMap((name) => [
    `  --text-${name}: var(--mp-text-${name});`,
    `  --text-${name}--line-height: var(--mp-leading-${name});`,
    `  --text-${name}--font-weight: var(--mp-font-weight-${name});`,
  ]),
  ...Object.keys(tokens.radius).map((name) => `  --radius-${name}: var(--mp-radius-${name});`),
  ...Object.keys(tokens.shadow).map((name) => `  --shadow-${name}: var(--mp-shadow-${name});`),
]

const webCss = `${generatedHeader}\n:root {\n${rootVariables.join('\n')}\n}\n\n@theme inline {\n${themeVariables.join('\n')}\n}\n`

const toDartName = (name) => name.replace(/-([a-z0-9])/g, (_, character) => character.toUpperCase())
const dartColors = Object.entries(tokens.color)
  .filter(([, value]) => /^#[0-9A-F]{6}$/i.test(value))
  .map(([name, value]) => `  static const int ${toDartName(name)} = 0xFF${value.slice(1).toUpperCase()};`)
const dart = `// @generated from tokens.json — do not edit directly.\nabstract final class MateryalColorTokens {\n${dartColors.join('\n')}\n}\n`

const outputs = [
  [resolve(packageRoot, 'web.css'), webCss],
  [resolve(repositoryRoot, 'apps/buyer-mobile/lib/design_system/generated/color_tokens.dart'), dart],
]

if (process.argv.includes('--check')) {
  let drifted = false
  for (const [path, expected] of outputs) {
    const actual = await readFile(path, 'utf8').catch(() => '')
    if (actual !== expected) {
      console.error(`Generated token output is stale: ${path}`)
      drifted = true
    }
  }
  process.exitCode = drifted ? 1 : 0
} else {
  await Promise.all(outputs.map(async ([path, contents]) => {
    await mkdir(dirname(path), { recursive: true })
    await writeFile(path, contents, 'utf8')
  }))
}
