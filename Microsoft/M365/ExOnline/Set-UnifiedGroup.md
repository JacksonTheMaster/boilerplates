Created at 17.02.23;11:02 by ADMJLA

powershell
````powershell
Set-UnifiedGroup
````

The command Set-UnifiedGroup is used to modify existing Microsoft 365 Groups. Before using this command, you need to connect to Exchange Online PowerShell by using Connect-ExchangeOnline. You can specify various parameters to change different settings of a group, such as its name, description, access type, language, etc. Some parameters are only available on New-UnifiedGroup and can’t be changed later, such as HiddenGroupMembershipEnabled. For a full list of parameters, see the source below.


Source: [Set-UnifiedGroup (ExchangePowerShell) | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/exchange/set-unifiedgroup?view=exchange-ps)