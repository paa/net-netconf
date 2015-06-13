$LOAD_PATH.unshift 'lib'
require 'rake'
require 'net/netconf/version'

Gem::Specification.new do |s|
  s.name = 'netconf'
  s.version = Netconf::VERSION
  s.summary = "NetConf client"
  s.description = "Ruby NetConf client"
  s.homepage = 'https://github.com/kkirsche/net-netconf'
  s.authors = ["Kevin Kirsche"]
  s.email = 'jschulman@juniper.net'
  s.files = FileList['lib/net/**/*.rb', 'examples/**/*.rb']
  s.add_dependency('nokogiri', '>= 1.5.5')
  s.add_dependency('net-ssh-multi', '~1.2.1')
  s.add_dependency('net-scp')
end
