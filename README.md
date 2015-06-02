# uge

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with uge](#setup)
    * [What uge affects](#what-uge-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with uge](#beginning-with-uge)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Puppet module that installs and configures UGE 8.X in a submit or execution host.
It has been tested in Scientific Linux 6.5 and Puppet 3.7

## Module Description

The module downloads UGE source package from your local repository and installs
it in SGE_ROOT. It accepts two different UGE nodes: execution/submit.

If desired, it also configures sge_execd service (only in a execution host), adds 
uge admin user and sge_request (if defined) in the submission host.

### Dependencies

* `archive` type is provided by 'camptocamp-archive'.

## Setup

### What uge affects

* Install everything under SGE_ROOT
* Adds /etc/init.d/sgeexecd.$SGE_CELL (if execution host)
* Adds $SGE_ROOT/$SGE_CELL/common/sge_Request (if sge_request defined and 
  the node is a submit host)
* Adds uge admin user
 
### Beginning with uge

UGE sources must be downloaded from `uge::package_source` . If not provided, 
the module aborts.

## Usage

```puppet
class { 'uge' :
  package_source => 'http://my_private_url.exemple.com',
}
```

Or if you use hiera:

```puppet
 classes:
   - '::uge'
 uge::version: '8.2.1'
 uge::uge_root: '/usr/share/univage/'
 uge::uge_cell: 'mycell'
 uge::uge_cluster_name: 'mycluster'
 uge::uge_qmaster_port: '7454'
 uge::uge_execd_port: '7445'
 uge::uge_qmaster_name: 'master_nomde.example.com'
 uge::manage_user: true
 uge::uge_admin_user: 'ugeadmin'
 uge::uge_admin_user_id: '398'
 uge::uge_admin_group: 'ugeadmin'
 uge::uge_admin_group_id: '399'
 uge::uge_arch: 'lx-amd64'
 uge::manage_service: true
 uge::node_type: 'submit'
 uge::package_source: 'http://repositorios.linux.crg.es/crg-local/src/'
 uge::sge_request:
  - '-w w'
  - '-q short'
  - '-l h_vmem=4G,h_rt=6:00:00'
  - '-v _JAVA_OPTIONS=-Xmx3276M'
```



## Reference

###Classes

####Public Classes

* iuge: Main class, includes all other classes.

####Private Classes

* uge::install: Installs UGE from sources
* uge::params: Sets defaults for all the parameters
* uge::configure: Modifies all configuration files
* uge::service: Handles the service.
* uge::user: Handles the user creation.

###Parameters

The following parameters are available in the uge  module:

####`config_template`
####`version`

UGE version. Only tested in major version 8. (default to 8.2.1)

####`uge_root`

Base directory of the Univa Grid Engine installation. (default to /usr/share/univage/)

####`uge_cell`

Name of the Univa Grid Engine cell to be installed. (Default to default)

####`uge_cluster_name`

Name of the Univa Grid Engine cluster to be installed. (Default to cluster1)

####`uge_qmaster_port`

Port number for the sge_qmaster daemon. (default to 6444)

####`uge_execd_port`

Port number for the sge_execd daemon. (default to 6445)

####`uge_qmaster_name`

FQDN of the node running as master host. (default to masterhost)

####`manage_user`

Attemp to create UGE admin user. (default to true)

####`uge_admin_user`

Username for the UGE admin user. (default to ugeadmin)

####`uge_admin_user_id`

uid for the username of the UGE admin user. (default to 398)

####`uge_admin_group`

Groupname for the UGE admin user. (default to ugeadmin)

####`uge_admin_group_id`

gid for the groupname of the UGE admin user. (default to 399)

####`uge_arch`

arch for the binaries of the UGE. (default to lx-amd64)

####`manage_service`

Attempt to install init.d script and configure sgeexecd as system service. (default to true)

####`package_source`

Source for the UGE packages. It must be a URL (http/ftp).

####`sge_request`

Array of parameters for creating a system sge_request. (default to undef)

####`uge_node_type`

UGE node type of the target node. (default to execution. Only submit/execution supported).


## Limitations

This module has been built on and tested against Puppet 3 and Scientific Linux 6.5.
It should work in any RedHat 6.X like OS.

## Development

If you want to contribute, fork the repo, create a branch with your fix/patch, commit, push the branch and open  Pull Request.
