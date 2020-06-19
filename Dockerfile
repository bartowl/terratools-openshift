FROM rendanic/terratools
MAINTAINER Bartlomiej Sowa <bartlomiej.sowa@opitz-consulting.com>

COPY sshd-config /etc/ssh/sshd_config
COPY openshift-entrypoint.sh /
RUN chmod g=u /etc/passwd /etc/shadow
RUN chgrp 0 /home/terraform
RUN chmod 775 /openshift-entrypoint.sh

USER 12345

ENTRYPOINT /openshift-entrypoint.sh
VOLUME /home/terraform

CMD /usr/sbin/sshd
