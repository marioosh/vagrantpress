exec { 'apt_update':
  command => 'apt-get update',
  path    => '/usr/bin'
}

$db_user = 'wordpress'
$db_name = 'wordpress'
$db_password = 'wordpress'
#$wp_lang = 'pl_PL'
$wp_lang = ''
#$wordpress_file_url = "http://pl.wordpress.org"
$wordpress_file_url = "http://wordpress.org"
#$wordpress_file_name = "wordpress-3.8.1-pl_PL.tar.gz"
$wordpress_file_name = "latest.tar.gz"


class { 'git::install': }
class { 'subversion::install': }
class { 'apache2::install': }
class { 'php5::install': }
class { 'mysql::install': }
class { 'wordpress::install': }
class { 'phpmyadmin::install': }
class { 'phpqa::install': }
