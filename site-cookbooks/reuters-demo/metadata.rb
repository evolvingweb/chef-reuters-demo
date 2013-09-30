name             'reuters-demo'
maintainer       'Amir Kadivar'
maintainer_email 'amir@evolvingweb.ca'
description      'configures a secure solr instance serving reuters data'
version          '0.0.1'

%w{ ubuntu }.each do |os|
  supports os
end

depends 'drupal-solr'
depends 'tomcat'
depends 'apt'
depends 'build-essential'
