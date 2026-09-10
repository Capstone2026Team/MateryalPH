<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\Auth;

use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class SessionController extends Controller
{
    public function __invoke(Request $request): JsonResponse
    {
        $user = $request->user();

        return ApiResponse::success(['user' => [
            'id' => $user->public_id,
            'name' => $user->name,
            'email' => $user->email,
            'account_type' => $user->account_type,
        ]]);
    }
}
