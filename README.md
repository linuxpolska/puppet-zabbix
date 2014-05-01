zabbix
======

Overview
--------
The Zabbix module allows you to easily configure, manage and scale Zabbix monitoring with Puppet.

Usage
-----
We strongly recommends to use Zabbix module be simply:

    include zabbix

with all parameters stored in hiera. But you can use this module in traditional way:

    class { 'zabbix':
      add_zabbix_repos => 'true',
      agent            => 'false',
    }

this will only create repository.
