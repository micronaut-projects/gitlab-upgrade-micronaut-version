#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Need to provide repository branch, old version and new version:"
    echo " $ `basename $0` <repo-branch> <old-version> <new-version>"
    echo " $ `basename $0` 3.0.x 6.1.0 7.0.0"
    echo ""
    echo "That would upgrade the branch '3.0.x' in all test applications from Shadow 6.1.0 to 7.0.0"
    exit 1
fi

REPO_BRANCH=$1
OLD_SHADOW_PLUGIN_VERSION=$2
NEW_SHADOW_PLUGIN_VERSION=$3

COMMIT_MSG="Upgrade Shadow plugin to ${NEW_SHADOW_PLUGIN_VERSION}"

upgradeSingleBranchRepo() {
  echo "***************************************************************************************"
  REPOS=$1

  for REPO in $REPOS; do
    figlet ${REPO} -w 200
    git clone git@github.com:micronaut-graal-tests/${REPO}.git
    cd ${REPO}
    git checkout $REPO_BRANCH
    sed -i '' "s/id(\"com.github.johnrengelman.shadow\") version \"${OLD_SHADOW_PLUGIN_VERSION}\"/id(\"com.github.johnrengelman.shadow\") version \"${NEW_SHADOW_PLUGIN_VERSION}\"/g" build.gradle
    git add . && git commit -m "${COMMIT_MSG}" && git push
    echo "***************************************************************************************"
    cd ..
  done
}

upgradeSingleBranchKotlinRepo() {
  echo "***************************************************************************************"
  REPOS=$1

  for REPO in $REPOS; do
    figlet ${REPO} -w 200
    git clone git@github.com:micronaut-graal-tests/${REPO}.git
    cd ${REPO}
    git checkout $REPO_BRANCH
    sed -i '' "s/id(\"com.github.johnrengelman.shadow\") version \"${OLD_SHADOW_PLUGIN_VERSION}\"/id(\"com.github.johnrengelman.shadow\") version \"${NEW_SHADOW_PLUGIN_VERSION}\"/g" build.gradle.kts
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
    sed -i '' "s/id(\"com.github.johnrengelman.shadow\") version \"${OLD_SHADOW_PLUGIN_VERSION}\"/id(\"com.github.johnrengelman.shadow\") version \"${NEW_SHADOW_PLUGIN_VERSION}\"/g" build.gradle
    git add . && git commit -m "${COMMIT_MSG}" && git push
    echo "***************************************************************************************"
  done
  cd ..
}

upgradeMultipleProjectRepo() {
  echo "***************************************************************************************"
  REPO=$1
  MODULES=$2

  figlet ${REPO} -w 200
  git clone git@github.com:micronaut-graal-tests/${REPO}.git
  cd ${REPO}
  git checkout ${REPO_BRANCH}
  for MODULE in ${MODULES}; do
    cd ${MODULE}
    sed -i '' "s/id(\"com.github.johnrengelman.shadow\") version \"${OLD_SHADOW_PLUGIN_VERSION}\"/id(\"com.github.johnrengelman.shadow\") version \"${NEW_SHADOW_PLUGIN_VERSION}\"/g" build.gradle
    cd ..
    echo "***************************************************************************************"
  done
  git add . && git commit -m "${COMMIT_MSG}" && git push
  cd ..
}


#################
### MAIN
#################
TMP_DIR=`mktemp -d`
cd ${TMP_DIR}

upgradeSingleBranchRepo "micronaut-aws-app-graal \
      micronaut-basic-app \
      micronaut-cache-graal \
      micronaut-cassandra-graal \
      micronaut-elasticsearch-graal \
      micronaut-email \
      micronaut-function-aws-graal \
      micronaut-graphql-graal \
      micronaut-grpc-graal \
      micronaut-introspected-graal \
      micronaut-kafka-graal \
      micronaut-maven-graal \
      micronaut-management-graal \
      micronaut-rabbitmq-graal \
      micronaut-redis-graal \
      micronaut-schedule-graal \
      micronaut-security-basic-auth-graal \
      micronaut-security-cookie-graal \
      micronaut-security-jwt-graal \
      micronaut-security-session-graal \
      micronaut-security-ldap-graal \
      micronaut-service-discovery-consul \
      micronaut-service-discovery-eureka \
      micronaut-zipkin-graal"
upgradeMultipleBranchesRepo "micronaut-data-jdbc-graal" "h2 mariadb mysql oracle postgres sqlserver"
upgradeMultipleBranchesRepo "micronaut-data-jpa-graal" "h2 mariadb mysql oracle postgres sqlserver"
upgradeMultipleBranchesRepo "micronaut-flyway-graal" "h2 mariadb postgres"
upgradeMultipleBranchesRepo "micronaut-jooq-graal" "h2 postgres"
upgradeMultipleBranchesRepo "micronaut-liquibase-graal" "h2 mariadb postgres"
upgradeMultipleBranchesRepo "micronaut-mqtt-graal" "v3 v5"
upgradeMultipleBranchesRepo "micronaut-servlet-graal" "tomcat jetty"
upgradeMultipleBranchesRepo "micronaut-views-graal" "freemarker handlebars pebble thymeleaf velocity"
upgradeMultipleBranchesRepo "micronaut-aws-sdk2-graal" "s3 paramstore"
upgradeMultipleProjectRepo "micronaut-grpc-graal" "client server"
upgradeMultipleProjectRepo "micronaut-introspected-graal" "app"
upgradeSingleBranchKotlinRepo "micronaut-kotlin-graal"

# Cleanup
rm -rf $TMP_DIR
