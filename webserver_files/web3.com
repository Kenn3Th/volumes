server {
        listen 80;
        root /var/www/html;
        index index.php index.html index.htm;
        server_name web3.com;

        location / {
            try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        }
}
