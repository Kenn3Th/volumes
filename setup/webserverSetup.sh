printf "Starting setup for web-servers\n"

echo "Making web1"
sudo docker run -d \
--publish 8081:80 \
--name web1 \
-v ~/volumes/web1:/var/www/html \
-v ~/volumes/webserver_files/web1.com:/etc/nginx/sites-available/web1.com \
richarvey/nginx-php-fpm:latest

echo "Making web2"
sudo docker run -d \
--publish 8082:80 \
--name web2 \
-v ~/volumes/web2:/var/www/html \
-v ~/volumes/webserver_files/web2.com:/etc/nginx/sites-available/web2.com \
richarvey/nginx-php-fpm:latest

echo "Making web3"
sudo docker run -d \
--publish 8083:80 \
--name web3 \
-v ~/volumes/web3/html:/var/www/html \
-v ~/volumes/webserver_files/web3.com:/etc/nginx/sites-available/web3.com \
richarvey/nginx-php-fpm:latest

sleep 5

echo "Making lb"
sudo docker run -d \
--publish 80:80 \
--name lb \
-v ~/volumes/lb:/usr/local/etc \
haproxy:latest
