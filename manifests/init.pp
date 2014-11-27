# == Class: softec_rsync
#
# This module manages rsync for sparse file
#
# === Authors
#
# Author Name <lorenzo.cocchi@softecspa.it>
#

class softec_rsync(
  $package_ensure = 'present'
) {

  package { 'rsync':
    ensure => $package_ensure,
  } -> Softec_rsync::Get_sparse<| |>
}
