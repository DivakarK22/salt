#! /usr/bin/env ruby
# frozen_string_literal: true

#
#   check-netstat-tcp
#
# DESCRIPTION:
#   Alert based on thresholds of discrete TCP socket states reported by netstat
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#
# USAGE:
#   $ ./check-netstat-tcp.rb --states ESTABLISHED,CLOSE_WAIT --warning 10,3 --critical 100,30
#
# NOTES:
#   - Thanks to metric-netstat-tcp.rb!
#   https://github.com/sensu/sensu-community-plugins
#   - Code for parsing Linux /proc/net/tcp from Anthony Goddard's ruby-netstat:
#   https://github.com/agoddard/ruby-netstat
#
# LICENSE:
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'socket'

TCP_STATES = {
  '00' => 'UNKNOWN',  # Bad state ... Impossible to achieve ...
  'FF' => 'UNKNOWN',  # Bad state ... Impossible to achieve ...
  '01' => 'ESTABLISHED',
  '02' => 'SYN_SENT',
  '03' => 'SYN_RECV',
  '04' => 'FIN_WAIT1',
  '05' => 'FIN_WAIT2',
  '06' => 'TIME_WAIT',
  '07' => 'CLOSE',
  '08' => 'CLOSE_WAIT',
  '09' => 'LAST_ACK',
  '0A' => 'LISTEN',
  '0B' => 'CLOSING'
}.freeze

#
# Check Netstat TCP
#
class CheckNetstatTCP < Sensu::Plugin::Check::CLI
  option :states,
         description: 'Comma delimited list of states to check',
         short: '-s STATES',
         long: '--states STATES',
         default: ['ESTABLISHED'],
         proc: proc { |a| a.split(',') }

  option :critical,
         description: "Comma delimited list of state values to set critical at (order follows 'states')",
         short: '-c CRITICAL',
         long: '--critical CRITICAL',
         default: [1000],
         proc: proc { |a| a.split(',').map(&:to_i) }

  option :warning,
         description: "Comma delimited list of state values to set warning at (order follows 'states')",
         short: '-w WARNING',
         long: '--warning WARNING',
         default: [500],
         proc: proc { |a| a.split(',').map(&:to_i) }

  option :port,
         description: 'Port you wish to check values on (default: all)',
         short: '-p PORT',
         long: '--port PORT',
         proc: proc(&:to_i)

  def netstat(protocols = ['tcp'])
    state_counts = Hash.new(0)
    TCP_STATES.each_pair { |_hex, name| state_counts[name] = 0 }

    protocols.select { |p| File.exist?('/proc/net/' + p) }.each do |protocol|
      File.open('/proc/net/' + protocol).each do |line|
        line.strip!
        if m = line.match(/^\s*\d+:\s+(.{8}|.{32}):(.{4})\s+(.{8}|.{32}):(.{4})\s+(.{2})/) # rubocop:disable AssignmentInCondition
          connection_state = m[5]
          connection_port = m[2].to_i(16)
          connection_state = TCP_STATES[connection_state]
          next unless config[:states].include?(connection_state)

          if config[:port] && config[:port] == connection_port
            state_counts[connection_state] += 1
          elsif !config[:port]
            state_counts[connection_state] += 1
          end
        end
      end
    end
    state_counts
  end

  def run
    state_counts = netstat(%w[tcp tcp6])
    is_critical = false
    is_warning = false
    message = ''

    config[:states].each_index do |i|
      if state_counts[config[:states][i]] >= config[:critical][i]
        is_critical = true
        message += " CRITICAL:#{config[:states][i]}=#{state_counts[config[:states][i]]}"
      elsif state_counts[config[:states][i]] >= config[:warning][i]
        is_warning = true
        message += " WARNING:#{config[:states][i]}=#{state_counts[config[:states][i]]}"
      else
        message += " OK:#{config[:states][i]}=#{state_counts[config[:states][i]]}"
      end
    end

    critical message if is_critical
    warning message if is_warning
    ok message
  end
end
