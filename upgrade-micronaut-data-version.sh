#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Need to provide repository branch, old version and new version:"
    echo " $ `basename $0` <repo-branch> <old-version> <new-version>"
    echo " $ `basename $0` 2.1.x 2.1.1 2.1.2"
    echo ""
    echo "That would upgrade the branch '2.1.x' in all test applications from Micronaut Data 2.1.1.BUILD-SNAPSHOT to 2.1.2.BUILD-SNAPSHOT"
    exit 1
fi

REPO_BRANCH=$1
OLD_MICRONAUT_DATA_VERSION=$2
NEW_MICRONAUT_DATA_VERSION=$3

COMMIT_MSG="Upgrade Micronaut Data to ${NEW_MICRONAUT_DATA_VERSION}.BUILD-SNAPSHOT"

upgradeMultipleBranchesRepo() {
  echo "***************************************************************************************"
  REPO=$1
  BRANCHES=$2

  figlet ${REPO} -w 200
  git clone git@github.com:micronaut-graal-tests/${REPO}.git
  cd ${REPO}
  for BRANCH in $BRANCHES; do
    git checkout ${REPO_BRANCH}_${BRANCH}
    sed -i "s/${OLD_MICRONAUT_DATA_VERSION}/${NEW_MICRONAUT_DATA_VERSION}/g" gradle.properties
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

upgradeMultipleBranchesRepo "micronaut-data-jdbc-graal" "h2 mariadb mysql oracle postgres sqlserver"
upgradeMultipleBranchesRepo "micronaut-data-jpa-graal" "h2 mariadb mysql oracle postgres sqlserver"
upgradeMultipleBranchesRepo "micronaut-flyway-graal" "h2 mariadb postgres"
upgradeMultipleBranchesRepo "micronaut-liquibase-graal" "h2 mariadb postgres"

# Cleanup
rm -rf $TMP_DIR
