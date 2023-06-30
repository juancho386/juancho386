main:
	gcc sql.c -o sql \
	-L/usr/lib/x86_64-linux-gnu -lmysqlclient -lpthread -lm -lrt -latomic -lssl -lcrypto -ldl \
	-I/usr/include/mysql

clean:
	rm sql
