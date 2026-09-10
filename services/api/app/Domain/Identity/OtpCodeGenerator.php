<?php

declare(strict_types=1);

namespace App\Domain\Identity;

interface OtpCodeGenerator
{
    public function sixDigits(): string;
}
