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

  def generate_module_recipes
    recipes = ""

    @module_names.each do |mod_name|
      recipes += "

# Module #{mod_name}
@#{mod_name} what='' args='':
  just -f {{module_#{mod_name}}} {{what}} {{args}}

"
    end

    return recipes
  end

  # Inserts the module_name into the Array of module_names
  # Returns a string that defines the variable for the path to the module
  def replacement_for_module_line(line_number, a_string)
    parts = a_string.split(" ")
    path_to_module = parts[1..].join(" ")

    unless File.exists?(path_to_module)
      error_file_does_not_exist(line_number, a_string)
      exit(1)
    end

    parts = path_to_module.split("/")
    module_name = parts[parts.size - 2]
    @module_names << module_name

    return "module_#{module_name} := \"#{path_to_module}\""
  end

  # single-level inclusion
  def include_content_from(out_file, module_filename)
    out_file.puts "\n# >>> #{module_filename}"

    File.read_lines(module_filename).each do |m_line|
      out_file.puts m_line
    end

    out_file.puts "# <<< #{module_filename}\n"

    return nil
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
        out_file.puts replacement_for_module_line(line_number, a_line)
      else
        out_file.puts a_line
      end
    end # in_file.readlines ...

    out_file.puts generate_module_recipes

    out_file.close
  end # def execute
end   # class Justprep

Justprep.new.execute
