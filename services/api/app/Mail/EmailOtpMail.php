<?php

declare(strict_types=1);

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

final class EmailOtpMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(
        public readonly string $code,
        public readonly string $purpose,
        public readonly int $expiresInMinutes,
    ) {}

    public function envelope(): Envelope
    {
        return new Envelope(subject: 'Your MateryalPH verification code');
    }

    public function content(): Content
    {
        return new Content(
            view: 'mail.email-otp',
            with: [
                'code' => $this->code,
                'purpose' => $this->purpose,
                'expiresInMinutes' => $this->expiresInMinutes,
            ],
        );
    }
}
