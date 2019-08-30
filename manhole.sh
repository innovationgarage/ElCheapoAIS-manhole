#! /bin/bash

cd "$1"

notifier="/lib/elcheapoais/notifier"

source ./config

if ! [ -e ./manhole-ordering.txt ]; then
    cat > ./manhole-ordering.txt <<EOF
last_ordering="-1"
EOF
fi
source ./manhole-ordering.txt

curl --max-time 20 --fail -s -o ./manhole-script -D ./manhole-headers "${manholeurl}/${stationid}"
status="$?"
ordering="$(grep Ordering ./manhole-headers | sed -e "s+.*: *++g" | tr -d "\r")"

if [ "$status" == "0" ]; then
    echo "manhole=1" >> "$notifier"
else
    echo "manhole=0" >> "$notifier"
fi

if [ "$status" == "0" ] && ((ordering > last_ordering)); then
    echo "Workman is entering the manhole for the ${ordering}th time..."
    now="$(date -Iseconds)"
    chmod ugo+x ./manhole-script
    ./manhole-script > ./manhole-log.txt 2>&1
    if curl --max-time 20 --fail -s -X PUT --data-binary @./manhole-log.txt "${manholeurl}/${stationid}/${ordering}"; then
        cat > ./manhole-ordering.txt <<EOF
last_ordering="$ordering"
EOF
    else
        echo "Sending results failed. Script will run again..."
    fi
fi
