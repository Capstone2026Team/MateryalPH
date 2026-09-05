# Design tokens

`tokens.json` is the canonical source approved by the UI/UX planner. Run `npm run generate` after changing it and commit both generated outputs. Run `npm run check` in CI to detect drift.

Web clients import `web.css`; Tailwind 4 consumes its shared `@theme` aliases. Flutter consumes the checked-in generated Dart constants under `apps/buyer-mobile/lib/design_system/generated/`.
