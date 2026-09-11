<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="referrer" content="no-referrer">
    <title>Google sign-in · MateryalPH</title>
    <link rel="stylesheet" href="/auth/brand.css">
</head>
<body>
    <main>
        <img src="/auth/mark.png" alt="MateryalPH" width="64" height="64">
        <h1>Let’s get you back to sign in</h1>
        <p role="alert">{{ $message }}</p>
        <p>Return to the app or portal where you started. Your account has not been changed.</p>
        <nav aria-label="Return to MateryalPH">
            <a href="{{ rtrim(config('app.vendor_frontend_url'), '/') }}/login">Vendor sign in</a>
            <a href="{{ config('app.buyer_redirect_uri') }}">Open Buyer app</a>
        </nav>
        <p class="help">If the Buyer app does not open, close this browser tab and return to MateryalPH on your phone.</p>
    </main>
</body>
</html>
