import { forwardRef, type InputHTMLAttributes, type ReactNode } from 'react'

export interface FieldProps extends InputHTMLAttributes<HTMLInputElement> {
  label: string
  error?: string
  hint?: ReactNode
}

export const Field = forwardRef<HTMLInputElement, FieldProps>(
  ({ className = '', error, hint, id, label, required, ...props }, ref) => {
    const fieldId = id ?? props.name
    const descriptionId = error ? `${fieldId}-error` : hint ? `${fieldId}-hint` : undefined

    return (
      <label className="grid gap-2 text-sm font-semibold text-text-strong" htmlFor={fieldId}>
        <span>
          {label} {required && <span className="text-status-error" aria-hidden="true">*</span>}
        </span>
        <input
          aria-describedby={descriptionId}
          aria-invalid={Boolean(error)}
          className={`min-h-12 w-full rounded-control border bg-surface-primary px-3 text-base font-normal text-text-strong shadow-surface transition-[border-color,box-shadow] placeholder:text-text-secondary/70 focus:border-focus-ring focus:outline-none focus:ring-2 focus:ring-focus-ring/20 ${error ? 'border-status-error' : 'border-border-default'} ${className}`}
          id={fieldId}
          ref={ref}
          required={required}
          {...props}
        />
        {error ? <span className="text-sm font-normal text-status-error" id={descriptionId} role="alert">{error}</span> : hint ? <span className="text-sm font-normal text-text-secondary" id={descriptionId}>{hint}</span> : null}
      </label>
    )
  },
)

Field.displayName = 'Field'
