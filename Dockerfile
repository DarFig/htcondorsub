#------------------------------
# htcondorexec imagen exec de condor sobre ubuntu
#------------------------------
# changelog
# - 1.0: basada en sshbaseimage, htcondor 9.0.0
#------------------------------


ARG VERSION=9.0.0
ARG VERSION_M=9.0
ARG HTCONDOR_LIST=/etc/apt/sources.list.d/htcondor.list

#FROM ghcr.io/darfig/sshbaseimage:latest
FROM ubuntu:20.04

LABEL manteiner="https://github.com/DarFig"
LABEL licenses="Apache-2.0"


#
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get install -y htop vim nano curl && \
    apt-get install -y openssh-server iputils-ping


#RUN echo "use ROLE : CentralManager"

ENV HTCONDOR_PASSWORD="NONE"
ENV CENTRAL_MANAGER="127.0.0.1"

#ADD https://get.htcondor.org /getcondor.sh
#RUN chmod u+x /getcondor.sh
#RUN /getcondor.sh --no-dry-run --channel stable

RUN apt-get install -y gnupg
RUN sh -c 'curl -fsSL https://research.cs.wisc.edu/htcondor/repo/keys/HTCondor-9.0-Key | apt-key add -'
RUN sh -c 'apt-get install apt-transport-https'
RUN sh -c 'echo "deb [arch=amd64] https://research.cs.wisc.edu/htcondor/repo/ubuntu/9.0 focal main" > /etc/apt/sources.list.d/htcondor.list'
RUN sh -c 'echo "deb-src https://research.cs.wisc.edu/htcondor/repo/ubuntu/9.0 focal main" >> /etc/apt/sources.list.d/htcondor.list'
RUN sh -c 'apt-get update'
RUN sh -c 'apt-get install -y procps'
RUN sh -c 'DEBIAN_FRONTEND=noninteractive apt-get install -y keyboard-configuration console-setup tzdata'
RUN sh -c 'apt-get install -y htcondor'

# add files

ADD run.sh /run.sh
RUN chmod a+x /run.sh

#ldap env-var
ENV LDAP_URI="ldap://"
ENV LDAP_BASE="dc=default,dc=com"
ENV LDAP_VERSION="3"
ENV PAM_PASSWORD="md5"

# config ldap
RUN touch /etc/ldap.conf
ADD common-session /etc/pam.d/common-session
ADD common-auth /etc/pam.d/common-auth
ADD nsswitch.conf /etc/nsswitch.conf


RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q build-essential apt-utils &&\
    apt-get install -y nscd ldap-utils &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -y -q ldap-auth-client


EXPOSE 9618
EXPOSE 22

#ENTRYPOINT ["configure.sh"]
ENTRYPOINT ["/run.sh"]
