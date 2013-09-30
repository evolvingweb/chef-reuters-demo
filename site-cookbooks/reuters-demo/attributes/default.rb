#
# Cookbook Name:: reuters-demo
# Recipe::        default
#
default['reuters-demo']['project_root'] = '/var/shared/sites/reuters'
default['reuters-demo']['indexed_data_src'] = 'https://github.com/downloads/evolvingweb/ajax-solr/reuters_data.tar.gz'
default['reuters-demo']['port'] = '9090'

default['reuters-demo']['nodejs_from_src'] = false

default['reuters-demo']['nodejs_bin'] = node['reuters-demo']['nodejs_from_src'] ? '/usr/local/bin' : '/usr/bin'

default['reuters-demo']['nodejs_path'] =  node['reuters-demo']['nodejs_from_src'] ? '/usr/local/lib/node_modules' : '/usr/lib/node_modules' 

# will be ignored if nodejs_from_src = false (most recent stable release instead)
default['reuters-demo']['nodejs_version'] = '0.10.18'
