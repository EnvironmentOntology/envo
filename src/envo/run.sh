#!/bin/sh
docker run -m 14g -e ROBOT_JAVA_ARGS=-Xmx11G -v $PWD/../../:/work -w /work/src/envo --rm -ti obolibrary/odkfull  "$@"
