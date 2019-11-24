#!/bin/bash

source env-conf.sh

echo $version

a=(${redis_port_range})
echo ${a[0]}


read -r -p "Are You Sure? [Y/n] " input

case $input in
    [yY][eE][sS]|[yY])
		echo "Yes"
		;;
    [nN][oO]|[nN])
		echo "No"
       	;;
    *)
		echo "Invalid input..."
		exit 1
		;;
esac


echo $version