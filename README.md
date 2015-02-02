knife-axe
=========
knife axe prints diff of objects (environment,data_bag,role) before uploading them.

![](https://raw.githubusercontent.com/faja/images/master/knife-axe/knife-axe.png)

### Installation:

```
$ gem install knife-axe
```
or
```
$ cp axe*.rb ~/.chef/plugins/knife
```

### Usage:
```
$ knife axe role ~/chef-repo/role/role42.rb
$ knife axe env ~/chef-repo/environments/environment42.rb
$ knife axe data bag databagname ~/chef-repo/data_bags/databagname/item42.rb
```

