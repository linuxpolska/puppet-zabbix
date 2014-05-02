# == Class: zabbix::server
#
# === Authors
#
# Marcin Piebiak <marcin.piebiak@gmail.com>
#
# === Copyright
#
# Copyright 2014 Linux Polska sp. z o.o.

class zabbix::server {
  if ! ($caller_module_name =~ /^zabbix$/) {
    fail("Please use class zabbix only!")
  }

  $ensure      = $zabbix::server_ensure
  $version     = $zabbix::server_version

  $db_type     = $zabbix::server_db_type
  $db_name     = $zabbix::server_db_name
  $db_user     = $zabbix::server_db_user
  $db_password = $zabbix::server_db_password
  $db_host     = $zabbix::server_db_host
  $db_port     = $zabbix::server_db_port
  $db_install  = $zabbix::server_db_install
  $db_schema   = $zabbix::server_db_schema

  if (($ensure != undef) and (! ($ensure in ['present', 'stopped', 'running']))) {
    fail("server_ensure: ${ensure} - has not allowed value!")
  }
  $service_ensure = $ensure ? {
    undef   => $zabbix::ensure,
    default => $ensure,
  }

  if $db_type == 'pgsql' {
    $package_db_backend = 'zabbix-server-pgsql'
  }
  else {
    fail("server_db_type: ${db_type} is not supported! Current supported databases: ['pgsql']")
  }

  if $version != undef {
    $package_params = {
      'name' => $package_db_backend,
      'ensure' => $version,
    }
  }
  else {
    $package_params = {
      'name' => $package_db_backend,
    }
  }

  $all_package_params = merge($zabbix::packages_defaults, $package_params)

  # I belive in good zabbix packages relationship, so we can only insall one package
  ensure_resource('package', 'zabbix-server-backend', $all_package_params)

  zabbix::helpers::version { 'server':
    ensure  => $all_package_params['ensure'],
    require => Package['zabbix-server-backend'],
  }

  if $db_install == 'true' or $db_install == true {
    zabbix::db { $db_name:
      db_type     => $db_type,
      db_name     => $db_name,
      db_user     => $db_user,
      db_password => $db_password,
      db_schema   => $db_schema,
      require     => Zabbix::Helpers::Version['server'],
      before      => File['zabbix-server.conf'],
    }
  }

  file { 'zabbix-server.conf':
    ensure  => 'file',
    path    => '/etc/zabbix/zabbix_server.conf',
    owner   => 'root',
    group   => 'zabbix',
    mode    => '640',
    #FIXME 01 {
    # if module is used with add_zabbix_repos = false, we can not be sure that
    #   zabbix::repos_version have good value
    # $::zabbixversion is not good - because there is condition when fact is empty
    content => template("zabbix/zabbix_server.conf-${zabbix::repos_version}.erb"),
    #}
    require => Zabbix::Helpers::Version['server'],
  }

  if $service_ensure != 'present' {
    $service_enable = $service_ensure ? {
      'running' => 'true',
      'stopped' => 'false',
    }

    service { 'zabbix-server':
      ensure    => $service_ensure,
      enable    => $service_enable,
      subscribe => File['zabbix-server.conf'],
    }
  }
}
