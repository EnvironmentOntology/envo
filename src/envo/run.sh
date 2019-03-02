#!/bin/sh
docker run -m 8g -e ROBOT_JAVA_ARGS=-Xmx7G -v $PWD/../../:/work -w /work/src/envo --rm -ti obolibrary/odkfull  "$@"
