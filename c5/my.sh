#!/bin/bash

cat << EOF > Containerfile
FROM ubi8/ubi:8.5

MAINTAINER chen chenzhan@ca.ibm.com

LABEL description="mode apache"

RUN yum -y install httpd && \
    yum clean all

RUN echo "Hello from Containerfile" > /var/www/html/index.html

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]
EOF

podman build --layers=false -t do180/apache .

podman run --name lab\-apache -d -p 10080:80 do180/apache 
curl localhost:10080
