#!/bin/bash
if [ ! -f ./secrets/postgres-passwd.txt ]
then
pwgen -cns > ./secrets/postgres-passwd.txt
fi
if [ ! -f ./secrets/mysql-passwd.txt ]
then
pwgen -cns > ./secrets/mysql-passwd.txt
fi
if [ ! -f ./secrets/postfix-db-user.txt ]
then
pwgen -cns > ./secrets/postfix-db-user.txt
fi
if [ ! -f ./secrets/postfix-db-passwd.txt ]
then
pwgen -cns > ./secrets/postfix-db-passwd.txt
fi