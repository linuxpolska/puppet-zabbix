# == Define: zabbix::db
#
# === Authors
#
# Marcin Piebiak <marcin.piebiak@gmail.com>
#
# === Copyright
#
# Copyright 2014 Linux Polska sp. z o.o.

define zabbix::db (
  $db_type,
  $db_name,
  $db_user,
  $db_password,
  $db_schema,
) {
  if ! ($caller_module_name =~ /^zabbix$/) {
    fail("Please use class zabbix only!")
  }

  if ($db_type == 'pgsql') {
    include postgresql::server

    postgresql::server::db { "$db_name":
      user     => $db_user,
      password => postgresql_password($db_user, $db_password),
    }

    postgresql::server::pg_hba_rule { "allow $db_user to access database $db_name":
      type        => 'local',
      database    => $db_name,
      user        => $db_user,
      auth_method => 'md5',
    }

    if ( (!($db_schema =~ /^$/)) and $db_schema) {
      exec { "${db_name}::schema":
        path        => '/usr/bin:/bin',
        environment => "PGPASSWORD=${db_password}",
        command     => "cat ${db_schema} | psql -U ${db_user} -h localhost ${db_name}",
        require     => Postgresql::Server::Pg_hba_rule["allow $db_user to access database $db_name"],
        subscribe   => Postgresql::Server::Db["$db_name"],
        refreshonly => 'true',
      }
    }
  }
  else {
    fail("db_type: ${db_type} is not supported! Current supported databases: ['postgresql']")
  }
}
