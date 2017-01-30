class opendaylight::quagga (
){
  firewall {'215 quagga':
    dport  => 179,
    proto  => 'tcp',
    action => 'accept',
  }

  $service_file = '/etc/systemd/system/zrpcd.service'
  file { $service_file:
    ensure  => file,
    content => template('opendaylight/zrpcd.service'),
  }

  if $::operatingsystem == 'Ubuntu' {
    exec { 'install_quagga':
      command => "sh /etc/fuel/plugins/opendaylight-1.0/install_quagga.sh",
      path    => '/usr/bin:/usr/sbin:/bin:/sbin',
      timeout => 0,
      require => File[$service_file],
      before  => Service['zrpcd']
    }

    service {'zrpcd':
      ensure => running
    }
  }
}
