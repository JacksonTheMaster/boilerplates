#Cleans all assigned owner permissions of one user
#needed for admin maintenance cleanups

#Variables for processing 
$AdminURL = "https://TENANT-admin.sharepoint.com/"
$LoginUser = "user.admin@TENANT.onmicrosoft.com"
$AdminAccount = "user.admin@TENANT.onmicrosoft.com"
 
#Connect to SharePoint Online
Connect-SPOService -url $AdminURL -credential (Get-Credential)
 
#Get All Site Collections
$Sites = Get-SPOSite -Limit ALL -IncludePersonalSite $true
 
#Loop through each site and remove site collection admin
Foreach ($Site in $Sites) {
    Write-host "_________ START SITE _________" -f Yellow
    Write-host "Checking Site:"$Site.URL -f Yellow
    $wasSiteAdmin = $False
    $isOnlyAdmin = $False
    try {
        Get-SPOUser -Site $site.Url
        $wasSiteAdmin = $True
        Write-host "Is Admin" -f Green
    }
    catch {
        $wasSiteAdmin = $False
        Write-host "Not Admin" -f Green
        Set-SPOUser -site $Site -LoginName $LoginUser -IsSiteCollectionAdmin $True
    }
    #Get All Site Collection Administrators
    $Admins = Get-SPOUser -Site $site.Url | Where { $_.IsSiteAdmin -eq $True }
 
    #Iterate through each admin
    Foreach ($Admin in $Admins) {
        #Check if the Admin Name matches
        If ($Admin.LoginName -eq $AdminAccount) {
            If ($Admins.Count -gt 1) {
                #Remove Site collection Administrator
                Write-host "Removing Site Collection Admin from:"$Site.URL -f Green
                Set-SPOUser -site $Site -LoginName $AdminAccount -IsSiteCollectionAdmin $False
            }
            Else {
                Write-host "Admin to remove Is only Admin!" -f Green
            }
            
            
        }
    }

    if (!$wasSiteAdmin) {
        Write-host "Resetting Own Admin:" -f Green
        Set-SPOUser -site $Site -LoginName $LoginUser -IsSiteCollectionAdmin $False
    }

    Write-host "_________ END SITE _________" -f Yellow
    Write-host ""
}
