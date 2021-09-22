#!/bin/bash
# 
# Script: cricinfo
# Author: Isuru Bandaranayake
#

url=http://static.cricinfo.com/rss/livescores.xml
path=~/.cricinfo
option=0

if [ "$1" = "-h" ]
then
	echo ""
	echo "Usage:"
	echo "	-a <team-name>	: Subscribe to a team"
	echo "	-h		: Display this help message"
	echo "	-l		: List all matches"
	echo "	-s		: List all subscribed teams"
	echo ""
elif [ "$1" = "-l" ]
then
	option=1
elif [ "$1" = "-a" ]
then
	echo $2 > $path
elif [ "$1" = "-s" ]
then
	if [ -e "$path" ]
	then
		cat $path
	else
		echo "No subscribed matches"
	fi
elif [ -e "$path" ]
then
	read -r id < $path

	if [ -z "$id" ]
	then
		echo Missing match ID
		option=1
	else
		option=2
	fi
else
	echo Missing match ID
	option=1
fi

if [ "$option" = 1 ]
then
	curl -s $url | grep -oP '(?<=<description>).*?(?=</description>)' | tail +2
elif [ "$option" = 2 ]
then 
	curl -s $url | grep -oP '(?<=<description>).*?(?=</description>)' | tail +2 | grep $id
fi

