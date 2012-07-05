node postgres-server {
  include postgres
}

node dupont inherits postgres-server {
  postgres::cluster {
    'cluster':
      other_node_ip        => '192.168.142.32',
      listen               => '192.168.142.30',
      max_connections      => '100',
      shared_buffers       => '120MB',
      work_mem             => '3MB',
      effective_cache_size => '352MB',
  }
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
}
