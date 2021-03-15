#!/bin/sh

LOCAL="$1"
REMOTE="$2"

# Sanitize LOCAL path
if [[ ! "$LOCAL" =~ ^/ ]]; then
	LOCAL=$(echo "$LOCAL" | sed -e 's/^\.\///')
	LOCAL="$PWD/$LOCAL"
fi

# Sanitize REMOTE path
if [[ ! "$REMOTE" =~ ^/ ]]; then
	REMOTE=$(echo "$REMOTE" | sed -e 's/^\.\///')
	REMOTE="$PWD/$REMOTE"
fi

MERGING="$4"
BACKUP="/tmp/$(date +"%Y%d%m%H%M%S")"

CMD=$(which codium)

if [ ! $CMD ] >/dev/null; then
	if [ -e '/usr/local/bin/codium' ]; then
		CMD='/usr/local/bin/codium'
	fi
fi

if [ ! -x "$CMD" ]; then
	echo "Visual Studio Code command line tool 'codium' could not be found. Please make sure it has been installed in /usr/local/bin/." >&2
	exit 128
fi

if [ -n "$MERGING" ]; then
	MERGE="$4"

	# Sanitize MERGE path
	if [[ ! "$MERGE" =~ ^/ ]]; then
		MERGE=$(echo "$MERGE" | sed -e 's/^\.\///')
		MERGE="$PWD/$MERGE"

		if [ ! -f "$MERGE" ]; then
			# For conflict "Both Added", Git does not pass the merge param correctly in current versions
			MERGE=$(echo "$LOCAL" | sed -e 's/\.LOCAL\.[0-9]*//')
		fi
	fi

	sleep 1 # required to create different modification timestamp
	touch "$BACKUP"

	"$CMD" --wait "$MERGE"
else
	"$CMD" --wait --diff "$LOCAL" "$REMOTE"
fi

if [ -n "$MERGING" ]; then
	# Check if the merged file has changed
	if [ "$MERGE" -ot "$BACKUP" ]; then
		exit 1
	fi
fi

exit 0
