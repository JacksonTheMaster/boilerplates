# Define the array of departments
$departments = @(
    "Department",
    "Department",
    "Department",
    "Department",
    "Department",
    "Department",
    "Department",
    "Department",
    "Department",
    "Department",
    "Department",
    "Department",
    "Department",
    "Department",
    "Department",
    "Department",
    "Department",
    "IT Serviceaccount"
)

# Get all users and their department and job title information, and sort by UPN
$output = Get-ADUser -SearchBase "OU=users,OU=location,OU=location,DC=domain,DC=de" -SearchScope OneLevel -Filter * -Properties Department, Title | Select-Object Name, Department, Title, SamAccountName | Sort-Object Name



# Iterate through each user in the output
foreach ($user in $output) {
    # Get the user's department and job title
    $userDepartment = $user.Department
    $userJobTitle = $user.Title

    # If the department value is empty, set it to "Not set"
    if ([string]::IsNullOrEmpty($userDepartment)) {
        $userDepartment = "Not set"
    }

    # Skip the user if their department matches any of the departments in the array
    if ($departments -contains $userDepartment) {
        Write-Host "Skipping user $($user.name) as their department is already set to $($userDepartment)" -ForegroundColor Yellow
        continue
    }

    # Display the user's information
    Write-Host "User: $($user.name)" -ForegroundColor Cyan
    Write-Host "Current department: $($userDepartment)" -ForegroundColor Red
    Write-Host "Job title: $($userJobTitle)" -ForegroundColor Yellow
    
    # Ask for input to change the department or skip the user
    $input = Read-Host "Do you want to change the department? (Enter a department number to change or anything else to skip)"
    
    # If the input is a number, change the department
    if ($input -match "^\d+$" -and $input -gt 0 -and $input -le $departments.Count) {
        $newDepartment = $departments[$input - 1]
        Set-ADUser -Identity $user.SamAccountName -Department $newDepartment
        Write-Host "Department set to $($newDepartment)" -ForegroundColor Green
    }
    else {
        Write-Host "Skipping user" -ForegroundColor Yellow
    }
}
