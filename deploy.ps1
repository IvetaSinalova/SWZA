$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

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
$ftpServerDir = Read-RequiredValue -Name "FTP_SERVER_DIR" -Prompt "FTP target directory" -DefaultValue "/startupweekendzilina.sk/web/preview/"

$ftpServerDir = $ftpServerDir.TrimEnd("/")

Write-Host "Building Astro site..."
npm run build

Write-Host "Checking FTP login..."
curl.exe --fail --show-error --ftp-ssl --insecure --ftp-pasv --disable-epsv `
  --user "$($ftpUsername):$($ftpPassword)" `
  "ftp://$ftpServer/"

$files = Get-ChildItem -Path "dist" -File -Recurse

foreach ($file in $files) {
  $relativePath = [System.IO.Path]::GetRelativePath("dist", $file.FullName).Replace("\", "/")
  $remoteUrl = "ftp://$ftpServer/$ftpServerDir/$relativePath"

  Write-Host "Uploading $relativePath"
  curl.exe --fail --show-error --ftp-ssl --insecure --ftp-pasv --disable-epsv --ftp-create-dirs `
    --user "$($ftpUsername):$($ftpPassword)" `
    --upload-file "$($file.FullName)" `
    "$remoteUrl"
}

Write-Host "Deploy finished."
