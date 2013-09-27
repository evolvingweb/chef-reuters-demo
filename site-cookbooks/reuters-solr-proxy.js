require('solr-security-proxy').start(9090,{validPaths: ['/reuters/select'], backend_port: 8080});
