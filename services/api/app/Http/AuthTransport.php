<?php

declare(strict_types=1);

namespace App\Http;

use Illuminate\Http\Request;
use LogicException;

enum AuthTransport: string
{
    case WEB = 'WEB';
    case MOBILE = 'MOBILE';

    public const ATTRIBUTE = 'materyalph_auth_transport';

    public static function fromRequest(Request $request): self
    {
        $transport = $request->attributes->get(self::ATTRIBUTE);
        if (! $transport instanceof self) {
            throw new LogicException('The authentication transport was not assigned by routing.');
        }

        return $transport;
    }
}
