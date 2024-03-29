# AD user an cloud user anflanschen

Basically die objectID vom AD objekt in die immutable ID vom cloud objekt einfügen.

Attribute vom AD obj werden dann in der Cloud übernommen.

Wenn ein neues AD obj mit einem bestehenden Cloudobj verknüpft werden soll, den User unbedingt in LOST&FOUND anlegen!


 
## Zunächst brauchen wir die ObjectID vom AD objekt:

```ps
Get-ADUser -Identity Testuser05 | Select-Object ObjectGUID
```


### Aus dieser Object ID generieren wir nun einen Base64 String:

```ps
$guid = [GUID]'HIERDIEID'

$base64Guid = [System.Convert]::ToBase64String($guid.ToByteArray())
Write-Host $base64Guid
```

### Nun connecten wir uns mit Azure AD & MsolSevice:

```ps
Connect-AzureAD
Connect-MsolService
```

### Nun kann die ImmutableID des Cloudobjekts gesetzt werden:

Hierfür benötigen wir die ObjectID des Cloudobjekts:

```ps
Get-AzureADUser -ObjectId "testuser05@domain.de"| select-object ObjectID
```

### Zur Sicherheit empfiehlt es sich, die bisherige ImmutableID  während der arbeiten zwischenzuspeichern. 

```ps
Get-MsolUser -ObjectId 'OBJECTID_AAD' | select-object ImmutableID
```

### Diese Object ID und den generierten base64 string können wir hier einsetzen:

```ps
Set-MsolUser -ObjectId 'OBJECTID_AAD' -ImmutableId "BASE64GUID"
```

### Nun können wir mit folgendem befehl die changes einsehen. 

```ps
Get-MsolUser -ObjectId 'OBJECTID_AAD' | select *
```