<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use RuntimeException;

final class AuthenticationException extends RuntimeException
{
    /** @param array<string, mixed> $details */
    public function __construct(
        public readonly string $errorCode,
        string $safeMessage,
        public readonly int $httpStatus = 422,
        public readonly array $details = [],
    ) {
        parent::__construct($safeMessage);
    }
}
