# == Class: uge::user
#
# Class that add ugeadmin user /group
#
class uge::user {
  validate_string($uge::uge_admin_user)
  validate_string($uge::uge_admin_group)
  validate_string($uge::uge_admin_user_id)
  validate_string($uge::uge_admin_group_id)

  user { $uge::uge_admin_user :
    ensure     => 'present',
    uid        => $uge::uge_admin_user_id,
    home       => $uge::uge_root,
    managehome => false,
    gid        => $uge::uge_admin_group_id,
    provider   => $uge::params::user_provider,
    require    => Group[$uge::uge_admin_group];
  }
  group { $uge::uge_admin_group :
    ensure   => 'present',
    provider => $uge::params::group_provider,
    gid      => $uge::uge_admin_group_id,
  }

}
