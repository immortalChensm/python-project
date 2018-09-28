#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
public_file=/www/server/panel/install/public.sh
if [ ! -f $public_file ];then
	wget -O $public_file http://download.bt.cn/install/public.sh -T 5;
fi
. $public_file

download_Url=$NODE_URL

Root_Path=`cat /var/bt_setupPath.conf`
Setup_Path=$Root_Path/server/mysql
Data_Path=$Root_Path/server/data
Is_64bit=`getconf LONG_BIT`
run_path='/root'
mysql_51='5.1.73'
mysql_55='5.5.57'
mysql_56='5.6.37'
mysql_57='5.7.19'
mariadb_55='5.5.55'
mariadb_100='10.0.32'
mariadb_101='10.1.26'
mariadb_102='10.2.8'
alisql_version='5.6.32'

#检查系统版本
centos_version=`cat /etc/redhat-release | grep ' 7.' | grep -i centos`
if [ "${centos_version}" != '' ] && [ "${Is_64bit}" = "32" ]; then
	wget -O mysql.sh ${download_Url}/install/0/mysql.sh && sh mysql.sh $1 $2
	exit;
fi
if [ "${centos_version}" != '' ]; then
	rpm_path="centos7"
else
	rpm_path="centos6"
fi

#检测hosts文件
hostfile=`cat /etc/hosts | grep 127.0.0.1 | grep localhost`
if [ "${hostfile}" = '' ]; then
	echo "127.0.0.1  localhost  localhost.localdomain" >> /etc/hosts
fi

#删除软链
DelLink()
{	
	rm -f /usr/bin/mysql*
	rm -f /usr/lib/libmysql*
	rm -f /usr/lib64/libmysql*
}
#设置软件链
SetLink()
{
    ln -sf ${Setup_Path}/bin/mysql /usr/bin/mysql
    ln -sf ${Setup_Path}/bin/mysqldump /usr/bin/mysqldump
    ln -sf ${Setup_Path}/bin/myisamchk /usr/bin/myisamchk
    ln -sf ${Setup_Path}/bin/mysqld_safe /usr/bin/mysqld_safe
    ln -sf ${Setup_Path}/bin/mysqlcheck /usr/bin/mysqlcheck
	ln -sf ${Setup_Path}/bin/mysql_config /usr/bin/mysql_config
	
	rm -f /usr/lib/libmysqlclient.so.16
	rm -f /usr/lib64/libmysqlclient.so.16
	rm -f /usr/lib/libmysqlclient.so.18
	rm -f /usr/lib64/libmysqlclient.so.18
	rm -f /usr/lib/libmysqlclient.so.20
	rm -f /usr/lib64/libmysqlclient.so.20
	rm -f /usr/lib/libmysqlclient.so.21
	rm -f /usr/lib64/libmysqlclient.so.21
	
	if [ -f "${Setup_Path}/lib/libmysqlclient.so.18" ];then
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.18 /usr/lib/libmysqlclient.so.16
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.18 /usr/lib64/libmysqlclient.so.16
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.18 /usr/lib/libmysqlclient.so.18
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.18 /usr/lib64/libmysqlclient.so.18
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.18 /usr/lib/libmysqlclient.so.20
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.18 /usr/lib64/libmysqlclient.so.20
	elif [ -f "${Setup_Path}/lib/mysql/libmysqlclient.so.18" ];then
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.18 /usr/lib/libmysqlclient.so.16
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.18 /usr/lib64/libmysqlclient.so.16
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.18 /usr/lib/libmysqlclient.so.18
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.18 /usr/lib64/libmysqlclient.so.18
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.18 /usr/lib/libmysqlclient.so.20
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.18 /usr/lib64/libmysqlclient.so.20
	elif [ -f "${Setup_Path}/lib/libmysqlclient.so.16" ];then
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.16 /usr/lib/libmysqlclient.so.16
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.16 /usr/lib64/libmysqlclient.so.16
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.16 /usr/lib/libmysqlclient.so.18
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.16 /usr/lib64/libmysqlclient.so.18
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.16 /usr/lib/libmysqlclient.so.20
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.16 /usr/lib64/libmysqlclient.so.20
	elif [ -f "${Setup_Path}/lib/mysql/libmysqlclient.so.16" ];then
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.16 /usr/lib/libmysqlclient.so.16
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.16 /usr/lib64/libmysqlclient.so.16
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.16 /usr/lib/libmysqlclient.so.18
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.16 /usr/lib64/libmysqlclient.so.18
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.16 /usr/lib/libmysqlclient.so.20
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.16 /usr/lib64/libmysqlclient.so.20
	elif [ -f "${Setup_Path}/lib/libmysqlclient_r.so.16" ];then
		ln -sf ${Setup_Path}/lib/libmysqlclient_r.so.16 /usr/lib/libmysqlclient_r.so.16
		ln -sf ${Setup_Path}/lib/libmysqlclient_r.so.16 /usr/lib64/libmysqlclient_r.so.16
	elif [ -f "${Setup_Path}/lib/mysql/libmysqlclient_r.so.16" ];then
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient_r.so.16 /usr/lib/libmysqlclient_r.so.16
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient_r.so.16 /usr/lib64/libmysqlclient_r.so.16
	elif [ -f "${Setup_Path}/lib/libmysqlclient.so.20" ];then
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.20 /usr/lib/libmysqlclient.so.16
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.20 /usr/lib64/libmysqlclient.so.16
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.20 /usr/lib/libmysqlclient.so.18
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.20 /usr/lib64/libmysqlclient.so.18
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.20 /usr/lib/libmysqlclient.so.20
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.20 /usr/lib64/libmysqlclient.so.20
	elif [ -f "${Setup_Path}/lib/libmysqlclient.so.21" ];then
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.21 /usr/lib/libmysqlclient.so.16
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.21 /usr/lib64/libmysqlclient.so.16
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.21 /usr/lib/libmysqlclient.so.18
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.21 /usr/lib64/libmysqlclient.so.18
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.21 /usr/lib/libmysqlclient.so.20
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.21 /usr/lib64/libmysqlclient.so.20
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.21 /usr/lib/libmysqlclient.so.21
		ln -sf ${Setup_Path}/lib/libmysqlclient.so.21 /usr/lib64/libmysqlclient.so.21
	elif [ -f "${Setup_Path}/lib/libmariadb.so.3" ]; then
		ln -sf ${Setup_Path}/lib/libmariadb.so.3 /usr/lib/libmysqlclient.so.16
		ln -sf ${Setup_Path}/lib/libmariadb.so.3 /usr/lib64/libmysqlclient.so.16
		ln -sf ${Setup_Path}/lib/libmariadb.so.3 /usr/lib/libmysqlclient.so.18
		ln -sf ${Setup_Path}/lib/libmariadb.so.3 /usr/lib64/libmysqlclient.so.18
		ln -sf ${Setup_Path}/lib/libmariadb.so.3 /usr/lib/libmysqlclient.so.20
		ln -sf ${Setup_Path}/lib/libmariadb.so.3 /usr/lib64/libmysqlclient.so.20
		ln -sf ${Setup_Path}/lib/libmariadb.so.3 /usr/lib/libmysqlclient.so.21
		ln -sf ${Setup_Path}/lib/libmariadb.so.3 /usr/lib64/libmysqlclient.so.21
	elif [ -f "${Setup_Path}/lib/mysql/libmysqlclient.so.20" ];then
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.20 /usr/lib/libmysqlclient.so.16
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.20 /usr/lib64/libmysqlclient.so.16
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.20 /usr/lib/libmysqlclient.so.18
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.20 /usr/lib64/libmysqlclient.so.18
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.20 /usr/lib/libmysqlclient.so.20
		ln -sf ${Setup_Path}/lib/mysql/libmysqlclient.so.20 /usr/lib64/libmysqlclient.so.20
	fi
}

Install_MySQL_51(){
	Close_MySQL
	cd ${run_path}
	#准备安装
	mkdir -p ${Setup_Path}
	rm -rf ${Setup_Path}/*
	cd ${Setup_Path}
	if [ ! -f "bt-mysql-5.1.73.rpm" ];then
		wget ${download_Url}/rpm/${rpm_path}/${Is_64bit}/bt-mysql-5.1.73.rpm
	fi
	rpm -ivh bt-mysql-5.1.73.rpm --force --nodeps
	rm -f bt-mysql-5.1.73.rpm

	#创建用户
	groupadd mysql
	useradd -s /sbin/nologin -M -g mysql mysql

	#写出配置文件
		cat > /etc/my.cnf<<EOF
[client]
#password	= your_password
port		= 3306
socket		= /tmp/mysql.sock

[mysqld]
port		= 3306
socket		= /tmp/mysql.sock
datadir = ${Data_Path}
default_storage_engine = MyISAM
#skip-external-locking
#loose-skip-innodb
key_buffer_size = 8M
max_allowed_packet = 100G
table_open_cache = 32
sort_buffer_size = 256K
net_buffer_length = 4K
read_buffer_size = 128K
read_rnd_buffer_size = 256K
myisam_sort_buffer_size = 4M
thread_cache_size = 4
query_cache_size = 4M
tmp_table_size = 8M

#skip-networking
#skip-name-resolve
max_connections = 500
max_connect_errors = 100
open_files_limit = 65535

log-bin=mysql-bin
binlog_format=mixed
server-id	= 1
expire_logs_days = 10
slow_query_log=1
slow-query-log-file=${Data_Path}/mysql-slow.log
long_query_time=3
#log_queries_not_using_indexes=on

innodb_data_home_dir = ${Data_Path}
innodb_data_file_path = ibdata1:10M:autoextend
innodb_log_group_home_dir = ${Data_Path}
innodb_buffer_pool_size = 16M
innodb_additional_mem_pool_size = 2M
innodb_log_file_size = 5M
innodb_log_buffer_size = 8M
innodb_flush_log_at_trx_commit = 1
innodb_lock_wait_timeout = 50

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
EOF

	MySQL_Opt
	#处理数据目录
	if [ -d "${Data_Path}" ]; then
		rm -rf ${Data_Path}/*
		else
			mkdir -p ${Data_Path}
		fi
		chown -R mysql:mysql ${Data_Path}
		${Setup_Path}/bin/mysql_install_db --defaults-file=/etc/my.cnf --basedir=${Setup_Path} --datadir=${Data_Path} --user=mysql
		chgrp -R mysql ${Setup_Path}/.
		rm -f /etc/init.d/mysqld
		wget -O /etc/init.d/mysqld ${download_Url}/init/mysql/mysql51
		chmod 755 /etc/init.d/mysqld
		sed -i "s#\"\$\*\"#--sql-mode=\"NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION\"#" /etc/init.d/mysqld
		sed -i '/case "$mode" in/i\ulimit -s unlimited' /etc/init.d/mysqld
		cat > /etc/ld.so.conf.d/mysql.conf<<EOF
${Setup_Path}/lib
/usr/local/lib
EOF

	

	#启动服务
    ldconfig
	#chown mysql:mysql /etc/my.cnf
    ln -sf ${Setup_Path}/lib/mysql /usr/lib/mysql
    ln -sf ${Setup_Path}/include/mysql /usr/include/mysql
	/etc/init.d/mysqld start
	
	#设置软链
	SetLink
	ldconfig

	#设置密码
    ${Setup_Path}/bin/mysqladmin -u root password "${mysqlpwd}"
	
	#添加到服务列表
	chkconfig --add mysqld
	chkconfig --level 2345 mysqld on
	
	ln -sf /www/server/mysql/lib/mysql/libmysqlclient_r.so.16 /usr/lib/libmysqlclient_r.so.16
	ln -sf /www/server/mysql/lib/mysql/libmysqlclient_r.so.16 /usr/lib64/libmysqlclient_r.so.16

	cd ${Setup_Path}
	echo "${mysql_51}" > ${Setup_Path}/version.pl
	
	
}

Install_MySQL_55(){
	Close_MySQL
	cd ${run_path}
	#准备安装
	mkdir -p ${Setup_Path}
	rm -rf ${Setup_Path}/*
	cd ${Setup_Path}
	if [ ! -f "bt-mysql-5.5.57.rpm" ];then
		wget ${download_Url}/rpm/${rpm_path}/${Is_64bit}/bt-mysql-5.5.57.rpm
	fi
	rpm -ivh bt-mysql-5.5.57.rpm --force --nodeps
	rm -f bt-mysql-5.5.57.rpm

	if [ ! -f "${Setup_Path}/bin/mysqld" ];then
		echo '========================================================'
		echo -e "\033[31mERROR: mysql-5.5 installation failed.\033[0m";
		rm -rf ${Setup_Path}
		exit 0;
	fi
	
	#创建用户
	groupadd mysql
	useradd -s /sbin/nologin -M -g mysql mysql

	#写出配置文件
		cat > /etc/my.cnf<<EOF
[client]
#password	= your_password
port		= 3306
socket		= /tmp/mysql.sock

[mysqld]
port		= 3306
socket		= /tmp/mysql.sock
datadir = ${Data_Path}
default_storage_engine = MyISAM
#skip-external-locking
#loose-skip-innodb
key_buffer_size = 8M
max_allowed_packet = 100G
table_open_cache = 32
sort_buffer_size = 256K
net_buffer_length = 4K
read_buffer_size = 128K
read_rnd_buffer_size = 256K
myisam_sort_buffer_size = 4M
thread_cache_size = 4
query_cache_size = 4M
tmp_table_size = 8M

#skip-networking
#skip-name-resolve
max_connections = 500
max_connect_errors = 100
open_files_limit = 65535

log-bin=mysql-bin
binlog_format=mixed
server-id	= 1
expire_logs_days = 10
slow_query_log=1
slow-query-log-file=${Data_Path}/mysql-slow.log
long_query_time=3
#log_queries_not_using_indexes=on

default_storage_engine = InnoDB
innodb_data_home_dir = ${Data_Path}
innodb_data_file_path = ibdata1:10M:autoextend
innodb_log_group_home_dir = ${Data_Path}
innodb_buffer_pool_size = 16M
innodb_additional_mem_pool_size = 2M
innodb_log_file_size = 5M
innodb_log_buffer_size = 8M
innodb_flush_log_at_trx_commit = 1
innodb_lock_wait_timeout = 120
innodb_max_dirty_pages_pct = 90
innodb_read_io_threads = 4
innodb_write_io_threads = 4

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
EOF

	MySQL_Opt
	#处理数据目录
	if [ -d "${Data_Path}" ]; then
		rm -rf ${Data_Path}/*
		else
			mkdir -p ${Data_Path}
		fi
		chown -R mysql:mysql ${Data_Path}
		${Setup_Path}/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=${Setup_Path} --datadir=${Data_Path} --user=mysql
		chgrp -R mysql ${Setup_Path}/.
		\cp support-files/mysql.server /etc/init.d/mysqld
		if [ ! -f "/etc/init.d/mysqld" ]; then
			wget -O /etc/init.d/mysqld ${download_Url}/init/mysql/mysql55
		fi
		chmod 755 /etc/init.d/mysqld
		sed -i "s#\"\$\*\"#--sql-mode=\"NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION\"#" /etc/init.d/mysqld
		sed -i '/case "$mode" in/i\ulimit -s unlimited' /etc/init.d/mysqld
		cat > /etc/ld.so.conf.d/mysql.conf<<EOF
${Setup_Path}/lib
/usr/local/lib
EOF

	

	#启动服务
    ldconfig
	#chown mysql:mysql /etc/my.cnf
    ln -sf ${Setup_Path}/lib/mysql /usr/lib/mysql
    ln -sf ${Setup_Path}/include/mysql /usr/include/mysql
	/etc/init.d/mysqld start
	
	#设置软链
    SetLink
	ldconfig

	#设置密码
    ${Setup_Path}/bin/mysqladmin -u root password "${mysqlpwd}"
    /www/server/mysql/bin/mysql -uroot -p${mysqlpwd} -e "drop user 'test'@'127.0.0.1'";
    /www/server/mysql/bin/mysql -uroot -p${mysqlpwd} -e "drop user 'test'@'localhost'";
    /www/server/mysql/bin/mysql -uroot -p${mysqlpwd} -e "flush privileges";
	
	#添加到服务列表
	chkconfig --add mysqld
	chkconfig --level 2345 mysqld on
	
	cd ${Setup_Path}
	echo "${mysql_55}" > ${Setup_Path}/version.pl
	
	
}

Install_MySQL_56()
{
	Close_MySQL
	cd ${run_path}
	#准备安装
	
	
	mkdir -p ${Setup_Path}
	rm -rf ${Setup_Path}/*
	cd ${Setup_Path}
	if [ ! -f "bt-mysql-5.6.37.rpm" ];then
		wget ${download_Url}/rpm/${rpm_path}/${Is_64bit}/bt-mysql-5.6.37.rpm
	fi
	rpm -ivh bt-mysql-5.6.37.rpm --force --nodeps
	rm -f bt-mysql-5.6.37.rpm

	if [ ! -f "${Setup_Path}/bin/mysqld" ];then
		echo '========================================================'
		echo -e "\033[31mERROR: mysql-5.6 installation failed.\033[0m";
		rm -rf ${Setup_Path}
		exit 0;
	fi
	
    groupadd mysql
    useradd -s /sbin/nologin -M -g mysql mysql

    cat > /etc/my.cnf<<EOF
[client]
#password   = your_password
port        = 3306
socket      = /tmp/mysql.sock

[mysqld]
port        = 3306
socket      = /tmp/mysql.sock
datadir = ${Data_Path}
skip-external-locking
performance_schema_max_table_instances=400
table_definition_cache=400
key_buffer_size = 8M
max_allowed_packet = 100G
table_open_cache = 32
sort_buffer_size = 256K
net_buffer_length = 8K
read_buffer_size = 128K
read_rnd_buffer_size = 256K
myisam_sort_buffer_size = 4M
thread_cache_size = 4
query_cache_size = 4M
tmp_table_size = 8M

explicit_defaults_for_timestamp = true
#skip-networking
#skip-name-resolve
max_connections = 500
max_connect_errors = 100
open_files_limit = 65535
sql-mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

log-bin=mysql-bin
binlog_format=mixed
server-id   = 1
expire_logs_days = 10
slow_query_log=1
slow-query-log-file=${Data_Path}/mysql-slow.log
long_query_time=3
#log_queries_not_using_indexes=on

#loose-innodb-trx=0
#loose-innodb-locks=0
#loose-innodb-lock-waits=0
#loose-innodb-cmp=0
#loose-innodb-cmp-per-index=0
#loose-innodb-cmp-per-index-reset=0
#loose-innodb-cmp-reset=0
#loose-innodb-cmpmem=0
#loose-innodb-cmpmem-reset=0
#loose-innodb-buffer-page=0
#loose-innodb-buffer-page-lru=0
#loose-innodb-buffer-pool-stats=0
#loose-innodb-metrics=0
#loose-innodb-ft-default-stopword=0
#loose-innodb-ft-inserted=0
#loose-innodb-ft-deleted=0
#loose-innodb-ft-being-deleted=0
#loose-innodb-ft-config=0
#loose-innodb-ft-index-cache=0
#loose-innodb-ft-index-table=0
#loose-innodb-sys-tables=0
#loose-innodb-sys-tablestats=0
#loose-innodb-sys-indexes=0
#loose-innodb-sys-columns=0
#loose-innodb-sys-fields=0
#loose-innodb-sys-foreign=0
#loose-innodb-sys-foreign-cols=0

default_storage_engine = InnoDB
innodb_data_home_dir = ${Data_Path}
innodb_data_file_path = ibdata1:10M:autoextend
innodb_log_group_home_dir = ${Data_Path}
innodb_buffer_pool_size = 16M
innodb_log_file_size = 5M
innodb_log_buffer_size = 8M
innodb_flush_log_at_trx_commit = 1
innodb_lock_wait_timeout = 120
innodb_max_dirty_pages_pct = 90
innodb_read_io_threads = 4
innodb_write_io_threads = 4

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
EOF
    
    MySQL_Opt
    if [ -d "${Data_Path}" ]; then
        rm -rf ${Data_Path}/*
    else
        mkdir -p ${Data_Path}
    fi
    #chown -R mysql:mysql ${Data_Path}
    ${Setup_Path}/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=${Setup_Path} --datadir=${Data_Path} --user=mysql
    chgrp -R mysql ${Setup_Path}/.
    \cp support-files/mysql.server /etc/init.d/mysqld
    if [ ! -f "/etc/init.d/mysqld" ]; then
    	wget -O /etc/init.d/mysqld ${download_Url}/init/mysql/mysql56
    fi
    chmod 755 /etc/init.d/mysqld
	sed -i "s#\"\$\*\"#--sql-mode=\"NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION\"#" /etc/init.d/mysqld
	sed -i '/case "$mode" in/i\ulimit -s unlimited' /etc/init.d/mysqld
    cat > /etc/ld.so.conf.d/mysql.conf<<EOF
    ${Setup_Path}/lib
    /usr/local/lib
EOF
	
	
	#启动服务
    ldconfig
	chown mysql:mysql /etc/my.cnf
    ln -sf ${Setup_Path}/lib/mysql /usr/lib/mysql
    ln -sf ${Setup_Path}/include/mysql /usr/include/mysql
	/etc/init.d/mysqld start
	
	SetLink
	ldconfig
	
	
	#设置密码
    ${Setup_Path}/bin/mysqladmin -u root password "${mysqlpwd}"
    /www/server/mysql/bin/mysql -uroot -p${mysqlpwd} -e "drop user 'test'@'127.0.0.1'";
    /www/server/mysql/bin/mysql -uroot -p${mysqlpwd} -e "drop user 'test'@'localhost'";
    /www/server/mysql/bin/mysql -uroot -p${mysqlpwd} -e "flush privileges";
	
	#添加到服务列表
	chkconfig --add mysqld
	chkconfig --level 2345 mysqld on
	
	cd ${Setup_Path}
	echo "${mysql_56}" > ${Setup_Path}/version.pl
	

}


Install_MySQL_57()
{
	Close_MySQL
	cd ${run_path}
	#准备安装
	Setup_Path="/www/server/mysql"
	Data_Path="/www/server/data"
	if [ ! -f "bt-mysql-5.7.19.rpm" ];then
		wget ${download_Url}/rpm/${rpm_path}/${Is_64bit}/bt-mysql-5.7.19.rpm
	fi
	rpm -ivh bt-mysql-5.7.19.rpm --force --nodeps
	rm -f bt-mysql-5.7.19.rpm

    groupadd mysql
    useradd -s /sbin/nologin -M -g mysql mysql

    cat > /etc/my.cnf<<EOF
[client]
#password   = your_password
port        = 3306
socket      = /tmp/mysql.sock

[mysqld]
port        = 3306
socket      = /tmp/mysql.sock
datadir = ${Data_Path}
skip-external-locking
performance_schema_max_table_instances=400
table_definition_cache=400
key_buffer_size = 16M
max_allowed_packet = 100G
table_open_cache = 64
sort_buffer_size = 512K
net_buffer_length = 8K
read_buffer_size = 256K
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 8M
thread_cache_size = 8
query_cache_size = 8M
tmp_table_size = 16M
sql-mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

explicit_defaults_for_timestamp = true
#skip-networking
max_connections = 500
max_connect_errors = 100
open_files_limit = 65535

log-bin=mysql-bin
binlog_format=mixed
server-id   = 1
expire_logs_days = 10
slow_query_log=1
slow-query-log-file=${Data_Path}/mysql-slow.log
long_query_time=3
#log_queries_not_using_indexes=on
early-plugin-load = ""

#loose-innodb-trx=0
#loose-innodb-locks=0
#loose-innodb-lock-waits=0
#loose-innodb-cmp=0
#loose-innodb-cmp-per-index=0
#loose-innodb-cmp-per-index-reset=0
#loose-innodb-cmp-reset=0
#loose-innodb-cmpmem=0
#loose-innodb-cmpmem-reset=0
#loose-innodb-buffer-page=0
#loose-innodb-buffer-page-lru=0
#loose-innodb-buffer-pool-stats=0
#loose-innodb-metrics=0
#loose-innodb-ft-default-stopword=0
#loose-innodb-ft-inserted=0
#loose-innodb-ft-deleted=0
#loose-innodb-ft-being-deleted=0
#loose-innodb-ft-config=0
#loose-innodb-ft-index-cache=0
#loose-innodb-ft-index-table=0
#loose-innodb-sys-tables=0
#loose-innodb-sys-tablestats=0
#loose-innodb-sys-indexes=0
#loose-innodb-sys-columns=0
#loose-innodb-sys-fields=0
#loose-innodb-sys-foreign=0
#loose-innodb-sys-foreign-cols=0

default_storage_engine = InnoDB
innodb_data_home_dir = ${Data_Path}
innodb_data_file_path = ibdata1:10M:autoextend
innodb_log_group_home_dir = ${Data_Path}
innodb_buffer_pool_size = 16M
innodb_log_file_size = 5M
innodb_log_buffer_size = 8M
innodb_flush_log_at_trx_commit = 1
innodb_lock_wait_timeout = 120
innodb_max_dirty_pages_pct = 90
innodb_read_io_threads = 4
innodb_write_io_threads = 4

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
EOF

    MySQL_Opt
    if [ -d "${Data_Path}" ]; then
        rm -rf ${Data_Path}/*
    else
        mkdir -p ${Data_Path}
    fi
    chown -R mysql:mysql ${Data_Path}
    ${Setup_Path}/bin/mysqld --initialize-insecure --basedir=${Setup_Path} --datadir=${Data_Path} --user=mysql
    chgrp -R mysql ${Setup_Path}/.
    rm -f /etc/init.d/mysql
    wget -O /etc/init.d/mysqld ${download_Url}/init/mysql/mysql57
    chmod 755 /etc/init.d/mysqld
    sed -i '/case "$mode" in/i\ulimit -s unlimited' /etc/init.d/mysqld
    cat > /etc/ld.so.conf.d/mysql.conf<<EOF
    ${Setup_Path}/lib
    /usr/local/lib
EOF


	#启动服务
    ldconfig
    ln -sf ${Setup_Path}/lib/mysql /usr/lib/mysql
    ln -sf ${Setup_Path}/include/mysql /usr/include/mysql
	/etc/init.d/mysqld start
	
	#设置软链
    SetLink
	ldconfig
	
	#设置密码
    ${Setup_Path}/bin/mysqladmin -u root password "${mysqlpwd}"
    /www/server/mysql/bin/mysql -uroot -p${mysqlpwd} -e "drop user 'test'@'127.0.0.1'";
    /www/server/mysql/bin/mysql -uroot -p${mysqlpwd} -e "drop user 'test'@'localhost'";
    /www/server/mysql/bin/mysql -uroot -p${mysqlpwd} -e "flush privileges";
		
	#添加到服务列表
	chkconfig --add mysqld
	chkconfig --level 2345 mysqld on
	
	cd ${Setup_Path}
	echo "${mysql_57}" > ${Setup_Path}/version.pl
	if [ ! -f "${Setup_Path}/bin/mysqld" ];then
		echo '========================================================'
		echo -e "\033[31mERROR: mysql-5.7 installation failed.\033[0m";
		rm -rf ${Setup_Path}
		exit 0;
	fi
}


Install_AliSQL()
{
	Close_MySQL
	cd ${run_path}
	#准备安装
	Setup_Path="/www/server/mysql"
	Data_Path="/www/server/data"
	
	
	mkdir -p ${Setup_Path}
	rm -rf ${Setup_Path}/*
	cd ${Setup_Path}

	groupadd mysql
    useradd -s /sbin/nologin -M -g mysql mysql
	yum install bison-2.7 -y

	if [ ! -f "alisql.rpm" ];then
		wget ${download_Url}/rpm/${rpm_path}/${Is_64bit}/alisql.rpm
	fi
	rpm -ivh alisql.rpm --force --nodeps
	rm -f alisql.rpm
   
	if [ ! -f "${Setup_Path}/bin/mysqld" ];then
		echo '========================================================'
		echo -e "\033[31mERROR: AliSQL-$alisql_version installation failed.\033[0m";
		rm -rf ${Setup_Path}
		exit 0;
	fi

	    cat > /etc/my.cnf<<EOF
[client]
#password   = your_password
port        = 3306
socket      = /tmp/mysql.sock

[mysqld]
port        = 3306
socket      = /tmp/mysql.sock
datadir = ${Data_Path}
skip-external-locking
performance_schema_max_table_instances=400
table_definition_cache=400
key_buffer_size = 4M
max_allowed_packet = 100G
table_open_cache = 32
sort_buffer_size = 256K
net_buffer_length = 8K
read_buffer_size = 128K
read_rnd_buffer_size = 256K
myisam_sort_buffer_size = 4M
thread_cache_size = 4
query_cache_size = 4M
tmp_table_size = 8M

explicit_defaults_for_timestamp = true

#skip-networking
#skip-name-resolve
max_connections = 500
max_connect_errors = 100
open_files_limit = 65535
sql-mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

log-bin=mysql-bin
binlog_format=mixed
server-id   = 1
expire_logs_days = 10
slow_query_log=1
slow-query-log-file=${Data_Path}/mysql-slow.log
long_query_time=3
#log_queries_not_using_indexes=on

#loose-innodb-trx=0
#loose-innodb-locks=0
#loose-innodb-lock-waits=0
#loose-innodb-cmp=0
#loose-innodb-cmp-per-index=0
#loose-innodb-cmp-per-index-reset=0
#loose-innodb-cmp-reset=0
#loose-innodb-cmpmem=0
#loose-innodb-cmpmem-reset=0
#loose-innodb-buffer-page=0
#loose-innodb-buffer-page-lru=0
#loose-innodb-buffer-pool-stats=0
#loose-innodb-metrics=0
#loose-innodb-ft-default-stopword=0
#loose-innodb-ft-inserted=0
#loose-innodb-ft-deleted=0
#loose-innodb-ft-being-deleted=0
#loose-innodb-ft-config=0
#loose-innodb-ft-index-cache=0
#loose-innodb-ft-index-table=0
#loose-innodb-sys-tables=0
#loose-innodb-sys-tablestats=0
#loose-innodb-sys-indexes=0
#loose-innodb-sys-columns=0
#loose-innodb-sys-fields=0
#loose-innodb-sys-foreign=0
#loose-innodb-sys-foreign-cols=0

default_storage_engine = InnoDB
innodb_data_home_dir = ${Data_Path}
innodb_data_file_path = ibdata1:10M:autoextend
innodb_log_group_home_dir = ${Data_Path}
innodb_buffer_pool_size = 16M
innodb_log_file_size = 5M
innodb_log_buffer_size = 8M
innodb_flush_log_at_trx_commit = 1
innodb_lock_wait_timeout = 120
innodb_max_dirty_pages_pct = 90
innodb_read_io_threads = 4
innodb_write_io_threads = 4

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
EOF

    
    MySQL_Opt
    if [ -d "${Data_Path}" ]; then
        rm -rf ${Data_Path}/*
    else
        mkdir -p ${Data_Path}
    fi
	
	chown -R mysql:mysql $Setup_Path
	chown -R mysql:mysql $Data_Path
    #chown -R mysql:mysql ${Data_Path}
    ${Setup_Path}/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=${Setup_Path} --datadir=${Data_Path} --user=mysql
    chgrp -R mysql ${Setup_Path}/.
    \cp support-files/mysql.server /etc/init.d/mysqld
    chmod 755 /etc/init.d/mysqld
	sed -i "s#\"\$\*\"#--sql-mode=\"NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION\"#" /etc/init.d/mysqld
	sed -i '/case "$mode" in/i\ulimit -s unlimited' /etc/init.d/mysqld
    cat > /etc/ld.so.conf.d/mysql.conf<<EOF
    ${Setup_Path}/lib
    /usr/local/lib
EOF
	
	
	#启动服务
    ldconfig
	chown mysql:mysql /etc/my.cnf
    ln -sf ${Setup_Path}/lib/mysql /usr/lib/mysql
    ln -sf ${Setup_Path}/include/mysql /usr/include/mysql
	/etc/init.d/mysqld start
	
	#设置软链
    SetLink
	ldconfig
	
	
	#设置密码
    ${Setup_Path}/bin/mysqladmin -u root password "${mysqlpwd}"
    /www/server/mysql/bin/mysql -uroot -p${mysqlpwd} -e "drop user 'test'@'127.0.0.1'";
    /www/server/mysql/bin/mysql -uroot -p${mysqlpwd} -e "drop user 'test'@'localhost'";
    /www/server/mysql/bin/mysql -uroot -p${mysqlpwd} -e "flush privileges";
	
	#添加到服务列表
	chkconfig --add mysqld
	chkconfig --level 2345 mysqld on
	
	cd ${Setup_Path}
	echo "AliSQL $alisql_version" > ${Setup_Path}/version.pl
}


Install_Mariadb_55(){
	Close_MySQL
	cd ${run_path}
	#准备安装
	mkdir -p ${Setup_Path}
	rm -rf ${Setup_Path}/*
	cd ${Setup_Path}
	if [ ! -f "${Setup_Path}/src.tar.gz" ];then
		wget -O ${Setup_Path}/src.tar.gz ${download_Url}/src/mariadb-$mariadb_55.tar.gz -T20
	fi
	tar -zxvf src.tar.gz
	mv mariadb-$mariadb_55 src
	cd src
	
	#编译
	
	cmake -DCMAKE_INSTALL_PREFIX=${Setup_Path} -DWITH_ARIA_STORAGE_ENGINE=1 -DWITH_XTRADB_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8mb4 -DDEFAULT_COLLATION=utf8mb4_general_ci -DWITH_READLINE=1 -DWITH_EMBEDDED_SERVER=1 -DENABLED_LOCAL_INFILE=1 
	make && make install
	
	#创建用户
	groupadd mysql
	useradd -s /sbin/nologin -M -g mysql mysql

	#写出配置文件
		cat > /etc/my.cnf<<EOF
[client]
#password	= your_password
port		= 3306
socket		= /tmp/mysql.sock

[mysqld]
port		= 3306
socket		= /tmp/mysql.sock
user    = mariadb
datadir = ${Data_Path}
basedir = ${Setup_Path}
log_error = ${Data_Path}/mariadb.err
#pid-file = ${Data_Path}/mariadb.pid
default_storage_engine = MyISAM
#skip-external-locking
#loose-skip-innodb
key_buffer_size = 8M
max_allowed_packet = 100G
table_open_cache = 32
sort_buffer_size = 256K
net_buffer_length = 4K
read_buffer_size = 128K
read_rnd_buffer_size = 256K
myisam_sort_buffer_size = 4M
thread_cache_size = 4
query_cache_size = 4M
tmp_table_size = 8M

#skip-networking
#skip-name-resolve
max_connections = 500
max_connect_errors = 100
open_files_limit = 65535

log-bin=mysql-bin
binlog_format=mixed
server-id	= 1
expire_logs_days = 10
slow_query_log=1
slow-query-log-file=${Data_Path}/mysql-slow.log
long_query_time=3
#log_queries_not_using_indexes=on

default_storage_engine = InnoDB
innodb_data_home_dir = ${Data_Path}
innodb_data_file_path = ibdata1:10M:autoextend
innodb_log_group_home_dir = ${Data_Path}
innodb_buffer_pool_size = 16M
innodb_additional_mem_pool_size = 2M
innodb_log_file_size = 5M
innodb_log_buffer_size = 8M
innodb_flush_log_at_trx_commit = 1
innodb_lock_wait_timeout = 120
innodb_max_dirty_pages_pct = 90
innodb_read_io_threads = 4
innodb_write_io_threads = 4

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
EOF

	MySQL_Opt
	#处理数据目录
	if [ -d "${Data_Path}" ]; then
		rm -rf ${Data_Path}/*
		else
			mkdir -p ${Data_Path}
		fi
		chown -R mysql:mysql ${Data_Path}
		${Setup_Path}/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=${Setup_Path} --datadir=${Data_Path} --user=mysql
		${Setup_Path}/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=${Setup_Path} --datadir=${Data_Path} --user=mysql
		chgrp -R mysql ${Setup_Path}/.
		\cp support-files/mysql.server /etc/init.d/mysqld
		chmod 755 /etc/init.d/mysqld
		sed -i "s#\"\$\*\"#--sql-mode=\"NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION\"#" /etc/init.d/mysqld

		cat > /etc/ld.so.conf.d/mysql.conf<<EOF
${Setup_Path}/lib
/usr/local/lib
EOF

	

	#启动服务
    ldconfig
	#chown mysql:mysql /etc/my.cnf
    ln -sf ${Setup_Path}/lib/mysql /usr/lib/mysql
    ln -sf ${Setup_Path}/include/mysql /usr/include/mysql

	/etc/init.d/mysqld start

	#设置软链
    SetLink
	ldconfig

	#设置密码
    ${Setup_Path}/bin/mysqladmin -u root password "${mysqlpwd}"
	
	#添加到服务列表
	chkconfig --add mysqld
	chkconfig --level 2345 mysqld on
    
    service mysqld start
	
	cd ${Setup_Path}
	echo "mariadb_${mariadb_55}" > ${Setup_Path}/version.pl
	
	
}

Install_Mariadb_100(){
	Close_MySQL
	cd ${run_path}
	#准备安装
	mkdir -p ${Setup_Path}
	rm -rf ${Setup_Path}/*
	cd ${Setup_Path}
	if [ ! -f "bt-mariadb-10.0.32.rpm" ];then
		wget ${download_Url}/rpm/${rpm_path}/${Is_64bit}/bt-mariadb-10.0.32.rpm
	fi
	rpm -ivh bt-mariadb-10.0.32.rpm --force --nodeps
	rm -f bt-mariadb-10.0.32.rpm
	
	#创建用户
	groupadd mysql
	useradd -s /sbin/nologin -M -g mysql mysql

	#写出配置文件
		cat > /etc/my.cnf<<EOF
[client]
#password	= your_password
port		= 3306
socket		= /tmp/mysql.sock

[mysqld]
port		= 3306
socket		= /tmp/mysql.sock
user    = mysql
datadir = ${Data_Path}
basedir = ${Setup_Path}
log_error = ${Data_Path}/mariadb.err
#pid-file = ${Data_Path}/mariadb.pid
default_storage_engine = MyISAM
#skip-external-locking
#loose-skip-innodb
key_buffer_size = 16M
max_allowed_packet = 100G
table_open_cache = 64
sort_buffer_size = 512K
net_buffer_length = 8K
read_buffer_size = 256K
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 8M
thread_cache_size = 4
query_cache_size = 8M
tmp_table_size = 16M

#skip-networking
#skip-name-resolve
max_connections = 500
max_connect_errors = 100
open_files_limit = 65535

log-bin=mysql-bin
binlog_format=mixed
server-id	= 1
expire_logs_days = 10
slow_query_log=1
slow-query-log-file=${Data_Path}/mysql-slow.log
long_query_time=3
#log_queries_not_using_indexes=on

default_storage_engine = InnoDB
innodb_data_home_dir = ${Data_Path}
innodb_data_file_path = ibdata1:10M:autoextend
innodb_log_group_home_dir = ${Data_Path}
innodb_buffer_pool_size = 16M
innodb_additional_mem_pool_size = 2M
innodb_log_file_size = 5M
innodb_log_buffer_size = 8M
innodb_flush_log_at_trx_commit = 1
innodb_lock_wait_timeout = 120
innodb_max_dirty_pages_pct = 90
innodb_read_io_threads = 4
innodb_write_io_threads = 4


[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
EOF

	MySQL_Opt
	#处理数据目录
	if [ -d "${Data_Path}" ]; then
		rm -rf ${Data_Path}/*
		else
			mkdir -p ${Data_Path}
		fi
		chown -R mysql:mysql ${Data_Path}
		${Setup_Path}/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=${Setup_Path} --datadir=${Data_Path} --user=mysql
		${Setup_Path}/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=${Setup_Path} --datadir=${Data_Path} --user=mysql
		chgrp -R mysql ${Setup_Path}/.
		\cp support-files/mysql.server /etc/init.d/mysqld
		if [ ! -f "/etc/init.d/mysqld" ]; then
			wget -O /etc/init.d/mysqld ${download_Url}/init/mysql/mariadb10
		fi
		chmod 755 /etc/init.d/mysqld
		sed -i "s#\"\$\*\"#--sql-mode=\"NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION\"#" /etc/init.d/mysqld
		sed -i '/case "$mode" in/i\ulimit -s unlimited' /etc/init.d/mysqld
		cat > /etc/ld.so.conf.d/mysql.conf<<EOF
${Setup_Path}/lib
/usr/local/lib
EOF

	

	#启动服务
    ldconfig
	#chown mysql:mysql /etc/my.cnf
    ln -sf ${Setup_Path}/lib/mysql /usr/lib/mysql
    ln -sf ${Setup_Path}/include/mysql /usr/include/mysql

	#设置软链
    SetLink
	ldconfig

	/etc/init.d/mysqld start

	#设置密码
    ${Setup_Path}/bin/mysqladmin -u root password "${mysqlpwd}"
	
	#添加到服务列表
	chkconfig --add mysqld
	chkconfig --level 2345 mysqld on

	service mysqld start

	
	cd ${Setup_Path}
	echo "mariadb_${mariadb_100}" > ${Setup_Path}/version.pl
	
	
}

Install_Mariadb_101(){
	Close_MySQL
	cd ${run_path}
	#准备安装
	mkdir -p ${Setup_Path}
	rm -rf ${Setup_Path}/*
	cd ${Setup_Path}
	if [ ! -f "bt-mariadb-10.1.26.rpm" ];then
		wget ${download_Url}/rpm/${rpm_path}/${Is_64bit}/bt-mariadb-10.1.26.rpm
	fi
	rpm -ivh bt-mariadb-10.1.26.rpm --force --nodeps
	rm -f bt-mariadb-10.1.26.rpm
	
	#创建用户
	groupadd mysql
	useradd -s /sbin/nologin -M -g mysql mysql

	#写出配置文件
		cat > /etc/my.cnf<<EOF
[client]
#password	= your_password
port		= 3306
socket		= /tmp/mysql.sock

[mysqld]
port		= 3306
socket		= /tmp/mysql.sock
user    = mysql
datadir = ${Data_Path}
basedir = ${Setup_Path}
log_error = ${Data_Path}/mariadb.err
#pid-file = ${Data_Path}/mariadb.pid
default_storage_engine = MyISAM
#skip-external-locking
#loose-skip-innodb
key_buffer_size = 16M
max_allowed_packet = 100G
table_open_cache = 64
sort_buffer_size = 512K
net_buffer_length = 8K
read_buffer_size = 256K
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 8M
thread_cache_size = 8
query_cache_size = 8M
tmp_table_size = 16M
sql-mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

#skip-networking
#skip-name-resolve
max_connections = 500
max_connect_errors = 100
open_files_limit = 65535

log-bin=mysql-bin
binlog_format=mixed
server-id	= 1
expire_logs_days = 10
slow_query_log=1
slow-query-log-file=${Data_Path}/mysql-slow.log
long_query_time=3
#log_queries_not_using_indexes=on

default_storage_engine = InnoDB
innodb_data_home_dir = ${Data_Path}
innodb_data_file_path = ibdata1:10M:autoextend
innodb_log_group_home_dir = ${Data_Path}
innodb_buffer_pool_size = 16M
innodb_additional_mem_pool_size = 2M
innodb_log_file_size = 5M
innodb_log_buffer_size = 8M
innodb_flush_log_at_trx_commit = 1
innodb_lock_wait_timeout = 120
innodb_max_dirty_pages_pct = 90
innodb_read_io_threads = 4
innodb_write_io_threads = 4

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
EOF

	MySQL_Opt
	#处理数据目录
	if [ -d "${Data_Path}" ]; then
		rm -rf ${Data_Path}/*
		else
			mkdir -p ${Data_Path}
		fi
		chown -R mysql:mysql ${Data_Path}
		${Setup_Path}/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=${Setup_Path} --datadir=${Data_Path} --user=mysql
		${Setup_Path}/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=${Setup_Path} --datadir=${Data_Path} --user=mysql
		chgrp -R mysql ${Setup_Path}/.
		\cp support-files/mysql.server /etc/init.d/mysqld
		if [ ! -f "/etc/init.d/mysqld" ]; then
			wget -O /etc/init.d/mysqld ${download_Url}/init/mysql/mariadb11
		fi
		chmod 755 /etc/init.d/mysqld
		sed -i "s#\"\$\*\"#--sql-mode=\"NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION\"#" /etc/init.d/mysqld
		sed -i '/case "$mode" in/i\ulimit -s unlimited' /etc/init.d/mysqld
		cat > /etc/ld.so.conf.d/mysql.conf<<EOF
${Setup_Path}/lib
/usr/local/lib
EOF

	

	#启动服务
    ldconfig
	#chown mysql:mysql /etc/my.cnf
    ln -sf ${Setup_Path}/lib/mysql /usr/lib/mysql
    ln -sf ${Setup_Path}/include/mysql /usr/include/mysql

	/etc/init.d/mysqld start

	#设置软链
    SetLink
	ldconfig

	#设置密码
    ${Setup_Path}/bin/mysqladmin -u root password "${mysqlpwd}"
	
	#添加到服务列表
	chkconfig --add mysqld
	chkconfig --level 2345 mysqld on

	service mysqld start
	
	cd ${Setup_Path}
	echo "mariadb_${mariadb_101}" > ${Setup_Path}/version.pl
	
	
}
Install_Mariadb_102(){
	Close_MySQL
	cd ${run_path}
	#准备安装
	mkdir -p ${Setup_Path}
	rm -rf ${Setup_Path}/*
	cd ${Setup_Path}
	if [ ! -f "bt-mariadb-10.2.8.rpm" ];then
		wget ${download_Url}/rpm/${rpm_path}/${Is_64bit}/bt-mariadb-10.2.8.rpm
	fi
	rpm -ivh bt-mariadb-10.2.8.rpm --force --nodeps
	rm -f bt-mariadb-10.2.8.rpm
	
	#创建用户
	groupadd mysql
	useradd -s /sbin/nologin -M -g mysql mysql

	#写出配置文件
		cat > /etc/my.cnf<<EOF
[client]
#password	= your_password
port		= 3306
socket		= /tmp/mysql.sock

[mysqld]
port		= 3306
socket		= /tmp/mysql.sock
user    = mysql
datadir = ${Data_Path}
basedir = ${Setup_Path}
log_error = ${Data_Path}/mariadb.err
#pid-file = ${Data_Path}/mariadb.pid
default_storage_engine = MyISAM
#skip-external-locking
#loose-skip-innodb
key_buffer_size = 16M
max_allowed_packet = 100G
table_open_cache = 64
sort_buffer_size = 512K
net_buffer_length = 8K
read_buffer_size = 256K
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 8M
thread_cache_size = 8
query_cache_size = 8M
tmp_table_size = 16M
sql-mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

#skip-networking
#skip-name-resolve
max_connections = 500
max_connect_errors = 100
open_files_limit = 65535

log-bin=mysql-bin
binlog_format=mixed
server-id	= 1
expire_logs_days = 10

default_storage_engine = InnoDB
innodb_data_home_dir = ${Data_Path}
innodb_data_file_path = ibdata1:10M:autoextend
innodb_log_group_home_dir = ${Data_Path}
innodb_buffer_pool_size = 16M
innodb_log_file_size = 5M
innodb_log_buffer_size = 8M
innodb_flush_log_at_trx_commit = 1
innodb_lock_wait_timeout = 50

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
EOF

	MySQL_Opt
	#处理数据目录
	if [ -d "${Data_Path}" ]; then
		rm -rf ${Data_Path}/*
		else
			mkdir -p ${Data_Path}
		fi
		chown -R mysql:mysql ${Data_Path}
		/www/server/mysql/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=/www/server/mysql --datadir=/www/server/data --user=mysql
		${Setup_Path}/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=${Setup_Path} --datadir=${Data_Path} --user=mysql
		chgrp -R mysql ${Setup_Path}/.
		\cp support-files/mysql.server /etc/init.d/mysqld
		if [ ! -f "/etc/init.d/mysqld" ]; then
			wget -O /etc/init.d/mysqld ${download_Url}/init/mysql/mariadb12
		fi
		chmod 755 /etc/init.d/mysqld
		sed -i "s#\"\$\*\"#--sql-mode=\"NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION\"#" /etc/init.d/mysqld

		cat > /etc/ld.so.conf.d/mysql.conf<<EOF
${Setup_Path}/lib
/usr/local/lib
EOF

	

	#启动服务
    ldconfig
	#chown mysql:mysql /etc/my.cnf
    ln -sf ${Setup_Path}/lib/mysql /usr/lib/mysql
    ln -sf ${Setup_Path}/include/mysql /usr/include/mysql

	/etc/init.d/mysqld start

	#设置软链
    SetLink
	ldconfig

	#设置密码
    ${Setup_Path}/bin/mysqladmin -u root password "${mysqlpwd}"
	
	#添加到服务列表
	chkconfig --add mysqld
	chkconfig --level 2345 mysqld on

	service mysqld start
	
	cd ${Setup_Path}
	echo "mariadb_${mariadb_102}" > ${Setup_Path}/version.pl
	echo "True" > ${Setup_Path}/mysqlDb3.pl 
}



MySQL_Opt()
{
	cpuInfo=`cat /proc/cpuinfo |grep "processor"|wc -l`
	sed -i 's/innodb_write_io_threads = 4/innodb_write_io_threads = '${cpuInfo}'/g' /etc/my.cnf 
	sed -i 's/innodb_read_io_threads = 4/innodb_read_io_threads = '${cpuInfo}'/g' /etc/my.cnf
	MemTotal=`free -m | grep Mem | awk '{print  $2}'`
    if [[ ${MemTotal} -gt 1024 && ${MemTotal} -lt 2048 ]]; then
        sed -i "s#^key_buffer_size.*#key_buffer_size = 32M#" /etc/my.cnf
        sed -i "s#^table_open_cache.*#table_open_cache = 128#" /etc/my.cnf
        sed -i "s#^sort_buffer_size.*#sort_buffer_size = 768K#" /etc/my.cnf
        sed -i "s#^read_buffer_size.*#read_buffer_size = 768K#" /etc/my.cnf
        sed -i "s#^myisam_sort_buffer_size.*#myisam_sort_buffer_size = 8M#" /etc/my.cnf
        sed -i "s#^thread_cache_size.*#thread_cache_size = 16#" /etc/my.cnf
        sed -i "s#^query_cache_size.*#query_cache_size = 16M#" /etc/my.cnf
        sed -i "s#^tmp_table_size.*#tmp_table_size = 32M#" /etc/my.cnf
        sed -i "s#^innodb_buffer_pool_size.*#innodb_buffer_pool_size = 128M#" /etc/my.cnf
        sed -i "s#^innodb_log_file_size.*#innodb_log_file_size = 64M#" /etc/my.cnf
        sed -i "s#^innodb_log_buffer_size.*#innodb_log_buffer_size = 16M#" /etc/my.cnf
    elif [[ ${MemTotal} -ge 2048 && ${MemTotal} -lt 4096 ]]; then
        sed -i "s#^key_buffer_size.*#key_buffer_size = 64M#" /etc/my.cnf
        sed -i "s#^table_open_cache.*#table_open_cache = 256#" /etc/my.cnf
        sed -i "s#^sort_buffer_size.*#sort_buffer_size = 1M#" /etc/my.cnf
        sed -i "s#^read_buffer_size.*#read_buffer_size = 1M#" /etc/my.cnf
        sed -i "s#^myisam_sort_buffer_size.*#myisam_sort_buffer_size = 16M#" /etc/my.cnf
        sed -i "s#^thread_cache_size.*#thread_cache_size = 32#" /etc/my.cnf
        sed -i "s#^query_cache_size.*#query_cache_size = 32M#" /etc/my.cnf
        sed -i "s#^tmp_table_size.*#tmp_table_size = 64M#" /etc/my.cnf
        sed -i "s#^innodb_buffer_pool_size.*#innodb_buffer_pool_size = 256M#" /etc/my.cnf
        sed -i "s#^innodb_log_file_size.*#innodb_log_file_size = 128M#" /etc/my.cnf
        sed -i "s#^innodb_log_buffer_size.*#innodb_log_buffer_size = 32M#" /etc/my.cnf
    elif [[ ${MemTotal} -ge 4096 && ${MemTotal} -lt 8192 ]]; then
        sed -i "s#^key_buffer_size.*#key_buffer_size = 128M#" /etc/my.cnf
        sed -i "s#^table_open_cache.*#table_open_cache = 512#" /etc/my.cnf
        sed -i "s#^sort_buffer_size.*#sort_buffer_size = 2M#" /etc/my.cnf
        sed -i "s#^read_buffer_size.*#read_buffer_size = 2M#" /etc/my.cnf
        sed -i "s#^myisam_sort_buffer_size.*#myisam_sort_buffer_size = 32M#" /etc/my.cnf
        sed -i "s#^thread_cache_size.*#thread_cache_size = 64#" /etc/my.cnf
        sed -i "s#^query_cache_size.*#query_cache_size = 64M#" /etc/my.cnf
        sed -i "s#^tmp_table_size.*#tmp_table_size = 64M#" /etc/my.cnf
        sed -i "s#^innodb_buffer_pool_size.*#innodb_buffer_pool_size = 512M#" /etc/my.cnf
        sed -i "s#^innodb_log_file_size.*#innodb_log_file_size = 256M#" /etc/my.cnf
        sed -i "s#^innodb_log_buffer_size.*#innodb_log_buffer_size = 64M#" /etc/my.cnf
    elif [[ ${MemTotal} -ge 8192 && ${MemTotal} -lt 16384 ]]; then
        sed -i "s#^key_buffer_size.*#key_buffer_size = 256M#" /etc/my.cnf
        sed -i "s#^table_open_cache.*#table_open_cache = 1024#" /etc/my.cnf
        sed -i "s#^sort_buffer_size.*#sort_buffer_size = 4M#" /etc/my.cnf
        sed -i "s#^read_buffer_size.*#read_buffer_size = 4M#" /etc/my.cnf
        sed -i "s#^myisam_sort_buffer_size.*#myisam_sort_buffer_size = 64M#" /etc/my.cnf
        sed -i "s#^thread_cache_size.*#thread_cache_size = 128#" /etc/my.cnf
        sed -i "s#^query_cache_size.*#query_cache_size = 128M#" /etc/my.cnf
        sed -i "s#^tmp_table_size.*#tmp_table_size = 128M#" /etc/my.cnf
        sed -i "s#^innodb_buffer_pool_size.*#innodb_buffer_pool_size = 1024M#" /etc/my.cnf
        sed -i "s#^innodb_log_file_size.*#innodb_log_file_size = 512M#" /etc/my.cnf
        sed -i "s#^innodb_log_buffer_size.*#innodb_log_buffer_size = 128M#" /etc/my.cnf
    elif [[ ${MemTotal} -ge 16384 && ${MemTotal} -lt 32768 ]]; then
        sed -i "s#^key_buffer_size.*#key_buffer_size = 512M#" /etc/my.cnf
        sed -i "s#^table_open_cache.*#table_open_cache = 2048#" /etc/my.cnf
        sed -i "s#^sort_buffer_size.*#sort_buffer_size = 8M#" /etc/my.cnf
        sed -i "s#^read_buffer_size.*#read_buffer_size = 8M#" /etc/my.cnf
        sed -i "s#^myisam_sort_buffer_size.*#myisam_sort_buffer_size = 128M#" /etc/my.cnf
        sed -i "s#^thread_cache_size.*#thread_cache_size = 256#" /etc/my.cnf
        sed -i "s#^query_cache_size.*#query_cache_size = 256M#" /etc/my.cnf
        sed -i "s#^tmp_table_size.*#tmp_table_size = 256M#" /etc/my.cnf
        sed -i "s#^innodb_buffer_pool_size.*#innodb_buffer_pool_size = 2048M#" /etc/my.cnf
        sed -i "s#^innodb_log_file_size.*#innodb_log_file_size = 1024M#" /etc/my.cnf
        sed -i "s#^innodb_log_buffer_size.*#innodb_log_buffer_size = 256M#" /etc/my.cnf
    elif [[ ${MemTotal} -ge 32768 ]]; then
        sed -i "s#^key_buffer_size.*#key_buffer_size = 1024M#" /etc/my.cnf
        sed -i "s#^table_open_cache.*#table_open_cache = 4096#" /etc/my.cnf
        sed -i "s#^sort_buffer_size.*#sort_buffer_size = 16M#" /etc/my.cnf
        sed -i "s#^read_buffer_size.*#read_buffer_size = 16M#" /etc/my.cnf
        sed -i "s#^myisam_sort_buffer_size.*#myisam_sort_buffer_size = 256M#" /etc/my.cnf
        sed -i "s#^thread_cache_size.*#thread_cache_size = 512#" /etc/my.cnf
        sed -i "s#^query_cache_size.*#query_cache_size = 512M#" /etc/my.cnf
        sed -i "s#^tmp_table_size.*#tmp_table_size = 512M#" /etc/my.cnf
        sed -i "s#^innodb_buffer_pool_size.*#innodb_buffer_pool_size = 4096M#" /etc/my.cnf
        if [ "${version}" == "5.5" ];then
        	sed -i "s#^innodb_log_file_size.*#innodb_log_file_size = 1024M#" /etc/my.cnf
        	sed -i "s#^innodb_log_buffer_size.*#innodb_log_buffer_size = 256M#" /etc/my.cnf
        else
        	sed -i "s#^innodb_log_file_size.*#innodb_log_file_size = 2048M#" /etc/my.cnf
        	sed -i "s#^innodb_log_buffer_size.*#innodb_log_buffer_size = 512M#" /etc/my.cnf
        fi
    fi
}

Install_mysqldb()
{
	wget -O MySQL-python-1.2.5.zip ${download_Url}/install/src/MySQL-python-1.2.5.zip -T 10
	unzip MySQL-python-1.2.5.zip
	rm -f MySQL-python-1.2.5.zip
	cd MySQL-python-1.2.5
	python setup.py install
	cd ..
	rm -rf MySQL-python-1.2.5
}
Install_mysqldb3()
{
	wget -O mysqlclient-1.3.12.zip ${download_Url}/install/src/mysqlclient-1.3.12.zip -T 10
	unzip mysqlclient-1.3.12.zip
	rm -f mysqlclient-1.3.12.zip
	cd mysqlclient-1.3.12
	python setup.py install
	cd ..
	rm -rf mysqlclient-1.3.12
}


Close_MySQL()
{
	yum remove mysql-devel -y
	service mysqld stop
	rpm -qa |grep bt-mysql > mysql.pl
	rpm -qa |grep bt-mariadb > mariadb.pl
	mysqlVersion=`cat mysql.pl`
	mariadbVersion=`cat mariadb.pl`
	if [ "${mysqlVersion}" != "" ]; then
		rpm -e $mysqlVersion --nodeps
	fi
	if [ "${mariadbVersion}" != "" ]; then
		rpm -e $mariadbVersion --nodeps
	fi
	rm -f mysql.pl
	rm -f mariadb.pl
	if [ "$1" == 'del' ];then
		rm -rf $Setup_Path
	fi
	
	if [ -d "${Data_Path}" ];then
		mkdir -p $Root_Path/backup
		mv $Data_Path  $Root_Path/backup/oldData
		rm -rf $Data_Path
	fi
	
	chkconfig --del mysqld
	rm -rf /etc/init.d/mysqld
	DelLink
}

actionType=$1
version=$2

if [ "$actionType" == 'install' ];then
	mysqlpwd=`cat /dev/urandom | head -n 16 | md5sum | head -c 16`
	case "$version" in
		'5.1')
			Install_MySQL_51
			;;
		'5.5')
			Install_MySQL_55
			;;
		'5.6')
			Install_MySQL_56
			;;
		'5.7')
			Install_MySQL_57
			;;
		'8.0')
			Install_MySQL_57
			;;
		'alisql')
			Install_AliSQL
			;;
		'mariadb_5.5')
			Install_Mariadb_55
			;;		
		'mariadb_10.0')
			Install_Mariadb_100
			;;		
		'mariadb_10.1')
			Install_Mariadb_101
			;;
		'mariadb_10.2')
			Install_Mariadb_102
			;;

	esac
	service mysqld start
	/www/server/mysql/bin/mysql -uroot -proot -e "drop user 'test'@'127.0.0.1'";
	/www/server/mysql/bin/mysql -uroot -proot -e "drop user 'test'@'localhost'";
	/www/server/mysql/bin/mysql -uroot -proot -e "flush privileges";
	cd $Root_Path/server/panel
	python tools.pyc root $mysqlpwd
	
	pip uninstall mysql-python mysqlclient -y

	if [ -f "${Setup_Path}/mysqlDb3.pl" ]; then
		Install_mysqldb3
		/etc/init.d/bt reload
	else
		pipUrl=`cat /root/.pip/pip.conf|awk 'NR==2 {print $3}'`
		if [ "${pipUrl}" != "" ]; then
			checkPip=`curl --connect-timeout 5 --head -s -o /dev/null -w %{http_code} ${pipUrl}`
		fi
		if [ "${checkPip}" = "200" ]; then
			pip install mysql-python
		else
			Install_mysqldb
			/etc/init.d/bt reload
		fi
	fi

elif [ "$actionType" == 'uninstall' ];then
	Close_MySQL del
fi
