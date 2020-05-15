#Change this IP's to the IP range your network has
web1_ip="172.17.0.2"
web2_ip="172.17.0.3"
web3_ip="172.17.0.4"
lb_ip="172.17.0.5"
db1_ip="172.17.0.6"
db2_ip="172.17.0.7"
db3_ip="172.17.0.8"
maxscale_ip="172.17.0.9"
#Password section
MYSQL_ROOT_PASSWORD="maxscalepass" \
MYSQL_USER="maxscaleuser" \
MYSQL_PASSWORD="sure caught drop" \

export web1_ip
export web2_ip
export web3_ip
export lb_ip
export db1_ip
export db2_ip
export db3_ip
export maxscale_ip
export MYSQL_ROOT_PASSWORD
export MYSQL_USER
export MYSQL_PASSWORD
