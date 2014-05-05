require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.module_path = "/etc/puppet/modules:/usr/share/puppet/modules"
  c.manifest_dir = "manifests"
end
