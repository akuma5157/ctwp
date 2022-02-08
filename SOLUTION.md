## Check-in the latest version of WordPress into a git repository
1. run:
```
curl https://wordpress.org/latest.tar.gz | sudo tar zx -C .
mv wordpress/* ./
rmdir wordpress
```

## Add support to dockerise the wordpress and run /serve it with Apache and PHP
1. run: 
```
curl -LO https://github.com/docker-library/wordpress/raw/master/latest/php7.4/apache/Dockerfile
curl -LO  https://raw.githubusercontent.com/docker-library/wordpress/master/latest/php7.4/apache/docker-entrypoint.sh
curl -LO https://raw.githubusercontent.com/docker-library/wordpress/master/latest/php7.4/apache/wp-config-docker.php
```
2. [edit Dockerfile](Dockerfile#L118) to copy local files instead of downloading tar from wordpress.org

3. [edit Dockerfile](Dockerfile#L168) to ensure docker-entrypoint.sh has execution permissions
```
docker build -t akuma5157/ctwp .
docker run --rm -it --name ctwp -p 8080:80 akuma5157/ctwp:latest
```

## Setup a pipeline to build the container when changes are pushed to the repository
1. get sample yaml from https://docs.github.com/en/actions/publishing-packages/publishing-docker-images#publishing-images-to-github-packages and write to [workflow file](.github/workflows/docker-image.yml)   
2. [update conditional](.github/workflows/docker-image.yml#L4) to enable builds on each push to any branch  