<?php

declare(strict_types=1);

namespace App\Http\Requests\Auth;

use App\Http\AuthTransport;
use App\Http\Requests\Auth\Concerns\ValidatesBotProtectionEvidence;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Rules\Password;
use Illuminate\Validation\Validator;

final class RegisterRequest extends FormRequest
{
    use ValidatesBotProtectionEvidence;

    public function authorize(): bool
    {
        return true;
    }

    /** @return array<string, list<mixed>> */
    public function rules(): array
    {
        $transport = AuthTransport::fromRequest($this);

        return [
            'full_name' => ['required', 'string', 'max:160'],
            'email' => ['required', 'email:rfc', 'max:254'],
            'mobile_e164' => ['required', 'regex:/^\+[1-9]\d{7,14}$/'],
            'password' => ['required', 'confirmed', Password::min(12)->mixedCase()->numbers()],
            'account_type' => ['prohibited'],
            'business_name' => [Rule::requiredIf($transport === AuthTransport::WEB), 'nullable', 'string', 'max:180'],
            'buyer_type' => [Rule::requiredIf($transport === AuthTransport::MOBILE), 'nullable', 'string', 'max:32'],
            'company_name' => ['nullable', 'string', 'max:180'],
            'terms_accepted' => ['accepted'],
            'privacy_accepted' => ['accepted'],
        ] + $this->botProtectionRules();
    }

    public function withValidator(Validator $validator): void
    {
        $this->validateBotProtectionEvidence($validator);
    }
}
