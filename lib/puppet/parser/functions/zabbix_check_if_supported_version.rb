Puppet::Parser::Functions.newfunction(:zabbix_check_if_supported_version, :type => :rvalue) do |args|
  raise ArgumentError, 'Wrong number of arguments' if args.length != 2

  result = false

  args[1].each do |version|
    if args[0] =~ /^#{version}/ then
      result = true
      break
    end
  end

  result
end
