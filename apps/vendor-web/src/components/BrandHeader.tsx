import { Menu, X } from 'lucide-react'
import { useState } from 'react'
import { Link, NavLink } from 'react-router-dom'

const links: ReadonlyArray<readonly [string, string]> = [
  ['Home', '/#main-content'],
  ['Benefits', '/#benefits'],
  ['Features', '/#features'],
  ['How it works', '/#how-it-works'],
  ['Payments / Fees', '/#payments-fees'],
  ['FAQ', '/#faq'],
]

export function BrandHeader() {
  const [open, setOpen] = useState(false)

  return (
    <header className="site-header">
      <a className="skip-link" href="#main-content">Skip to content</a>
      <div className="site-header__inner">
        <Link className="brand-link" to="/" aria-label="MaterialPH Vendor home">
          <img src="/brand/materyalph-mark.png" alt="MateryalPH" width="48" height="48" />
          <span>MaterialPH Vendor</span>
        </Link>
        <button className="menu-button" type="button" aria-expanded={open} aria-controls="site-navigation" onClick={() => setOpen((value) => !value)}>
          {open ? <X aria-hidden="true" /> : <Menu aria-hidden="true" />}
          <span className="sr-only">{open ? 'Close navigation' : 'Open navigation'}</span>
        </button>
        <nav className={open ? 'site-nav site-nav--open' : 'site-nav'} id="site-navigation" aria-label="Vendor portal">
          {links.map(([label, href]) => href.startsWith('/#')
            ? <a key={href} href={href} onClick={() => setOpen(false)}>{label}</a>
            : <NavLink key={href} to={href} onClick={() => setOpen(false)}>{label}</NavLink>)}
          <Link className="nav-login" to="/login">Sign in</Link>
          <Link className="nav-cta" to="/register">Register your store</Link>
        </nav>
      </div>
    </header>
  )
}
