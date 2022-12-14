#! /usr/bin/env ruby
# frozen_string_literal: false

#
#   check-smart
#
# DESCRIPTION:
#   S.M.A.R.T. - Self-Monitoring, Analysis and Reporting Technology
#
#   Check hdd and ssd SMART attributes defined in smart.json file. Default is
#   to check all attributes defined in this file if attribute is presented by hdd.
#   If attribute not presented script will skip it.
#
#   I defined smart.json file based on this two specification
#   http://en.wikipedia.org/wiki/S.M.A.R.T.#cite_note-kingston1-32
#   http://media.kingston.com/support/downloads/MKP_306_SMART_attribute.pdf
#
#   I tested on several Seagate, Western Digital hdd and Cosair force Gt SSD
#
#   It is possible some hdd give strange attribute values and warnings based on it
#   but in this case simply define attribute list with '-a' parameter
#   and ignore wrong parameters. Maybe attribute 1 and 201 will be wrong because
#   format of this attributes specified by hdd vendors.
#
#   You can test the script just make a copy of your smartctl output and change some
#   value. I put a hdd attribute file into 'test_hdd.txt' and a failed hdd file into
#   'test_hdd_failed.txt'.
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: json
#   smartmontools
#   smart.json
#
# USAGE:
#   You need to add 'sensu' user to suduers or you can't use 'smartctl'
#   sensu  ALL=(ALL) NOPASSWD:/usr/sbin/smartctl
#
#   PARAMETERS:
#   -b: smartctl binary to use, in case you hide yours (default: /usr/sbin/smartctl)
#   -d: default threshold for crit_min,warn_min,warn_max,crit_max (default: 0,0,0,0)
#   -a: SMART attributes to check (default: all)
#   -t: Custom threshold for SMART attributes. (id,crit_min,warn_min,warn_max,crit_max)
#   -o: Overall SMART health check (default: on)
#   -d: Devices to check (default: all)
#   --debug: turn debug output on (default: off)
#   --debug_file: process this file instead of smartctl output for testing
#
# NOTES:
#
# LICENSE:
#   Copyright 2013 Peter Kepes <https://github.com/kepes>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'json'

class Disk
  # Setup variables
  #
  def initialize(name, override, ignore)
    @device_path = "/dev/#{name}"
    @override_path = override
    @att_ignore = ignore
  end

  # Is the device SMART capable and enabled
  #
  def device_path
    if @override_path.nil?
      @device_path
    else
      @override_path
    end
  end

  def smart_ignore?(num)
    return false if @att_ignore.nil?

    @att_ignore.include? num
  end

  public :device_path, :smart_ignore?
end

#
# Smart Check Status
#
class SmartCheckStatus < Sensu::Plugin::Check::CLI
  option :binary,
         short: '-b path/to/smartctl',
         long: '--binary /usr/sbin/smartctl',
         description: 'smartctl binary to use, in case you hide yours',
         required: false,
         default: 'smartctl'

  option :json,
         short: '-j path/to/smart.json',
         long: '--json path/to/smart.json',
         description: 'Path to SMART attributes JSON file',
         required: false,
         default: File.dirname(__FILE__) + '/smart.json'

  option :defaults,
         short: '-d 0,0,0,0',
         long: '--defaults 0,0,0,0',
         description: 'default threshold for crit_min,warn_min,warn_max,crit_max',
         required: false,
         default: '0,0,0,0'

  option :attributes,
         short: '-a 1,5,9,230',
         long: '--attributes 1,5,9,230',
         description: 'SMART attributes to check',
         required: false,
         default: 'all'

  option :threshold,
         short: '-t 194,5,10,50,60',
         long: '--threshold 194,5,10,50,60',
         description: 'Custom threshold for SMART attributes. (id,crit_min,warn_min,warn_max,crit_max)',
         required: false

  option :overall,
         short: '-o off',
         long: '--overall off',
         description: 'Overall SMART health check',
         required: false,
         default: 'on'

  option :devices,
         short: '-d sda,sdb,sdc',
         long: '--device sda,sdb,sdc',
         description: 'Devices to check',
         required: false,
         default: 'all'

  option :debug,
         long: '--debug on',
         description: 'Turn debug output on',
         required: false,
         default: 'off'

  option :debug_file,
         long: '--debugfile test_hdd.txt',
         description: 'Process a debug file for testing',
         required: false

  # Main function
  #
  def run
    @smart_attributes = JSON.parse(IO.read(config[:json]), symbolize_names: true)[:smart][:attributes]
    @smart_debug = config[:debug] == 'on'

    # Load in the device configuration
    @hardware = JSON.parse(IO.read(config[:json]), symbolize_names: true)[:hardware][:devices]

    # Set default threshold
    default_threshold = config[:defaults].split(',')
    raise 'Invalid default threshold parameter count' unless default_threshold.size == 4

    @smart_attributes.each do |att|
      att[:crit_min] = default_threshold[0].to_i if att[:crit_min].nil?
      att[:warn_min] = default_threshold[1].to_i if att[:warn_min].nil?
      att[:warn_max] = default_threshold[2].to_i if att[:warn_max].nil?
      att[:crit_max] = default_threshold[3].to_i if att[:crit_max].nil?
    end

    # Check threshold parameter if present
    unless config[:threshold].nil?
      thresholds = config[:threshold].split(',')
      # Check threshold parameter length
      raise 'Invalid threshold parameter count' unless (thresholds.size % 5).zero?

      (0..(thresholds.size / 5 - 1)).each do |i|
        att_id = @smart_attributes.index { |att| att[:id] == thresholds[i + 0].to_i }
        thash = { crit_min: thresholds[i + 1].to_i,
                  warn_min: thresholds[i + 2].to_i,
                  warn_max: thresholds[i + 3].to_i,
                  crit_max: thresholds[i + 4].to_i }
        @smart_attributes[att_id].merge! thash
      end
    end

    # Attributes to check
    att_check_list = find_attributes

    # Devices to check
    devices = config[:debug_file].nil? ? find_devices : [Disk.new('sda', nil, nil)]

    # Overall health and attributes parameter
    parameters = '-H -A'

    # Get attributes in raw48 format
    att_check_list.each do |att|
      parameters += " -v #{att},raw48"
    end

    output = {}
    warnings = []
    criticals = []
    # TODO: refactor me
    devices.each do |dev| # rubocop:disable Metrics/BlockLength
      puts "#{config[:binary]} #{parameters} #{dev.device_path}" if @smart_debug
      # check if debug file specified
      if config[:debug_file].nil?
        output[dev] = `sudo #{config[:binary]} #{parameters} #{dev.device_path}`
      else
        test_file = File.open(config[:debug_file], 'rb')
        output[dev] = test_file.read
        test_file.close
      end

      # check overall helath status
      if config[:overall] == 'on' && !output[dev].include?('SMART overall-health self-assessment test result: PASSED')
        criticals << "Overall health check failed on #{dev.name}"
      end

      # #YELLOW
      output[dev].split("\n").each do |line|
        fields = line.split
        if fields.size == 10 && fields[0].to_i != 0 && att_check_list.include?(fields[0].to_i) && (dev.smart_ignore?(fields[0].to_i) == false)
          smart_att = @smart_attributes.find { |att| att[:id] == fields[0].to_i }
          att_value = fields[9].to_i
          att_value = send(smart_att[:read], att_value) unless smart_att[:read].nil?
          if att_value < smart_att[:crit_min] || att_value > smart_att[:crit_max]
            criticals << "#{dev.device_path} critical #{fields[0]} #{smart_att[:name]}: #{att_value}"
            puts "#{fields[0]} #{smart_att[:name]}: #{att_value} (critical)" if @smart_debug
          elsif att_value < smart_att[:warn_min] || att_value > smart_att[:warn_max]
            warnings << "#{dev.device_path} warning #{fields[0]} #{smart_att[:name]}: #{att_value}"
            puts "#{fields[0]} #{smart_att[:name]}: #{att_value} (warning)" if @smart_debug
          else
            puts "#{fields[0]} #{smart_att[:name]}: #{att_value} (ok)" if @smart_debug # rubocop:disable Style/IfInsideElse
          end
        end
      end
      puts "\n\n" if @smart_debug
    end

    # check the result
    if criticals.size != 0
      critical criticals.concat(warnings).join("\n")
    elsif warnings.size != 0
      warning warnings.join("\n")
    else
      ok 'All device operating properly'
    end
  end

  # Get right 16 bit from raw48
  #
  def right16bit(value)
    value & 0xffff
  end

  # Get left 16 bit from raw48
  #
  def left16bit(value)
    value >> 32
  end

  # find all devices from /proc/partitions or from parameter
  #
  def find_devices
    # Search for devices without number
    devices = []

    # Return parameter value if it's defined
    if config[:devices] != 'all'
      config[:devices].split(',').each do |dev|
        jconfig = @hardware.find { |d| d[:path] == dev }

        if jconfig.nil?
          override = nil
          ignore = nil
        else
          override = jconfig[:override]
          ignore = jconfig[:ignore]
        end
        devices << Disk.new(dev.to_s, override, ignore)
      end
      return devices
    end

    `lsblk -nro NAME,TYPE`.each_line do |line|
      name, type = line.split

      if type == 'disk'
        jconfig = @hardware.find { |h1| h1[:path] == name }

        if jconfig.nil?
          override = nil
          ignore = nil
        else
          override = jconfig[:override]
          ignore = jconfig[:ignore]
        end

        device = Disk.new(name, override, ignore)

        output = `sudo #{config[:binary]} -i #{device.device_path}`

        # Check if we can use this device or not
        available = !output.scan(/SMART support is:\s+Available/).empty?
        enabled = !output.scan(/SMART support is:\s+Enabled/).empty?
        devices << device if available && enabled
      end
    end

    devices
  end

  # find all attribute id from parameter or json file
  #
  def find_attributes
    return config[:attributes].split(',') unless config[:attributes] == 'all'

    attributes = []
    @smart_attributes.each do |att|
      attributes << att[:id]
    end

    attributes
  end
end
