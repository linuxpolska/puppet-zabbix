Puppet::Parser::Functions.newfunction(:gsub, :type => :rvalue) do |args|
  raise ArgumentError, 'Wrong number of arguments' if args.length != 3

  args[0].gsub(args[1], args[2])
end
