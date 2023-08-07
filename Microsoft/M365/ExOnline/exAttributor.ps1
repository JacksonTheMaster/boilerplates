# 2023 JLangisch.de
$users = Get-Mailbox -Resultsize Unlimited -RecipientTypeDetails usermailbox | Select *

$students = $users | Where-Object { $_.UserPrincipalName -like "*@domain.de" } | Select-Object Name, DisplayName, UserPrincipalName, WhenCreated

# Initialize the counter variable
$successfulChanges = 0
$failedChanges = 0

$students | ForEach-Object {
    $studentUPN = $_.UserPrincipalName

    # Set the 'CustomAttribute10' for the student mailbox
    Set-Mailbox -Identity $studentUPN -CustomAttribute10 "StudentAccount" -ErrorAction SilentlyContinue

    # Check if the previous command was successful (no errors occurred)
    if ($?) {
        # Increment the counter for successful changes
        $successfulChanges++
        Write-Host "Attribute 'CustomAttribute10' set to 'StudentAccount' for student: $studentUPN"
    } else {
        Write-Host "Failed to set attribute 'CustomAttribute10' for student: $studentUPN" -ForegroundColor Red
        $failedChanges++
    }
    $successfulChanges
}

# Display the total count of successful changes
Write-Host "Total students changed: $successfulChanges"
Write-Host "Total students failed: $failedChanges"
