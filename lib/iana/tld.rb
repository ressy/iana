#!/usr/bin/env ruby
# encoding: UTF-8
# vim: expandtab tabstop=2 softtabstop=2 shiftwidth=2

# lib/tld.rb

module IANA
  module TLD
    # Download official IANA Top Level Domain list
    # http://data.iana.org/TLD/tlds-alpha-by-domain.txt
    def self.iana_list
      open("http://data.iana.org/TLD/tlds-alpha-by-domain.txt").read.
        split("\n").
        reject {|ln| ln =~ /^#/ }
    end

    # is specified tld a valid IANA Top Level Domain?
    def self.valid?(tld)
      iana_list.include?(tld.to_s.upcase.sub('.',''))
    end

    # is specified domain name a TLD?
    def self.tld?(tld)
      valid?(tld)
    end
  end
end

raise RuntimeError, 'This library is for require only' if $0 == __FILE__
