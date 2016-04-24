#!/usr/bin/env ruby

# NOTE
# RFC 4646 described below has been obseleted by RFC5646. Tests still run OK
# but I have no idea (yet) what this new RFC has changed in terms of the LSR
# file format or langugae tags generally.
# See http://tools.ietf.org/html/rfc5646 (particularly section 8).
# 2011-04-18
module IANA
  # Get the Language Subtag Registry data from the IANA site or a text file
  # and load it into an array of hashes for further processing.
  #
  # IANA's Language Subtag Registry incorporates multiple standards for the
  # definition of language- and locale-defining strings, including:
  # ISO 3166: English country names and code elements 
  # ( http://www.iso.org/iso/english_country_names_and_code_elements )
  # ISO 639.2: Codes for the Representation of Names of Languages
  # ( http://www.loc.gov/standards/iso639-2/php/code_list.php )
  # The registry's format is specified in RFC 4646
  # ( http://www.ietf.org/rfc/rfc4646.txt )
  class LanguageSubtagRegistry
    # Entries always have these keys: Type, [Tag or Subtag], Description, Added
    # All keys used in the IANA format:
    Keys = [
      "Type",
      "Tag",
      "Subtag",
      "Description",
      "Added",
      "Preferred-Value",
      "Deprecated",
      "Suppress-Script",
      "Prefix",
      "Comments" ]
    IANAHost = 'www.iana.org'
    IANAPath = '/assignments/language-subtag-registry'
    IANAFile = File.dirname(__FILE__) + "/../../example-data/lsr.txt"
    @@tags      = [] 
    @@file_date = ""

    def self.tags
      @@tags
    end

    def self.file_date
      @@file_date
    end

    # Load data directly from IANA site
    def self.get(path=IANAPath, host=IANAHost)
      require 'net/http'
      site = Net::HTTP.new host
      response = site.request_get path
      self.load(response.body)
    end

    # Load data from a text file
    def self.open(filename=IANAFile)
      file = File.open(filename, 'r')
      self.load(file.read)
    end

    # Load data from text string
    def self.load(text)
      @@tags = []
      @@file_date = ""
      item  = {}
      prev  = []
      text.each do |line|
        line.chomp!
        case line
        when /^%%$/
          (@@tags << item; item = {}) unless item.empty? # separator; append last entry, if present
        when /^File-Date: .*/
          @@file_date = line.gsub('File-Date: ','') # File-date entry
        when /^  [^ ].*/
          item[prev].kind_of?(Array) ? item[prev].last += " " + line.strip : item[prev] += " " + line.strip # continuation line
        else # everything else (the actual key: value pairs)
          key, val = line.split(':', 2) # the main pair (ie, "Subtag: en")
          if /\.\./.match val # value specifies a range, not simply a string
            start, finish = val.strip.split('..', 2)
            val = Range.new(start, finish)
          else # otherwise it's just a string
            val.strip!
          end
          if item.has_key?(key) # append to array if this key already exists
            item[key] = [item[key]] unless item[key].kind_of? Array
            item[key] << val
          else # otherwise simply assign the item
            item[key] = val
          end
          prev = key # in case of continuation (wrapped text)
        end
      end
      @@tags << item
      nil
    end

    # Dump data to:
    # IANA's flat text format (String)
    # YAML (String)
    # A hash of hashes, with the keys being the tags (Hash)
    def self.dump(format = "iana")
      begin
        format = format.strip.downcase
      rescue
        raise ArgumentError, "Invalid argument type; expected String"
      end
      case format
      when "iana"
        new_text = "File-Date: " + @@file_date + $/ + "%%" + $/
        new_text << @@tags.map do |item|
          Keys.map do |key|
            val = item[key]
            if val 
              if val.kind_of? Array
                val.map { |i| key + ": " + i.to_s }.join($/)
              else
                key + ": " + val.to_s
              end
            else
              nil
            end
          end.compact.join($/) + $/
        end.join('%%' + $/)
      when "yaml"
        require 'yaml'
        YAML::dump([@@file_date, @@tags])
      when "hash"
        taghash = {}
        @@tags.each do |tag|
          tag = tag.clone
          val = tag.delete("Tag") || tag.delete("Subtag")
          taghash[val.to_s] = tag
        end
        taghash
      else
        raise ArgumentError, "Invalid format option"
      end
    end

  end
end

raise RuntimeError, 'This library is for require only' if $0 == __FILE__
