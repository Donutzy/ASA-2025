FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y bind9 dnsutils &&

COPY named.conf /etc/bind/named.conf.local
COPY db.asa.br /etc/bind/zones/db.asa.br

CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]
