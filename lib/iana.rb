#!/usr/bin/env ruby
# encoding: UTF-8
# vim: expandtab tabstop=2 softtabstop=2 shiftwidth=2

# lib/iana.rb
module IANA
end # IANA

require 'open-uri'
require 'open-uri/cached'

#require 'consumer'
require 'iana/ethertype'
require 'iana/port'
require 'iana/protocol'
require 'iana/tld'
require 'iana/lsr'

# TODO implement consumer model
# TODO complete documentaion
# TODO implement unit tests
# TODO lookup needs to be more flexible

raise RuntimeError, 'This library is for require only' if $0 == __FILE__
