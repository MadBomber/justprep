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
#

require           "pathname"
require_relative  "justprep/version"

module Justprep
  class << self
    JUSTPREP_FILENAME_IN  = ENV.fetch('JUSTPREP_FILENAME_IN',   'main.just')
    JUSTPREP_FILENAME_OUT = ENV.fetch('JUSTPREP_FILENAME_OUT',  'justfile')
    JUSTPREP_KEYWORDS     = ENV.fetch('JUSTPREP_KEYWORDS', 'import include require with').split


    # review the text looking for module references
    def find_modules(text)
      modules = []

      JUSTPREP_KEYWORDS.each do |keyword|
        modules << text.select{|x| x.start_with? "#{keyword} "}
      end

      return modules.flatten!
    end


    # somg;e-level inclusion
    def include_content_from(file_path)
      content   = []
      content  << "\n# >>> #{file_path}"
      content  << file_path.readlines.map{|x| x.chomp} # TODO: support recursion??
      content  << "# <<< #{file_path}\n"

      return content.flatten
    end


    # look for first occurace of mainfile
    def just_find_it(here=Pathname.pwd)
      mainfile = here + JUSTPREP_FILENAME_IN
      return mainfile if mainfile.exist?
      return nil if here == here.parent
      return just_find_it(here.parent)
    end


    # use an external shell to expand system environment variables
    def expand_file_path(a_path_string)
      if a_path_string.start_with? '~'
        a_path_string = "${HOME}" + a_path_string[1, a_path_string.size-1]
      end

      a_path_string = `echo "#{a_path_string}"`.chomp

      return a_path_string
    end

    # Print usage text
    def usage
      puts <<~EOS
        justprep v#{VERSION} (ruby)
        A pre-processor to the just command line utility
        By Dewayne VanHoozer <dvanhoozer@gmail.com>

        USAGE:
          justprep [flags] && just

        FLAGS:
              --version   Shows the current version
          -h, --help      Displays this usage message

        DESCRIPTION:
          Looks for a file named #{JUSTPREP_FILENAME_IN} in the current
          directory hierarchy.  If found it replaces all lines that
          have the keywords (#{JUSTPREP_KEYWORDS.join(", ")}) followed
          by file path with the contents of the specified file.

        SYSTEM ENVIRONMENT VARIABLES:
                                    Default Value
          JUSTPREP_FILENAME_IN .... main.just
          JUSTPREP_FILENAME_OUT ... justfile
          JUSTPREP_KEYWORDS ....... 'import include require with'

        SUGGESTION:
          Create an alias for your command shell. For example
            alias jj='justprop && just'

        THANKS TO:
          Casey Rodarmor <casey@rodarmor.com>
          Just because just is just a handy utility with just an odd name. :)

      EOS
    end


    # take care of ARGV processing
    def handle_command_line_parameters
      if ARGV.size > 0
        ARGV.each do |param|
          if "--version" == param
            puts "jusrprep v#{VERSION} (ruby)"
          elsif ["-h", "--help"].include?(param)
            usage
          else
            STDERR.puts "justprep does not support: #{param}"
            exit(1)
          end
        end
      end
    end


    # Main function called from executable
    def execute
      handle_command_line_parameters

      mainfile  = just_find_it

      exit(0) if mainfile.nil?

      basefile  = mainfile.parent + JUSTPREP_FILENAME_OUT

      text = mainfile.readlines.map{|x| x.chomp} # drop the line ending from each line

      modules = find_modules text

      if modules.empty?
        basefile.write text
        exit(0)
      end

      modules.each do |a_line|
        an_index        = text.index a_line
        begin_filename  = a_line.index(' ')
        module_filename = a_line[begin_filename, a_line.size - begin_filename].strip

        if module_filename.empty?
          STDERR.puts "#{an_index}: #{a_line}"
          STDERR.puts "ERROR: No path/to/file was provided"
          next
        end

        if module_filename.include?('~')  || module_filename.include?('$')
          module_filename = expand_file_path(module_filename)
        end

        module_path     = Pathname.new(module_filename)

        if module_path.relative?
          module_path = mainfile.parent + module_path
        end

        if module_path.exist?
          text[an_index]  = include_content_from(module_path)
        else
          STDERR.puts "#{an_index}: #{a_line}"
          STDERR.puts "| ERROR: File Does Not Exist - #{module_path}"
        end
      end

      basefile.write text.flatten!.join "\n"
    end # def execute
  end # class << self
end # module Justprep
