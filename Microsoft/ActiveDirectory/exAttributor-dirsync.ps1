# 2023 JLangisch.de
# Define the paths to your OUs
$internalOUPath = "XXXXXXXXX"
$mailaccountsOUPath = "XXXXXX"
$serviceOUPath = "XXXXXXXX"

# Define the values for extension attributes
$mailaccAttributeValue = "LegacyMailAccount"
$internalAttributeValue = "InternalAccount"
$serviceAttributeValue = "ServiceAccount"

# Function to set the extension attribute for users in a specific OU
function Set-ExtensionAttributeForOU {
    param (
        [string]$OUPath,
        [string]$extensionAttribute,
        [string]$attributeValue
    )
    # Get all user objects in the specified OU
    $usersInOU = Get-ADUser -SearchBase $OUPath -Filter {Enabled -eq $true} -Properties extensionAttribute1, extensionAttribute2, extensionAttribute3, extensionAttribute4, extensionAttribute5, extensionAttribute6, extensionAttribute7, extensionAttribute8, extensionAttribute9, extensionAttribute10

    # Set the extension attribute for each user in the OU
    foreach ($user in $usersInOU) {
        $user | Set-ADUser -Replace @{ $extensionAttribute = $attributeValue }
    }
}

# Run the script for each OU and set the appropriate extension attribute
Set-ExtensionAttributeForOU -OUPath $mailaccountsOUPath -extensionAttribute "extensionAttribute10" -attributeValue $mailaccAttributeValue
Set-ExtensionAttributeForOU -OUPath $internalOUPath -extensionAttribute "extensionAttribute10" -attributeValue $internalAttributeValue
Set-ExtensionAttributeForOU -OUPath $serviceOUPath -extensionAttribute "extensionAttribute10" -attributeValue $serviceAttributeValue
