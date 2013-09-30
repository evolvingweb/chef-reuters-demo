#
# Cookbook Name:: reuters-demo
# Recipe::        default
# 

# update apt repositories
include_recipe 'apt'

include_recipe 'drupal-solr::install_solr'

data_filename = node['reuters-demo']['project_root'] + "/reuters_data.tar.gz"
remote_file "reuters-data" do
  owner node['tomcat']['user']
  group node['tomcat']['group']
  source node['reuters-demo']['indexed_data_src']
  path data_filename
  action :create_if_missing
end

bash "install-reuters-data" do
  user node['tomcat']['user']
  cwd node['drupal-solr']['home_dir']
  code <<-EOH
    tar -zxf #{data_filename} data 
  EOH
  creates node['drupal-solr']['home_dir']+ '/data'
  notifies :restart, 'service[tomcat]'
end

%w{schema.xml solrconfig.xml stopwords.txt}.each do |f|
  cookbook_file f do
    path "#{node['drupal-solr']['home_dir']}/conf/#{f}"
    owner node['tomcat']['user']
    group node['tomcat']['group']
    mode 0775
  end
end

untarred_solr_path = "#{node['drupal-solr']['war_dir']}/apache-solr-#{node['drupal-solr']['solr_version']}"
execute "copy-velocity-jar-files" do
  user node['tomcat']['user']
  cwd untarred_solr_path
  command "cp -Rf contrib/velocity/src/main/solr/lib/. #{node['drupal-solr']['home_dir']}/lib"
  creates node['drupal-solr']['home_dir'] + "/lib/apache-solr-velocity-#{node['drupal-solr']['solr_version']}.jar"
  notifies :restart, 'service[tomcat]'
end

include_recipe 'reuters-demo::solr_proxy'
