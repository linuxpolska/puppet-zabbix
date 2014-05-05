# == Class: zabbix::params
#
# === Authors
#
# Marcin Piebiak <marcin.piebiak@gmail.com>
#
# === Copyright
#
# Copyright 2014 Linux Polska sp. z o.o.

class zabbix::params {
  $supported_osfamily = ['RedHat']

  case $::osfamily {
    'RedHat': {
      $supported_zabbix_versions = ['2.2']
      $supported_release         = ['5', '6']
      $supported_architecture    = ['i386', 'x86_64']

      $apache_user    = 'apache'
      $apache_group   = 'apache'
      $apache_service = 'httpd'
    }

    default: {
      $supported = join($supported_osfamily, ', ')
      fail("osfamily: ${::osfamily} is not supported yet! Current supported osfamilys: ${supported}")
    }
  }

  if (! ($::operatingsystemmajrelease in $supported_release)) {
    $supported = join($supported_release, ', ')
    fail("operatingsystemmajrelease: ${::operatingsystemmajrelease} for ${::osfamily} is not supported! Current supported operatingsystemmajreleases: ${supported}")
  }

  if (! ($::architecture in $supported_architecture)) {
    $supported = join($supported_architecture, ', ')
    fail("architecture: ${::architecture} for ${::osfamily} is not supported! Current supported architectures: ${supported}")
  }

  $repos_version = '2.2'
  $repos_url     = 'http://repo.zabbix.com'

  $server_db_type     = 'pgsql'
  $server_db_name     = 'zabbix_server'
  $server_db_user     = 'zabbix_server'
  $server_db_password = 'zzzzzzzzzz'
  $server_db_host     = '127.0.0.1'
  $server_db_port     = '5432'
  $server_db_install  = 'false'
  #FIXME {
  # wild card? :(
  $server_db_schema   = '/usr/share/doc/zabbix-server-pgsql-*/create/schema.sql /usr/share/doc/zabbix-server-pgsql-*/create/images.sql /usr/share/doc/zabbix-server-pgsql-*/create/data.sql'
  #}

  $proxy_db_type     = 'pgsql'
  $proxy_db_name     = 'zabbix_proxy'
  $proxy_db_user     = 'zabbix_proxy'
  $proxy_db_password = 'zzzzzzzzzz'
  $proxy_db_host     = '127.0.0.1'
  $proxy_db_port     = '5432'
  $proxy_db_install  = 'false'
  #FIXME {
  # wild card? :(
  $proxy_db_schema   = '/usr/share/doc/zabbix-proxy-pgsql-*/create/schema.sql'
  #}
  $proxy_server      = '127.0.0.1'

  $web_db_type     = 'pgsql'
  $web_db_name     = 'zabbix_server'
  $web_db_user     = 'zabbix_server'
  $web_db_password = 'zzzzzzzzzz'
  $web_db_host     = '127.0.0.1'
  $web_db_port     = '5432'
  $web_server_host = '127.0.0.1'
  $web_server_port = '10051'

  $agent_server       = '127.0.0.1'
  $agent_serveractive = '127.0.0.1'
}
