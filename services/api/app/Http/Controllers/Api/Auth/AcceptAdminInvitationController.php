<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\Auth;

use App\Domain\Identity\AcceptAdminInvitation;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\AcceptAdminInvitationRequest;
use Illuminate\Http\JsonResponse;

final class AcceptAdminInvitationController extends Controller
{
    public function __invoke(AcceptAdminInvitationRequest $request, AcceptAdminInvitation $accept): JsonResponse
    {
        $user = $accept->handle(
            (string) $request->validated('token'),
            (string) $request->validated('full_name'),
            (string) $request->validated('password'),
        );

        return ApiResponse::success(['user_id' => $user->public_id, 'next' => 'SIGN_IN_AND_ENROLL_MFA'], status: 201);
    }
}
