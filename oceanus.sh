#!/bin/bash
set -ex

DIR=$(pwd)/data
mkdir -p $DIR

while getopts ":d:h" OPT; do
    case "$OPT" in
        d)
            if [ "$OPTARG"="." ]; then
                DIR=$(cd "$OPTARG" && pwd)
            elif [ "$OPTARG:0:3"="../" ]; then
                DIR=$(cd "$OPTARG" && pwd)/$OPTARG
            else
                DIR="$OPTARG"
            fi
            ;;
        h)
            echo "Usage: oceanus.sh [options]"
            echo "Options:"
            echo "  -d  directory for output ( default "\""./data"\"" )"
            exit 1
            ;;
    esac
done

echo "Building Oceanus Docker Image.Tag name is geolonia/oceanus."
docker build -t geolonia/oceanus .
cp ./shp2geojson.yaml $DIR
cp ./japan-bl/japan-bl.json $DIR
docker run -it --rm --name oceanus -v $DIR:/data geolonia/oceanus /app/ne2mbtiles
echo "docker run -it --rm --name oceanus -v ${DIR}:/data geolonia/oceanus /app/ne2mbtiles"
