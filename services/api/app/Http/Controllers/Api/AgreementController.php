<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

final class AgreementController extends Controller
{
    public function __invoke(): JsonResponse
    {
        $agreements = DB::table('agreement_versions as av')
            ->join('agreement_documents as ad', 'ad.id', '=', 'av.agreement_document_id')
            ->whereNull('av.retired_at')
            ->where('av.effective_at', '<=', now())
            ->whereIn('ad.code', ['TERMS_OF_SERVICE', 'PRIVACY_NOTICE'])
            ->orderBy('ad.code')
            ->get(['av.id', 'ad.code', 'ad.title', 'ad.audience', 'av.version', 'av.content_uri', 'av.effective_at'])
            ->map(fn ($row): array => [
                'id' => $row->id,
                'code' => $row->code,
                'title' => $row->title,
                'audience' => $row->audience,
                'version' => $row->version,
                'content_uri' => $row->content_uri,
                'effective_at' => $row->effective_at,
            ]);

        return ApiResponse::success($agreements);
    }
}
