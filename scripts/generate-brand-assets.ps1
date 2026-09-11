$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$repoRoot = Split-Path $PSScriptRoot -Parent

function Export-SquareImage([string]$Source, [string]$Destination, [int]$Size) {
    $image = [System.Drawing.Image]::FromFile((Join-Path $repoRoot $Source))
    $bitmap = [System.Drawing.Bitmap]::new($Size, $Size)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    try {
        $graphics.Clear([System.Drawing.Color]::White)
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $ratio = [Math]::Min($Size / $image.Width, $Size / $image.Height)
        $width = [int][Math]::Round($image.Width * $ratio)
        $height = [int][Math]::Round($image.Height * $ratio)
        $graphics.DrawImage($image, [int](($Size - $width) / 2), [int](($Size - $height) / 2), $width, $height)
        $bitmap.Save((Join-Path $repoRoot $Destination), [System.Drawing.Imaging.ImageFormat]::Png)
    } finally {
        $graphics.Dispose()
        $bitmap.Dispose()
        $image.Dispose()
    }
}

$mobileSource = 'materials/Logo/Icon with no name_whitebackground.jpg'
Export-SquareImage $mobileSource 'apps/buyer-mobile/assets/branding/app-icon.png' 1024
foreach ($density in @{ mdpi = 48; hdpi = 72; xhdpi = 96; xxhdpi = 144; xxxhdpi = 192 }.GetEnumerator()) {
    Export-SquareImage $mobileSource "apps/buyer-mobile/android/app/src/main/res/mipmap-$($density.Key)/ic_launcher.png" $density.Value
}
$iosDir = 'apps/buyer-mobile/ios/Runner/Assets.xcassets/AppIcon.appiconset'
$catalog = Get-Content -LiteralPath (Join-Path $repoRoot "$iosDir/Contents.json") -Raw | ConvertFrom-Json
foreach ($item in $catalog.images) {
    $size = [int]([double]($item.size.Split('x')[0]) * [double]($item.scale.TrimEnd('x')))
    Export-SquareImage $mobileSource "$iosDir/$($item.filename)" $size
}
foreach ($portal in @('vendor-web', 'admin-web')) {
    Export-SquareImage 'materials/Logo/Icon with name_White background.jpg' "apps/$portal/public/brand/favicon.png" 64
}
Copy-Item -LiteralPath (Join-Path $repoRoot 'materials/Logo/Icon with no name_No background.png') -Destination (Join-Path $repoRoot 'apps/vendor-web/public/brand/materyalph-mark.png')
$onboarding = @{
    'Hero_for source samrt, build fast (2).png' = 'source-smart.png'
    'Hero_for Find Suppliers Near Your Site (2).png' = 'find-suppliers.png'
    'Hero_for Plan Every Phase, Track Every Peso (2).png' = 'plan-project.png'
}
foreach ($asset in $onboarding.GetEnumerator()) {
    Copy-Item -LiteralPath (Join-Path $repoRoot "materials/Mobile Onbording Images/$($asset.Key)") -Destination (Join-Path $repoRoot "apps/buyer-mobile/assets/onboarding/$($asset.Value)")
}
Write-Output 'Generated proportion-preserving Android, iOS and web icons; copied supplied transparent assets.'
