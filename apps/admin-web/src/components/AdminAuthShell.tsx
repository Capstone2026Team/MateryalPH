import { BadgeCheck, FileCheck2, LockKeyhole, ShieldCheck } from 'lucide-react'
import type { ReactNode } from 'react'
import { Link } from 'react-router-dom'

export function AdminAuthShell({ title, description, children }: { title: string; description: string; children: ReactNode }) {
  return <main className="admin-auth">
    <section className="admin-story" aria-label="Admin portal safeguards"><Link className="admin-brand" to="/"><img src="/brand/materyalph-logo.png" alt="MateryalPH" /><span>Admin Portal</span></Link><div><h1>Protect trust across every transaction.</h1><p>Review marketplace evidence, enforce approved workflows, and keep high-impact decisions traceable.</p><ul><li><ShieldCheck aria-hidden="true" /><span><strong>Deny-by-default access</strong> Role and assignment checks remain server-side.</span></li><li><FileCheck2 aria-hidden="true" /><span><strong>Reasoned review</strong> Decisions preserve evidence, actor, state, and reason.</span></li><li><LockKeyhole aria-hidden="true" /><span><strong>Immutable audit trail</strong> Sensitive actions are correlated and append-only.</span></li></ul></div><small>Private operations surface · Authorized staff only</small></section>
    <section className="admin-panel"><div className="admin-form-wrap"><img className="admin-mobile-logo" src="/brand/materyalph-logo.png" alt="MateryalPH Admin Portal" /><div className="secure-note"><BadgeCheck aria-hidden="true" /> Authorized accounts only</div><h2>{title}</h2><p>{description}</p>{children}</div></section>
  </main>
}
