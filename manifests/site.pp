node postgres-server {
  include postgres
  include site

  class {
    'cluster':
      cluster_bind_interface => 'eth1',
      cluster_mcastaddr      => '226.94.1.1',
  }

  include site::sshkeys

  Class['site'] -> Class['cluster']
  Postgres::Cluster['cluster'] -> Class['cluster']

}
node dupont inherits postgres-server {
  postgres::initdb { 'initdb': }
  postgres::cluster {
    'cluster':
      other_node_ip        => '192.168.142.32',
      listen               => '192.168.142.30',
      max_connections      => '100',
      shared_buffers       => '120MB',
      work_mem             => '3MB',
      effective_cache_size => '352MB',
  }
  Class['postgres'] -> Postgres::Initdb['initdb'] -> Postgres::Cluster['cluster']
}

node dupond inherits postgres-server {
  postgres::cluster {
    'cluster':
      other_node_ip        => '192.168.142.31',
      listen               => '192.168.142.30',
      max_connections      => '100',
      shared_buffers       => '120MB',
      work_mem             => '3MB',
      effective_cache_size => '352MB',
  }
  Class['postgres'] -> Postgres::Cluster['cluster']
  include postgres::firstsync

  Class['cluster'] -> Class['postgres::firstsync']
}
