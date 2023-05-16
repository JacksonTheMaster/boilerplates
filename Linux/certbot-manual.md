idk what this does, maybe i should test it. But i found it in my docs, so it must work.

sudo apt-get install certbot

sudo certbot certonly --manual   --preferred-challenges=dns   --email info@domain.de   --server https://acme-v02.api.letsencrypt.org/directory   --agree-tos   --manual-public-ip-logging-ok   -d "domain.de"   -d "*.domain.de" -v 


add acme shit

verify with toolbox https://toolbox.googleapps.com/apps/dig/#TXT/_acme-challenge.jlangisch.de
done
