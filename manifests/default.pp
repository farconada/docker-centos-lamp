
include apache
class{'php':
	 php_packages => ['php56w', 'php56w-mysqlnd', 'php56w-curl', 'php56w-gd', 'php56w-json', 'php56w-mhash', 'php56w-pecl-apcu', 'php56w-readline']
}

file {'/etc/service/apache':
	ensure => 'directory'
}

file {'/etc/service/apache/run':
	ensure 		=> 'present',
	mode 		=> '777',
	source 		=> 'file:///puppet/files/runit/service/apache-service'
}

File['/etc/service/apache/'] -> File['/etc/service/apache/run']

Class['apache'] ~> Class['php']
