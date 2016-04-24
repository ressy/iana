#!/usr/bin/env ruby
# encoding: UTF-8
# vim: expandtab tabstop=2 softtabstop=2 shiftwidth=2

# examples/ports.rb
require 'iana'

# lookup port 22
port = 22
result = IANA::Port[port]
puts "#{result.size} matches for port #{port}:"
result.each do |p|
  puts "=> #{p.keyword} #{port}/#{p.protocol} \"#{p.description}\""
end

exit 0
