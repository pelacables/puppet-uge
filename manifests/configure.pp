# == Class: uge::configure
#
# Class to configure uge package in $uge_root from sources (tarball).
# It also manages uge admin user if $manage_user is true
#
class uge::configure inherits uge {
  validate_absolute_path($uge::uge_root)
  validate_string($uge::version)
  validate_string($uge::uge_cluster_name)
  validate_bool($uge::manage_user)
  validate_bool($uge::manage_service)
  validate_string($uge::uge_admin_user)
  validate_string($uge::uge_admin_group)
  validate_string($uge::uge_admin_user_id)
  validate_string($uge::uge_admin_group_id)

  if ($uge::sge_request != undef) and ($uge::node_type == 'submit')  {
    $ensure_sge_request = 'present'
  }
  else {
    $ensure_sge_request = 'absent'
  }

  if ($uge::manage_service == true) and ($uge::node_type == 'execution')  {
    $ensure_init_file = 'present'
  }
  else {
    $ensure_init_file = 'absent'
  }

  # UGE conf files: bootstrap, settings, act_qmaster, settings.sh
  file {
    [ "${uge::uge_root}/${uge::uge_cell}/" , "${uge::uge_root}/${uge::uge_cell}/common" ] :
      ensure => directory,
      owner   => $uge::uge_admin_user,
      group   => $uge::uge_admin_group,
      mode    => '0755';
    "${uge::uge_root}/${uge::uge_cell}/common/act_qmaster" :
      ensure  => present,
      owner   => $uge::uge_admin_user,
      group   => $uge::uge_admin_group,
      mode    => '0644',
      content => $uge::uge_qmaster_name,
      require => File["${uge::uge_root}/${uge::uge_cell}/common"];
    "${uge::uge_root}/${uge::uge_cell}/common/bootstrap" :
      ensure  => present,
      owner   => $uge::uge_admin_user,
      group   => $uge::uge_admin_group,
      mode    => '0644',
      content => template('uge/client/bootstrap.erb'),
      require => File["${uge::uge_root}/${uge::uge_cell}/common"];
    "${uge::uge_root}/${uge::uge_cell}/common/settings.sh" :
      ensure  => present,
      owner   => $uge::uge_admin_user,
      group   => $uge::uge_admin_group,
      mode    => '0644',
      content => template('uge/client/settings.sh.erb'),
      require => File["${uge::uge_root}/${uge::uge_cell}/common"];
    '/etc/profile.d/uge_settings.sh' :
      ensure  => link,
      target  => "${uge::uge_root}/${uge::uge_cell}/common/settings.sh",
      require => File["${uge::uge_root}/${uge::uge_cell}/common/settings.sh"];
    "/etc/init.d/sgeexecd.${uge::uge_cluster_name}" :
      ensure  => $ensure_init_file,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('uge/client/sgeexecd.erb');
    "${uge::uge_root}/${uge::uge_cell}/common/sge_request" :
      ensure  => $ensure_sge_request,
      owner   => $uge::uge_admin_user,
      group   => $uge::uge_admin_group,
      mode    => '0644',
      content => template('uge/client/sge_request.erb');
  }
}
