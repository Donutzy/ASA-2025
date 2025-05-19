FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y bind9 dnsutils &&

COPY named.conf /etc/bind/named.conf.local
COPY db.asa.local /etc/bind/zones/db.asa.br

CMD ["named", "-g", "-c", "/etc/bind/named.conf"]
