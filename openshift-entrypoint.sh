#!/bin/sh
# based on uid_entrypoint from https://github.com/RHsyseng/container-rhel-examples/blob/master/starter-arbitrary-uid/bin/uid_entrypoint
# override any image comand with local sshd, that stores host key in volume under HOME directory

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    sed "s/:12345:/:$(id -u):/" /etc/passwd > /tmp/passwd
    cat /tmp/passwd > /etc/passwd
    rm /tmp/passwd
    sed "s/:12345:/:$(id -u):/" /etc/group > /tmp/group
    cat /tmp/group > /etc/group
    rm /tmp/group
    [ "$HOME" = "/" ] && HOME="/home/terraform" && export HOME
  fi
  if [ -w /etc/shadow ]; then
    grep -v terraform /etc/shadow > /tmp/shadow
    if [ -z "$TERRAFORM_PASSWORD" ]; then
      TERRAFORM_PASSWORD=$(date|md5sum|cut -b0-12)
      echo "Generated random password: $TERRAFORM_PASSWORD as TERRAFORM_PASSWORD not specified"
    fi
    cat /tmp/shadow > /etc/shadow
    echo "terraform:$(mkpasswd $TERRAFORM_PASSWORD)::0:::::" >> /etc/shadow
    # now not GID_0 anymore :)
  fi
  [ -d "$HOME/.sshd" ] || mkdir "$HOME/.sshd"
  [ -f "$HOME/.sshd/sshd_rsa_key" ] || ssh-keygen -t rsa -f "$HOME/.sshd/sshd_rsa_key" -N ''

fi
exec /usr/sbin/sshd -D -d
