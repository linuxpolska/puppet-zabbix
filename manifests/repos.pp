# == Class: zabbix::repos
#
# === Authors
#
# Marcin Piebiak <marcin.piebiak@gmail.com>
#
# === Copyright
#
# Copyright 2014 Linux Polska sp. z o.o.

class zabbix::repos {
  if ! ($caller_module_name =~ /^zabbix$/) {
    fail("Please use class zabbix only!")
  }

  $repos_url     = $zabbix::params::repos_url
  $repos_version = $zabbix::repos_version

  case $::osfamily {
    'RedHat': {
      yumrepo { 'zabbix':
        descr    => 'Zabbix Official Repository - $basearch',
        baseurl  => "${repos_url}/zabbix/${repos_version}/rhel/${::operatingsystemmajrelease}/${::architecture}",
        enabled  => '1',
        gpgcheck => '1',
        gpgkey   => "${repos_url}/RPM-GPG-KEY-ZABBIX",
      }

      yumrepo { 'zabbix-non-supported':
        descr    => 'Zabbix Official Repository non-supported - $basearch',
        baseurl  => "${repos_url}/non-supported/rhel/${::operatingsystemmajrelease}/${::architecture}",
        enabled  => '1',
        gpgcheck => '1',
        gpgkey   => "${repos_url}/RPM-GPG-KEY-ZABBIX",
      }
    }
  }
}
