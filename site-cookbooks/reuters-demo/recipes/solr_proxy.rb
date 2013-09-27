#
# Cookbook Name:: reuters-demo
# Recipe::        solr_proxy
#

# Add Chris Lea's repository to install node and npm 
apt_repository 'node.js' do
  # install node 0.8 instead of the buggy 0.10.19
  # https://github.com/isaacs/npm/issues/2907#issuecomment-15215278
  # use the following when issue is resolved:
  # uri 'http://ppa.launchpad.net/chris-lea/node.js/ubuntu'
  uri 'http://ppa.launchpad.net/chris-lea/node.js-legacy/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  key 'C7917B12'
  keyserver 'keyserver.ubuntu.com'
end
%w{nodejs upstart}.each do |pkg|
  package(pkg) { action :install }
end

# create proxy node app
proxy_root = "#{node['reuters-demo']['project_root']}/proxy"

directory proxy_root do
  owner node['tomcat']['user']
  group node['tomcat']['user']
  recursive true
end

proxy_app = "require('solr-security-proxy').start(#{node['reuters-demo']['port']} \
              ,{validPaths: ['/#{node['drupal-solr']['app_name']}/select'], \ 
                backend_port: #{node['tomcat']['port']}});"

file "#{proxy_root}/reuters-solr-proxy.js" do
  content proxy_app
end

execute 'install-forever' do
  command "npm update -g && npm install -g forever"
  creates "#{node['reuters-demo']['node_bin']}/forever"
end

execute 'install-solr-security-proxy' do
  cwd proxy_root
  user node['tomcat']['user']
  command "npm install solr-security-proxy"
  creates "#{proxy_root}/node_modules/solr-security-proxy"
end

template '/etc/init/reuters-solr-proxy.conf' do
  variables ({
    :user => node['tomcat']['user'],
    :node_appfile => 'reuters-solr-proxy.js',
    :forever_logfile => '/var/log/reuters-solr-proxy.log'
  })
  source 'reuters-solr-proxy.conf.erb'
end

execute 'start-server' do
  command 'start reuters-solr-proxy'
end
