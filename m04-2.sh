#!/bin/bash

podman pull quay.io/redhattraining/nginx:1.17

podman images

podman run --name official-nginx -d -p 8080:80 quay.io/redhattraining/nginx:1.17

sleep 9

podman exec official-nginx /bin/bash -c 'echo "DO180" > /usr/share/nginx/html/index.html'

curl 127.0.0.1:8080/index.html

podman stop official-nginx
echo "jiji"

podman commit -a "chen" official-nginx do180/nginx:v1.0-SNAPSHOT

podman run -d --name official-nginx-dev -p 8080:80 do180/nginx:v1.0-SNAPSHOT

sleep 9

podman exec -it official-nginx-dev /bin/bash -c 'echo "DO180 Page" > /usr/share/nginx/html/index.html'

curl 127.0.0.1:8080/index.html

podman stop official-nginx-dev

podman commit -a "chen" official-nginx-dev do180/mynginx:v1.0

echo qiqi
podman rmi -f do180/nginx:v1.0-SNAPSHOT

podman run -d --name my-nginx -p 8280:80 do180/mynginx:v1.0

sleep 9

curl 127.0.0.1:8280/index.html
