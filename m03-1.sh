#!/bin/bash
workDir=/home/student/local/mysql

if [ -z $workDir ]
then
	rm -rf $workDir
fi

mkdir -p $workDir


ls -alZd $workDir

podman unshare chown -R 27:27 $workDir

sudo semanage fcontext -a -t container_file_t '/home/student/local/mysql(/.*)?'

sudo restorecon -Rv $workDir

echo "After change"
ls -alZd $workDir

echo login registry
podman login registry.redhat.io -u chenzhan-ca -p IBMrh6498200!

podman pull registry.redhat.io/rhel8/mysql-80:1

podman run --name persist-db -d -v $workDir:/var/lib/mysql/data \
       -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 \
       -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 \
 	registry.redhat.io/rhel8/mysql-80:1

sleep 9

podman ps --format="{{.ID}} {{.Names}} {{.Status}}"
ls -l $workDir

podman unshare ls -ld /home/student/local/mysql
