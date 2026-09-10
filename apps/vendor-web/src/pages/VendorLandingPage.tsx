import {
  ArrowRight,
  BadgeCheck,
  Boxes,
  Building2,
  ChevronDown,
  ClipboardCheck,
  FileCheck2,
  Handshake,
  LockKeyhole,
  MapPinned,
  PackageCheck,
  ReceiptText,
  Search,
  ShieldCheck,
  Star,
  Users,
} from 'lucide-react'
import { Link } from 'react-router-dom'

import { BrandHeader } from '../components/BrandHeader'
import { SiteFooter } from '../components/SiteFooter'

const benefits = [
  {
    icon: Building2,
    title: 'Reach serious project buyers',
    text: 'Receive item orders and direct inquiries tied to structured Work Packages—not an open bidding queue.',
  },
  {
    icon: Boxes,
    title: 'Keep catalog and stock decisions yours',
    text: 'Publish approved variants, ordinary prices, and availability while exact inventory stays private.',
  },
  {
    icon: ShieldCheck,
    title: 'Build visible marketplace trust',
    text: 'Verification, fulfillment history, and eligible verified-purchase reviews support your Vendor Performance Score.',
  },
] as const

const features = [
  { title: 'Verified digital storefront', text: 'Present approved store details and published listings as a Tier 2 Vendor.', icon: Building2 },
  { title: 'Catalog and variants', text: 'Structure products by canonical material, unit, brand, model, and controlled specifications.', icon: Boxes },
  { title: 'Inventory controls', text: 'Track on-hand and hard-reserved quantities. Cart placement and quotation soft holds never reserve stock.', icon: PackageCheck },
  { title: 'Order operations', text: 'Confirm item orders, review NRPC manually when enabled, and move fulfillment through approved states.', icon: ClipboardCheck },
  { title: 'Project inquiries', text: 'Reply to eligible Buyer Work Package inquiries with immutable, versioned quotations.', icon: FileCheck2 },
  { title: 'Messages in context', text: 'Keep Buyer conversations attached to listings, orders, and Work Packages.', icon: Users },
  { title: 'Product compliance', text: 'Submit applicable regulated-material evidence for review before publication.', icon: ShieldCheck },
  { title: 'Vendor team accounts', text: 'Assign one approved role per user with explicit Store Manager delegation.', icon: Users },
  { title: 'Reputation evidence', text: 'Understand the verified signals behind VCS, MQS, OHS, and your composite VPS.', icon: Star },
] as const

const onboardingSteps = [
  ['Create the Owner account', 'Accept the versioned Terms and Privacy Notice separately.'],
  ['Verify the account', 'Confirm email ownership and enroll required Owner multi-factor authentication.'],
  ['Provide business details', 'Add the store, location, ownership, and required private documents.'],
  ['Complete Vendor review', 'An authorized Admin records the verification decision and reason.'],
  ['Complete payment onboarding', 'When online commerce is enabled, satisfy the configured Vendor payment-account requirements.'],
  ['Configure the storefront', 'Add approved variants, ordinary prices, inventory, service area, and fulfillment methods.'],
  ['Receive eligible opportunities', 'Confirm item orders or respond directly to selected Work Package inquiries.'],
] as const

const questions = [
  ['Who can register as a Vendor?', 'Eligible independent hardware stores and construction-material suppliers may create an Owner account, subject to the approved identity, business, location, and verification requirements.'],
  ['What does Vendor verification provide?', 'An approved Vendor can become a Tier 2 authenticated storefront. Verification is reviewed and does not guarantee sales, ranking, or Buyer selection.'],
  ['Does MateryalPH hold money in escrow?', 'No. MateryalPH is not a wallet or escrow service. Digital payments use the configured provider in TEST mode for the capstone; physical payments are recorded separately.'],
  ['When is the 2% commission charged?', 'It is assessed on the approved completed-materials basis and included in monthly Vendor billing. It is separate from Buyer payment-processing fees and configurable withholding scenarios.'],
  ['Are processing fees included in the 2%?', 'No. Third-party payment-processing fees are separate and depend on the configured provider and payment method. MateryalPH does not invent a universal processing rate.'],
  ['Is payment-account onboarding required?', 'It applies before supported online marketplace payments when that capability is enabled for the deployment. Phase 1 does not enable live commerce.'],
  ['Can every product be published immediately?', 'No. Regulated categories require the applicable evidence and an approved compliance decision before publication.'],
  ['How do Buyers contact my store?', 'Eligible Buyers can message within listing, order, or Work Package context and may send a direct Work Package inquiry. There is no public reverse-auction queue.'],
  ['Can I send quotations?', 'Eligible Vendors can respond to direct project inquiries using immutable quotation versions. Editing a published quotation creates a new version.'],
  ['Can staff manage the store?', 'Yes, after Owner setup. Each Vendor user has one approved role; Store Manager delegation is explicit and disabled by default.'],
] as const

export function VendorLandingPage() {
  return (
    <>
      <BrandHeader />
      <main id="main-content">
        <Hero />
        <Benefits />
        <Verification />
        <Features />
        <HowItWorks />
        <Compliance />
        <Opportunities />
        <Fees />
        <DashboardPreview />
        <Reputation />
        <Faq />
        <FinalCallToAction />
      </main>
      <SiteFooter />
    </>
  )
}

function Hero() {
  return (
    <section className="hero">
      <div className="hero__copy">
        <h1>Turn project demand into dependable store growth.</h1>
        <p>MateryalPH connects eligible Philippine hardware suppliers with Buyers sourcing materials for item purchases and construction Work Packages.</p>
        <div className="hero__actions">
          <Link className="button button--primary" to="/register">Register your store <ArrowRight aria-hidden="true" /></Link>
          <a className="button button--secondary" href="#how-it-works">See how it works</a>
        </div>
        <ul className="hero__proof" aria-label="Marketplace safeguards">
          <li><BadgeCheck aria-hidden="true" /> Verified Vendor activation</li>
          <li><LockKeyhole aria-hidden="true" /> Private compliance files</li>
          <li><ReceiptText aria-hidden="true" /> Traceable payment records</li>
        </ul>
      </div>
      <div className="opportunity-sheet" aria-label="Illustrative project inquiry preview">
        <div className="opportunity-sheet__topline"><span>Illustrative demo</span><strong>New inquiry</strong></div>
        <h2>Two-storey residence · Structural materials</h2>
        <p className="opportunity-sheet__location"><MapPinned aria-hidden="true" /> Quezon City · Delivery requested</p>
        <div className="material-line"><span>Portland cement · 40 kg</span><strong>180 bags</strong></div>
        <div className="material-line"><span>Deformed steel bar · 12 mm</span><strong>96 lengths</strong></div>
        <div className="material-line"><span>Concrete hollow block · 6 in</span><strong>1,200 pcs</strong></div>
        <div className="opportunity-sheet__footer"><span><Search aria-hidden="true" /> Direct Buyer inquiry</span><span className="status-chip">Quotation open</span></div>
      </div>
    </section>
  )
}

function Benefits() {
  return (
    <section className="benefit-band" id="benefits" aria-labelledby="benefits-title">
      <h2 id="benefits-title">Built around the way material stores actually operate</h2>
      <div className="benefit-list">
        {benefits.map(({ icon: Icon, title, text }) => <article key={title}><Icon aria-hidden="true" /><div><h3>{title}</h3><p>{text}</p></div></article>)}
      </div>
    </section>
  )
}

function Verification() {
  return (
    <section className="verification-story" aria-labelledby="verified-title">
      <div>
        <h2 id="verified-title">Verification earns access—and gives Buyers a reason to trust you.</h2>
        <p>A Verified (Tier 2) Vendor has an authenticated storefront and can use approved marketplace capabilities after review. A Tier 1 supplier is a directory presence only and cannot sign in or transact through MateryalPH.</p>
        <Link className="text-link" to="/verification">Review verification requirements <ArrowRight aria-hidden="true" /></Link>
      </div>
      <ol className="verification-track">
        <li><span><FileCheck2 aria-hidden="true" /></span><div><strong>Submit</strong><p>Owner, store, business, location, and required private evidence.</p></div></li>
        <li><span><ShieldCheck aria-hidden="true" /></span><div><strong>Review</strong><p>Authorized Admin reviewers record a reasoned decision.</p></div></li>
        <li><span><BadgeCheck aria-hidden="true" /></span><div><strong>Activate</strong><p>Complete catalog, fulfillment, and enabled payment readiness.</p></div></li>
      </ol>
    </section>
  )
}

function Features() {
  return (
    <section className="feature-section" id="features" aria-labelledby="feature-title">
      <div className="section-heading"><h2 id="feature-title">One operating view from listing to fulfillment</h2><p>Storefront, team access, catalog, inventory, messaging, quotations, orders, and compliance remain connected without collapsing their distinct states.</p></div>
      <div className="feature-grid">{features.map(({ title, text, icon: Icon }) => <article key={title}><Icon aria-hidden="true" /><h3>{title}</h3><p>{text}</p></article>)}</div>
    </section>
  )
}

function HowItWorks() {
  return (
    <section className="how-section" id="how-it-works" aria-labelledby="how-title">
      <div className="section-heading"><h2 id="how-title">From registration to marketplace eligibility</h2><p>Your store stays in control of acceptance, pricing, fulfillment, and staff permissions at every stage.</p></div>
      <ol className="how-flow">{onboardingSteps.map(([title, description]) => <li key={title}><strong>{title}</strong><span>{description}</span></li>)}</ol>
    </section>
  )
}

function Compliance() {
  return (
    <section className="compliance-section" aria-labelledby="compliance-title">
      <div className="compliance-symbol"><ShieldCheck aria-hidden="true" /></div>
      <div>
        <h2 id="compliance-title">Regulated materials need evidence before publication.</h2>
        <p>Applicable DTI-BPS regulated materials require reviewed PS Mark or ICC evidence. Photo/OCR-assisted entry, QR input, or manual entry may help submit details, but MateryalPH does not issue marks, stickers, government certificates, or regulatory approval.</p>
        <p>Documents remain private, access-controlled, malware-scanned, and served through short-lived authorized links.</p>
      </div>
      <Link className="button button--secondary" to="/verification">What you may need</Link>
    </section>
  )
}

function Opportunities() {
  return (
    <section className="opportunity-section" aria-labelledby="opportunities-title">
      <div className="section-heading"><h2 id="opportunities-title">Two paths to qualified demand</h2><p>MateryalPH does not run a public Vendor RFQ bidding queue.</p></div>
      <div className="opportunity-columns">
        <article><PackageCheck aria-hidden="true" /><h3>Item-Based orders</h3><p>Buyers compare eligible listings, build a cart, and receive one child order per Vendor at checkout.</p><ul><li>Cart placement does not reserve stock</li><li>Auto-accept is optional, item-only, and disabled with NRPC</li><li>Vendor confirmation rules stay visible</li></ul></article>
        <article><Handshake aria-hidden="true" /><h3>Project Work Package inquiries</h3><p>Eligible Buyers contact selected Vendors directly for a scoped package of materials and delivery needs.</p><ul><li>Versioned quotation and counter-offer trail</li><li>One selected Vendor outcome per Work Package</li><li>No anonymous reverse auction</li></ul></article>
      </div>
    </section>
  )
}

function Fees() {
  return (
    <section className="fees-section" id="payments-fees" aria-labelledby="fees-title">
      <div>
        <h2 id="fees-title">Plain-language payments and fees, before you commit</h2>
        <p>Supported online marketplace payments use the approved Xendit architecture when the deployment enables commerce and the Vendor has completed required payment-account onboarding. MateryalPH is a marketplace, not a bank, card processor, e-wallet processor, or the seller.</p>
        <p>The approved Vendor-paid platform commission is <strong>2%</strong> of the completed-materials basis after Vendor discounts and excluding included Vendor VAT. It becomes a separate Vendor liability billed on the approved monthly cycle.</p>
        <p>Third-party processing fees are distinct, may vary by configured provider and method, and are not assigned an invented percentage here. Tax and withholding treatment depends on the approved configuration and prevailing rules; there is no BIR API integration.</p>
        <Link className="text-link" to="/fees">Read the payment and fee breakdown <ArrowRight aria-hidden="true" /></Link>
      </div>
      <dl>
        <div><dt>Vendor commission</dt><dd>2% monthly</dd></div>
        <div><dt>Provider processing fees</dt><dd>Separate, method-dependent</dd></div>
        <div><dt>Tax / withholding</dt><dd>Configuration-controlled</dd></div>
        <div><dt>Phase 1 commerce</dt><dd>TEST/DEMO only</dd></div>
      </dl>
    </section>
  )
}

function DashboardPreview() {
  return (
    <section className="dashboard-preview" aria-labelledby="dashboard-title">
      <div className="dashboard-preview__copy"><span className="demo-label">Illustrative demo · no live data</span><h2 id="dashboard-title">Know what needs attention next.</h2><p>The authenticated portal will prioritize review queues, stale inventory confirmations, open inquiries, fulfillment milestones, and monthly fee statements without mixing their states.</p></div>
      <div className="queue-preview"><div><span>Needs confirmation</span><strong>Item order · 6 lines</strong><small>Exact deadline will show in Asia/Manila</small></div><div><span>Quotation reply</span><strong>Foundation package</strong><small>Version 2 · Buyer changes available</small></div><div><span>Ready for pickup</span><strong>Order snapshot locked</strong><small>Pickup authorization required</small></div></div>
    </section>
  )
}

function Reputation() {
  return (
    <section className="reputation-section" aria-labelledby="reputation-title">
      <div><h2 id="reputation-title">A score Buyers can understand</h2><p>Your Vendor Performance Score combines versioned service, quality, and fulfillment signals. New Vendors are labeled clearly until enough eligible evidence exists. Badges such as Fast Responder, Best Price, Most Ordered, and Highly Rated are illustrative and earned only when their approved rules are satisfied.</p></div>
      <div className="score-diagram" role="img" aria-label="Vendor Performance Score combines compliance, material quality, and order handling signals"><span>VCS<br /><strong>Compliance</strong></span><span>MQS<br /><strong>Material quality</strong></span><span>OHS<br /><strong>Order handling</strong></span><b>VPS</b></div>
    </section>
  )
}

function Faq() {
  return (
    <section className="faq-section" id="faq" aria-labelledby="faq-title">
      <div className="section-heading"><h2 id="faq-title">Questions before you register</h2></div>
      <div>{questions.map(([question, answer]) => <details key={question}><summary>{question}<ChevronDown aria-hidden="true" /></summary><p>{answer}</p></details>)}</div>
    </section>
  )
}

function FinalCallToAction() {
  return (
    <section className="final-cta" aria-labelledby="cta-title">
      <div><h2 id="cta-title">Ready to build a verified storefront?</h2><p>Start with the Vendor Owner account. Your store stays private until activation requirements are complete.</p></div>
      <Link className="button button--light" to="/register">Start registration <ArrowRight aria-hidden="true" /></Link>
    </section>
  )
}
