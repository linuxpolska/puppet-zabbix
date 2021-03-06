# == Class: zabbix
#
# === Authors
#
# Marcin Piebiak <marcin.piebiak@gmail.com>
#
# === Copyright
#
# Copyright 2014 Linux Polska sp. z o.o.


class zabbix (
  $ensure  = 'running',
  $version = undef,       # in version you can use latest

  $add_zabbix_repos = false,

  $agent               = true,
  $agent_ensure        = undef,
  $agent_version       = undef,
  $agent_server        = $zabbix::params::agent_server,
  $agent_serveractive  = $zabbix::params::agent_serveractive,

  $web              = false,
  $web_timezone     = undef,
  $web_db_type      = $zabbix::params::web_db_type,
  $web_db_name      = $zabbix::params::web_db_name,
  $web_db_user      = $zabbix::params::web_db_user,
  $web_db_password  = $zabbix::params::web_db_password,
  $web_db_host      = $zabbix::params::web_db_host,
  $web_db_port      = $zabbix::params::web_db_port,
  $web_server_name  = undef,
  $web_server_host  = $zabbix::params::web_server_ip,
  $web_server_port  = $zabbix::params::web_server_port,

  $server             = false,
  $server_ensure      = undef,
  $server_version     = undef,
  $server_db_type     = $zabbix::params::server_db_type,
  $server_db_name     = $zabbix::params::server_db_name,
  $server_db_user     = $zabbix::params::server_db_user,
  $server_db_password = $zabbix::params::server_db_password,
  $server_db_host     = $zabbix::params::server_db_host,
  $server_db_port     = $zabbix::params::server_db_port,
  $server_db_install  = $zabbix::params::server_db_install,
  $server_db_schema   = $zabbix::params::server_db_schema,

  $proxy             = false,
  $proxy_ensure      = undef,
  $proxy_version     = undef,
  $proxy_server      = $zabbix::params::proxy_server,
  $proxy_db_type     = $zabbix::params::proxy_db_type,
  $proxy_db_name     = $zabbix::params::proxy_db_name,
  $proxy_db_user     = $zabbix::params::proxy_db_user,
  $proxy_db_password = $zabbix::params::proxy_db_password,
  $proxy_db_host     = $zabbix::params::proxy_db_host,
  $proxy_db_port     = $zabbix::params::proxy_db_port,
  $proxy_db_install  = $zabbix::params::proxy_db_install,
  $proxy_db_schema   = $zabbix::params::proxy_db_schema,
) inherits zabbix::params {
  if (! ($ensure in ['present', 'stopped', 'running'])) {
    fail("ensure: ${ensure} - has not allowed value!")
  }

  #FIXME {
  # repo_version should be a parameter but first we must resolve FIXME 01
  # right now one zabbix version is supported so we can remove repo_version
  #   from parameters
  $repos_version    = $zabbix::params::repos_version
  #}

  $packages_defaults = {
    'ensure' => $version ? {
      undef   => 'present',
      default => $version,
    },
  }

  if $add_zabbix_repos == 'true' or $add_zabbix_repos == true {
    if (! ($repos_version in $zabbix::params::supported_zabbix_versions) ) {
      $supported = join($zabbix::params::supported_zabbix_versions, ', ')
      fail("repos_version: ${repos_version} is not supported! Current supported versions: ${supported}")
    }

    stage { 'zabbix::repos':
      before => Stage['main'],
    }

    class { 'zabbix::repos':
      stage => 'zabbix::repos',
    }
  }

  if $server == 'true' or $server == true {
    include zabbix::server
  }

  if $web == 'true' or $web == true {
    include zabbix::web
  }

  if $proxy == 'true' or $proxy == true {
    include zabbix::proxy
  }

  if $agent == 'true' or $agent == true {
    include zabbix::agent
  }
}
