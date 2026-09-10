<?php

declare(strict_types=1);

namespace App\Http\Requests\Auth;

use App\Http\AuthTransport;
use Illuminate\Foundation\Http\FormRequest;

final class RefreshRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /** @return array<string, list<mixed>> */
    public function rules(): array
    {
        $transport = AuthTransport::fromRequest($this);

        return [
            'client_kind' => ['prohibited'],
            'refresh_token' => $transport === AuthTransport::MOBILE
                ? ['required', 'string', 'max:512']
                : ['prohibited'],
        ];
    }
}
