Connect-AzureAD
$isMemberCount = 0
$isCreatedCount = 0
$fuckedUpCount = 0
$securityGroupName = "SG_ADM_Licensing"

$users = Import-Csv "C:\custom\all.csv"
foreach ($user in $users) {
    $upn = $user."Benutzername"

    # Check if usr exists in AAD
    $userObject = Get-AzureADUser -Filter "userPrincipalName eq '$upn'"

    if ($userObject) { 
        Write-Host "User '$upn' exists in AAD." -ForegroundColor Green
        $isCreatedCount += 1
        
        # Check if the user is part of the security group
        $isMember = Get-AzureADUserMembership -ObjectId $userObject.ObjectId | Where-Object {$_.ObjectId -eq $securityGroup.ObjectId}

        if ($isMember) {
            Write-Host "User '$upn' is member of sec group '$securityGroupName'." -ForegroundColor Green
            $isMemberCount += 1
        } else {
            Write-Host "User '$upn' is not member of sec group '$securityGroupName'." -ForegroundColor DarkYellow
        }
    } else {
        Write-Host "User '$upn' does not exist in Azure AD." -ForegroundColor Red
        $fuckedUpCount += 1
    }
}
Write-Host "Users Created: $isCreatedCount" -ForegroundColor Green
Write-Host "Users added to Sec Group: $isMemberCount" -ForegroundColor Green
Write-Host "Users fucked up: $fuckedUpCount" -ForegroundColor Red
