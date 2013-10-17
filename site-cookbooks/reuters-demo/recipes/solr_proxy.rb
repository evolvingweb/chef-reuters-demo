#
# Cookbook Name:: reuters-demo
# Recipe::        solr_proxy
#

if node['reuters-demo']['nodejs_from_src']
  # compile nodejs from source
  include_recipe 'build-essential'
  nodejs = "node-v#{node['reuters-demo']['nodejs_version']}"
  # urls are of the form: http://nodejs.org/dist/v0.10.20/node-v0.10.20.tar.gz
  download_url = "http://nodejs.org/dist/v#{node['reuters-demo']['nodejs_version']}/node-v#{node['reuters-demo']['nodejs_version']}.tar.gz"
  bash "install-nodejs-from-source" do
    code <<-EOH
      wget #{download_url} 
      tar zxf #{nodejs}.tar.gz
      cd #{nodejs}
      ./configure && make -j 2 && make install
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

execute 'install-solr-security-proxy' do
  cwd node['reuters-demo']['project_root']
  command "npm install -g solr-security-proxy"
  creates "#{node['reuters-demo']['project_root']}/node_modules/solr-security-proxy"
end

template '/etc/init/reuters-solr-proxy.conf' do
  variables ({
    :dir => node['reuters-demo']['project_root'],
    :proxy_port => node['reuters-demo']['port'],
    :solr_port => node['tomcat']['port']
  })
  mode 0755
  source 'reuters-solr-proxy.conf.erb'
  notifies :run, 'execute[start-server]'
end

execute 'start-server' do
  command 'start reuters-solr-proxy'
end
