
include apache
class{'php':
	 php_packages => ['php56w', 'php56w-mysqlnd', 'php56w-curl', 'php56w-gd', 'php56w-json', 'php56w-mhash', 'php56w-pecl-apcu', 'php56w-readline', 'php56w-pdo.x86_64', 'php56w-xml']
}

file {'/etc/service/apache':
	ensure => 'directory'
}

file {'/etc/service/apache/run':
	ensure 		=> 'present',
	mode 		=> '777',
	source 		=> 'file:///puppet/files/runit/service/apache-service'
}


file {'/usr/local/bin/composer':
        ensure          => 'present',
        mode            => '777',
        source          => 'file:///puppet/files/composer.phar',
}

class { 'nodejs': }

package { 'bower':
	    ensure => present,
	    provider => 'npm',
}

Class['nodejs'] -> Package['bower']

File['/etc/service/apache/'] -> File['/etc/service/apache/run']

Class['apache'] ~> Class['php']
