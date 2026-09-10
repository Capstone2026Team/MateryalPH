<?php

declare(strict_types=1);

namespace App\Domain\Identity;

interface RecaptchaAssessmentGateway
{
    public function assess(string $token, string $siteKey, string $expectedAction): RecaptchaAssessmentResult;
}
