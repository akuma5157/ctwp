set -eux

# install compose cli
curl -L https://raw.githubusercontent.com/docker/compose-cli/main/scripts/install/install_linux.sh | sh

docker version

# setup ecs context
docker context create ecs myecscontext --from-env

docker context use myecscontext

# create stack
docker compose up
