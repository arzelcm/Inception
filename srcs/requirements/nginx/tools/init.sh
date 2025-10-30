#! /bin/sh

create_tls_cert()
{
    if [ -f /etc/ssl/certs/cert.crt ] && [ -f /etc/ssl/private/cert.key ]; then return 0; fi;

    openssl req -x509 \
                -nodes \
                -days 365 \
                -newkey rsa:4096 \
                -keyout /etc/ssl/private/cert.key \
                -out /etc/ssl/certs/cert.crt \
                -subj "/C=SP/ST=Barcelona/L=Barcelona/O=42bcn/OU=42bcn"
}

create_tls_cert
exec "$@"
