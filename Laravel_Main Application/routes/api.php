<?php

use App\Http\Controllers\Api\HealthController;
use App\Http\Controllers\Api\ProductController;
use Illuminate\Support\Facades\Route;

Route::get('/health', HealthController::class);
Route::apiResource('/products', ProductController::class);
