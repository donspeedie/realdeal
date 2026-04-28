import { Building2, HardHat, LineChart } from 'lucide-react';

type ProductKey = 'nimble' | 'fluidcm' | 'realdeal';

interface EcosystemStripProps {
  current?: ProductKey | null;
  heading?: string;
}

const products: Array<{
  key: ProductKey;
  name: string;
  blurb: string;
  href: string;
  textClass: string;
  borderClass: string;
  Icon: React.ComponentType<{ className?: string }>;
}> = [
  {
    key: 'nimble',
    name: 'Nimble Development',
    blurb: 'AI-first homebuilder. Attainable homes in Central California.',
    href: 'https://nimble-development.com',
    textClass: 'text-[#0D9B76]',
    borderClass: 'border-[rgba(13,155,118,0.25)] hover:border-[rgba(13,155,118,0.5)]',
    Icon: Building2,
  },
  {
    key: 'fluidcm',
    name: 'FluidCM',
    blurb: 'Mobile-first construction management. Built for the field.',
    href: 'https://fluidcm.com',
    textClass: 'text-[#D4612A]',
    borderClass: 'border-[rgba(212,97,42,0.25)] hover:border-[rgba(212,97,42,0.5)]',
    Icon: HardHat,
  },
  {
    key: 'realdeal',
    name: 'GetRealDeal.ai',
    blurb: 'AI deal analysis for residential real estate investors.',
    href: 'https://getrealdeal.ai',
    textClass: 'text-[#1D4F7D]',
    borderClass: 'border-[rgba(29,79,125,0.25)] hover:border-[rgba(29,79,125,0.5)]',
    Icon: LineChart,
  },
];

export function EcosystemStrip({
  current = null,
  heading = 'Built by the same team',
}: EcosystemStripProps) {
  return (
    <section className="container mx-auto px-4 py-12 lg:py-16">
      <div className="mb-6 text-center lg:text-left">
        <p className="text-xs font-semibold tracking-widest uppercase text-muted-foreground mb-2">
          Family of Products
        </p>
        <h3 className="text-xl lg:text-2xl font-sans font-bold text-foreground">{heading}</h3>
      </div>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {products.map((p) => {
          const isCurrent = p.key === current;
          const inner = (
            <div
              className={`rounded-xl border bg-card ${p.borderClass} p-5 h-full transition-colors relative ${
                isCurrent ? 'opacity-60' : ''
              }`}
            >
              <div className="flex items-center gap-3 mb-2">
                <p.Icon className={`w-5 h-5 ${p.textClass}`} />
                <span className="font-sans font-bold text-foreground">{p.name}</span>
                {isCurrent && (
                  <span className="ml-auto text-[10px] font-semibold uppercase tracking-wider text-muted-foreground">
                    You are here
                  </span>
                )}
              </div>
              <p className="text-sm text-muted-foreground leading-relaxed">{p.blurb}</p>
            </div>
          );

          if (isCurrent) return <div key={p.key}>{inner}</div>;

          return (
            <a
              key={p.key}
              href={p.href}
              target="_blank"
              rel="noopener noreferrer"
              className="block hover:scale-[1.01] transition-transform"
            >
              {inner}
            </a>
          );
        })}
      </div>
    </section>
  );
}
