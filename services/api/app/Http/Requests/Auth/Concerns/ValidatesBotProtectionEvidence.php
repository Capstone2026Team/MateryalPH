<?php

declare(strict_types=1);

namespace App\Http\Requests\Auth\Concerns;

use App\Http\AuthTransport;
use Illuminate\Validation\Validator;

trait ValidatesBotProtectionEvidence
{
    /** @return array<string, list<mixed>> */
    protected function botProtectionRules(): array
    {
        return [
            'bot_protection' => ['nullable', 'array:recaptcha_token,request_email_step_up'],
            'bot_protection.recaptcha_token' => ['nullable', 'string', 'max:8192'],
            'bot_protection.request_email_step_up' => ['nullable', 'boolean'],
            'risk_proof_token' => ['nullable', 'string', 'max:128'],
        ];
    }

    protected function validateBotProtectionEvidence(Validator $validator): void
    {
        $validator->after(function (Validator $validator): void {
            $evidence = $this->input('bot_protection');
            $transport = AuthTransport::fromRequest($this);
            $portal = $transport === AuthTransport::MOBILE
                ? 'BUYER'
                : strtoupper((string) ($this->input('account_type') ?? $this->input('portal') ?? 'VENDOR'));
            $riskProof = $this->input('risk_proof_token');

            if ($portal !== 'VENDOR' && $evidence !== null) {
                $validator->errors()->add('bot_protection', 'Bot protection is available only for Vendor web authentication.');
            }
            if ($portal !== 'BUYER' && is_string($riskProof) && $riskProof !== '') {
                $validator->errors()->add('risk_proof_token', 'Risk proof is available only for Buyer email step-up.');
            }
            $hasCookieProof = is_string($this->cookie('mp_bot_proof'))
                && $this->cookie('mp_bot_proof') !== '';
            if (! is_array($evidence)) {
                if ($portal === 'VENDOR'
                    && (bool) config('materyalph.bot_protection.enabled', false)
                    && ! $hasCookieProof) {
                    $validator->errors()->add('bot_protection', 'Complete the Vendor verification or request the accessible email check.');
                }

                return;
            }

            $provided = 0;
            $provided += isset($evidence['recaptcha_token']) && $evidence['recaptcha_token'] !== '' ? 1 : 0;
            $provided += ($evidence['request_email_step_up'] ?? false) === true ? 1 : 0;
            $cookieProof = $provided === 0 && $hasCookieProof;
            if ($provided !== 1 && ! $cookieProof) {
                $validator->errors()->add('bot_protection', 'Provide exactly one bot-protection method.');
            }
        });
    }
}
