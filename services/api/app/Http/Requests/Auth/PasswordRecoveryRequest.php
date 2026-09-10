<?php

declare(strict_types=1);

namespace App\Http\Requests\Auth;

use App\Http\AuthTransport;
use App\Http\Requests\Auth\Concerns\ValidatesBotProtectionEvidence;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Validator;

final class PasswordRecoveryRequest extends FormRequest
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
            'email' => ['required', 'email:rfc', 'max:254'],
            'portal' => $transport === AuthTransport::WEB
                ? ['required', Rule::in(['VENDOR', 'ADMIN'])]
                : ['prohibited'],
            'client_kind' => ['prohibited'],
        ] + $this->botProtectionRules();
    }

    public function withValidator(Validator $validator): void
    {
        $this->validateBotProtectionEvidence($validator);
    }
}
