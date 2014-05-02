#
# === Authors
#
# Marcin Piebiak <marcin.piebiak@gmail.com>
#
# === Copyright
#
# Copyright 2014 Linux Polska sp. z o.o.

define zabbix::helpers::version (
  $ensure,
) {
  if ! ($caller_module_name =~ /^zabbix$/) {
    fail("Please use class zabbix only!")
  }

  if $ensure == 'present' {
    if $::zabbixversion == undef {
      $check_installed_package_version = true
    }
    else {
      if ! zabbix_check_if_supported_version($::zabbixversion, $zabbix::params::supported_zabbix_versions) {
        fail("zabbix version: ${::zabbixversion} is not supported!")
      }
    }
  }
  elsif $ensure == 'latest' {
    $check_installed_package_version = true
  }
  elsif ! zabbix_check_if_supported_version($ensure, $zabbix::params::supported_zabbix_versions) {
    fail("zabbix version: ${ensure} is not supported!")
  }

  if $check_installed_package_version == true {
    $teststr = gsub(join(prefix($zabbix::params::supported_zabbix_versions, '^'), "\|"), '.', '\.')
    
    exec { "check if zabbix version for ${name} is supported":
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      command => "rpm -q zabbix --queryformat %{VERSION} | grep -q '${teststr}'",
    }
  }
}
