#!/bin/sh
# based on uid_entrypoint from https://github.com/RHsyseng/container-rhel-examples/blob/master/starter-arbitrary-uid/bin/uid_entrypoint
# override any image comand with local sshd, that stores host key in volume under HOME directory

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    sed -ie "s/:12345:/:$(id -u):/" /etc/passwd
  fi
  [ -d "$HOME/.sshd" ] || mkdir "$HOME/.sshd"
  [ -f "$HOME/.sshd/sshd_rsa_key" ] || ssh-keygen -t rsa -f "$HOME/.sshd/sshd_rsa_key" -N ''
  echo "${TERRAFORM_PASSWORD:-terraform}" | passwd --stdin terraform

fi
exec "$@"
