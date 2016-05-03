Swift Vagrant
=============

OpenStack Object Storage (swift) setup for Vagrant using multiple VMs.

The goal of this project is to create an environment that better mimics how a production setup might be, while still trying to remain small/simple.

By default, the environment will contain:

* 1 Load Balancer
* 2 Proxy nodes (w/ memcache)
* 4 Storage nodes (w/ account/container/object)

Since this creates multiple VMs, it is recommended you use a system with plenty of resources.   I am using a Intel i7 with 16 GB of RAM.

Setup
-----

First install the only python dependency

```shell
$ pip install pyyaml
```

Once that is installed, you can run the config script

```shell
$ ./config
generating local.yaml, leave blank to use the default value.

network (10.0.0):
host_port (8080):
proxy count (2):
storage count (4):
```

If you don't want to install pyyaml, you could manually create a local.yaml file similar to the following:

```shell
$ cat local.yaml
general:
  network: 10.0.0
lb:
  host_port: 8080
proxy:
  count: 2
storage:
  count: 4
```

Now run Vagrant
```shell
$ vagrant up
Bringing machine 'lb1' up with 'virtualbox' provider...
Bringing machine 'proxy-z1' up with 'virtualbox' provider...
Bringing machine 'proxy-z2' up with 'virtualbox' provider...
Bringing machine 'storage-z1' up with 'virtualbox' provider...
Bringing machine 'storage-z2' up with 'virtualbox' provider...
Bringing machine 'storage-z3' up with 'virtualbox' provider...
Bringing machine 'storage-z4' up with 'virtualbox' provider...
...
```

Remaining Work
--------------

* TODO: Get initial environment running.
* TODO: Add option to run hummingbird.
* TODO: Add keystone node for authentication.
* TODO: Add (optional) graphite node.
* TODO: Add (optional) horizon node.
