import type { ReactNode } from 'react';

const APP_BASE = 'https://app.getrealdeal.ai';

type Props = {
  href?: string;
  label?: string;
  variant?: 'primary' | 'ghost';
  className?: string;
  children?: ReactNode;
  external?: boolean;
};

const baseStyles =
  'inline-flex items-center justify-center rounded-lg px-5 py-2.5 text-sm font-medium transition-opacity hover:opacity-90 whitespace-nowrap';

const variantStyles: Record<NonNullable<Props['variant']>, string> = {
  primary: 'bg-product-realdeal text-white shadow-sm',
  ghost: 'bg-transparent border border-foreground/[0.12] text-foreground hover:bg-foreground/[0.04]',
};

export function CtaButton({
  href = APP_BASE,
  label = 'Try free',
  variant = 'primary',
  className = '',
  children,
  external = true,
}: Props) {
  const styleClass = `${baseStyles} ${variantStyles[variant]} ${className}`.trim();
  return (
    <a
      href={href}
      {...(external ? { target: '_blank', rel: 'noopener noreferrer' } : {})}
      className={styleClass}
    >
      {children ?? label}
    </a>
  );
}
