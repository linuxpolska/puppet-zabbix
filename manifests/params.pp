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

  $proxy_db_type     = 'pgsql'
  $proxy_db_name     = 'zabbix_proxy'
  $proxy_db_user     = 'zabbix_proxy'
  $proxy_db_password = 'zzzzzzzzzz'
  $proxy_db_host     = '127.0.0.1'
  $proxy_db_port     = '5432'
  $proxy_db_install  = 'false'
  $proxy_db_schema   = '/usr/share/doc/zabbix-proxy-pgsql-*/create/schema.sql'
}
