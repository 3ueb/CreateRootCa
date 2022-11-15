# CreateRootCa

Change in the *.conf files the location information.
```
c = Country Name (2 letter code)
ST = State or Province Name (full name)
L = Locality Name (e.g., city)
O = Organization Name (e.g., company)
CN = Common Name (e.g., server FQDN)
```
Change in th passwort*.txt files the first line to a valid password.

Next, you create the CAs and the Endpoint certificate. It is essential to do it in the following order. 
```
CreateRootCa.sh
CreateIntermediatieCA.sh
CreateEnpointCert.sh
```
