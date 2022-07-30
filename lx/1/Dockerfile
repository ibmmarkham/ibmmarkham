FROM ubi8/ubi:8.6

LABEL description "This is a custom httpd container image"

MAINTAINER chen chen@ibm 

RUN yum -y install httpd unzip && yum clean all

EXPOSE 80

#ENV LogLevel "info"
COPY ./all.zip /var/www/html/
COPY ./all.zip /tmp
WORKDIR /var/www/html/
RUN unzip /var/www/html/all.zip

#USER apache

#ENTRYPOINT ["/usr/sbin/httpd"]

CMD ["httpd","-D", "FOREGROUND"]
