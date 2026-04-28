export function Footer() {
  return (
    <footer className="container mx-auto px-4 py-10 lg:py-16 border-t border-border">
      <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-10">
        <div>
          <p className="text-sm font-semibold uppercase tracking-widest text-muted-foreground mb-3">
            About
          </p>
          <p className="text-sm text-foreground leading-relaxed max-w-xs">
            getRealDeal.ai provides tools for analyzing real estate investments
            such as calculators and estimates. We make no guarantees as to the
            accuracy of the information provided. User is required to verify
            all amounts and calculations before relying on this information.
          </p>
        </div>

        <div>
          <p className="text-sm font-semibold uppercase tracking-widest text-muted-foreground mb-3">
            Family of Products
          </p>
          <ul className="space-y-2">
            <li>
              <a
                href="https://nimble-development.com"
                target="_blank"
                rel="noopener noreferrer"
                className="text-sm text-foreground hover:underline"
              >
                Nimble Development
              </a>
            </li>
            <li>
              <a
                href="https://fluidcm.com"
                target="_blank"
                rel="noopener noreferrer"
                className="text-sm text-foreground hover:underline"
              >
                FluidCM
              </a>
            </li>
            <li>
              <span className="text-sm text-muted-foreground">
                GetRealDeal.ai (you are here)
              </span>
            </li>
          </ul>
        </div>

        <div>
          <p className="text-sm font-semibold uppercase tracking-widest text-muted-foreground mb-3">
            Contact
          </p>
          <ul className="space-y-2">
            <li>
              <a
                href="mailto:info@nimble-development.com"
                className="text-sm text-foreground hover:underline"
              >
                info@nimble-development.com
              </a>
            </li>
            <li>
              <a
                href="https://app.getrealdeal.ai"
                target="_blank"
                rel="noopener noreferrer"
                className="text-sm text-foreground hover:underline"
              >
                Open the App &rarr;
              </a>
            </li>
          </ul>
        </div>
      </div>

      <div className="text-center text-muted-foreground pt-4 border-t border-border">
        <p className="text-sm font-inter">
          &copy; {new Date().getFullYear()} Real Deal. A{' '}
          <a
            href="https://nimble-development.com"
            target="_blank"
            rel="noopener noreferrer"
            className="hover:underline text-foreground"
          >
            Nimble Development
          </a>{' '}
          product. All rights reserved.
        </p>
      </div>
    </footer>
  );
}
