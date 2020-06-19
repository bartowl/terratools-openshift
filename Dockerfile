FROM rendanic/terratools
MAINTAINER Bartlomiej Sowa <bartlomiej.sowa@opitz-consulting.com>

COPY sshd-config /etc/ssh/sshd_config
COPY openshift-entrypoint.sh /
RUN chown 0:0 /etc/shadow
RUN chmod g=u /etc/passwd /etc/shadow /etc/group
RUN chmod 755 /openshift-entrypoint.sh
RUN chmod 777 /home/terraform
RUN apk add --no-cache libcap
RUN /usr/sbin/setcap 'cap_net_bind_service=+ep' /usr/sbin/sshd

USER 12345

ENTRYPOINT /openshift-entrypoint.sh
VOLUME /home/terraform

EXPOSE 22/tcp

CMD ["/usr/sbin/sshd", "-D", "-d"]
