# encoding: utf-8
# frozen_string_literal: true
# warn_indent: true
##########################################################
# File: justprep.rb
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
# JUSTPREP_MODULE_KEYWORD . 'module'
#

IMPLEMENTATION  = "Ruby"

require           "fileutils"
require           "pathname"
require_relative  "justprep/crystal_methods"

# The common directory contains files which are usable in
# both the Ruby gem and compiled Crystal implementations
# The files have the extension ".crb"
#
COMMON_DIR = Pathname.new(__FILE__) + '../justprep/common'

# Loading these common methods as global kernel-level
load COMMON_DIR + "constants.crb"
load COMMON_DIR + "error_messages.crb"
load COMMON_DIR + "expand_file_path.crb"
load COMMON_DIR + "handle_command_line_parameters.crb"
load COMMON_DIR + "just_find_it.crb"
load COMMON_DIR + "usage.crb"
load COMMON_DIR + "generate_module_recipes.crb"
load COMMON_DIR + "replacement_for_module_line.crb"

class Justprep
  attr_accessor :module_names

  def initialize
    handle_command_line_parameters  # may terminate the process
    @module_names = []
  end


  # single-level inclusion
  def include_content_from(out_file, module_filename)
    module_file = File.open(module_filename, "r")

    out_file.puts "\n# >>> #{module_filename}"

    module_file.readlines.each do |m_line|
      out_file.write m_line
      end

    out_file.puts "# <<< #{module_filename}\n"

    return nil
  end


  # Main function called from executable
  def execute
  in_filename  = just_find_it

  if in_filename.nil?
      STDERR.puts "WARNING: JUSTPREP_FILENAME_IN Not Found: #{JUSTPREP_FILENAME_IN}"
      exit(0)
    end

  out_filename  = File.dirname(in_filename) + "/" + JUSTPREP_FILENAME_OUT

  in_file   = File.open(in_filename,  "r")
  out_file  = File.open(out_filename, "w")

  line_number = 0

  in_file.readlines.map{|x| x.chomp}.each do |a_line|
    line_number += 1

    parts = a_line.to_s.split(" ")

    if 0 == parts.size
      out_file.puts
      next
      end

    # NOTE: Leading spaces are not allowed.  The keywords
    #       MUST be complete left-justified.
    #
    if JUSTPREP_KEYWORDS.include?(parts.first.downcase)
      out_file.puts "# #{a_line}"

      glob_filename = expand_file_path(parts[1..parts.size].join(" "))

      module_filenames = Dir.glob(glob_filename)

      if 0 == module_filenames.size
        error_file_does_not_exist(line_number, a_line)
        exit(1)
      end

      module_filenames.each do |module_filename|
        if File.exist?(module_filename)
          include_content_from(out_file, module_filename)
        else
          error_file_does_not_exist(line_number, a_line)
          exit(1)
        end
      end
    elsif JUSTPREP_MODULE_KEYWORD == parts.first.downcase
      result_array  = replacement_for_module_line(line_number, a_line)
      @module_names << result_array.first
      out_file.puts result_array.last
    else
      out_file.puts a_line
    end
  end # in_file.readlines ...

  out_file.puts generate_module_recipes(@module_names)

  out_file.close
  end # def


end # class Justprep
