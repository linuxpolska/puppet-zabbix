Puppet::Parser::Functions.newfunction(:gsub, :type => :rvalue) do |args|
  raise ArgumentError, 'Wrong number of arguments' if args.length != 3
  raise ArgumentError, 'All arguments should be string' if ! (args[0].is_a? String and args[1].is_a? String and args[2].is_a? String)

  args[0].gsub(args[1], args[2])
end
