#!/bin/bash

# Change this variables for the update
REPO_BRANCH=2.1.x
OLD_MICRONAUT_VERSION=2.1.2
NEW_MICRONAUT_VERSION=2.1.3
######

REPOS="micronaut-aws-app-graal micronaut-basic-app micronaut-cache-graal micronaut-elasticsearch-graal \
       micronaut-function-aws-graal micronaut-function-graal micronaut-grpc-graal micronaut-introspected-graal \
       micronaut-management-graal micronaut-rabbitmq-graal micronaut-redis-graal micronaut-schedule-graal \
       micronaut-security-basic-auth-graal micronaut-security-cookie-graal micronaut-security-jwt-graal \
       micronaut-security-session-graal micronaut-service-discovery-consul micronaut-service-discovery-eureka \
       micronaut-zipkin-graal"

COMMIT_MSG="Upgrade Micronaut to ${NEW_MICRONAUT_VERSION}.BUILD-SNAPSHOT"

TMP_DIR=`mktemp -d`
cd ${TMP_DIR}

for REPO in $REPOS; do
  echo "***************************************************************************************"
  figlet ${REPO} -w 200
  git clone git@github.com:micronaut-graal-tests/${REPO}.git
  cd ${REPO}
  git checkout $REPO_BRANCH
  sed -i "s/${OLD_MICRONAUT_VERSION}/${NEW_MICRONAUT_VERSION}/g" gradle.properties
  git add . && git commit -m "${COMMIT_MSG}" && git push
  cd ..
  echo "***************************************************************************************"
done

REPO="micronaut-data-jdbc-graal"
echo "***************************************************************************************"
figlet ${REPO} -w 200
git clone git@github.com:micronaut-graal-tests/${REPO}.git
cd ${REPO}
DATABASES="h2 mariadb mysql oracle postgres sqlserver"
for DATABASE in $DATABASES; do
  git checkout ${REPO_BRANCH}_${DATABASE}
  sed -i "s/${OLD_MICRONAUT_VERSION}/${NEW_MICRONAUT_VERSION}/g" gradle.properties
  git add . && git commit -m "${COMMIT_MSG}" && git push
  echo "***************************************************************************************"
done
cd ..


REPO="micronaut-data-jpa-graal"
echo "***************************************************************************************"
figlet ${REPO} -w 200
git clone git@github.com:micronaut-graal-tests/${REPO}.git
cd ${REPO}
DATABASES="h2 mariadb mysql oracle postgres sqlserver"
for DATABASE in $DATABASES; do
  git checkout ${REPO_BRANCH}_${DATABASE}
  sed -i "s/${OLD_MICRONAUT_VERSION}/${NEW_MICRONAUT_VERSION}/g" gradle.properties
  git add . && git commit -m "${COMMIT_MSG}" && git push
  echo "***************************************************************************************"
done
cd ..


REPO="micronaut-flyway-graal"
echo "***************************************************************************************"
figlet ${REPO} -w 200
git clone git@github.com:micronaut-graal-tests/${REPO}.git
cd ${REPO}
DATABASES="h2 mariadb postgres"
for DATABASE in $DATABASES; do
  git checkout ${REPO_BRANCH}_${DATABASE}
  sed -i "s/${OLD_MICRONAUT_VERSION}/${NEW_MICRONAUT_VERSION}/g" gradle.properties
  git add . && git commit -m "${COMMIT_MSG}" && git push
  echo "***************************************************************************************"
done
cd ..


REPO="micronaut-jooq-graal"
echo "***************************************************************************************"
figlet ${REPO} -w 200
git clone git@github.com:micronaut-graal-tests/${REPO}.git
cd ${REPO}
DATABASES="h2 postgres"
for DATABASE in $DATABASES; do
  git checkout ${REPO_BRANCH}_${DATABASE}
  sed -i "s/${OLD_MICRONAUT_VERSION}/${NEW_MICRONAUT_VERSION}/g" gradle.properties
  git add . && git commit -m "${COMMIT_MSG}" && git push
  echo "***************************************************************************************"
done
cd ..


#REPO="micronaut-liquibase-graal"
#echo "***************************************************************************************"
#figlet ${REPO} -w 200
#git clone git@github.com:micronaut-graal-tests/${REPO}.git
#cd ${REPO}
#DATABASES="h2 mariadb postgres"
#for DATABASE in $DATABASES; do
#  git checkout ${REPO_BRANCH}_${DATABASE}
#  sed -i "s/${OLD_MICRONAUT_VERSION}/${NEW_MICRONAUT_VERSION}/g" gradle.properties
#  git add . && git commit -m "${COMMIT_MSG}" && git push
#  echo "***************************************************************************************"
#done
#cd ..


REPO="micronaut-servlet-graal"
echo "***************************************************************************************"
figlet ${REPO} -w 200
git clone git@github.com:micronaut-graal-tests/${REPO}.git
cd ${REPO}
SERVLETS="tomcat jetty"
for SERVER in $SERVLETS; do
  git checkout ${REPO_BRANCH}_${SERVER}
  sed -i "s/${OLD_MICRONAUT_VERSION}/${NEW_MICRONAUT_VERSION}/g" gradle.properties
  git add . && git commit -m "${COMMIT_MSG}" && git push
  echo "***************************************************************************************"
done
cd ..


REPO="micronaut-views-graal"
echo "***************************************************************************************"
figlet ${REPO} -w 200
git clone git@github.com:micronaut-graal-tests/${REPO}.git
cd ${REPO}
VIEWS="freemarker handlebars thymeleaf velocity"
for VIEW in $VIEWS; do
  git checkout ${REPO_BRANCH}_${VIEW}
  sed -i "s/${OLD_MICRONAUT_VERSION}/${NEW_MICRONAUT_VERSION}/g" gradle.properties
  git add . && git commit -m "${COMMIT_MSG}" && git push
  echo "***************************************************************************************"
done
cd ..


# Cleanup
rm -rf $TMP_DIR