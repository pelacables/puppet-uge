# == Class: uge::configure
#
# Class to configure uge package in $uge_root from sources (tarball).
# It also manages uge admin user if $manage_user is true
#
class uge::service {
  validate_absolute_path($uge::uge_root)
  validate_string($uge::version)
  validate_string($uge::uge_cluster_name)
  validate_bool($uge::manage_user)
  validate_bool($uge::manage_service)
  validate_string($uge::uge_admin_user)
  validate_string($uge::uge_admin_group)
  validate_string($uge::uge_admin_user_id)
  validate_string($uge::uge_admin_group_id)
  
  if ($uge::manage_service == true) and ($uge::node_type == 'execution')  {
    $execd_ensure = 'running'
    $execd_enable = true
  }
  else {
    $execd_ensure = 'stopped'
    $execd_enable = false
  }

  service {
    "sgeexecd.${uge::uge_cluster_name}" :
      ensure    => $execd_ensure,
      enable    => $execd_enable,
      hasstatus => false,
  }

}
