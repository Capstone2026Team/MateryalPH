import { PortalBrand } from '@materyalph/web-ui'
import { FileCheck2, PackageCheck, ReceiptText, Star } from 'lucide-react'
import type { ReactNode } from 'react'
import { Link } from 'react-router-dom'

export function VendorAuthShell({ title, description, children }: { title: string; description: string; children: ReactNode }) {
  return <main className="auth-page">
    <section className="auth-story" aria-label="Vendor portal benefits">
      <Link className="portal-brand-link" to="/"><PortalBrand label="MaterialPH Vendor" /></Link>
      <div><h2>Your next chapter<br />starts here.</h2><p>Create your Owner account, protect your access, and prepare your store for verification.</p><ul><li><PackageCheck aria-hidden="true" /><span><strong>Structured demand</strong> Item orders and direct Work Package inquiries</span></li><li><ReceiptText aria-hidden="true" /><span><strong>Traceable payments</strong> Separate payment, refund, and fee records</span></li><li><Star aria-hidden="true" /><span><strong>Evidence-based reputation</strong> Versioned performance signals</span></li></ul></div>
      <small><FileCheck2 aria-hidden="true" /> Vendor activation is reviewed before publication.</small>
    </section>
    <section className="auth-panel"><div className="auth-panel__inner"><Link className="mobile-auth-brand" to="/"><PortalBrand label="MaterialPH Vendor" /></Link><h1>{title}</h1><p>{description}</p>{children}</div></section>
  </main>
}
