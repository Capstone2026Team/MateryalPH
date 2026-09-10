<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\Auth;

use App\Domain\Identity\EmailOtpService;
use App\Http\ApiResponse;
use App\Http\AuthTransport;
use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class ResendVerificationController extends Controller
{
    public function __invoke(Request $request, EmailOtpService $otps): JsonResponse
    {
        $validated = $request->validate(['email' => ['required', 'email:rfc', 'max:254']]);
        $transport = AuthTransport::fromRequest($request);
        $accountTypes = $transport === AuthTransport::MOBILE ? ['BUYER'] : ['VENDOR'];
        $user = User::query()
            ->whereRaw('LOWER(email) = ?', [mb_strtolower(trim($validated['email']))])
            ->whereIn('account_type', $accountTypes)
            ->first();
        if ($user !== null && $user->account_status === 'PENDING_VERIFICATION') {
            $otps->issue($user->email, 'EMAIL_VERIFICATION', $user);
        }

        return ApiResponse::success(['message' => 'If verification is available, a new code has been sent.']);
    }
}
