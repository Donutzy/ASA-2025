FROM ubuntu:latest

RUN apt-get update 
RUN apt-get install -y bind9 dnsutils

CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]
