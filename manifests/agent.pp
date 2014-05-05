# == Class: zabbix::agent
#
# === Authors
#
# Marcin Piebiak <marcin.piebiak@gmail.com>
#
# === Copyright
#
# Copyright 2014 Linux Polska sp. z o.o.

class zabbix::agent {
  if ! ($caller_module_name =~ /^zabbix$/) {
    fail("Please use class zabbix only!")
  }

  $ensure      = $zabbix::agent_ensure
  $version     = $zabbix::agent_version

  $server       = $zabbix::agent_server
  $serveractive = $zabbix::agent_serveractive

  if (($ensure != undef) and (! ($ensure in ['present', 'stopped', 'running']))) {
    fail("server_ensure: ${ensure} - has not allowed value!")
  }
  $service_ensure = $ensure ? {
    undef   => $zabbix::ensure,
    default => $ensure,
  }

  if $version != undef {
    $package_params = {
      'ensure' => $version,
    }
  }
  else {
    $package_params = {}
  }

  $all_package_params = merge($zabbix::packages_defaults, $package_params)

  # I belive in good zabbix packages relationship, so we can only insall one package
  ensure_resource('package', 'zabbix-agent', $all_package_params)

  zabbix::helpers::version { 'agent':
    ensure  => $all_package_params['ensure'],
    require => Package['zabbix-agent'],
  }

  file { 'zabbix-agent.conf':
    ensure  => 'file',
    path    => '/etc/zabbix/zabbix_agentd.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    #FIXME 01 {
    content => template("zabbix/zabbix_agentd.conf-${zabbix::repos_version}.erb"),
    #}
    require => Zabbix::Helpers::Version['agent'],
  }

  if $service_ensure != 'present' {
    $service_enable = $service_ensure ? {
      'running' => 'true',
      'stopped' => 'false',
    }

    service { 'zabbix-agent':
      ensure    => $service_ensure,
      enable    => $service_enable,
      subscribe => File['zabbix-agent.conf'],
    }
  }
}
