# == Class consul_template::params
#
# This class is meant to be called from consul_template.
# It sets variables according to platform.
#
class consul_template::params {

  $install_method    = 'url'
  $package_name      = 'consul-template'
  $package_ensure    = 'latest'
  $version           = '0.6.0'

  case $::architecture {
    'x86_64', 'amd64': { $arch = 'amd64' }
    'i386':            { $arch = '386'   }
    default:           { fail("Unsupported kernel architecture: ${::architecture}") }
  }

  $os = downcase($::kernel)

  $init_style = $::operatingsystem ? {
    'Ubuntu'           => $::lsbdistrelease ? {
      '8.04'           => 'debian',
      /(10|12|14)\.04/ => 'upstart',
      default          => undef
    },
    /CentOS|RedHat/    => $::operatingsystemmajrelease ? {
      /(4|5|6)/        => 'init',
      default          => 'systemd',
    },
    'Fedora'           => $::operatingsystemmajrelease ? {
      /(12|13|14)/     => 'init',
      default          => 'systemd',
    },
    'Debian'           => 'debian',
    default            => 'init'
  }
}
