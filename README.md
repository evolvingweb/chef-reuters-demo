This repository contains a cookbook that provisions a secure Solr Server 
(using [solr-security-proxy](http://github.com/dergachev/solr-security-proxy)
for the [AJAX-Solr](http://github.com/evolvingweb/ajax-solr)
[demo](http://evolvingweb.github.com/ajax-solr/examples/reuters/index.html).
This repository uses
[gusteau](https://github.com/locomote/gusteau) but the 
`reuters-demo` cookbook (to be found under `site-cookbooks`)
can be used in any way by Opscode Chef.

## To use with Vagrant:
The following assumes you have [vagrant 1.1+](http://docs.vagrantup.com/v2/installation/)
installed.
### install gusteau:

``` bash
vagrant plugin install gusteau
```
### provision Solr server:

``` bash
# inside the repo
vagrant up
gusteau converge production-box
```
After chef-solo is done, y
our Solr server can be accessed locally at `http://192.168.50.4:9090/reuters`
(you can change the private IP in your `Vagrantfile` and `.gusteau.yml`

## To provision a remote server:
### install gusteau
If you installed the vagrant-gusteau plugin you already have the gusteau gem available, if not:

``` bash
gem install gusteau
```
### define remote server
To provision a remote server you have to change `.gusteau.yml` to include your
remote server's IP (or domain name):

``` yaml
# in .gusteau.yml
  server:
    before: apt-get update && apt-get install -q -y curl
    host: fqdn.for.your.remote.server # <---
    user: root
```
If you user does not have its SSH public key recognized by the remote server,
you will need to provide gusteau with the root password of your server. This 
information will go in the same stanza as above:
``` yaml
# in .gusteau.yml
  server:
    before: apt-get update && apt-get install -q -y curl
    host: fqdn.for.your.remote.server
    user: root
    password: root.password.for.host # <---
```
### provision Solr server:

``` bash
# inside the repo
gusteau converge production-server --bootstrap
```
