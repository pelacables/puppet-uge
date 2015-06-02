# == Class: uge::install
#
# Class to install uge package in $uge_root from sources (tarball).
# It also manages uge admin user if $manage_user is true
#
class uge::install {
  validate_absolute_path($uge::uge_root)
  validate_string($uge::version)
  validate_string($uge::uge_cluster_name)
  validate_string($uge::uge_cell)
  validate_bool($uge::manage_user)
  validate_bool($uge::manage_service)
  validate_string($uge::uge_admin_user)
  validate_string($uge::uge_admin_group)
  validate_string($uge::uge_admin_group_id)
  validate_string($uge::uge_admin_user_id)

  if ($uge::manage_user) {
    include uge::user
  }
  #Extract tarball in uge_root
  file { $uge::uge_root :
    ensure => 'directory',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  archive {
    "ge-${uge::version}-common" :
      ensure   => present,
      url      => "${uge::package_source}/ge-${uge::version}-common.tar.gz",
      checksum => false,
      target   => $uge::uge_root,
      root_dir => '/',
      require  => File[$uge::uge_root];
    "ge-${uge::version}-bin-${uge::uge_arch}" :
      ensure   => present,
      url      => "${uge::package_source}/ge-${uge::version}-bin-${uge::uge_arch}.tar.gz",
      checksum => false,
      target   => $uge::uge_root,
      root_dir => '/',
      require  => File[$uge::uge_root];
  }

  exec { 'fix_uge_perms' :
    command     => "/bin/bash ${uge::uge_root}/util/setfileperm.sh -auto ${uge::uge_root}",
    cwd         => $uge::uge_root,
    environment => "SGE_ROOT=${uge::uge_root}",
    subscribe   => Archive["ge-${uge::version}-common"],
    refreshonly => true,
  }

}
