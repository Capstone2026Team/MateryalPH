<?php

declare(strict_types=1);

namespace App\Models\Concerns;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

trait HasUuidV7
{
    protected static function bootHasUuidV7(): void
    {
        static::creating(function (Model $model): void {
            if (in_array('public_id', $model->getFillable(), true) && blank($model->getAttribute('public_id'))) {
                $model->setAttribute('public_id', (string) Str::uuid7());
            }

            if ($model->getKeyName() === 'id' && ! $model->getIncrementing() && blank($model->getKey())) {
                $model->setAttribute('id', (string) Str::uuid7());
            }
        });
    }
}
