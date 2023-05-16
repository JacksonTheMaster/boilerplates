Created at 17.02.23;12:02 by ADMJLA

powershell
````powershell
$users = Get-Mailbox -Resultsize Unlimited -RecipientTypeDetails usermailbox | Select *
````

The command $users = Get-Mailbox -Resultsize Unlimited -RecipientTypeDetails usermailbox | Select * is using the Get-Mailbox cmdlet to get all mailboxes that have a recipient type detail of user mailbox. The ResultSize parameter specifies the maximum number of results to return. If you set this parameter to Unlimited, it returns all mailboxes. The Select * part returns all properties of each mailbox.

Before you run this command, you need to connect to Exchange Online PowerShell. You can do this by using the Connect-ExchangeOnline cmdlet.