# Definition: softec_rsync::get_sparse
#
# get "sparse" files via softec_rsync
#
# Parameters:
#   $source  - source to copy from
#   $path    - path to copy to, defaults to $name
#   $user    - username on remote system
#   $purge   - if set, rsync will use '--delete'
#   $exlude  - string to be excluded
#   $keyfile - path to ssh key used to connect to remote host, defaults to /home/${user}/.ssh/id_rsa
#   $timeout - timeout in seconds, defaults to 900
#   $bwlimit - limit I/O bandwidth; KBytes per second
#
# Actions:
#   get files via rsync
#
# Requires:
#   $source must be set
#
# Sample Usage:
#
# softec_rsync::get_sparse { '/root/file.sparse':
#   user    => 'root',
#   keyfile => '/root/.ssh/id_rsa',
#   source  => 'puppetmaster.vagrant.local:/root/file.sparse',
# }
#
define softec_rsync::get_sparse (
  $source,
  $path       = $name,
  $user       = undef,
  $purge      = undef,
  $recursive  = undef,
  $links      = undef,
  $hardlinks  = undef,
  $copylinks  = undef,
  $times      = undef,
  $include    = undef,
  $exclude    = undef,
  $keyfile    = undef,
  $timeout    = '900',
  $execuser   = 'root',
  $chown      = undef,
  $bwlimit    = undef,
) {

  if $keyfile {
    $mykeyfile = $keyfile
  } else {
    $mykeyfile = "/home/${user}/.ssh/id_rsa"
  }

  if $user {
    $myUser = "-e \'ssh -i ${mykeyfile} -l ${user}\' ${user}@"
  }

  if $purge {
    $myPurge = ' --delete'
  }

  # Not currently correct, there can be multiple --exclude arguments
  if $exclude {
    $myExclude = " --exclude=${exclude}"
  }

  # Not currently correct, there can be multiple --include arguments
  if $include {
    $myInclude = " --include=${include}"
  }

  if $recursive {
    $myRecursive = ' -r'
  }

  if $links {
    $myLinks = ' --links'
  }

  if $hardlinks {
    $myHardLinks = ' --hard-links'
  }

  if $copylinks {
    $myCopyLinks = ' --copy-links'
  }

  if $times {
    $myTimes = ' --times'
  }

  if $chown {
    $myChown = " --chown=${chown}"
  }

  if $bwlimit {
    $myBwLimit = " --bwlimit=${bwlimit}"
  }

  $rsync_options = "-a${myPurge}${myExclude}${myInclude}${myLinks}${myHardLinks}${myCopyLinks}${myTimes}${myRecursive}${myChown}${myBwLimit} ${myUser}${source} ${path}"

  exec { "rsync_inplace ${name}":
    command => "rsync -q --inplace ${rsync_options}",
    path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    user    => $execuser,
    onlyif  => "test -f ${path}",
    timeout => $timeout,
  } ->

  exec { "rsync_sparse ${name}":
    command => "rsync -q --sparse ${rsync_options}",
    path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    user    => $execuser,
    unless  => "test -f ${path}",
    timeout => $timeout,
  }

}
