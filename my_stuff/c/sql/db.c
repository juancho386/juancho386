#include <mysql.h>

class Db {
	/*
	MYSQL *con = mysql_init(NULL);
	MYSQL_RES *res;
	MYSQL_ROW row;
	*/

	public function __construct() {}
	/*
	if (con == NULL) {
		printf("error on init\n");
		exit(1);
	}
	if (mysql_real_connect(con, "localhost", "root", "", NULL, 0, NULL, 0) == NULL) {
		mysql_close(con);
		printf("error connecting\n");
		exit(1);
	}
	mysql_query(con, "select \"it works\"");
	res = mysql_store_result(con);
	while(row=mysql_fetch_row(res)) {
		printf("%s\n", row[0]);
	}
	mysql_free_result(res);
	mysql_close(con);
	*/
}
