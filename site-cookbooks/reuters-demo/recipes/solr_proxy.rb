#
# Cookbook Name:: reuters-demo
# Recipe::        solr_proxy
#

if node['reuters-demo']['nodejs_from_src']
  # compile nodejs from source
  include_recipe 'build-essential'
  nodejs = "node-v#{node['reuters-demo']['nodejs_version']}"
  bash "install-nodejs-from-source" do
    code <<-EOH
      wget http://nodejs.org/dist/v0.10.18/#{nodejs}.tar.gz
      tar zxf #{nodejs}.tar.gz
      cd #{nodejs}
      ./configure && make && make install
      export NODE_PATH=#{node['reuters-demo']['nodejs_path']}
      export PATH=#{node['reuters-demo']['nodejs_bin']}:$PATH
    EOH
    creates "#{node['reuters-demo']['nodejs_bin']}/node"
  end
else
  # add Chris Lea's repository to install node and npm.
  apt_repository 'node.js' do
    uri 'http://ppa.launchpad.net/chris-lea/node.js/ubuntu'
    distribution node['lsb']['codename']
    components ['main']
    key 'C7917B12'
    keyserver 'keyserver.ubuntu.com'
  end
  package ('nodejs') { action :install }
end

directory node['reuters-demo']['project_root'] do
  owner node['tomcat']['user']
  group node['tomcat']['user']
  recursive true
end

proxy_app = "require('solr-security-proxy').start(#{node['reuters-demo']['port']} \
              ,{validPaths: ['/#{node['drupal-solr']['app_name']}/select'], \ 
                backend_port: #{node['tomcat']['port']}});"

file "#{node['reuters-demo']['project_root']}/reuters-solr-proxy.js" do
  owner node['tomcat']['user']
  group node['tomcat']['group']
  content proxy_app
end

execute 'install-forever' do
  command "npm install -g forever"
  creates "#{node['reuters-demo']['nodejs_bin']}/forever"
end

execute 'install-solr-security-proxy' do
  cwd node['reuters-demo']['project_root']
  command "npm install solr-security-proxy"
  creates "#{node['reuters-demo']['project_root']}/node_modules/solr-security-proxy"
end

template '/etc/init.d/reuters-solr-proxy' do
  variables ({
    :dir => node['reuters-demo']['project_root'],
    :node_appfile => 'reuters-solr-proxy.js',
    :forever_logfile => '/var/log/reuters-solr-proxy.log'
  })
  mode 0755
  source 'reuters-solr-proxy.erb'
  notifies :run, 'execute[install-systemv-link]'
end

execute 'install-systemv-link' do
  command 'update-rc.d reuters-solr-proxy defaults'
  action :nothing
end

execute 'start-server' do
  command 'service reuters-solr-proxy start'
end
