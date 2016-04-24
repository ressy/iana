#!/usr/bin/env ruby
# encoding: UTF-8
# vim: expandtab tabstop=2 softtabstop=2 shiftwidth=2

# examples/protocols.rb
require 'iana'

# lookup protocol 22
result = IANA::Protocol[22]
puts "protocol 22 => #{result.name} \"#{result.description}\""

exit 0
