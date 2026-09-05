import { forwardRef, type ButtonHTMLAttributes } from 'react'

export type ButtonVariant = 'primary' | 'secondary'

export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant
}

const variantClasses: Record<ButtonVariant, string> = {
  primary: 'bg-action-primary text-white hover:bg-action-primary-pressed',
  secondary: 'border border-border-default bg-surface-primary text-text-strong',
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className = '', type = 'button', variant = 'primary', ...props }, ref) => (
    <button
      className={`inline-flex min-h-11 items-center justify-center rounded-control px-4 text-body-strong focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring disabled:cursor-not-allowed disabled:opacity-50 ${variantClasses[variant]} ${className}`}
      ref={ref}
      type={type}
      {...props}
    />
  ),
)

Button.displayName = 'Button'
