#!/bin/sh
while :
do
	date >> mysql_stats.txt
	mysql -u 51185 -h mysql2.alwaysdata.com -ppourqu01 -e "USE orfeunegro_lfmconstellation;SELECT COUNT(*) FROM artists;" | sed -n 2p >> mysql_stats.txt
	sleep 1
done

