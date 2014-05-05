Puppet::Parser::Functions.newfunction(:zabbix_check_if_supported_version, :type => :rvalue) do |args|
  raise ArgumentError, 'Wrong number of arguments' if args.length != 2
   raise ArgumentError, 'First argument should be string' if ! args[0].is_a? String 
   raise ArgumentError, 'Second argument should be array' if ! args[1].is_a? Array

  result = false

  args[1].each do |version|
    raise ArgumentError, 'Array should contain only strings' if ! version.is_a? String
    if args[0] =~ /^#{version}/ then
      result = version
      break
    end
  end

  result
end
