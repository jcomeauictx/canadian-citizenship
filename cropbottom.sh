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
if [ "$side" = top ]; then
	gravity=South
	otherside=bottom
else
	gravity=North
	otherside=top
fi
if [ -z "$cropped" ]; then
	cropped=${original%.*}_$otherside.$suffix
fi
declare -p
echo cropping out $side of $original and saving to $cropped >&2
convert $original -gravity $gravity -crop 100%x50%+0+0 $cropped
