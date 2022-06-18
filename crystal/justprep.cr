#!/usr/bin/env crystal
# encoding: utf-8
# frozen_string_literal: true
# warn_indent: true
##########################################################
# File: justprep.cr
# Desc: A preprocessor to "just" cli tool
# By:   Dewayne VanHoozer (dvanhoozer@gmail.com)
#
# The following system environment variable are supported:
#
# variable name             default value
# ---------------------     -------------
# JUSTPREP_FILENAME_IN  ... main.just
# JUSTPREP_FILENAME_OUT ... justfile
# JUSTPREP_KEYWORDS     ... 'import include require with'
# JUSTPREP_MODULE_KEYWORD . module
#

IMPLEMENTATION = "Crystal"

require "file_utils"

class Justprep
  def initialize
    handle_command_line_parameters
    @module_names = Array(String).new
  end

  def execute
    in_filename = just_find_it

    if in_filename.nil?
      STDERR.puts "WARNING: JUSTPREP_FILENAME_IN Not Found: #{JUSTPREP_FILENAME_IN}"
      exit(0)
    end

    out_filename = File.dirname(in_filename) + "/" + JUSTPREP_FILENAME_OUT

    # in_file = File.open(in_filename, "r")
    out_file = File.open(out_filename, "w")

    line_number = 0

    File.read_lines(in_filename).map { |x| x.chomp }.each do |a_line|
      line_number += 1

      parts = a_line.split(" ")

      if 0 == parts.size
        out_file.puts
        next
      end

      # NOTE: Leading spaces are not allowed.  The keywords
      #       MUST be complete left-justified.
      #
      if JUSTPREP_KEYWORDS.includes?(parts.first.downcase)
        out_file.puts "# #{a_line}"

        glob_filename = expand_file_path(parts[1..parts.size].join(" "))

        module_filenames = Dir.glob(glob_filename)

        if 0 == module_filenames.size
          error_file_does_not_exist(line_number, a_line)
          exit(1)
        end

        module_filenames.each do |module_filename|
          if File.exists?(module_filename)
            include_content_from(out_file, module_filename)
          else
            error_file_does_not_exist(line_number, a_line)
            exit(1)
          end
        end
      elsif JUSTPREP_MODULE_KEYWORD == parts.first.downcase
        module_name, module_filename = replacement_for_module_line(line_number, a_line)
        @module_names << module_name
        out_file.puts module_filename
      else
        out_file.puts a_line
      end
    end # in_file.readlines ...

    out_file.puts generate_module_recipes(@module_names)

    out_file.close
  end # def execute
end   # class Justprep

Justprep.new.execute
