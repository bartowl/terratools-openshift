FROM rendanic/terratools
MAINTAINER Bartlomiej Sowa <bartlomiej.sowa@opitz-consulting.com>

COPY sshd-config /etc/ssh/sshd_config
COPY openshift-entrypoint.sh /
RUN chown 0:0 /home/terraform /home /etc/shadow
RUN chmod g=u /etc/passwd /etc/shadow /home
RUN chmod 775 /openshift-entrypoint.sh

USER 12345

ENTRYPOINT /openshift-entrypoint.sh
VOLUME /home/terraform

EXPOSE 2222/tcp

CMD /usr/sbin/sshd
