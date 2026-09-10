<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Identity\SecureOtpCodeGenerator;
use PHPUnit\Framework\TestCase;

final class SecureOtpCodeGeneratorTest extends TestCase
{
    public function test_it_generates_fixed_width_six_digit_codes(): void
    {
        $generator = new SecureOtpCodeGenerator;

        for ($iteration = 0; $iteration < 200; $iteration++) {
            self::assertMatchesRegularExpression('/^\d{6}$/', $generator->sixDigits());
        }
    }
}
