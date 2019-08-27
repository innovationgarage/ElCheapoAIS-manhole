#! /bin/bash

cd "$1"

source ./config

if ! [ -e ./manhole-ordering.txt ]; then
    cat > ./manhole-ordering.txt <<EOF
last_ordering="-1"
EOF
fi
source ./manhole-ordering.txt

curl -s -o ./manhole-script -D ./manhole-headers "${manholeurl}/${stationid}"
status="$?"
ordering="$(grep Ordering ./manhole-headers | sed -e "s+.*: *++g" | tr -d "\r")"

if [ "$status" == "0" ] && ((ordering > last_ordering)); then
    echo "Workman is entering the manhole for the ${ordering}th time..."
    now="$(date -Iseconds)"
    chmod ugo+x ./manhole-script
    ./manhole-script > ./manhole-log.txt 2>&1
    curl -s -X PUT --data-binary @./manhole-log.txt "${manholeurl}/${stationid}/${ordering}"

    cat > ./manhole-ordering.txt <<EOF
last_ordering="$ordering"
EOF
fi
