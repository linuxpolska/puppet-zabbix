Facter.add(:zabbixversion) do
  confine :osfamily => "RedHat"

  setcode do
    result = Facter::Util::Resolution.exec('rpm -q zabbix --queryformat "%{VERSION}"')
    result if result =~ /^\d+\.\d+\.\d+$/
  end
end
