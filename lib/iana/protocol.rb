#!/usr/bin/env ruby
# encoding: UTF-8
# vim: expandtab tabstop=2 softtabstop=2 shiftwidth=2

# lib/iana/protocol.rb

# rubygems
require 'nokogiri'

module IANA
  class Protocol
    attr_reader :protocol, :name, :description, :references

    def initialize(protocol, name, description, xref)
      @protocol, @name, @description, @references = protocol, name, description, xref
    end

    def protocol; @protocol; end
    def number; @protocol; end
    def name; @name; end
    def description; @description; end
    def references; @references; end

    # Download IANA protocols list in XML format, return list
    # http://www.iana.org/assignments/protocol-numbers/protocol-numbers.xml
    def self.iana_list
      source = open("http://www.iana.org/assignments/protocol-numbers/protocol-numbers.xml").read

      protocols = {}
      updated = nil

      begin
        doc = Nokogiri::XML(source)
        updated = doc.css('registry/updated').text
        doc.css('registry/registry/record').each do |r|
          # range
          value = r.css('value').text
          if value =~ /-/ then
            low,high = value.split('-').map(&:to_i)
          else
            low = value.to_i
            high = low
          end

          # name
          name = r.css('name').text
          name = nil if !name.nil? && name.empty?

          # description
          description = r.css('description').text
          description = nil if !description.nil? && description.empty?

          # references
          xref = []
          r.css('xref').each do |x|
            data = x['data']
            xref << data if !data.nil? && !data.empty?
          end

          if low == high then
            protocols[low] = Protocol.new(low, name, description, xref)
          else
            # create an entry for each range element
            (high-low+1).times do |i|
              protocols[low+i] = Protocol.new(low+i, name, description, xref)
            end
          end
        end
      end

      return protocols
    end

    # Look up protocol definition in iana_list
    def self.[](arg)
      raise ArgumentError, 'protocol number must be an Fixnum' if arg.class != Fixnum
      iana_list[arg]
    end
  end
end

raise RuntimeError, 'This library is for require only' if $0 == __FILE__
