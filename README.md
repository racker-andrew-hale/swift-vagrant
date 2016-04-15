Swift Vagrant
=============

OpenStack Object Storage (swift) setup for Vagrant using multiple VMs.

The goal of this project is to create an evnironment that better mimics how a production setup might be, while trying to remain small/simple.  (Mostly for developemnt/testing purposes)

Since this creates mutliple VMs, it is recommended you use a system with plenty of resources.   I am using a Intel i7 with 16 GB of RAM.

* 1 Load Balancer
* 2 Proxy (memcache)
* 4 Storage (account/container/object)
