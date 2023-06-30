sudo apt install libmysqlclient-dev

mysql_config --cflags
-I/usr/include/mysql
mysql_config --libs
-L/usr/lib/x86_64-linux-gnu -lmysqlclient -lpthread -lm -lrt -latomic -lssl -lcrypto -ldl


