echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin
SOURCE_TAG=`git show-ref | grep ${GITHUB_SHA} | grep -E -o "refs/tags.{0,100}" | cut -c11-`
MASTER_HASH=`git rev-parse origin/master`
# REMOVE THIS LINE BEFORE MERGING
MASTER_HASH=${GITHUB_SHA}
if [ "x${SOURCE_TAG}"  == "x" ] ; then
    if [ "x${MASTER_HASH}"  == "x${GITHUB_SHA}" ] ; then
        docker tag ${DOCKER_IMG} ${DOCKER_IMG}:latest || exit 1 ;
        docker push ${DOCKER_IMG}:latest || exit 1 ;
    else
        echo "Not on master or a tag, so not pushing the docker image."
    fi
else
    docker tag ${DOCKER_IMG} ${DOCKER_IMG}:${SOURCE_TAG} || exit 1 ;
    docker push ${DOCKER_IMG}:${SOURCE_TAG} || exit 1 ;
fi ;
