$guid = [GUID]'ID-HERE'

$base64Guid = [System.Convert]::ToBase64String($guid.ToByteArray())
Write-Host $base64Guid