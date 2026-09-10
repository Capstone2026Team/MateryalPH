<?php

declare(strict_types=1);

namespace App\Domain\Identity;

final readonly class RecaptchaAssessmentResult
{
    public function __construct(
        public bool $valid,
        public ?string $action,
        public ?string $hostname,
    ) {}
}
