<!doctype html>
<html lang="en">
<body style="font-family: Arial, sans-serif; color: #1f2937">
    <h1 style="font-size: 22px">Verify your MateryalPH account</h1>
    <p>Use this six-digit code for {{ str_replace('_', ' ', strtolower($purpose)) }}:</p>
    <p style="font-size: 28px; font-weight: 700; letter-spacing: 0.25em">{{ $code }}</p>
    <p>This code expires in {{ $expiresInMinutes }} minutes. MateryalPH will never ask you to share it.</p>
</body>
</html>
