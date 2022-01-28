#!/bin/bash
apt update
apt install -y nginx
mkdir -p /var/www/html

systemctl start nginx
touch  /var/www/html/healthstatus

cat << EOF > /etc/nginx/conf.d/reverse.conf
server {
    listen       80;
    root          /var/www/;
    #server_name  ;

    location /healthstatus {
        access_log off;
        return 200;
    }

        
    location / {
        proxy_set_header             Host \$host;
        proxy_pass                   http://${alb}/; 
    }
}
EOF

sed -i -e "s/include \/etc\/nginx\/sites\-enabled\/\*;/#include \/etc\/nginx\/sites-enabled\/\*;/" /etc/nginx/nginx.conf

systemctl restart nginx
systemctl enable nginx