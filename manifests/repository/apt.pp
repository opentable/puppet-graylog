class graylog::repository::apt(
  $url,
  $release,
  $version,
) {
  $gpg_file = '/etc/apt/trusted.gpg.d/graylog-keyring.gpg'

  file { $gpg_file:
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
    source => 'puppet:///modules/graylog/graylog-keyring.gpg',
    notify => Exec['apt_update'],
  }

  package {'apt-transport-https':
    ensure => 'installed',
  }

  apt::source { 'graylog':
    comment  => 'The official Graylog package repository',
    location => $url,
    release  => $release,
    repos    => $version,
    include  => {
      'deb' => true,
      'src' => false,
    },
    require  => [
      File[$gpg_file],
    ],
  }
}
