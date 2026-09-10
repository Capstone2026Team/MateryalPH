<?php

declare(strict_types=1);

namespace App\Models;

use App\Models\Concerns\HasUuidV7;
use Illuminate\Database\Eloquent\Model;

abstract class UuidModel extends Model
{
    use HasUuidV7;

    public $incrementing = false;

    protected $keyType = 'string';

    protected $guarded = [];
}
