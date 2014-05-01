# == Class: zabbix::proxy
#
# === Authors
#
# Marcin Piebiak <marcin.piebiak@gmail.com>
#
# === Copyright
#
# Copyright 2014 Linux Polska sp. z o.o.

class zabbix::proxy {
  if ! ($caller_module_name =~ /^zabbix$/) {
    fail("Please use class zabbix only!")
  }

  $ensure      = $zabbix::proxy_ensure
  $version     = $zabbix::proxy_version

  $db_type     = $zabbix::proxy_db_type
  $db_name     = $zabbix::proxy_db_name
  $db_user     = $zabbix::proxy_db_user
  $db_password = $zabbix::proxy_db_password
  $db_host     = $zabbix::proxy_db_host
  $db_port     = $zabbix::proxy_db_port
  $db_install  = $zabbix::proxy_db_install
  $db_schema   = $zabbix::proxy_db_schema

  if (($ensure != undef) and (! ($ensure in ['present', 'stopped', 'running']))) {
    fail("ensure: ${ensure} - has not allowed value!")
  }

  if $db_type in ['pgsql', 'postgres', 'postgresql'] {
    $internal_db_type   = 'pgsql'
    $package_db_backend = 'zabbix-proxy-pgsql'
  }
  else {
    fail("db_type: ${db_type} is not supported! Current supported databases: ['postgresql']")
  }

  $service_ensure = $ensure ? {
    undef   => $zabbix::ensure,
    default => $ensure,
  }

  $package_params = {
    'name' => $package_db_backend,
    'ensure' => $version ? {
      undef   => 'present',
      default => $version,
    },
  }

  # I belive in good zabbix packages relationship, so we can only insall one package
  ensure_resource('package', 'zabbix-proxy-backend', merge($zabbix::packages_defaults, $package_params))

  if $db_install == 'true' or $db_install == true {
    zabbix::db { $db_name:
      db_type     => $internal_db_type,
      db_name     => $db_name,
      db_user     => $db_user,
      db_password => $db_password,
      db_schema   => $db_schema,
      require     => Package['zabbix-proxy-backend'],
      before      => File['zabbix-proxy.conf'],
    }
  }

  file { 'zabbix-proxy.conf':
    ensure  => 'file',
    path    => '/etc/zabbix/zabbix_proxy.conf',
    owner   => 'root',
    group   => 'zabbix',
    mode    => '640',
    content => template("zabbix/zabbix_proxy.conf-${zabbix::repos_version}.erb"),
    require => Package['zabbix-proxy-backend'],
  }

  if $service_ensure != 'present' {
    $service_enable = $service_ensure ? {
      'running' => 'true',
      'stopped' => 'false',
    }

    service { 'zabbix-proxy':
      ensure    => $service_ensure,
      enable    => $service_enable,
      subscribe => File['zabbix-proxy.conf'],
    }
  }
}
