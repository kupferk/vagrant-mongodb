# This puppet file simply installs the required packages for provisioning and gets the base 
# provisioning from the correct repos. The VM can then provision itself from there. 

package {puppet:ensure=> [latest,installed]}
package {ruby:ensure=> [latest,installed]}

$datadir = '/var/lib/mongodb'
$logdir = '/var/log/mongodb'
$logfile = '/var/log/mongodb/mongo.log'

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

file {$logdir:
  ensure => directory,
  owner => 'mongodb',
  group => 'mongodb',
  mode => '0755'
}->
class {'::mongodb::globals':
  manage_package_repo => true,
  user => 'mongodb',
  group => 'mongodb',
  bind_ip => ['0.0.0.0'],
  require => User['mongodb']
}->
class {'::mongodb::server': 
  ensure => present,
  logpath => $logfle,
  dbpath => $datadir,
  diaglog => 7,
  verbose => true

}->
class {'::mongodb::client': }

