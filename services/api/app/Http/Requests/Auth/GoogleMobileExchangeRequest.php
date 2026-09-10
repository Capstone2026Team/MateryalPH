<?php

declare(strict_types=1);

namespace App\Http\Requests\Auth;

use Illuminate\Foundation\Http\FormRequest;

final class GoogleMobileExchangeRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /** @return array<string, list<mixed>> */
    public function rules(): array
    {
        return [
            'exchange_code' => ['required', 'string', 'max:128'],
            'device_id' => ['nullable', 'uuid'],
        ];
    }
}
