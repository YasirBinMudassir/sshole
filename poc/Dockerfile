# stock alpine + openssh-server, default sshd_config. alice has "*" (key-only), bob has a real password.
ARG BASE=alpine:3.24
FROM ${BASE}
RUN apk add --no-cache openssh-server && ssh-keygen -A \
 && adduser -D -s /bin/sh alice && adduser -D -s /bin/sh bob \
 && echo 'bob:BobPass-123' | chpasswd \
 && sed -i 's/^alice:[^:]*:/alice:*:/' /etc/shadow
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-e"]
