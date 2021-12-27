## htcondorcm

Image based on HTCondor execute with ldap authentication.

FROM ubuntu:20.04
licenses="Apache-2.0"

### ENV VAR

**ldap**
- LDAP_URI="ldap://"
- LDAP_BASE="dc=default,dc=com"
- LDAP_VERSION="3"
- PAM_PASSWORD="md5"

**htcondor**
- HTCONDOR_PASSWORD="NONE"
- CENTRAL_MANAGER="127.0.0.1"
- FILESYSTEM_DOMAIN=""

### PULL

docker pull ghcr.io/darfig/htcondorsub:latest
