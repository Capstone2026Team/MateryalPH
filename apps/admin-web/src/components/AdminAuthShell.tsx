import { PortalBrand } from '@materyalph/web-ui'
import { BadgeCheck, FileCheck2, LockKeyhole, ShieldCheck } from 'lucide-react'
import type { ReactNode } from 'react'
import { Link } from 'react-router-dom'

export function AdminAuthShell({ title, description, children }: { title: string; description: string; children: ReactNode }) {
  return <main className="admin-auth">
    <section className="admin-story" aria-label="Admin portal safeguards"><Link className="portal-brand-link" to="/"><PortalBrand label="Admin Portal" /></Link><div><h2>Careful decisions.<br />Lasting trust.</h2><p>Review marketplace evidence, enforce approved workflows, and keep high-impact decisions traceable.</p><ul><li><ShieldCheck aria-hidden="true" /><span><strong>Deny-by-default access</strong> Role and assignment checks remain server-side.</span></li><li><FileCheck2 aria-hidden="true" /><span><strong>Reasoned review</strong> Decisions preserve evidence, actor, state, and reason.</span></li><li><LockKeyhole aria-hidden="true" /><span><strong>Immutable audit trail</strong> Sensitive actions are correlated and append-only.</span></li></ul></div><small>Private operations surface · Authorized staff only</small></section>
    <section className="admin-panel"><div className="admin-form-wrap"><Link className="admin-mobile-logo portal-brand-link" to="/"><PortalBrand label="Admin Portal" /></Link><h1>{title}</h1><p>{description}</p><div className="secure-note"><BadgeCheck aria-hidden="true" /> Authorized accounts only</div>{children}</div></section>
  </main>
}
