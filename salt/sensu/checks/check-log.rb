#! /usr/bin/env ruby
# frozen_string_literal: false

#
#   check-log
#
# DESCRIPTION:
#   This plugin checks a log file for a regular expression, skipping lines
#   that have already been read, like Nagios's check_log. However, instead
#   of making a backup copy of the whole log file (very slow with large
#   logs), it stores the number of bytes read, and seeks to that position
#   next time.
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
#   #YELLOW
#
# NOTES:
#
# LICENSE:
#   Copyright 2011 Sonian, Inc <chefs@sonian.net>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'fileutils'

class CheckLog < Sensu::Plugin::Check::CLI
  BASE_DIR = '/var/cache/check-log'.freeze

  option :state_auto,
         description: 'Set state file dir automatically using name',
         short: '-n NAME',
         long: '--name NAME',
         proc: proc { |arg| "#{BASE_DIR}/#{arg}" }

  option :state_dir,
         description: 'Dir to keep state files under',
         short: '-s DIR',
         long: '--state-dir DIR',
         default: "#{BASE_DIR}/default"

  option :log_file,
         description: 'Path to log file',
         short: '-f FILE',
         long: '--log-file FILE'

  option :pattern,
         description: 'Pattern to search for',
         short: '-q PAT',
         long: '--pattern PAT',
         required: true

  # this check currently makes no attempt to try to save you from
  # a bad regex such as being unbound. Regexes ending in anything like:
  # `.*`, `.+`, `[0-9-A-Z-a-z]+`, etc. Having regex without a real
  # boundry could force the entire log file into memory at once rather
  # line by line and could have signifigant performance impact. Please
  # if you are going to use this please make sure you have log rotation
  # set up and test your regex to make sure that it will catch what
  # you want. I would reccomend placing several log examples into
  # something like http://regexr.com/ and ensure that your regex properly
  # catches the boundries. You have been warned.
  option :log_pattern,
         description: 'The log format of each log entry',
         short: '-l PAT',
         long: '--log-pattern PAT'

  option :exclude,
         description: 'Pattern to exclude from matching',
         short: '-E PAT',
         long: '--exclude PAT',
         proc: proc { |s| Regexp.compile s },
         default: /(?!)/

  option :encoding,
         description: 'Explicit encoding page to read log file with',
         short: '-e ENCODING-PAGE',
         long: '--encoding ENCODING-PAGE'

  option :warn,
         description: 'Warning level if pattern is found >= <warn> times',
         short: '-w N',
         long: '--warn N',
         proc: proc(&:to_i)

  option :crit,
         description: 'Critical level if pattern is found >= <crit> times. Default: 1',
         short: '-c N',
         long: '--crit N',
         proc: proc(&:to_i),
         default: 1

  option :only_warn,
         description: 'Warn instead of critical on match',
         short: '-o',
         long: '--warn-only',
         boolean: true

  option :case_insensitive,
         description: 'Run a case insensitive match',
         short: '-i',
         long: '--icase',
         boolean: true,
         default: false

  option :file_pattern,
         description: 'Check a pattern of files, instead of one file',
         short: '-F FILE',
         long: '--filepattern FILE'

  option :return_content,
         description: 'Return matched line',
         short: '-r',
         long: '--return',
         boolean: true,
         default: false

  option :return_content_length,
         description: 'Matched line length',
         short: '-L N',
         long: '--return-length N',
         proc: proc(&:to_i),
         default: 250

  option :return_error_limit,
         description: 'Max number of returned matched lines(log entries)',
         short: '-M N',
         long: '--return-error-limit N',
         proc: proc(&:to_i)

  # Use this option when you expecting your log lines to contain invalid byte sequence in utf-8.
  # https://github.com/sensu-plugins/sensu-plugins-logs/pull/26
  option :encode_utf16,
         description: 'Encode line with utf16 before matching',
         short: '-eu',
         long: '--encode-utf16',
         boolean: true,
         default: false

  def run
    unknown 'No log file specified' unless config[:log_file] || config[:file_pattern]
    unknown 'No thresholds specified' unless config[:crit] || config[:warn]
    file_list = []
    file_list << config[:log_file] if config[:log_file]
    if config[:file_pattern]
      dir_str = config[:file_pattern].slice(0, config[:file_pattern].to_s.rindex('/'))
      file_pat = config[:file_pattern].slice((config[:file_pattern].to_s.rindex('/') + 1), config[:file_pattern].length)
      Dir.foreach(dir_str) do |file|
        if config[:case_insensitive]
          file_list << "#{dir_str}/#{file}" if file.to_s.downcase.match(file_pat.downcase)
        else
          file_list << "#{dir_str}/#{file}" if file.to_s.match(file_pat) # rubocop:disable Style/IfInsideElse
        end
      end
    end
    n_warns_overall = 0
    n_crits_overall = 0
    error_overall = ''
    file_list.each do |log_file|
      begin
        open_log log_file
      rescue StandardError => e
        unknown "Could not open log file: #{e}"
      end
      n_warns, n_crits, accumulative_error = search_log
      n_warns_overall += n_warns
      n_crits_overall += n_crits

      if config[:return_content]
        error_overall += accumulative_error
      end
    end
    message "#{n_warns_overall} warnings, #{n_crits_overall} criticals for pattern #{config[:pattern]}. #{error_overall}"
    if n_crits_overall > 0
      critical
    elsif n_warns_overall > 0
      warning
    else
      ok
    end
  end

  def open_log(log_file)
    state_dir = config[:state_auto] || config[:state_dir]

    # Opens file using optional encoding page.  ex: 'iso8859-1'
    @log = if config[:encoding]
             File.open(log_file, "r:#{config[:encoding]}")
           else
             File.open(log_file)
           end

    @state_file = File.join(state_dir, File.expand_path(log_file).sub(/^([A-Z]):\//, '\1/'))
    @bytes_to_skip =
      begin
        File.open(@state_file) do |file|
          file.flock(File::LOCK_SH) unless Gem.win_platform?
          file.readline.to_i
        end
      rescue StandardError
        0
      end
  end

  def search_log
    log_file_size = @log.stat.size
    @bytes_to_skip = 0 if log_file_size < @bytes_to_skip
    bytes_read = 0
    n_warns = 0
    n_crits = 0
    n_matched = 0
    accumulative_error = ''

    @log.seek(@bytes_to_skip, File::SEEK_SET) if @bytes_to_skip > 0
    # #YELLOW
    @log.each_line do |line|
      line = encode_line(line)
      if config[:log_pattern]
        line = get_log_entry(line)
      end

      bytes_read += line.bytesize
      if config[:case_insensitive]
        m = line.downcase.match(config[:pattern].downcase) unless line.match(config[:exclude])
      else
        m = line.match(config[:pattern]) unless line.match(config[:exclude])
      end
      if m
        if !config[:return_error_limit] || (config[:return_error_limit] && n_matched < config[:return_error_limit])
          accumulative_error += "\n" + line.slice(0..config[:return_content_length])
        end
        n_matched += 1
      end
    end
    if !config[:only_warn] && config[:crit] && n_matched >= config[:crit]
      n_crits = n_matched
    elsif config[:warn] && n_matched >= config[:warn]
      n_warns = n_matched
    end
    FileUtils.mkdir_p(File.dirname(@state_file))
    File.open(@state_file, File::RDWR | File::TRUNC | File::CREAT, 0o0644) do |file|
      file.flock(File::LOCK_EX) unless Gem.win_platform?
      file.write(@bytes_to_skip + bytes_read)
    end
    [n_warns, n_crits, accumulative_error]
  end

  def get_log_entry(first_line)
    log_entry = [first_line]

    @log.each_line do |line|
      line = encode_line(line)

      if !line.match(config[:log_pattern])
        log_entry.push(line)
      else
        @log.pos = @log.pos - line.bytesize if line
        break
      end
    end

    log_entry.join('')
  end

  def encode_line(line)
    if config[:encode_utf16]
      line = line.encode('UTF-16', invalid: :replace, replace: '')
    end

    line.encode('UTF-8', invalid: :replace, replace: '')
  end
end