import { forwardRef, useId, useState, type InputHTMLAttributes, type ReactNode } from 'react'

export interface FieldProps extends InputHTMLAttributes<HTMLInputElement> {
  label: string
  error?: string
  hint?: ReactNode
}

export const Field = forwardRef<HTMLInputElement, FieldProps>(
  ({ className = '', error, hint, id, label, required, type, ...props }, ref) => {
    const generatedId = useId()
    const [visible, setVisible] = useState(false)
    const fieldId = id ?? props.name ?? generatedId
    const descriptionId = error ? `${fieldId}-error` : hint ? `${fieldId}-hint` : undefined

    return (
      <div className="grid gap-2 text-sm font-semibold text-text-strong">
        <label htmlFor={fieldId}>
          {label} {required && <span className="text-status-error" aria-hidden="true">*</span>}
        </label>
        <div className="relative">
        <input
          aria-describedby={descriptionId}
          aria-invalid={Boolean(error)}
          className={`min-h-12 w-full rounded-control border bg-surface-primary px-3 text-base font-normal text-text-strong transition-[border-color,box-shadow] placeholder:text-text-secondary focus:border-focus-ring focus:ring-2 focus:ring-focus-ring/20 ${type === 'password' ? 'pr-20' : ''} ${error ? 'border-status-error' : 'border-border-default'} ${className}`}
          id={fieldId}
          ref={ref}
          required={required}
          type={type === 'password' && visible ? 'text' : type}
          {...props}
        />
        {type === 'password' && <button type="button" className="absolute inset-y-0 right-0 min-h-12 min-w-16 rounded-control px-3 text-sm font-semibold text-action-primary disabled:opacity-50" disabled={props.disabled} aria-label={`${visible ? 'Hide' : 'Show'} ${label.toLowerCase()}`} aria-controls={fieldId} aria-pressed={visible} onClick={() => setVisible((value) => !value)}>{visible ? 'Hide' : 'Show'}</button>}
        </div>
        {error ? <span className="text-sm font-normal text-status-error" id={descriptionId} role="alert">{error}</span> : hint ? <span className="text-sm font-normal text-text-secondary" id={descriptionId}>{hint}</span> : null}
      </div>
    )
  },
)

Field.displayName = 'Field'
