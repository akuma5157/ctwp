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
1. get sample yaml from https://docs.github.com/en/actions/publishing-packages/publishing-docker-images#publishing-images-to-github-packages and write to [workflow file](.github/workflows/docker-fargate.yml)   
2. [update conditional](.github/workflows/docker-fargate.yml#L4) to enable builds on each push to any branch  


## Setup a pipeline to deploy the freshly build container to Fargate
1. get sample docker-compose.yml from https://docs.docker.com/samples/wordpress
2. update container image name, port, DB creds and volume mounts in docker-compose.yml
3. test compose file with:
```
docker-compose up
# check app on browser
docker-compose down
```

4. install compose-cli. run:
```
curl -L https://raw.githubusercontent.com/docker/compose-cli/main/scripts/install/install_linux.sh | sh
```
5. reload shell session  
```
exec bash
```
6. ensure aws configuration profile is present
7. set up ecs context and create stack with:
```
docker context create ecs myecscontext --profile default

docker context use myecscontext ecs

docker compose up
```
8. add [script](scripts/compose.sh) and [job](.github/workflows/docker-fargate.yml#L52) for deployment

## Provision all the AWS resources you used via CloudFormation or Terraform or any other infrastructure as code framework
1. ensure compose stack is up on ecs
``` 
docker compose up
```
2. convert compose stack to [cloudformation template](cloudformation.yml)
```
docker compose convert > cloudformation.yml
```

## Instances of wordpress should horizontally scale to handle an increase in traffic
1. add [autoscaling properties](docker-compose.yml#L29) to wordpress service in docker-compose.yml


## Use IAM best practices to ensure better security
1. Create a policy as recommended at [Docker ECS Integration Prerequisites](https://docs.docker.com/cloud/ecs-integration/#run-an-application-on-ecs), [see example](iam-policy.json).
2. Create a group for all principals that will be handling this set of resources. e.g. your local cli, github-actions etc.
3. Create separate users for all principals and add them to your group.
4. Disable access keys when not being actively used.
## Tear down
run in any shell with proper aws profile and binaries:
```
docker compose down
```