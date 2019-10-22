#! /bin/bash

cd "$1"

SCRIPTDIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
echo "SCRIPTDIR=$SCRIPTDIR"

notifier="/lib/elcheapoais/notifier"

manholeurl="$(${SCRIPTDIR}/elcheapoais-manhole-dbus config "/no/innovationgarage/elcheapoais/install" "no.innovationgarage.elcheapoais.manhole" "url")"
stationid="$(SCRIPTDIR}/elcheapoais-manhole-dbus config "/no/innovationgarage/elcheapoais/receiver" "no.innovationgarage.elcheapoais.receiver" "station_id")"

if ! [ -e ./manhole-ordering.txt ]; then
    cat > ./manhole-ordering.txt <<EOF
last_ordering="-1"
EOF
fi
source ./manhole-ordering.txt

echo "Connecting to ${manholeurl}/${stationid}..." >&2
curl --max-time 20 --fail -s -o ./manhole-script -D ./manhole-headers "${manholeurl}/${stationid}"
status="$?"
ordering="$(grep Ordering ./manhole-headers | sed -e "s+.*: *++g" | tr -d "\r")"

echo "Connection status: $status, ordering: $ordering, last ordering: $last_ordering" >&2


${SCRIPTDIR}/elcheapoais-manhole-dbus status "$([ "$status" == "0" ] && echo "true" || echo "false")" "$status"

if [ "$status" == "0" ] && ((ordering > last_ordering)); then
    echo "Workman is entering the manhole for the ${ordering}th time..." >&2
    now="$(date -Iseconds)"
    chmod ugo+x ./manhole-script
    ./manhole-script > ./manhole-log.txt 2>&1
    if curl --max-time 20 --fail -s -X PUT --data-binary @./manhole-log.txt "${manholeurl}/${stationid}/${ordering}"; then
        cat > ./manhole-ordering.txt <<EOF
last_ordering="$ordering"
EOF
    else
        echo "Sending results failed. Script will run again..." >&2
    fi
fi
