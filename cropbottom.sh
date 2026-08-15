#!/bin/bash
command=$(basename $0 .sh)
side=${command:4}
original=$1
suffix=${original##*.}
cropped=$2
if [ -z "$original" ]; then
	echo Must specify image to crop >&2
	exit
fi
if [ -z "$cropped" ]; then
	cropped=${original%.*}_top.$suffix
fi
declare -p
echo convert $original -gravity South -crop 100%x50%+0+0 $cropped
