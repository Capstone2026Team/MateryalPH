<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\Auth;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\VerifyEmailAddress;
use App\Http\ApiResponse;
use App\Http\AuthTransport;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\VerifyEmailRequest;
use Illuminate\Http\JsonResponse;

final class VerifyEmailController extends Controller
{
    public function __invoke(VerifyEmailRequest $request, VerifyEmailAddress $verify, AuditRecorder $audit): JsonResponse
    {
        $transport = AuthTransport::fromRequest($request);
        $user = $verify->handle(
            (string) $request->validated('email'),
            (string) $request->validated('code'),
            $transport === AuthTransport::MOBILE ? ['BUYER'] : ['VENDOR'],
        );
        $audit->record($request, 'EMAIL_VERIFIED', true, $user);

        return ApiResponse::success(['verified' => true, 'next' => 'SIGN_IN']);
    }
}
