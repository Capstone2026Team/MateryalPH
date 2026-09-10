import { FileCheck2, PackageCheck, ReceiptText, Star } from 'lucide-react'
import type { ReactNode } from 'react'
import { Link } from 'react-router-dom'

export function VendorAuthShell({ title, description, children }: { title: string; description: string; children: ReactNode }) {
  return <main className="auth-page">
    <section className="auth-story" aria-label="Vendor portal benefits">
      <Link className="brand-link" to="/"><img src="/brand/materyalph-logo.png" alt="MateryalPH" width="154" height="80" /><span>Vendor Portal</span></Link>
      <div><h1>Reach more contractors.<br />Grow your business.</h1><p>Join a marketplace designed around verified material supply, explicit controls, and documented fulfillment.</p><ul><li><PackageCheck aria-hidden="true" /><span><strong>Structured demand</strong> Item orders and direct Work Package inquiries</span></li><li><ReceiptText aria-hidden="true" /><span><strong>Traceable payments</strong> Separate payment, refund, and fee records</span></li><li><Star aria-hidden="true" /><span><strong>Evidence-based reputation</strong> Versioned performance signals</span></li></ul></div>
      <small><FileCheck2 aria-hidden="true" /> Vendor activation is reviewed before publication.</small>
    </section>
    <section className="auth-panel"><div className="auth-panel__inner"><Link className="mobile-auth-brand" to="/"><img src="/brand/materyalph-logo.png" alt="MateryalPH Vendor Portal" /></Link><h2>{title}</h2><p>{description}</p>{children}</div></section>
  </main>
}
