$LOAD_PATH.unshift 'lib'
require 'rake'
require 'net/netconf/version'

Gem::Specification.new do |s|
  s.name = 'net-netconf'
  s.version = Netconf::VERSION
  s.summary = "NetConf client"
  s.description = "Ruby NetConf client"
  s.homepage = 'https://github.com/kkirsche/net-netconf'
  s.authors = ["Kevin Kirsche"]
  s.email = 'kev.kirsche@gmail.com'
  s.files = FileList['lib/net/**/*.rb', 'examples/**/*.rb']
  s.license = 'BSD 2'
  s.add_dependency('nokogiri', '~> 1.6')
  s.add_dependency('net-ssh', '~> 2.9')
  s.add_dependency('net-scp', '~> 1.2')
end
