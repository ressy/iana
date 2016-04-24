#!/usr/bin/env ruby
# encoding: UTF-8
# vim: expandtab tabstop=2 softtabstop=2 shiftwidth=2

# examples/tlds.rb
require 'iana'

# is com a TLD?
puts "com is a TLD? => #{IANA::TLD.tld?('com')}"

# how about to?
puts "to is a TLD? => #{IANA::TLD.tld?('to')}"

# grizzlebat is probably not a TLD
puts "grizzlebat is a TLD? => #{IANA::TLD.tld?('grizzlebat')}"

# how about yn?
puts "yn is a TLD? => #{IANA::TLD.tld?('yn')}"

exit 0
