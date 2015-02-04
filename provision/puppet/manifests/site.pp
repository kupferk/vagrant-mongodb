# This puppet file simply installs the required packages for provisioning and gets the base 
# provisioning from the correct repos. The VM can then provision itself from there. 

package {puppet:ensure=> [latest,installed]}
package {ruby:ensure=> [latest,installed]}

$datadir = '/var/lib/mongodb'
$logdir = '/var/log/mongodb'

group {'mongodb':
  ensure => present,
  system => true
}->
user {'mongodb':
  ensure => present,
  system => true,
  gid => 'mongodb',
  home => $datadir
}

file {$datadir:
  ensure => directory
  user => 'mongodb',
  group => 'mongodb',
  require => User['mongodb']
}
file {$logdir:
  ensure => directory
  user => 'mongodb',
  group => 'mongodb',
  require => User['mongodb']
}

class {'::mongodb::globals':
  manage_package_repo => true,
  user => 'mongodb',
  group => 'mongodb',
  require => User['mongodb']
}->
class {'::mongodb::server': 
  ensure => present,
  logpath => $logdir,
  dbpath => $datadir,
  require => [File[$logdir], File[$datadir]]
}->
class {'::mongodb::client': }

