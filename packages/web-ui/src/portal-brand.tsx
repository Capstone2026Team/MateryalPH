/** Identical logo footprint, divider and label spacing for both web portals. */
export function PortalBrand({ label }: { label: string }) {
  return <span className="inline-flex items-center gap-3 text-sm font-semibold text-text-strong">
    <img className="h-12 w-12 shrink-0 object-contain" src="/brand/materyalph-logo.png" alt="MateryalPH" width={48} height={48} />
    <span className="border-l border-border-default pl-3">{label}</span>
  </span>
}
