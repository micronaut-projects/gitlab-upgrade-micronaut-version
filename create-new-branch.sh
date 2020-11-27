#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Need to provide the branch to branch off and the new branch:"
    echo " $ `basename $0` <from-branch> <new-branch>"
    echo " $ `basename $0` 2.2.x 2.3.x"
    echo ""
    echo "That would upgrade create a new branch 2.3.x based on 2.2.x branch"
    exit 1
fi

BRANCH_FROM=$1
NEW_BRANCH=$2

createNewBranchSingleBranchRepo() {
  echo "***************************************************************************************"
  REPOS=$1

  for REPO in $REPOS; do
    figlet ${REPO} -w 200
    git clone git@github.com:micronaut-graal-tests/${REPO}.git
    cd ${REPO}
    git checkout -b ${NEW_BRANCH} origin/${BRANCH_FROM}
    git push -u origin ${NEW_BRANCH}
    echo "***************************************************************************************"
    cd ..
  done
}

createNewBranchMultipleBranchesRepo() {
  echo "***************************************************************************************"
  REPO=$1
  BRANCHES=$2

  figlet ${REPO} -w 200
  git clone git@github.com:micronaut-graal-tests/${REPO}.git
  cd ${REPO}
  for BRANCH in $BRANCHES; do
    git checkout -b ${NEW_BRANCH}_${BRANCH} origin/${BRANCH_FROM}_${BRANCH}
    git push -u origin ${NEW_BRANCH}_${BRANCH}
    echo "***************************************************************************************"
  done
  cd ..
}


#################
### MAIN
#################
TMP_DIR=`mktemp -d`
cd ${TMP_DIR}

createNewBranchSingleBranchRepo "micronaut-aws-app-graal micronaut-basic-app micronaut-cache-graal micronaut-elasticsearch-graal \
       micronaut-function-aws-graal micronaut-function-graal micronaut-grpc-graal micronaut-introspected-graal \
       micronaut-management-graal micronaut-rabbitmq-graal micronaut-redis-graal micronaut-schedule-graal \
       micronaut-security-basic-auth-graal micronaut-security-cookie-graal micronaut-security-jwt-graal \
       micronaut-security-session-graal micronaut-service-discovery-consul micronaut-service-discovery-eureka \
       micronaut-zipkin-graal"
createNewBranchMultipleBranchesRepo "micronaut-data-jdbc-graal" "h2 mariadb mysql oracle postgres sqlserver"
createNewBranchMultipleBranchesRepo "micronaut-data-jpa-graal" "h2 mariadb mysql oracle postgres sqlserver"
createNewBranchMultipleBranchesRepo "micronaut-flyway-graal" "h2 mariadb postgres"
createNewBranchMultipleBranchesRepo "micronaut-jooq-graal" "h2 postgres"
createNewBranchMultipleBranchesRepo "micronaut-liquibase-graal" "h2 mariadb postgres"
createNewBranchMultipleBranchesRepo "micronaut-mqtt-graal" "v3 v5"
createNewBranchMultipleBranchesRepo "micronaut-servlet-graal" "tomcat jetty"
createNewBranchMultipleBranchesRepo "micronaut-views-graal" "freemarker handlebars pebble thymeleaf velocity"

# Cleanup
rm -rf $TMP_DIR
