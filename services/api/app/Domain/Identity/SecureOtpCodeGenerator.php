<?php

declare(strict_types=1);

namespace App\Domain\Identity;

final class SecureOtpCodeGenerator implements OtpCodeGenerator
{
    public function sixDigits(): string
    {
        return str_pad((string) random_int(0, 999999), 6, '0', STR_PAD_LEFT);
    }
}
