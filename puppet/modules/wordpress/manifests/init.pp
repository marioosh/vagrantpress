# Install latest Wordpress

class wordpress::install {


# Create the Wordpress database
exec { 'create-database':
  unless  => "/usr/bin/mysql -u root -pvagrant ${db_name}",
  command => "/usr/bin/mysql -u root -pvagrant --execute=\'create database ${db_name}\'",
}

exec { 'create-user':
  unless  => "/usr/bin/mysql -u ${db_user} -p${db_password} ${db_name}",
  command => "/usr/bin/mysql -u root -pvagrant --execute=\"GRANT ALL PRIVILEGES ON ${db_name}.* TO \'${db_user}\'@\'localhost\' IDENTIFIED BY \'${db_password}\'\"",
}

# Get a new copy of the latest wordpress release
# FILE TO DOWNLOAD: http://wordpress.org/latest.tar.gz

exec { 'download-wordpress': #tee hee
  command => "/usr/bin/wget ${wordpress_file_url}/${wordpress_file_name}",
  cwd     => '/vagrant/',
  creates => "/vagrant/${wordpress_file_name}"
}

exec { 'untar-wordpress':
  cwd     => '/vagrant/',
  command => "/bin/tar xzvf /vagrant/${wordpress_file_name}",
  require => Exec['download-wordpress'],
  creates => '/vagrant/wordpress',
}

# Import a MySQL database for a basic wordpress site.
file { '/tmp/wordpress-db.sql':
  source => 'puppet:///modules/wordpress/wordpress-db.sql'
}

exec { 'load-db':
  command => "/usr/bin/mysql -u ${db_user} -p${db_password} ${db_name} < /tmp/wordpress-db.sql && touch /home/vagrant/db-created",
  creates => '/home/vagrant/db-created',
}

# Copy a working wp-config.php file for the vagrant setup.
file { '/vagrant/wordpress/wp-config.php':
  content => template('wordpress/wp-config.php')
}

# Create the Wordpress Unit Tests database
exec { 'create-tests-database':
  unless  => '/usr/bin/mysql -u root -pvagrant wp_tests',
  command => '/usr/bin/mysql -u root -pvagrant --execute=\'create database wp_tests\'',
}

exec { 'create-tests-user':
  unless  => '/usr/bin/mysql -u wordpress -pwordpress',
  command => '/usr/bin/mysql -u root -pvagrant --execute="GRANT ALL PRIVILEGES ON wp_tests.* TO \'wordpress\'@\'localhost\' IDENTIFIED BY \'wordpress\'"',
}

# Copy a working wp-tests-config.php file for the vagrant setup.
file { '/vagrant/wordpress/wp-tests-config.php':
  source => 'puppet:///modules/wordpress/wp-tests-config.php'
}
}
