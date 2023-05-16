# Im AD Löschen (oder in Lost&Found verschieben)

Delta Sync durchführen

**ACHTUNG:**

### Nach dem DelaSync etwas warten, dann nochmal DeltaSyncen, da ein Delete immer beim nächsten Sync noch einmal verifiziert wird.

Erst  jetzt kann der user als clouduser restored werden:

Admin Center - > Deleted users - > restore



# Source Anchor / immutable ID vom Cloudobjekt löschen.

Windows Powershell: 

Connect-AzureAD

## Object ID ziehen:

Get-AzureADUser -ObjectId "testuser05@domain.de"| select-object ObjectID

Connect-MsolService
### Backup

Zur Sicherheit empfiehlt es sich, die bisherige ImmutableID  während der Arbeiten zwischenzuspeichern. 

Get-MsolUser -ObjectId 'OBJECTID_AAD' | select-object ImmutableID

## ImmutableID nullen

Set-MsolUser -ObjectId 'OBJECTID_AAD' -ImmutableId "$null"

delta sync durchführen


Wenn man ungeduldig war und es feher wirft, alte immutableID setzen, warten, wiederholen. Beim zweiten mal einfach einen Kaffe dazwischen holen, das passt Zeitlich.

Set-MsolUser -ObjectId 'OBJECTID_AAD' -ImmutableId "7fS1dztiq0SRQGHficOMCA=="
