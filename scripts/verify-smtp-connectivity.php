<?php

declare(strict_types=1);

$host = $argv[1] ?? 'mailpit';
$port = isset($argv[2]) ? filter_var($argv[2], FILTER_VALIDATE_INT) : 1025;
if (! is_string($host) || $host === '' || ! is_int($port) || $port < 1 || $port > 65535) {
    fwrite(STDERR, "SMTP connectivity verifier arguments are invalid.\n");
    exit(2);
}

$errorCode = 0;
$errorMessage = '';
$socket = @fsockopen($host, $port, $errorCode, $errorMessage, 5);
if ($socket === false) {
    fwrite(STDERR, "Mailpit SMTP connectivity failed.\n");
    exit(1);
}

fclose($socket);
fwrite(STDOUT, "Mailpit SMTP connectivity passed.\n");
