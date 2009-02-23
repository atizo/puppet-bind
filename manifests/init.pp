#
# bind module
# Copyright (c) 2007 David Schmitt <david@schmitt.edv-bus.at>
#
# Copyright 2008, Puzzle ITC
# Marcel Härry haerry+puppet(at)puzzle.ch
# Simon Josi josi+puppet(at)puzzle.ch
#
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#

import "zone.pp"

modules_dir { [ "bind", "bind/zones", "bind/options.d" ]: }

import 'defines/*.pp'

class bind {
  case $operatingsystem {
    centos: { include bind::centos }
    debian,ubuntu: { include bind::debian }
    default: { include bind::base }
  }
}

class bind::base {
  package{ ['bind', 'bind-utils']:
    ensure => present,
  }

	service { "bind":
		ensure => running,
		pattern => named,
    hasstatus => false,
    require => Package[bind],
		#subscribe => Exec["concat_/etc/bind/named.conf.local"],
	}
}

class bind::centos inherits bind::base {
  Service[bind]{
    name => 'named',
  }
}

class bind::debian inherits bind::base {
  Package[bind]{
    name => 'bind9',
  }
  Package[bind-utils]{
    name => 'dnsutils',
  }

  Service[bind]{
    name => 'bind9',
  }
}
