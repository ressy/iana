#!/usr/bin/env ruby
# encoding: UTF-8
# vim: expandtab tabstop=2 softtabstop=2 shiftwidth=2

# lib/iana/port.rb

module IANA
  class Port
    attr_reader :port, :keyword, :protocol, :description

    def initialize(port, keyword, protocol, description)
      @port, @keyword, @protocol, @description = port, keyword, protocol, description
    end

    def port; @port; end
    def number; @port; end
    def keyword; @keyword; end
    def protocol; @protocol; end
    def description; @description; end

    # Download IANA ports list in XML format, return list
    # http://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xml
    def self.iana_list
      source = open("http://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv").
        read

      # concatenate multiline strings, then split on newline
      lines = source.gsub(/(?<!\r)\n/, ' ').split(/\r\n/)

      ports = {}

      begin
        while (line = lines.shift)
          # skip lines which do not contain the ,proto, pattern
          if line !~ /\d,(tcp|udp|sctp|dccp),/
            next
          end

          proto = line.split(/,(?=(?:[^"]|"[^"]*")*$)/)
          name = proto[0]
          num = proto[1].to_i
          protocol = proto[2]
          desc = proto[3]

          ports[num] ||= Array.new
          ports[num] << Port.new(num, name, protocol, desc)
        end
      end

      return ports
    end

    # Look up port definition in iana_list by number
    def self.[](num, protocol=nil)
      raise ArgumentError, 'port number must be an Fixnum' if num.class != Fixnum
      raise ArgumentError, 'protocol must be tcp, udp, sctp or dccp' unless [nil, 'tcp', 'udp', 'sctp', 'dccp'].include?(protocol)

      if protocol.nil?
        iana_list[num]
      else
        iana_list[num].select {|p| p.protocol == protocol }
      end
    end

    # Select Ports by properties and values
    def self.select(properties)
      portlist = iana_list.collect do |num, ports|
        list = ports.select do |p|
          properties.collect {|key, val|
            p.send(key) == val
          }.all?
        end
        list.empty? ? nil : [num, list]
      end
      Hash[*portlist.compact.flatten(1)]
    end

    # Methods to query IANA Ports within a namespace, like IANA::Port::TCP
    class PortQuerying

      # Return the Port's protocol name in lower case
      def self.protocol
        name.sub(/.*::/,'').downcase
      end

      # List all Ports by this protocol
      def self.list
        IANA::Port.select protocol: protocol
      end

      # Look up given Port number under this protocol
      def self.[](num)
        IANA::Port[num, protocol]
      end
    end

    # Look up DCCP port definition in iana_list
    class DCCP < PortQuerying
    end

    # Look up SCTP port definition in iana_list
    class SCTP < PortQuerying
    end

    # Look up UDP port definition in iana_list
    class UDP < PortQuerying
    end

    # Look up TCP port definition in iana_list
    class TCP < PortQuerying
    end
  end
end

raise RuntimeError, 'This library is for require only' if $0 == __FILE__
