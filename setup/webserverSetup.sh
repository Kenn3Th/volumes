source ./parameter.sh

printf "Starting setup for web-servers\n"

echo "Making web1"
docker run -d \
--publish 8081:80 \
--name web1 \
-v ~/volumes/web1:/var/www/html \
-v ~/volumes/webserver_files/web1.com:/etc/nginx/sites-available/web1.com \
richarvey/nginx-php-fpm:latest

echo "Making web2"
docker run -d \
--publish 8082:80 \
--name web2 \
-v ~/volumes/web2:/var/www/html \
-v ~/volumes/webserver_files/web2.com:/etc/nginx/sites-available/web2.com \
richarvey/nginx-php-fpm:latest

echo "Making web3"
docker run -d \
--publish 8083:80 \
--name web3 \
-v ~/volumes/web3/html:/var/www/html \
-v ~/volumes/webserver_files/web3.com:/etc/nginx/sites-available/web3.com \
richarvey/nginx-php-fpm:latest

sleep 5

echo "Making lb"
docker run -d \
--publish 80:80 \
--name lb \
--add-host lb:$lb_ip \
--add-host web1:$web1_ip \
--add-host web2:$web2_ip \
--add-host web3:172.17.0.4 \
-v ~/volumes/lb:/usr/local/etc \
haproxy:latest
