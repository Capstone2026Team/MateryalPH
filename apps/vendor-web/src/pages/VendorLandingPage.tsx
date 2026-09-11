import { ArrowRight, BadgeCheck, Boxes, ChevronDown, ClipboardCheck, FileCheck2, LockKeyhole, MapPinned, MessageSquare, PackageCheck, ReceiptText, ShieldCheck, Store, Users } from 'lucide-react'
import { useEffect, useRef, useState } from 'react'
import { Link } from 'react-router-dom'

import { BrandHeader } from '../components/BrandHeader'
import './VendorLandingPage.css'

const benefits = [
  { icon: MapPinned, title: 'Be found by buyers building nearby', text: 'Give contractors and material buyers a clearer way to discover your store, location and approved products.' },
  { icon: MessageSquare, title: 'Turn questions into clear requirements', text: 'Keep conversations connected to the materials, order or project a Buyer is asking about.' },
  { icon: BadgeCheck, title: 'Build trust with a documented track record', text: 'Store verification, completed orders and eligible purchase reviews help Buyers make informed decisions.' },
]
const steps = [
  ['Create your Owner account', 'Have your name, business name, email and mobile number ready. Review the Terms and Privacy Notice.'],
  ['Verify and secure your access', 'Verify email ownership and set up the required authenticator-based security for your Owner account.'],
  ['Prepare your store for review', 'Provide store details, location and required business documents. Complete the applicable activation requirements.'],
  ['Prepare your product listings', 'Add materials, variants, prices and fulfillment options. Complete any required product compliance review.'],
  ['Connect with eligible Buyers', 'After activation, receive item orders and respond to direct project inquiries with clear quotations.'],
  ['Build your store’s reputation', 'Keep information current, communicate clearly and fulfill accepted orders. Eligible reviews build your record.'],
]
const questions = [
  ['Getting started', [
    ['Who can register as a Vendor?', 'Independent hardware stores and construction-material suppliers can create a Vendor Owner account, subject to the required identity, business, location and verification checks.'],
    ['What should I prepare before registering?', 'Start with your Owner name, business or store name, email and mobile number. Have access to your email and an authenticator app. Store review later requires the applicable business, ownership and location evidence.'],
    ['What happens after I create my store account?', 'Complete email verification and required account security. Your account is the starting point for preparing store information and activation requirements; it does not publish a storefront automatically.'],
    ['Does registration activate my store immediately?', 'No. Registration creates your account. Store activation is reviewed before publication, and the applicable verification and readiness requirements must be completed.'],
  ]],
  ['Your store and Buyers', [
    ['What does Vendor verification provide?', 'An approved Tier 2 Vendor has an authenticated storefront and access to eligible marketplace capabilities after activation. Verification supports informed Buyer decisions; it does not guarantee sales or ranking. A Tier 1 supplier is a directory presence only and cannot transact on MateryalPH.'],
    ['Can every product be published immediately?', 'No. Product listings must meet the applicable publication requirements. Regulated materials need the required reviewed PS Mark or ICC evidence before publication. Store approval does not replace product compliance review.'],
    ['How do Buyers contact my store?', 'Eligible Buyers can start conversations linked to listings, orders or project Work Packages. Project inquiries are sent directly to selected Vendors with the Buyer’s material and fulfillment requirements.'],
    ['Can I send quotations?', 'Eligible Vendors can respond to direct Work Package inquiries with a quotation. Revisions create a new version so Buyers can clearly see and accept the current offer.'],
    ['Can my store improve visibility on the platform?', 'Accurate listings, approved store details, responsive communication and eligible fulfillment/review evidence help Buyers evaluate your store. Visibility follows the platform’s rules; registration does not promise placement or a sales volume.'],
  ]],
  ['Payments and account security', [
    ['When is the 2% commission charged?', 'It is assessed on the approved completed-materials basis and included in monthly Vendor billing. Vendor discounts are considered and included material VAT is excluded. Payment processing, refunds and dispute adjustments have separate records.'],
    ['Are processing fees included in the 2%?', 'No. The Vendor-paid 2% platform commission and third-party payment-processing fees are separate. Processing charges vary by payment method and provider; there is no single processing rate shown in this example.'],
    ['How are refunds and dispute adjustments handled?', 'Refunds and concluded-dispute adjustments are recorded separately from payment-processing fees and commission. Approved changes refer back to the original transaction and may lead to a corresponding commission adjustment.'],
    ['Do I need to verify my email?', 'Email/password registration requires email verification. A valid verified Google email satisfies email ownership verification when you register with Google. You still complete the remaining Vendor account requirements.'],
    ['Why do I need authenticator-based security?', 'Vendor Owner access uses an authenticator as an additional account safeguard. Save your recovery codes securely during setup so you have the supported recovery option if your authenticator becomes unavailable.'],
    ['What happens if I forget my password?', 'Use Forgot password on the Vendor sign-in page and follow the instructions sent to your registered email. A password reset does not remove the account’s required authenticator security.'],
  ]],
] as const
const previews = [
  { label: 'Storefront', icon: Store, title: 'Your materials. A clearer digital presence.', text: 'Present approved products with useful specifications, prices and availability. Exact inventory stays private.', rows: [['Portland cement', '40 kg · Per bag'], ['Deformed steel bar', '12 mm · Per length'], ['Concrete hollow block', '6 in · Per piece']] },
  { label: 'Inquiries', icon: MessageSquare, title: 'A project brief you can respond to.', text: 'Review direct Work Package inquiries with material quantities and fulfillment needs, then prepare a versioned quotation.', rows: [['Material requirements', 'Cement, steel and blocks'], ['Requested fulfillment', 'Delivery to project site'], ['Vendor response', 'Quotation with clear terms']] },
  { label: 'Orders', icon: ClipboardCheck, title: 'Keep the next action in view.', text: 'Review item orders, confirm availability and follow the approved fulfillment steps with a documented transaction history.', rows: [['Review', 'Check the order requirements'], ['Confirm', 'Accept through the approved flow'], ['Fulfill', 'Record delivery or pickup']] },
]

export function VendorLandingPage() {
  const root = useRef<HTMLDivElement>(null)
  const [preview, setPreview] = useState(0)
  useEffect(() => {
    const element = root.current
    if (typeof window.matchMedia !== 'function' || !element) return
    const motion = window.matchMedia('(prefers-reduced-motion: reduce)')
    if (motion.matches || !('IntersectionObserver' in window) || typeof element.animate !== 'function') return
    const observer = new IntersectionObserver(entries => entries.forEach(entry => {
      if (entry.isIntersecting) { entry.target.animate([{ opacity: .65, transform: 'translateY(12px)' }, { opacity: 1, transform: 'translateY(0)' }], { duration: 450, easing: 'cubic-bezier(.16,1,.3,1)' }); observer.unobserve(entry.target) }
    }), { threshold: .1 })
    element.querySelectorAll('[data-reveal]').forEach(node => observer.observe(node))
    const stopMotion = () => { observer.disconnect(); element.getAnimations({ subtree: true }).forEach(animation => animation.cancel()) }
    motion.addEventListener('change', stopMotion)
    return () => { stopMotion(); motion.removeEventListener('change', stopMotion) }
  }, [])
  const selected = previews[preview] ?? previews[0]!
  return <div className="vendor-landing" ref={root}>
    <BrandHeader />
    <main id="main-content">
      <section className="lp-hero lp-container">
        <div className="lp-hero-copy">
          <h1>Build your store’s <em>next chapter.</em></h1>
          <p>Bring your materials closer to the people building the Philippines. Showcase your store, connect with project Buyers and give every inquiry a clearer path forward.</p>
          <div className="hero__actions lp-actions"><Link className="button button--primary" to="/register">Register your store <ArrowRight aria-hidden="true" /></Link><a className="button button--secondary" href="#how-it-works">See how it works</a></div>
          <p className="lp-hero-note"><ShieldCheck aria-hidden="true" /> Start with an Owner account. Store activation is reviewed.</p>
        </div>
        <div className="lp-hero-visual" aria-label="Illustrative marketplace connection">
          <div className="lp-store-sign"><img src="/brand/materyalph-mark.png" width="48" height="48" alt="" /><span>From your store<br /><strong>to their next build.</strong></span></div>
          <div className="lp-materials"><div><Boxes aria-hidden="true" /><span>Materials</span></div><div><Store aria-hidden="true" /><span>Your storefront</span></div><div><Users aria-hidden="true" /><span>Project Buyers</span></div></div>
          <div className="lp-inquiry"><div className="lp-inquiry-heading"><MessageSquare aria-hidden="true" /><strong>A clearer conversation</strong><span>Example inquiry</span></div><h2>Materials for a two-storey home</h2><p><MapPinned aria-hidden="true" /> Quezon City · Delivery requested</p><dl><div><dt>Cement · 40 kg</dt><dd>180 bags</dd></div><div><dt>Steel bar · 12 mm</dt><dd>96 lengths</dd></div><div><dt>Hollow block · 6 in</dt><dd>1,200 pcs</dd></div></dl><div className="lp-inquiry-bottom"><FileCheck2 aria-hidden="true" /><span>Defined requirements. An informed quotation.</span></div></div>
        </div>
      </section>
      <div className="lp-audience"><div className="lp-container"><p>Built for the Philippine construction community</p><ul><li>Hardware stores</li><li>Material suppliers</li><li>Independent Vendors</li></ul></div></div>
      <section id="benefits" className="lp-container lp-section" data-reveal aria-labelledby="benefits-title"><div className="lp-heading"><h2 id="benefits-title">Good materials deserve<br />a stronger presence.</h2><p>Make your store easier to discover, your offers easier to understand and your Buyer relationships easier to manage.</p></div><div className="lp-benefits">{benefits.map(({ icon: Icon, title, text }) => <article key={title}><Icon aria-hidden="true" /><h3>{title}</h3><p>{text}</p></article>)}</div></section>
      <section id="features" className="lp-feature-band" data-reveal aria-labelledby="features-title"><div className="lp-container lp-section"><div className="lp-heading"><h2 id="features-title">From product discovery<br />to a documented order.</h2><p>A preview of the marketplace capabilities planned for eligible, activated stores. Registration is your first step; publication follows review.</p></div><div className="lp-feature-layout"><div className="lp-feature-options" aria-label="Explore marketplace capabilities">{previews.map(({ label, icon: Icon, title }, i) => <button type="button" key={label} aria-pressed={preview === i} aria-controls="landing-feature-preview" onClick={() => setPreview(i)}><Icon aria-hidden="true" /><span><strong>{label}</strong><span>{title}</span></span><ArrowRight aria-hidden="true" /></button>)}</div><div id="landing-feature-preview" className="lp-feature-preview" aria-live="polite"><span className="lp-preview-label">Illustrative {selected.label.toLowerCase()} preview</span><h3>{selected.title}</h3><p>{selected.text}</p><dl>{selected.rows.map(([label, value]) => <div key={label}><dt>{label}</dt><dd>{value}</dd></div>)}</dl></div></div></div></section>
      <section id="how-it-works" className="lp-container lp-section" data-reveal aria-labelledby="how-title"><div className="lp-heading"><h2 id="how-title">Start with your account.<br />Build toward your storefront.</h2><p>A clear path from registration to eligible marketplace participation, with checks at the stages that matter.</p></div><ol className="lp-steps">{steps.map(([title, description], i) => <li key={title}><span className="lp-step-number" aria-hidden="true">{String(i + 1).padStart(2, '0')}</span><h3>{title}</h3><p>{description}</p></li>)}</ol></section>
      <section id="verification" className="lp-trust lp-container" data-reveal aria-labelledby="trust-title"><div><ShieldCheck className="lp-trust-icon" aria-hidden="true" /><h2 id="trust-title">Trust starts before<br />your first order.</h2><p>Creating an account is the beginning. Store activation is reviewed before publication, and regulated products need their own applicable compliance checks.</p><a className="lp-text-link" href="#faq">Understand the requirements <ArrowRight aria-hidden="true" /></a></div><ul><li><BadgeCheck aria-hidden="true" /><div><h3>A reviewed store identity</h3><p>Business, ownership and location information support the Vendor review.</p></div></li><li><PackageCheck aria-hidden="true" /><div><h3>Products ready for publication</h3><p>Applicable regulated materials need reviewed PS Mark or ICC evidence. Store approval alone does not publish every product.</p></div></li><li><LockKeyhole aria-hidden="true" /><div><h3>Private documents. Protected access.</h3><p>Required evidence is available to authorized reviewers. Owner accounts use authenticator-based security.</p></div></li></ul></section>
      <section id="payments-fees" className="lp-container lp-section lp-fees" data-reveal aria-labelledby="fees-title"><div><h2 id="fees-title">Plain-language payments and fees, before you commit</h2><p>The approved Vendor-paid platform commission is <strong>2%</strong>, assessed on the completed-materials basis and billed monthly.</p><p>Vendor discounts are considered. Included material VAT and delivery are excluded from the commission basis.</p><ul className="lp-fee-notes"><li><ReceiptText aria-hidden="true" /><span><strong>Processing is separate.</strong> Third-party processing fees are distinct and vary by payment method and provider.</span></li><li><FileCheck2 aria-hidden="true" /><span><strong>Adjustments stay traceable.</strong> Refunds and dispute adjustments have separate records, with corresponding approved commission adjustments where applicable.</span></li></ul></div><div className="lp-fee-example"><div className="lp-fee-top"><h3>A simple monthly example</h3><span>2% monthly</span></div><p>Illustrative amounts · Material VAT already excluded</p><dl><div><dt>Completed materials before discounts</dt><dd>₱150,000</dd></div><div><dt>Less Vendor discounts</dt><dd>− ₱10,000</dd></div><div className="lp-basis"><dt>Commission basis</dt><dd>₱140,000</dd></div></dl><div className="lp-fee-result"><span>Vendor platform commission<strong>₱2,800</strong></span><span>₱140,000 × 2%</span></div><p>Delivery and processing fees are not part of this example. This is a commission illustration, not a payout statement.</p></div></section>
      <section id="faq" className="lp-faq-band" data-reveal aria-labelledby="faq-title"><div className="lp-container lp-section lp-faq-layout"><div className="lp-faq-intro"><h2 id="faq-title">A few answers.<br />A clearer next step.</h2><p>What to know about joining, publishing products, connecting with Buyers and protecting your account.</p><Link className="lp-text-link" to="/support">Need more help? <ArrowRight aria-hidden="true" /></Link></div><div className="lp-faq-groups">{questions.map(([group, entries]) => <div key={group}><h3>{group}</h3>{entries.map(([question, answer]) => <details key={question}><summary>{question}<ChevronDown aria-hidden="true" /></summary><p>{answer}</p></details>)}</div>)}</div></div></section>
      <section className="lp-container lp-section" data-reveal><div className="lp-final"><div><h2>Your next chapter<br />starts with your store.</h2><p>Create your Vendor Owner account and take the first step toward a reviewed digital storefront.</p></div><div><Link className="button button--primary" to="/register">Start registration <ArrowRight aria-hidden="true" /></Link><p>Already have an account? <Link to="/login">Sign in</Link></p></div></div></section>
    </main>
    <footer className="lp-footer"><div className="lp-container"><div className="lp-footer-main"><div><Link className="brand-link" to="/"><img src="/brand/materyalph-mark.png" alt="MateryalPH" width="48" height="48" /><span>MaterialPH Vendor</span></Link><p>Materials for every build.<br />Connections that help your store move forward.</p></div><nav aria-label="Explore"><strong>Explore MateryalPH</strong><a href="#benefits">Vendor benefits</a><a href="#how-it-works">How it works</a><a href="#payments-fees">Payments &amp; fees</a></nav><nav aria-label="Vendor resources"><strong>Here to help</strong><a href="#verification">Verification</a><a href="#faq">Common questions</a><Link to="/support">Support</Link></nav></div><div className="lp-footer-bottom"><small>MateryalPH · Built for the Philippine construction community.</small><nav aria-label="Legal"><Link to="/legal/terms-of-service">Terms of Service</Link><Link to="/legal/privacy-notice">Privacy Notice</Link></nav></div></div></footer>
  </div>
}
