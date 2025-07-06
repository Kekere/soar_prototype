FROM debian:bookworm-slim

# Install Dovecot
RUN apt-get update && apt-get install -y \
    dovecot-core \
    dovecot-imapd \
    dovecot-pop3d \
    passwd \
    && apt-get clean

# Create vmail user and mail directory
RUN useradd -r -u 5000 -g nogroup vmail && \
    mkdir -p /var/mail/roundcube && \
    chown -R vmail:nogroup /var/mail

# Create Maildir structure manually (safer)
RUN mkdir -p /var/mail && \
    maildirmake.dovecot /var/mail/roundcube && \
    chown -R vmail:nogroup /var/mail/roundcube

# Copy config and password file
COPY dovecot.conf /etc/dovecot/dovecot.conf
COPY passwd /etc/dovecot/passwd

EXPOSE 143
CMD ["dovecot", "-F"]
