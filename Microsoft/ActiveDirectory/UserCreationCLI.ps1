#
#
#
#This is a run-to-configure script for creating users in an AD with some attributes rather than adding them manually
#
#No need for configuration below.
#
#
#

---
> ## ⚠️DEPRECATED⚠️
> 
> **Note**: This documentation has moved. Please refer to [the new documentation site](https://docs.jmg-it.de/), wich is still WIP!
---



# Import the Active Directory module
Import-Module ActiveDirectory

# Prompt the user for the name and surname
$name = Read-Host "Enter the user's Given name / Vorname"
$surname = Read-Host "Enter the user's surname / Nachname"

# Construct the login name and display name
$loginName = "$name.$surname"
$displayName = "$surname, $name"

# Prompt the user for the name of the template user
$templateUser = Read-Host "Enter the name of the template user (leave empty for default groups and no template user)"

# Check if the template user is specified
if ($templateUser -ne "") {
    # Get the template user object
    $template = Get-ADUser -Identity $templateUser

    # Get the MemberOf property of the template user
    $templateGroups = Get-ADPrincipalGroupMembership -Identity $templateUser | Where-Object {
        $_.Name -ne "Domain-Users" -and $_.Name -notlike "Group_*"
    }
} else {
    # Set the template groups to only include the VPN-Users group
    Write-Host "Using default groups VPN-Users and Domain-Users"
    $templateGroups = "CN=VPNUsers,OU=Gruppen,OU=Location,OU=Standorte,DC=ad.jmg-it.de,DC=de"
}

# Prompt the user for whether they want to use the default password for the new user
$useDefaultPassword = Read-Host "Do you want to use the default password for the new user? (Y/N) (enter for Y)"

# Set the default password and cry in plaintext
$defaultPassword = ConvertTo-SecureString "DefaultPw123!" -AsPlainText -Force

# Check if the user wants to use the default password or specify their own
if ($useDefaultPassword -eq "Y" -or $useDefaultPassword -eq "") {
    $password = $defaultPassword
} else {
    $password = Read-Host "Enter the password for the NEW user" -AsSecureString
}
# Get the template user object


#Create a email adress for the user
$email = "$name.$surname@ad.jmg-it.de"

Write-Host "Created email:" + $email

$DistinguishedName = "OU=Benutzer,OU=location,OU=Standorte,DC=ad.jmg-it.de,DC=de"

# Create the new user with the login name and display name, copying the rights of the template user
New-ADUser -Name $displayName -SamAccountName $loginName -UserPrincipalName "$loginName@ad.jmg-it.de" -EmailAddress $email -GivenName $name -Surname $surname -AccountPassword $password -Path $DistinguishedName -Instance $template

# Add the new user to the groups that the template user is a member of
$newuser = Get-ADUser -Identity $loginName
foreach ($group in $templateGroups) {
    Add-ADPrincipalGroupMembership -Identity $newuser -MemberOf $group
    Write-Host "Successfully added to" $group
}

# Display a success message
Write-Host "Successfully created user $loginName with display name $displayName and rights of template user $templateUser if specified"
