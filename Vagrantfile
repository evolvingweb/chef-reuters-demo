# vi:ft=ruby:

%W(
  vagrant-omnibus
  gusteau
).each { |p| Vagrant.require_plugin(p) }

require 'gusteau'

Vagrant.configure('2') do |config|
  #config.vm.box = 'precise64'
  config.omnibus.chef_version = '11.4.4'

  Gusteau::Vagrant.detect(config) do |setup|
    setup.defaults.box = 'precise64'
    setup.defaults.box_url = 'http://dl.dropbox.com/u/1537815/precise64.box'
    setup.prefix = Time.now.to_i
  end
end
