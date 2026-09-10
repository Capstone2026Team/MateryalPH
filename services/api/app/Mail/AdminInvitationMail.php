<?php

declare(strict_types=1);

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

final class AdminInvitationMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(public readonly string $acceptUrl) {}

    public function envelope(): Envelope
    {
        return new Envelope(subject: 'Your MateryalPH admin invitation');
    }

    public function content(): Content
    {
        return new Content(view: 'mail.admin-invitation', with: ['acceptUrl' => $this->acceptUrl]);
    }
}
