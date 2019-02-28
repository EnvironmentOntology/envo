#!/bin/sh
docker run -m 12g  -v $PWD/../../:/work -w /work/src/envo --rm -ti obolibrary/odkfull  "$@"
