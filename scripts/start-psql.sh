 
#!/bin/bash

mkdir -p /var/run/postgresql
chown -R postgres /var/run/postgresql
chmod 775 /var/run/postgresql

export PGDATA=/var/lib/postgresql/data

mkdir -p $PGDATA
chown -R postgres $PGDATA
chmod 700 $PGDATA

# unset shell so -p command does not use whatever weird shell you use
unset SHELL
su -p - postgres -c '/usr/lib/postgresql/9.6/bin/pg_ctl init && /usr/lib/postgresql/9.6/bin/pg_ctl -w -t 20 -D ${PGDATA} start'
