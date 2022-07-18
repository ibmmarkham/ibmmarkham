#!/bin/bash

cat << EOF > Containerfile

FROM ubi8/ubi:8.5

MAINTAINER ibmcanada chenzhan@ca.ibm.com

ENV PORT 8080

RUN yum -y install httpd && yum clean all

RUN sed -i 's/^Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf && \
chown -R apache:apache /etc/httpd/logs/ && chown -R apache:apache /run/httpd/

EXPOSE \$PORT

USER apache

COPY ./src/ /var/www/html

CMD ["httpd", "-D", "FOREGROUND"]

EOF

podman build --layers=false -t do180/custom-apache .

podman run -d --name containerfile -p 20080:8080 do180/custom-apache

podman ps

curl localhost:20080
