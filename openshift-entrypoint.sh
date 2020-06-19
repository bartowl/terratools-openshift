#!/bin/sh
# based on uid_entrypoint from https://github.com/RHsyseng/container-rhel-examples/blob/master/starter-arbitrary-uid/bin/uid_entrypoint
# override any image comand with local sshd, that stores host key in volume under HOME directory

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    sed "s/:12345:/:$(id -u):/" /etc/passwd > /tmp/passwd.tmp
    cat /tmp/passwd.tmp > /etc/passwd
    rm /tmp/passwd.tmp
    [ "$HOME" = "/" ] && HOME="/home/terraform" && export HOME
    chown -R "$(id -u)" "$HOME"
  fi
  [ -d "$HOME/.sshd" ] || mkdir "$HOME/.sshd"
  [ -f "$HOME/.sshd/sshd_rsa_key" ] || ssh-keygen -t rsa -f "$HOME/.sshd/sshd_rsa_key" -N ''
  echo "${TERRAFORM_PASSWORD:-terraform}" | passwd --stdin terraform

fi
exec "$@"
