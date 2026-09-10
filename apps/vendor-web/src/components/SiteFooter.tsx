import { Link } from 'react-router-dom'

export function SiteFooter() {
  return (
    <footer>
      <div>
        <Link className="brand-link" to="/">
          <img src="/brand/materyalph-logo.png" alt="MateryalPH" />
          <span>Vendor Portal</span>
        </Link>
        <p>Verified materials commerce for the Philippine construction community.</p>
      </div>
      <nav aria-label="Footer">
        <Link to="/verification">Verification</Link>
        <Link to="/fees">Payments &amp; fees</Link>
        <Link to="/support">Support</Link>
        <Link to="/legal/terms-of-service">Terms</Link>
        <Link to="/legal/privacy-notice">Privacy</Link>
      </nav>
      <small>Phase 1 capstone environment · Live commerce disabled</small>
    </footer>
  )
}
