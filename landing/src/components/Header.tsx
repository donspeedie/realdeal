import { Menu } from 'lucide-react';
import { useState } from 'react';
import { CtaButton } from './CtaButton';

const navItems = [
  { name: 'How it works', href: '#how-it-works' },
  { name: 'Capabilities', href: '#capabilities' },
  { name: 'Pricing', href: '#pricing' },
];

export function Header() {
  const [mobileOpen, setMobileOpen] = useState(false);

  return (
    <header className="w-full py-4 px-6 border-b border-foreground/[0.06]">
      <div className="max-w-7xl mx-auto flex items-center justify-between gap-4">
        <a href="/" className="flex items-center gap-3">
          <img
            src="/lovable-uploads/05aea857-8655-4de2-982c-bf16fd500ec9.png"
            alt="GetRealDeal.ai"
            className="h-8 w-auto"
          />
        </a>

        <nav className="hidden md:flex items-center gap-2">
          {navItems.map((item) => (
            <a
              key={item.name}
              href={item.href}
              className="text-muted-foreground hover:text-foreground px-4 py-2 rounded-full text-sm font-medium transition-colors"
            >
              {item.name}
            </a>
          ))}
          <CtaButton variant="primary" label="Try free" className="ml-2" />
          <a
            href="https://app.getrealdeal.ai"
            target="_blank"
            rel="noopener noreferrer"
            className="ml-1 text-xs text-muted-foreground hover:text-foreground transition-colors"
          >
            Sign in
          </a>
          <a
            href="https://nimble-development.com"
            target="_blank"
            rel="noopener noreferrer"
            className="ml-3 text-xs text-muted-foreground hover:text-foreground transition-colors"
          >
            by Nimble Development
          </a>
        </nav>

        <button
          type="button"
          onClick={() => setMobileOpen((v) => !v)}
          className="md:hidden text-foreground p-2"
          aria-label="Toggle menu"
        >
          <Menu className="h-6 w-6" />
        </button>
      </div>

      {mobileOpen && (
        <div className="md:hidden mt-4 pb-2 flex flex-col gap-2">
          {navItems.map((item) => (
            <a
              key={item.name}
              href={item.href}
              onClick={() => setMobileOpen(false)}
              className="text-foreground px-4 py-2 text-base font-medium"
            >
              {item.name}
            </a>
          ))}
          <CtaButton variant="primary" label="Try free" className="mx-4 mt-2" />
          <a
            href="https://app.getrealdeal.ai"
            target="_blank"
            rel="noopener noreferrer"
            className="mx-4 mt-1 text-xs text-muted-foreground"
          >
            Sign in
          </a>
          <a
            href="https://nimble-development.com"
            target="_blank"
            rel="noopener noreferrer"
            className="mx-4 mt-2 text-xs text-muted-foreground"
          >
            by Nimble Development
          </a>
        </div>
      )}
    </header>
  );
}
