#
# Cookbook Name:: reuters-demo
# Recipe::        default
#
default['reuters-demo']['project_root'] = '/var/shared/sites/reuters'
default['reuters-demo']['indexed_data_src'] = 'https://github.com/downloads/evolvingweb/ajax-solr/reuters_data.tar.gz'
default['reuters-demo']['port'] = '9090'

default['reuters-demo']['node_bin'] = '/usr/bin'
default['reuters-demo']['node_path'] = '/usr/lib/node_modules'
