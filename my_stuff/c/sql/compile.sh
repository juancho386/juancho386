#!/bin/bash
gcc $1 -o ${1}.exe \
	$(mysql_config --cflags) \
	$(mysql_config --libs) \


-L/usr/lib/x86_64-linux-gnu -lmysqlclient -lpthread -lm -lrt -latomic -lssl -lcrypto -ldl
-I/usr/include/mysql 
