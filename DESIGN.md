# MateryalPH design context

## Direction

Use a light-first, industrial construction visual language: strong hierarchy, measured spacing, clear dividers, purposeful icons, and limited ornament. Avoid decorative gradients, glow effects, generic dashboard collages, nested-card-heavy layouts, bounce/elastic motion, gray text on colored surfaces, and unlabeled icon controls.

The Figma prototype is a composition reference. The workflows and UI/UX implementation planner control behavior, terminology, states, accessibility, and provider policy.

## Brand foundation

- Typeface: Inter with controlled local/system fallbacks; do not fetch it at runtime from an unapproved third party.
- Central brand accent: `brand.orange.500` (`#F97316`).
- Filled action with white text: `action.primary` (`#C2410C`), pressed `action.primary.pressed` (`#9A3412`).
- Primary text: `text.strong`; supporting text: `text.secondary` on light surfaces only.
- Page surface: `surface.canvas`; primary surface: `surface.primary`; borders: `border.default`.
- Keyboard focus: `focus.ring`, independent of brand selection state.

The canonical machine-readable values are in `packages/design-tokens/tokens.json`. Feature code uses semantic utilities or component APIs, not unexplained raw colors.

## Type and spacing

Use the approved Display, H1, H2, H3, Body large, Body, Body strong, Label, and Caption styles. Sentence case is the default. The base spacing unit is 4 px with the approved 4–64 px scale. Routine mobile targets should be 44×44 px; never go below WCAG's 24×24 CSS-pixel minimum.

## Layout and interaction

- Prefer one clear surface with spacing, dividers, and section headings before adding another card.
- Present one dominant filled action per decision area.
- Every surface handles relevant loading, empty, validation, unauthorized, offline/provider failure, retry, and success states.
- Status always has text or icon meaning in addition to color.
- Timers also show the exact date and time.
- Motion explains a state change, is cancelled when stale, and is removed or reduced under reduced-motion settings.

## Maps

Every map has a synchronized accessible list/table alternative. Tier 2 labels show store name plus VPS or New Vendor; Tier 1 labels show store name plus Directory. Never label a Google rating as VPS. A selected Tier 2 marker may reveal one decision route and preview with an explicit View Store action. Tier 1 opens attributed Place Details only. Never imply live GPS or animate a delivery vehicle.

## Review workflow

Impeccable is diagnostic only. For significant surfaces, use shape, critique, harden, animate, audit, and polish as appropriate, then run deterministic detection. The only approved shared detector exception is the exact `overused-font` value `Inter`, because Inter is the approved MateryalPH brand typeface.
