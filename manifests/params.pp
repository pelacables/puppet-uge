# == Class: uge::params
#
# Default parameter values for the UGE module
#
class uge::params {
  $version             = '8.2.1'
  $uge_root            = '/usr/share/univage/'
  $uge_cell            = 'default'
  $uge_cluster_name    = 'cluster1'
  $uge_qmaster_port    = '6444'
  $uge_execd_port      = '6445'
  $uge_qmaster_name    = 'mastehost'
  $manage_user         = true
  $uge_admin_user      = 'ugeadmin'
  $uge_admin_user_id   = '398'
  $uge_admin_group_id  = '399'
  $uge_admin_group     = 'ugeadmin'
  $uge_arch            = 'lx-amd64'
  $manage_service      = true
  $package_source      = 'ftp://ugepackagesource.example.com/'
  $sge_request         = undef
  $uge_node_type       = 'execution'

  case $::osfamily {
    'RedHat' : {
      $user_provider  = 'useradd'
      $group_provider = 'groupadd'
    }
    default : {
      $user_provider  = 'useradd'
      $group_provider = 'groupadd'
    }
  }


}
