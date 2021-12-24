FROM ubuntu
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install ssh wget npm apache2 php php-curl  mysql-server php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring  php-xml php-pear php-bcmath screen  -y
RUN  npm install -g wstunnel
RUN mkdir /run/sshd 
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod proxy_wstunnel
RUN a2enmod  rewrite
RUN wget https://github.com/netcyabc/cyserver/blob/f702250c443aa043af2e4dc77d529919c7710fac/web-default.conf
RUN rm /etc/apache2/sites-available/000-default.conf
RUN mv web-default.conf /etc/apache2/sites-available/000-default.conf
RUN echo 'Deploy Success!' >/var/www/html/index.html
RUN echo 'wstunnel -s 0.0.0.0:8989 & ' >>/startup.sh
RUN echo 'service mysql restart' >>/startup.sh
RUN echo 'service apache2 restart' >>/startup.sh
RUN echo '/usr/sbin/sshd -D' >>/startup.sh
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 
RUN echo root:netcyroot|chpasswd
RUN chmod 755 /startup.sh
EXPOSE 80
CMD  /startup.sh
