FROM ubuntu:16.04

# Add users and groups first, so we can keep the uids and gids consistent
# between containers.
RUN groupadd ssh-user
RUN groupadd sftponly
RUN useradd -M -d /upload -s /bin/sh -G sftponly,ssh-user sftp

# Unlock the sftp user by making the password hash unresolvable
RUN sed -i 's/sftp:!:/sftp:\*:/' /etc/shadow

RUN apt-get update && apt-get install -y openssh-server less
RUN mkdir /var/run/sshd

RUN sed -i '/PermitRootLogin/c\PermitRootLogin no' /etc/ssh/sshd_config

RUN sed -i '/AuthorizedKeysFile/c\AuthorizedKeysFile      /keys/%u/.ssh/authorized_keys' /etc/ssh/sshd_config

RUN sed -i '/PasswordAuthentication/c\PasswordAuthentication no' /etc/ssh/sshd_config

RUN sed -i '/Subsystem sftp/c\Subsystem sftp internal-sftp -l VERBOSE' /etc/ssh/sshd_config

RUN sed -i '/UsePAM/c\UsePAM no' /etc/ssh/sshd_config

RUN echo '\n\
KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256\n\
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\n\
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-ripemd160-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160,umac-128@openssh.com\n\
\n\
AllowGroups ssh-user\n\
\n\
Match group sftponly\n\
    ChrootDirectory %h\n\
    X11Forwarding no\n\
    AllowTcpForwarding no\n\
    ForceCommand internal-sftp -l VERBOSE\n\
' >> /etc/ssh/sshd_config

VOLUME ["/keys"]

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
