## Check-in the latest version of WordPress into a git repository
```
curl https://wordpress.org/latest.tar.gz | sudo tar zx -C .
mv wordpress/* ./
rmdir wordpress
```

## Add support to dockerise the wordpress and run /serve it with Apache and PHP
```
curl -LO https://github.com/docker-library/wordpress/raw/master/latest/php7.4/apache/Dockerfile
curl -LO  https://raw.githubusercontent.com/docker-library/wordpress/master/latest/php7.4/apache/docker-entrypoint.sh
curl -LO https://raw.githubusercontent.com/docker-library/wordpress/master/latest/php7.4/apache/wp-config-docker.php
```
[edit Dockerfile](Dockerfile#L118) to copy local files instead of downloading tar from wordpress.org

[edit Dockerfile](Dockerfile#L168) to ensure docker-entrypoint.sh has execution permissions
```
docker build -t akuma5157/ctwp .
docker run --rm -it --name ctwp -p 8080:80 akuma5157/ctwp:latest
```