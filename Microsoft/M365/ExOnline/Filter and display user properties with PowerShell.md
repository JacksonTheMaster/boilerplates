Created at 17.02.23;12:02 by ADMJLA

powershell
````powershell
$users | Where {$_.UserPrincipalName -notlike "*.domain.de"}| Select Name,DisplayN*,Userprin*,WhenC* | Out-GridView
````

The command is using the variable $users, which needs to be defined [[How to get all user mailboxes using PowerShell]], to get a list of user objects. Then it filters out the users whose UserPrincipalName does not end with “.domain.de” by using the Where clause. Next, it selects only the Name, DisplayName, UserPrincipalName and WhenCreated properties of the filtered users by using the Select cmdlet. Finally, it displays the selected properties in a grid view by using the Out-GridView cmdlet. This command needs to be executed after a Connect-ExchangeOnline request, so ExoModule is somewhat necesary.