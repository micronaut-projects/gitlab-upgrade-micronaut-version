#!/bin/bash

# Change this variables for the update
######
REPO_BRANCH=2.1.x
OLD_MICRONAUT_VERSION=2.1.2
NEW_MICRONAUT_VERSION=2.1.3
######

COMMIT_MSG="Upgrade Micronaut to ${NEW_MICRONAUT_VERSION}.BUILD-SNAPSHOT"

upgradeSingleBranchRepo() {
  echo "***************************************************************************************"
  REPOS=$1

  for REPO in $REPOS; do
    figlet ${REPO} -w 200
    git clone git@github.com:micronaut-graal-tests/${REPO}.git
    cd ${REPO}
    git checkout $REPO_BRANCH
    sed -i "s/${OLD_MICRONAUT_VERSION}/${NEW_MICRONAUT_VERSION}/g" gradle.properties
    git add . && git commit -m "${COMMIT_MSG}" && git push
    echo "***************************************************************************************"
    cd ..
  done
}

upgradeMultipleBranchesRepo() {
  echo "***************************************************************************************"
  REPO=$1
  BRANCHES=$2

  figlet ${REPO} -w 200
  git clone git@github.com:micronaut-graal-tests/${REPO}.git
  cd ${REPO}
  for BRANCH in $BRANCHES; do
    git checkout ${REPO_BRANCH}_${BRANCH}
    sed -i "s/${OLD_MICRONAUT_VERSION}/${NEW_MICRONAUT_VERSION}/g" gradle.properties
    git add . && git commit -m "${COMMIT_MSG}" && git push
    echo "***************************************************************************************"
  done
  cd ..
}


#################
### MAIN
#################
TMP_DIR=`mktemp -d`
cd ${TMP_DIR}

upgradeSingleBranchRepo "micronaut-aws-app-graal micronaut-basic-app micronaut-cache-graal micronaut-elasticsearch-graal \
       micronaut-function-aws-graal micronaut-function-graal micronaut-grpc-graal micronaut-introspected-graal \
       micronaut-management-graal micronaut-rabbitmq-graal micronaut-redis-graal micronaut-schedule-graal \
       micronaut-security-basic-auth-graal micronaut-security-cookie-graal micronaut-security-jwt-graal \
       micronaut-security-session-graal micronaut-service-discovery-consul micronaut-service-discovery-eureka \
       micronaut-zipkin-graal"
upgradeMultipleBranchesRepo "micronaut-data-jdbc-graal" "h2 mariadb mysql oracle postgres sqlserver"
upgradeMultipleBranchesRepo "micronaut-data-jpa-graal" "h2 mariadb mysql oracle postgres sqlserver"
upgradeMultipleBranchesRepo "micronaut-flyway-graal" "h2 mariadb postgres"
upgradeMultipleBranchesRepo "micronaut-jooq-graal" "h2 postgres"
#upgradeMultipleBranchesRepo "micronaut-liquibase-graal" "h2 mariadb postgres"
upgradeMultipleBranchesRepo "micronaut-servlet-graal" "tomcat jetty"
upgradeMultipleBranchesRepo "micronaut-views-graal" "freemarker handlebars thymeleaf velocity"

# Cleanup
rm -rf $TMP_DIR
