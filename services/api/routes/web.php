<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return response()->json([
        'message' => 'Hybrid stack API ready',
        'frontend' => ['admin', 'vendor', 'mobile'],
    ]);
});
