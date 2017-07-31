FROM php:7.1-apache

RUN apt-get update -y && \
    apt-get install -y git-core && \
    rm -rf /var/lib/apt/lists/* && \
    sed -e '/<Directory \/var\/www\/>/,/<\/Directory>/ s/Indexes FollowSymLinks/Indexes FollowSymLinks Includes/' \
        -i /etc/apache2/apache2.conf && \
    sed -e 's/DirectoryIndex index.php index.html/DirectoryIndex index.php index.html index.shtml/' \
        -i /etc/apache2/conf-available/docker-php.conf && \
    ln -s ../mods-available/include.load /etc/apache2/mods-enabled/include.load && \
    ln -s ../mods-available/cgi.load /etc/apache2/mods-enabled/cgi.load

COPY image/script/init-website /usr/local/bin
COPY image/script/update-site.cgi /usr/lib/cgi-bin

RUN cd /var/www &&\
    rm -rf html && \
    git init && \
    git config --global user.email "www@stratospike.com" && \
    git config --global user.name "Web Server" && \
    git config core.sparseCheckout true && \
    echo "html/*" > .git/info/sparse-checkout && \
    git remote add -f origin https://github.com/Stratospike/website.git && \
    git checkout master && \
    chown -R www-data:www-data html .git

CMD ["init-website"]
