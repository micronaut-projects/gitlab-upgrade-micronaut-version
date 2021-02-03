#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Need to provide repository branch, old version and new version:"
    echo " $ `basename $0` <repo-branch> <old-version> <new-version>"
    echo " $ `basename $0` 2.3.x 1.3.2 1.3.3"
    echo ""
    echo "That would upgrade the branch '2.1.x' in all test applications from Micronaut Gradle plugin 1.3.2 to 1.3.3"
    exit 1
fi

REPO_BRANCH=$1
OLD_GRADLE_PLUGIN_VERSION=$2
NEW_GRADLE_PLUGIN_VERSION=$3

COMMIT_MSG="Upgrade Micronaut Gradle plugin to ${NEW_GRADLE_PLUGIN_VERSION}"

upgradeSingleBranchRepo() {
  echo "***************************************************************************************"
  REPOS=$1

  for REPO in $REPOS; do
    figlet ${REPO} -w 200
    git clone git@github.com:micronaut-graal-tests/${REPO}.git
    cd ${REPO}
    git checkout $REPO_BRANCH
    sed -i "s/id(\"io.micronaut.application\") version \"${OLD_GRADLE_PLUGIN_VERSION}\"/id(\"io.micronaut.application\") version \"${NEW_GRADLE_PLUGIN_VERSION}\"/g" build.gradle
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
    sed -i "s/id(\"io.micronaut.application\") version \"${OLD_GRADLE_PLUGIN_VERSION}\"/id(\"io.micronaut.application\") version \"${NEW_GRADLE_PLUGIN_VERSION}\"/g" build.gradle
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
       micronaut-function-aws-graal micronaut-grpc-graal micronaut-introspected-graal \
       micronaut-management-graal micronaut-rabbitmq-graal micronaut-redis-graal micronaut-schedule-graal \
       micronaut-security-basic-auth-graal micronaut-security-cookie-graal micronaut-security-jwt-graal \
       micronaut-security-session-graal micronaut-service-discovery-consul micronaut-service-discovery-eureka \
       micronaut-zipkin-graal"
upgradeMultipleBranchesRepo "micronaut-data-jdbc-graal" "h2 mariadb mysql oracle postgres sqlserver"
upgradeMultipleBranchesRepo "micronaut-data-jpa-graal" "h2 mariadb mysql oracle postgres sqlserver"
upgradeMultipleBranchesRepo "micronaut-flyway-graal" "h2 mariadb postgres"
upgradeMultipleBranchesRepo "micronaut-jooq-graal" "h2 postgres"
upgradeMultipleBranchesRepo "micronaut-liquibase-graal" "h2 mariadb postgres"
upgradeMultipleBranchesRepo "micronaut-mqtt-graal" "v3 v5"
upgradeMultipleBranchesRepo "micronaut-servlet-graal" "tomcat jetty"
upgradeMultipleBranchesRepo "micronaut-views-graal" "freemarker handlebars pebble thymeleaf velocity"

# Cleanup
rm -rf $TMP_DIR
