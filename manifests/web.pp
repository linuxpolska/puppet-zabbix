# == Class: zabbix::web
#
# === Authors
#
# Marcin Piebiak <marcin.piebiak@gmail.com>
#
# === Copyright
#
# Copyright 2014 Linux Polska sp. z o.o.

class zabbix::web {
  if ! ($caller_module_name =~ /^zabbix$/) {
    fail("Please use class zabbix only!")
  }

  $ensure      = $zabbix::web_ensure
  $version     = $zabbix::web_version

  $timezone    = $zabbix::web_timezone

  $db_type     = $zabbix::web_db_type
  
  $db_name     = $zabbix::web_db_name
  $db_user     = $zabbix::web_db_user
  $db_password = $zabbix::web_db_password
  $db_host     = $zabbix::web_db_host
  $db_port     = $zabbix::web_db_port

  $server_name = $zabbix::web_server_name
  $server_host = $zabbix::web_server_host
  $server_port = $zabbix::web_server_port

  if (($ensure != undef) and (! ($ensure in ['present', 'stopped', 'running']))) {
    fail("web_ensure: ${ensure} - has not allowed value!")
  }
  $service_ensure = $ensure ? {
    undef   => $zabbix::ensure,
    default => $ensure,
  }

  if $db_type == 'pgsql' {
    $package_db_backend = 'zabbix-web-pgsql'
  }
  else {
    fail("web_db_type: ${db_type} is not supported! Current supported databases: ['pgsql']")
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
  ensure_resource('package', 'zabbix-web-backend', $all_package_params)

  zabbix::helpers::version { 'web':
    ensure   => $all_package_params['ensure'],
    pkg_name => 'zabbix-web',
    require  => Package['zabbix-web-backend'],
  }

  if $::selinux == 'true' {
    selboolean { 'httpd_can_network_connect_db':
      persistent => 'true',
      value      => 'on',
      require    => Zabbix::Helpers::Version['web'],
    }
  }

  file { 'zabbix-web.conf':
    ensure  => 'file',
    path    => '/etc/httpd/conf.d/zabbix.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    #FIXME 01 {
    # if module is used with add_zabbix_repos = false, we can not be sure that
    #   zabbix::repos_version have good value
    # $::zabbixversion is not good - because there is condition when fact is empty
    content => template("zabbix/zabbix_web.conf-${zabbix::repos_version}.erb"),
    #}
    require => Zabbix::Helpers::Version['web'],
  }

  file { 'zabbix-web.conf.php':
    ensure  => 'file',
    path    => '/etc/zabbix/web/zabbix.conf.php',
    owner   => $zabbix::params::apache_user,
    group   => $zabbix::params::apache_group,
    mode    => '644',
    #FIXME 01 {
    content => template("zabbix/zabbix_web.conf.php-${zabbix::repos_version}.erb"),
    #}
    require => File['zabbix-web.conf'],
  }

  if $service_ensure != 'present' {
    $service_enable = $service_ensure ? {
      'running' => 'true',
      'stopped' => 'false',
    }

    ensure_resource('service', $zabbix::params::apache_service, { 
      ensure    => $service_ensure,
      enable    => $service_enable,
      subscribe => File['zabbix-web.conf'],
    })
  }
}
