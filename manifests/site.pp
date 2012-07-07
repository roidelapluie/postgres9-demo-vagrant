node postgres-server {
  include postgres
  include site

  class {
    'cluster':
      cluster_bind_interface => 'eth1',
      cluster_mcastaddr      => '226.94.1.1',
  }
  postgres::hba {
    $::fqdn:
      password     => 'yes',
      allowedrules => [
        "host    all all    $::ipaddress/32  password",
        'hostnossl replication replicuser  192.168.142.31/24  trust',
        'hostnossl replication replicuser  192.168.142.32/24  trust',
        'hostnossl    all all    192.168.142.0/24  password',
      ]
  }


  include site::sshkeys

  Postgres::Cluster[$::fqdn] -> Class['cluster']

}
node dupont inherits postgres-server {
  postgres::initdb {
    $::fqdn:
      password => 'rmll2012',
  }
  postgres::cluster {
    $::fqdn:
      other_node_ip        => '192.168.142.32',
      listen               => '*',
      max_connections      => '100',
      shared_buffers       => '120MB',
      work_mem             => '3MB',
      effective_cache_size => '352MB',
  }
  Class['postgres'] -> Postgres::Initdb[$::fqdn] -> Postgres::Cluster[$::fqdn]
  Class['site'] -> Postgres::Hba[$::fqdn] -> Class['cluster']

  Postgres::Initdb[$::fqdn] -> Postgres::Hba[$::fqdn]
}

node dupond inherits postgres-server {
  postgres::cluster {
    $::fqdn:
      other_node_ip        => '192.168.142.31',
      listen               => '*',
      max_connections      => '100',
      shared_buffers       => '120MB',
      work_mem             => '3MB',
      effective_cache_size => '352MB',
  }
  Class['postgres'] -> Postgres::Cluster[$::fqdn]
  class {
    'postgres::firstsync':
      remotehost => 'dupont',
      password   => 'rmll2012',
  }
  exec {
    '/bin/sleep 10':
      refreshonly => true,
      subscribe   => Exec['load_crm_config'],
  }
  postgres::createuser {
    'tintin':
      password => 'rmll2012',
      host     => '192.168.142.30',
      passwd   => 'milou',
      require  => Exec['/bin/sleep 10'],
  }
  postgres::createdb {
    'moulinsart':
      password => 'rmll2012',
      host     => '192.168.142.30',
      owner    => 'tintin',
      require  => [Exec['/bin/sleep 10'],Postgres::Createuser['tintin']],
  }
  postgres::createsuperuser {
    'replicuser':
      password => 'rmll2012',
      host     => '192.168.142.30',
      passwd   => 'icanhazapassword',
      require  => Exec['/bin/sleep 10'],
  }
  exec {
    'crm node online dupond.demo':
      refreshonly => true,
      path        => $::path,
      subscribe   => Exec['load_crm_config'],
      require     => Exec['/bin/sleep 10'],
  }
  Class['site'] -> Class['cluster'] -> Class['postgres::firstsync']
  Class['postgres::firstsync'] -> Postgres::Hba[$::fqdn]
  Class['cluster'] -> Exec['/bin/sleep 10'] -> Class['postgres::firstsync']
}
