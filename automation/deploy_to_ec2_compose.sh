#!/bin/bash
# get variables form gitlab-ci or locals
source ./automation/read_config.sh
source ./automation/docker_getenv.sh

echo "============================="
echo "Patching docker-compose.yml"
echo "============================="

sed -i -- "s/REGISTRY/$REGISTRY/g" docker-compose.yml
sed -i -- "s/REPOSITORY/$REPOSITORY/g" docker-compose.yml
sed -i -- "s/NAME/$NAME/g" docker-compose.yml
sed -i -- "s/VERSION/$VERSION/g" docker-compose.yml

echo "============================="
echo "REVIEW docker-compose.yml"
echo "============================="

cat docker-compose.yml

echo "====================================="
echo "DEPLOY TO EC2 BRANCH: $BRANCH_NAME"
echo "====================================="

scp -o StrictHostKeyChecking=no docker-compose.yml ${EC2INSTANCE}:/home/ec2-user 
ssh ${EC2INSTANCE} docker-compose up -d

echo "====================================="
echo "REVIEW EC2 BRANCH: $BRANCH_NAME"
echo "====================================="

ssh ${EC2INSTANCE} docker images |grep $REGISTRY/$REPOSITORY
echo "====================================="
echo "====================================="
ssh ${EC2INSTANCE} docker ps |grep $REGISTRY/$REPOSITORY

echo "====================================="
echo "=============FINISH=================="
echo "====================================="


