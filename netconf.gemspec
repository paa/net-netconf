$LOAD_PATH.unshift 'lib'
require 'net/netconf/version'

Gem::Specification.new do |s|
  s.name = 'net-netconf'
  s.version = Netconf::VERSION
  s.required_ruby_version = '>= 2.1.0'
  s.summary = "Updated NetConf client"
  s.description = "Updated and maintained fork of the Juniper Ruby NetConf client. This is used to manage NETCONF devices."
  s.homepage = 'https://github.com/kkirsche/net-netconf'
  s.authors = ["TP Honey", "Rick Sherman", "Kevin Kirsche", "Jeremy Schulman", "Ankit Jain"]
  s.email = 'kev.kirsche@gmail.com'
  s.files = Dir.glob("{lib/net,examples}/**/*.rb")
  s.license = 'BSD-2-Clause'
  s.required_ruby_version = '>= 2.1.0'
  s.add_runtime_dependency('nokogiri', '~> 1.6')
  s.add_runtime_dependency('net-ssh', '~> 4.1')
  s.add_runtime_dependency('net-scp', '~> 1.2')
  s.add_runtime_dependency('colorize', '~> 0.8')
  s.add_development_dependency('pry-byebug')
end
