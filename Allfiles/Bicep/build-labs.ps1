$path = Get-Location
Get-ChildItem $path -Filter lab*.bicep |
ForEach-Object {
    Write-Host "Building $($_.Name) => ..\ARM\$($_.BaseName).json"
    bicep build $_.Name --outdir ..\ARM
}