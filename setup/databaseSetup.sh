echo "MariaDB database setup with Galera Cluster and Maxscale!"

echo "Making db1"
docker run -d \
--name db1 \
--publish "3306" \
--publish "4444" \
--publish "4567" \
--publish "4568" \
--add-host dbgc1:172.17.0.6 \
--add-host dbgc2:172.17.0.7 \
--add-host dbgc3:172.17.0.8 \
--add-host maxscale:172.17.0.9 \
--env MYSQL_ROOT_PASSWORD="rootpass" \
--env MYSQL_USER="dats44" \
--env MYSQL_PASSWORD="sure caught drop" \
-v ~/volumes/db1/conf.d:/etc/mysql/mariadb.conf.d \
-v ~/volumes/db1/datadir:/var/lib/mysql \
mariadb/server:10.4

sleep 10

echo "Making db2"
docker run -d \
--name db2 \
--publish "3306" \
--publish "4444" \
--publish "4567" \
--publish "4568" \
--add-host dbgc1:172.17.0.6 \
--add-host dbgc2:172.17.0.7 \
--add-host dbgc3:172.17.0.8 \
--add-host maxscale:172.17.0.9 \
--env MYSQL_ROOT_PASSWORD="rootpass" \
--env MYSQL_USER="dats44" \
--env MYSQL_PASSWORD="sure caught drop" \
-v ~/volumes/db2/conf.d:/etc/mysql/mariadb.conf.d \
-v ~/volumes/db2/datadir:/var/lib/mysql \
mariadb/server:10.4

sleep 10

echo "Making db3"
docker run -d \
--name db3 \
--publish "3306" \
--publish "4444" \
--publish "4567" \
--publish "4568" \
--add-host dbgc1:172.17.0.6 \
--add-host dbgc2:172.17.0.7 \
--add-host dbgc3:172.17.0.8 \
--add-host maxscale:172.17.0.9 \
--env MYSQL_ROOT_PASSWORD="rootpass" \
--env MYSQL_USER="dats44" \
--env MYSQL_PASSWORD="sure caught drop" \
-v ~/volumes/db3/conf.d:/etc/mysql/mariadb.conf.d \
-v ~/volumes/db3/datadir:/var/lib/mysql \
mariadb/server:10.4

printf "\n"
echo "Inserting Safe to Bootstrap"

sleep 5

echo "safe_to_bootstrap: 1" >> ~/volumes/db1/datadir/grastate.dat
sleep 5

printf "\n"
echo "Restarting db's"
docker restart db1 db2 db3

sleep 5

printf "\n"
echo "Making dbproxy"
docker run -d \
--name dbproxy \
--publish "3306:3306" \
--add-host dbgc1:172.17.0.6 \
--add-host dbgc2:172.17.0.7 \
--add-host dbgc3:172.17.0.8 \
--add-host maxscale:172.17.0.9 \
--env MYSQL_ROOT_PASSWORD="maxscalepass" \
--env MYSQL_USER="maxscaleuser" \
--env MYSQL_PASSWORD="sure caught drop" \
-v ~/volumes/dbproxy/maxscale.cnf:/etc/maxscale.cnf \
mariadb/maxscale:latest

printf "\n"
echo "Going to sleep... zzzZZZzzz"
sleep 20
printf "\n"

echo "Hello!! Lets see if this works!"

printf "\n"
echo "Checking cluster size"
docker exec db1 bash -c 'mysql -uroot -e "show status like \"wsrep_cluster_size\""'
echo "It should be cluster size 3"

printf "\n"
echo "MySQL setup for db-servers"
sleep 2
docker exec db1 bash -c 'mysql -uroot -p --password=rootpass -e "create user \"dats44\"@\"%\" identified by \"sure caught drop\""'
sleep 2
docker exec db1 bash -c 'mysql -uroot -p --password=rootpass -e "grant select on mysql.user to \"dats44\"@\"%\""'
sleep 2

echo "MySQL setup for MaxscaleUser"
docker exec db1 bash -c 'mysql -uroot -p --password=rootpass -e "create user \"maxscaleuser\"@\"172.17.0.9\" identified by \"sure caught drop\""'
sleep 2
docker exec db1 bash -c 'mysql -uroot -p --password=rootpass -e "grant select on mysql.user to \"maxscaleuser\"@\"172.17.0.9\""'
sleep 2
docker exec db1 bash -c 'mysql -uroot -p --password=rootpass -e "grant select on mysql.db to \"maxscaleuser\"@\"172.17.0.9\""'
sleep 2
docker exec db1 bash -c 'mysql -uroot -p --password=rootpass -e "grant select on mysql.tables_priv to \"maxscaleuser\"@\"172.17.0.9\""'
sleep 2
docker exec db1 bash -c 'mysql -uroot -p --password=rootpass -e "grant show databases on *.* to \"maxscaleuser\"@\"172.17.0.9\""'

sleep 5
printf "\n"
echo "Restarting dbproxy"
docker restart dbproxy

sleep 5

printf "\n"
echo "Checking if servers are online"
docker exec dbproxy maxctrl list servers

printf "\n"
echo "copying studentinfo to db containers"
docker cp ~/volumes/webapp/database/studentinfo-db.sql db1:/studentinfo-db.sql
sleep 2
echo "Checking the databases"
docker exec db1 bash -c 'mysql -uroot -e "source studentinfo-db.sql"'
sleep 2
docker exec db1 bash -c 'mysql -uroot -e "show DATABASES"'
sleep 2
docker exec db1 bash -c 'mysql -uroot -e "grant select on studentinfo.* to \"dats44\"@\"%\""'
