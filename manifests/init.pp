class confluencewiki (
  $uid                           = 8999,
  $gid                           = 8999,
  $group_present                 = 'present',
  $groupname                     = 'confluence',
  $groups                        = [],
  $service_ensure                = 'running',
  $service_name                  = 'confluence',
  $shell                         = '/bin/bash',
  $user_present                  = 'present',
  $username                      = 'confluence',

  # override below in yaml
  $confluence_version            = '',
  $mysql_connector_version       = '',
  $parent_dir,
  $server_port                   = '',
  $connector_port                = '',
  $context_path                  = '',
  $docroot                       = '',
  $server_alias                  = '',
  $heap_min_size                 = '',
  $heap_max_size                 = '',
  # Below setting replaces PermGen (jdk8), uses native memory for class metadata.
  # If not set resizes according to available native memory.
  $maxmetaspacesize              = '',

  # below should be contained in eyaml
  $confluence_license_hash       = '',
  $confluence_license_message    = '',
  $confluence_setup_server_id    = '',
  $hibernate_connection_password = '',
  $hibernate_connection_username = '',
  $hibernate_connection_url      = '',

  $required_packages             = ['graphviz' , 'graphviz-dev'],
){

# install required packages:
  package {
    $required_packages:
      ensure => 'present',
  }

# confluence specific
  $mysql_connector          = "mysql-connector-java-${mysql_connector_version}.jar" # lint:ignore:80chars
  $mysql_connector_dest_dir = "${parent_dir}/current/confluence/WEB-INF/lib"
  $confluence_build         = "atlassian-confluence-${confluence_version}"
  $tarball                  = "${confluence_build}.tar.gz"
  $download_dir             = '/tmp'
  $downloaded_tarball       = "${download_dir}/${tarball}"
  $download_url             = "http://www.atlassian.com/software/confluence/downloads/binary/${tarball}"
  $install_dir              = "${parent_dir}/${confluence_build}"
  $confluence_home          = "${parent_dir}/confluence-data"
  $current_dir              = "${parent_dir}/current"

  user {
    $username:
      ensure     => $user_present,
      name       => $username,
      home       => "/home/${username}",
      shell      => $shell,
      uid        => $uid,
      gid        => $groupname,
      groups     => $groups,
      managehome => true,
      require    => Group[$groupname],
  }

  group {
    $groupname:
      ensure => $group_present,
      name   => $groupname,
      gid    => $gid,
  }

# download standalone Confluence
  exec {
    'download-confluence':
      command => "/usr/bin/wget -O ${downloaded_tarball} ${download_url}",
      creates => $downloaded_tarball,
      timeout => 1200,
  }

  file { $downloaded_tarball:
    ensure  => file,
    require => Exec['download-confluence'],
  }

# extract the download and move it
  exec {
    'extract-confluence':
      command => "/bin/tar -xvzf ${tarball} && mv ${confluence_build} ${parent_dir}", # lint:ignore:80chars
      cwd     => $download_dir,
      user    => 'root',
      creates => "${install_dir}/NOTICE",
      timeout => 1200,
      require => [File[$downloaded_tarball],File[$parent_dir]],
  }

  exec {
    'chown-confluence-dirs':
      command => "/bin/chown -R ${username}:${username} ${install_dir}/logs ${install_dir}/temp ${install_dir}/work", # lint:ignore:80chars
      timeout => 1200,
      require => [User[$username],Group[$username]],
  }

  exec {
    'check_cfg_exists':
      command => '/bin/true',
      onlyif  => "/usr/bin/test -e ${confluence_home}/confluence.cfg.xml",
  }

  file {
    $parent_dir:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755';
    $confluence_home:
      ensure  => directory,
      owner   => 'confluence',
      group   => 'confluence',
      mode    => '0755',
      require => File[$install_dir];
    $install_dir:
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      require => Exec['extract-confluence'];
    $current_dir:
      ensure  => link,
      target  => $install_dir,
      owner   => 'root',
      group   => 'root',
      require => File[$install_dir];
    "${install_dir}/confluence/WEB-INF/classes/confluence-init.properties":
      content => template('confluencewiki/confluence-init.properties.erb'),
      mode    => '0644';
    "${install_dir}/conf/server.xml":
      content => template('confluencewiki/server.xml.erb'),
      mode    => '0644';
    "${install_dir}/bin/setenv.sh":
      content => template('confluencewiki/setenv.sh.erb'),
      mode    => '0644';
    "${confluence_home}/confluence.cfg.xml":
      content => template('confluencewiki/confluence.cfg.xml.erb'),
      owner   => 'confluence',
      group   => 'confluence',
      mode    => '0644',
      require => Exec['check_cfg_exists'],
      notify  => Service[$service_name];
    "${mysql_connector_dest_dir}/${mysql_connector}":
      ensure => present,
      source => "puppet:///modules/confluencewiki/${mysql_connector}";
    "/etc/init.d/${service_name}":
      mode    => '0755',
      owner   => 'root',
      group   => 'root',
      content => template('confluencewiki/confluence-init-script.erb');
  }

  service {
    $service_name:
      ensure     => $service_ensure,
      enable     => true,
      hasstatus  => false,
      hasrestart => true,
      require    => Class['apache'],
  }

}
