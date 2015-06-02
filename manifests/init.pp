# == Class: uge
#
# Module for install UGE 8.X and configure the node as submit/computing node.
#
# === Parameters
#
# [*version*]
#   UGE version. Only tested in major version 8. (default to 8.2.1)
# [*uge_root*]
#   Base directory of the Univa Grid Engine installation. (default to /usr/share/univage/)
# [*uge_cell*]
#   Name of the Univa Grid Engine cell to be installed. (Default to default)
# [*uge_cluster_name*]
#   Name of the Univa Grid Engine cluster to be installed. (Default to cluster1)
# [*uge_qmaster_port*]
#   Port number for the sge_qmaster daemon. (default to 6444)
# [*uge_execd_port*]
#   Port number for the sge_execd daemon. (default to 6445)
# [*uge_qmaster_name*]
#   FQDN of the node running as master host. (default to masterhost)
# [*manage_user*]
#   Attemp to create UGE admin user. (default to true)
# [*uge_admin_user*]
#   Username for the UGE admin user. (default to ugeadmin)
# [*uge_admin_user_id*]
#   uid for the username of the UGE admin user. (default to 398)
# [*uge_admin_group*]
#   Groupname for the UGE admin user. (default to ugeadmin)
# [*uge_admin_group_id*]
#   gid for the groupname of the UGE admin user. (default to 399)
# [*uge_arch*]
#   arch for the binaries of the UGE. (default to lx-amd64)
# [*manage_service*]
#   Attempt to install init.d script and configure sgeexecd as system service. (default to true)
# [*package_source*]
#   Source for the UGE packages. It must be a URL (http/ftp).
# [*sge_request*]
#   Array of parameters for creating a system sge_request. (default to undef)
# [*uge_node_type*]
#   UGE node type of the target node. (default to execution. Only submit/execution supported).
# === Examples
#
#  class { 'uge':
#    version  => '8.2.1',
#    uge_root => '/usr/local/uge',
#    uge_cell => 'mycell',
#  }
#
# === Authors
#
# Arnau Bria. arnau.bria at gmail.com
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class uge (
  $version            = $uge::params::version,
  $uge_root           = $uge::params::uge_root,
  $uge_cell           = $uge::params::uge_cell,
  $uge_cluster_name   = $uge::params::uge_cluster_name,
  $uge_qmaster_port   = $uge::params::uge_qmaster_port,
  $uge_execd_port     = $uge::params::uge_execd_port,
  $uge_qmaster_name   = $uge::params::uge_qmaster_name,
  $manage_user        = $uge::params::manage_user,
  $uge_admin_user     = $uge::params::uge_admin_user,
  $uge_admin_user_id  = $uge::params::uge_admin_user_id,
  $uge_admin_group    = $uge::params::uge_admin_group,
  $uge_admin_group_id = $uge::params::uge_admin_group_id,
  $uge_arch           = $uge::params::uge_arch,
  $manage_service     = $uge::params::manage_service,
  $package_source     = $uge::params::package_source,
  $node_type          = $uge::params::uge_node_type,
  $sge_request        = $uge::params::sge_request
) inherits uge::params {

  validate_string($version)
  validate_string($uge_cluster_name)
  validate_string($uge_cell)
  validate_string($uge_qmaster_name)
  validate_re($::osfamily, 'RedHat', 'This module only works on RedHat based systems')
  validate_bool($manage_user)
  validate_bool($manage_service)
  if ($sge_request) {
    validate_array($sge_request)
  }
  
  class { 'uge::install' : } ->
  class { 'uge::configure' : } ~>
  class { 'uge::service' : }
  contain 'uge::install'
  contain 'uge::configure'
  contain 'uge::service'

}
