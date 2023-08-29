$exePath = Get-Location
$jarFiles = Get-ChildItem -Path $exePath -Filter "*.jar"

foreach ($jarFile in $jarFiles) {
    $executionResult = Start-Process -FilePath "$exePath\A.exe" -ArgumentList "$($jarFile.FullName)" -Wait -PassThru

    if ($executionResult.ExitCode -eq 0) {
        $output = $executionResult.StandardOutput
        if ($output -contains "OK") {
            $newFileName = "YYYY_" + $jarFile.Name
            $newFilePath = Join-Path -Path $exePath -ChildPath $newFileName
            Copy-Item -Path $jarFile.FullName -Destination $newFilePath
            Write-Host "실행 성공: $($jarFile.Name) -> $newFileName"
        } else {
            Write-Host "실행 결과 확인 실패: $($jarFile.Name)"
        }
    } else {
        Write-Host "실행 실패: $($jarFile.Name)"
    }
}
