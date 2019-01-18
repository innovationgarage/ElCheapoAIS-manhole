#! /bin/bash

source ./config

if ! [ -e ./manhole-ordering.txt ]; then
    cat > ./manhole-ordering.txt <<EOF
last_ordering="-1"
EOF
fi
source ./manhole-ordering.txt

wget --quiet --server-response -O ./manhole-script "${manholeurl}/${stationid}" > ./manhole-headers.txt 2>&1
status="$?"
ordering="$(grep Ordering ./manhole-headers.txt | sed -e "s+.*: *++g")"


if [ "$status" == "0" ] && ((ordering > last_ordering)); then
    echo "Workman is entering the manhole for the ${ordering}th time..."
    now="$(date --iso-8601=seconds)"
    chmod ugo+x ./manhole-script
    ./manhole-script > ./manhole-log.txt 2>&1
    wget --quiet -O - --method=PUT --body-file=./manhole-log.txt "${manholeurl}/${stationid}/${ordering}"

    cat > ./manhole-ordering.txt <<EOF
last_ordering="$ordering"
EOF
fi
