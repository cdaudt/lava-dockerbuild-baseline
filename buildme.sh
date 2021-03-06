TAGNAME="lava/baseline"
ATTEMPT=0
NOCACHE=${1:-true}
COPYTO=${2:-}
VER=${3:-"latest"}
ADMINUSER=lava-admin
PASSWORD=`cat /home/${ADMINUSER}/.pushpw`
LOGS=$(mktemp /tmp/buildme.XXXXXX)


function dockerpush()
{
  docker login -u ${ADMINUSER} -p ${PASSWORD} ${COPYTO}
  docker push $1
  docker logout ${COPYTO}
}

echo "NOCACHE:${NOCACHE} COPYTO:${COPYTO} VER=${VER}"
docker build \
  --label "build.source=`git log --oneline -1`" \
  --label "build.status=`git status --short`" \
  --no-cache=${NOCACHE} \
  -t ${TAGNAME}:${VER} \
  . \
  >  ${LOGS} 2>&1
if [ $? -ne 0 ]
then
  cat ${LOGS}
  exit 1
fi
set -e
cat ${LOGS}
HASH=`grep "Successfully built " ${LOGS}|awk '{print $3}'`
echo "IMAGE_BUILD:TAGNAME=${TAGNAME}:HASH=${HASH}"

if [ "${COPYTO}A" != "A" ]
then
  docker tag ${TAGNAME}:${VER} ${COPYTO}/${TAGNAME}:${VER}
  dockerpush ${COPYTO}/${TAGNAME}:${VER}
fi
