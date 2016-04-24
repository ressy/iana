## What
IANA Ruby module [![Gem Version](https://badge.fury.io/rb/iana-data.svg)](https://badge.fury.io/rb/iana-data)
[![Code Climate](https://codeclimate.com/github/ringe/iana/badges/gpa.svg)](https://codeclimate.com/github/ringe/iana)

Look up TCP/IP port numbers, protocols, top-level domains, et al.

Get data from the Internet Assigned Numbers Authority (IANA) and make it
available to your programs.

## Install

    gem install iana-data

In your Gemfile

    gem 'iana-data'

## Usage

```ruby
require 'iana'

IANA::TLD.valid?("com")
=> true
IANA::TLD.valid?(".com")
=> true
IANA::TLD.valid?("isthisforreal")
=> false

prot = IANA::Protocol[25]
=> #<IANA::Protocol:0x00563e8bdd18a8 @protocol=25, @name="LEAF-1", @description="Leaf-1", @references=["Barry_Boehm"]>
prot.number
=> 25

port = IANA::Port[25]
=> [#<IANA::Port:0x00556cba04b600 @port=25, @keyword="smtp", @protocol="tcp", @description="Simple Mail Transfer">, #<IANA::Port:0x00556cba04b1a0 @port=25, @keyword="smtp", @protocol="udp", @description="Simple Mail Transfer">]
port.map(&:protocol)
=> ["tcp", "udp"]

IANA::Port.select port: 25, protocol: "udp"
=> {25=>[#<IANA::Port:0x00556cba1f3d90 @port=25, @keyword="smtp", @protocol="udp", @description="Simple Mail Transfer">]}

IANA::Port::DCCP[25]
=> []
IANA::Port::DCCP[8282]
=> [#<IANA::Port:0x00556cb9bc7840 @port=8282, @keyword="", @protocol="dccp", @description="Reserved">]

IANA::Port::UDP[443]
=> [#<IANA::Port:0x00556cba1a43a8 @port=443, @keyword="https", @protocol="udp", @description="http protocol over TLS/SSL">]

```

You still need to download some data files manually, while the IANA module is
rewritten to make use of open-uri everywhere.

The IANA Ruby module loads the data into conveniently searchable data
structures. The flat files the IANA Ruby module consume as data are hosted at
iana.org. You will need to fetch them so you can process the content locally.
I grab these files with with curl (but you can use wget or whatever if you
don't use curl):

    curl -L -O http://www.iana.org/assignments/ethernet-numbers


## Examples
When you run the example programs, do it like so:

    ruby examples/ports.rb port-numbers

Use these example programs to see how you might use and otherwise integrate
IANA data functionality into your own programs.

## Contribute
The source is availble at https://github.com/ringe/iana

Fork, patch and send a pull request.
