<?php

declare(strict_types=1);

namespace App\Http;

use Illuminate\Http\JsonResponse;

final class ApiResponse
{
    /** @param array<string, mixed> $meta */
    public static function success(mixed $data = null, array $meta = [], int $status = 200): JsonResponse
    {
        return response()->json(['data' => $data, 'meta' => (object) self::meta($meta), 'errors' => []], $status);
    }

    /** @param array<string, mixed> $details */
    public static function error(string $code, string $message, int $status, array $details = []): JsonResponse
    {
        return response()->json([
            'data' => null,
            'meta' => (object) self::meta(),
            'errors' => [[
                'code' => $code,
                'message' => $message,
                'details' => (object) $details,
            ]],
        ], $status);
    }

    /**
     * @param  array<string, mixed>  $meta
     * @return array<string, mixed>
     */
    private static function meta(array $meta = []): array
    {
        $correlationId = request()->attributes->get('correlation_id');

        return is_string($correlationId) && $correlationId !== ''
            ? ['correlation_id' => $correlationId] + $meta
            : $meta;
    }
}
