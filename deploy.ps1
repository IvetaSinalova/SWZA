param(
  [string] $TargetDirectory = ""
)

$ErrorActionPreference = "Stop"

function Assert-LastExitCode {
  param(
    [string] $Action
  )

  if ($LASTEXITCODE -ne 0) {
    throw "$Action failed with exit code $LASTEXITCODE."
  }
}

function Read-RequiredValue {
  param(
    [string] $Name,
    [string] $Prompt,
    [string] $DefaultValue = ""
  )

  $currentValue = [Environment]::GetEnvironmentVariable($Name)
  if (-not [string]::IsNullOrWhiteSpace($currentValue)) {
    return $currentValue
  }

  if ([string]::IsNullOrWhiteSpace($DefaultValue)) {
    $value = Read-Host $Prompt
  } else {
    $value = Read-Host "$Prompt [$DefaultValue]"
    if ([string]::IsNullOrWhiteSpace($value)) {
      $value = $DefaultValue
    }
  }

  if ([string]::IsNullOrWhiteSpace($value)) {
    throw "$Name is required."
  }

  return $value
}

$ftpServer = Read-RequiredValue -Name "FTP_SERVER" -Prompt "FTP server" -DefaultValue "startupweekendzilina.sk"
$ftpUsername = Read-RequiredValue -Name "FTP_USERNAME" -Prompt "FTP username"
$ftpPassword = Read-RequiredValue -Name "FTP_PASSWORD" -Prompt "FTP password"

if ([string]::IsNullOrWhiteSpace($TargetDirectory)) {
  $ftpServerDir = Read-Host "FTP target directory [startupweekendzilina.sk/web/preview/]"
  if ([string]::IsNullOrWhiteSpace($ftpServerDir)) {
    $ftpServerDir = "startupweekendzilina.sk/web/preview/"
  }
} else {
  $ftpServerDir = $TargetDirectory
}

$ftpServerDir = $ftpServerDir.Trim("/").TrimEnd("/")

Write-Host "Deploy target: ftp://$ftpServer/$ftpServerDir/"

Write-Host "Building Astro site..."
npm run build
Assert-LastExitCode "Astro build"

if (-not (Test-Path "dist/index.html")) {
  throw "Build finished, but dist/index.html was not created."
}

Write-Host "Checking FTP login..."
curl.exe --fail --show-error --ftp-ssl --insecure --ftp-pasv --disable-epsv `
  --user "$($ftpUsername):$($ftpPassword)" `
  "ftp://$ftpServer/"
Assert-LastExitCode "FTP login check"

$files = Get-ChildItem -Path "dist" -File -Recurse

if ($files.Count -eq 0) {
  throw "Build output folder dist is empty."
}

foreach ($file in $files) {
  $relativePath = [System.IO.Path]::GetRelativePath("dist", $file.FullName).Replace("\", "/")
  $remoteUrl = "ftp://$ftpServer/$ftpServerDir/$relativePath"

  Write-Host "Uploading $relativePath"
  curl.exe --fail --show-error --ftp-ssl --insecure --ftp-pasv --disable-epsv --ftp-create-dirs `
    --user "$($ftpUsername):$($ftpPassword)" `
    --upload-file "$($file.FullName)" `
    "$remoteUrl"
  Assert-LastExitCode "Upload $relativePath"
}

Write-Host "Checking deployed files in target directory..."
curl.exe --fail --show-error --ftp-ssl --insecure --ftp-pasv --disable-epsv `
  --user "$($ftpUsername):$($ftpPassword)" `
  "ftp://$ftpServer/$ftpServerDir/"
Assert-LastExitCode "Remote directory listing"

Write-Host "Deploy finished."
