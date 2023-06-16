<#  
#   
#   This Script will prepare a client pc/server and an Azure AD to allow unattended script logins in AAD and ExchangeOnline
#   by
#    1) creating a self signed cert, converting it to an X509Certificate and save it in local machine private certs
#    2) creating a new Azure AD Application and binding the certificate to it 
#    3) setting roles for the Application
#
#   NOTE:
#    You have to add API permissions for the App manually in Azure AD GUI (this particular permission is not supported by PowerShell yet)
#    
#       --> API Permissions
#           --> Add a permission
#               --> Office 365 Exchange Online
#                   --> Application permissions
#                       --> Exchange.ManageAsApp
#                           --> Grant admin concent for <OrgName>
#       
#>  


# Set temporary path for private certificate
$CertificatePath = "C:\path\UnattendedAzureADConnectionCertificate.pfx"
# The Name for the App to be created
$Appname = "string"
# The Domain in which the App is to be created
$domain = "string"


Connect-AzureAD

# Create the self signed private cert with 5 years validity
$currentDate = Get-Date
$endDate = $currentDate.AddYears(5)
$notAfter = $endDate.AddYears(5)
$pwd = "[CHANGEME]"
$thumb = (New-SelfSignedCertificate -CertStoreLocation cert:\localmachine\my -DnsName $domain -KeyExportPolicy Exportable -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" -NotAfter $notAfter).Thumbprint

# Export
$pwd = ConvertTo-SecureString -String $pwd -Force -AsPlainText
Export-PfxCertificate -cert "cert:\localmachine\my\$thumb" -FilePath $CertificatePath -Password $pwd
    
# Load the certificate
$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate($CertificatePath, $pwd)
$keyValue = [System.Convert]::ToBase64String($cert.GetRawCertData())
    
    
# Create the Azure Active Directory Application
$application = New-AzureADApplication -DisplayName $Appname -IdentifierUris $domain
New-AzureADApplicationKeyCredential -ObjectId $application.ObjectId -CustomKeyIdentifier $Appname -StartDate $currentDate -EndDate $endDate -Type AsymmetricX509Cert -Usage Verify -Value $keyValue
    
# Create the Service Principal and connect it to the Application
$sp = New-AzureADServicePrincipal -AppId $application.AppId
    
# Give the Service Principal User Admin permissions to the current tenant (Add-AzureADDirectoryRole)
$roleId_userAdministrator = (Get-AzureADDirectoryRole | ? { $_.DisplayName -eq "User Administrator" }).ObjectId
$roleId_exchangeAdmin = (Get-AzureADDirectoryRole | ? { $_.DisplayName -eq "Exchange Administrator" }).ObjectId

Add-AzureADDirectoryRoleMember -ObjectId $roleId_exchangeAdmin -RefObjectId $sp.ObjectId
Add-AzureADDirectoryRoleMember -ObjectId $roleId_userAdministrator -RefObjectId $sp.ObjectId
    
# Remove temp private certificate because it's no longer needed
Remove-Item $CertificatePath