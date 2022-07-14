#!/bin/bash

if [ -d /home/student/local/mysql ]
then
	rm -rf /home/student/local/mysql
fi

mkdir -p /home/student/local/mysql

echo setting up permission

podman unshare chown -R 27:27 /home/student/local/mysql
sudo semanage fcontext -a -t container_file_t '/home/student/local/mysql(/.*)?'
sudo restorecon -Rv /home/student/local/mysql
echo after chaning
ls -Zd /home/student/local/mysql

podman run --name mysql-1 -d -v /home/student/local/mysql:/var/lib/mysql/data -p 13306:3306 -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55  registry.redhat.io/rhel8/mysql-80:1

sleep 10
podman ps
podman cp /home/student/DO180/labs/manage-review/db.sql mysql-1:/
podman exec mysql-1 /bin/bash -c "mysql items -uuser1 -pmypa55 < /db.sql"

podman stop mysql-1

podman run --name mysql-2 -d -v /home/student/local/mysql:/var/lib/mysql/data -p 13306:3306 -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 registry.redhat.io/rhel8/mysql-80:1

sleep 10

podman ps -a > /tmp/my-containers
podman exec mysql-2 /bin/bash -c "mysql items -uuser1 -pmypa55 -p127.0.0.1 -e 'select * from Item'"

mysql items -P13306 -uuser1 -pmypa55 -h127.0.0.1 -e "insert into Item(description, done) values('Finished lab',1)"

podman rm mysql-1
