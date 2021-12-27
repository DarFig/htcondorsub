#!/bin/bash

# configure condor
CONFIG_FILE="/etc/condor/config.d/01-submit.config"
echo CONDOR_HOST = ${CENTRAL_MANAGER} > ${CONFIG_FILE}
echo '# For details, run condor_config_val use role:get_htcondor_submit' >> ${CONFIG_FILE}
echo 'use role:get_htcondor_submit' >> ${CONFIG_FILE}

# filesystemdomian
echo "FILESYSTEM_DOMAIN = ${FILESYSTEM_DOMAIN}"  >> ${CONFIG_FILE}
echo "UID_DOMAIN = ${FILESYSTEM_DOMAIN}"  >> ${CONFIG_FILE}
echo "TRUST_UID_DOMAIN = TRUE"  >> ${CONFIG_FILE}
echo "SOFT_UID_DOMAIN = TRUE"  >> ${CONFIG_FILE}


#token
rm -f /etc/condor/config.d/00-htcondor-${VERSION_M}.config
echo -n "${HTCONDOR_PASSWORD}" | sh -c "condor_store_cred add -c -i -"
# Now issue myself a token.
umask 0077; condor_token_create -identity condor@${CENTRAL_MANAGER} > /etc/condor/tokens.d/condor@${CENTRAL_MANAGER}

# condor_config options
#echo SCHEDD_NAME = ${CENTRAL_MANAGER} >> /etc/condor/condor_config

#start condor
condor_master



#configure
echo "base $LDAP_BASE" >> /etc/ldap.conf
echo "uri $LDAP_URI" >> /etc/ldap.conf
echo "ldap_version $LDAP_VERSION" >> /etc/ldap.conf
echo "pam_password $PAM_PASSWORD" >> /etc/ldap.conf

#echo $LDAP_BASE
#apt-get install -y nscd ldap-utils
#DEBIAN_FRONTEND=noninteractive apt-get install -y -q ldap-auth-client


sleep 1
#start services
service ssh start
service nscd start
systemctl enable nscd
#sleep 100

#launch schedd

#condor_schedd

while :; do :; done & kill -STOP $! && wait $!
