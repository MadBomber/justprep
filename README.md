# justprep
A pre-processor for the "just" command line utility.
https://github.com/casey/just

Please forgive the disorganization - thie README is still under development.

You might useful documentation more quickly in the project's
[Github wiki](https://github.com/MadBomber/justprep/wiki)

Casey's `just` utility is such a useful tool; but, it has one thing that bothered me - the inability to inherently include recipes from other files.  For those of us who work on many projects in parallel the ability to share recipes (effective code reuse / modularization) is an important feature.  Its advantages are:

* provides for smaller more easily maintained files
* more cohesive file content
* shared recipes between projects

Allowing this flexibility also opens up some use cases which are not supported by the `just` utility - the ability to over-ride a recipe, for example.  Duplicate recipes (and aliases) are treated by `just` as errors.  Allowing the inclusion of multiple files into a single project specific `justfile` can lead to having duplicate recipes.  These are easily found and can be dealt with manually.

HOWEVER, as of version 0.11.2+ `just` now supports duplicate recipes where the last  one defined is the one that is executed.  To take advantage of this capability you need to add this to your just file(s) ...

  set allow-duplicate-recipes

# Table of Contents

<!-- MarkdownTOC -->

- [System Environment Variables](#system-environment-variables)
    + [JUSTPREP_KEYWORDS](#justprep_keywords)
    + [JUSTPREP_MODULE_KEYWORD](#justprep_module_keyword)
    + [JUSTPREP_FILENAME_IN](#justprep_filename_in)
    + [JUSTPREP_FILENAME_OUT](#justprep_filename_out)
- [Install](#install)
    + [RubyGem](#rubygem)
    + [Crystal version](#crystal-version)
        * [With Homebrew](#with-homebrew)
        * [Precompiled binaries](#precompiled-binaries)
        * [From Source](#from-source)
- [Shell Configuration and My Conventions](#shell-configuration-and-my-conventions)
    + [Simple Configuration](#simple-configuration)
    + [My BASH Shell Configuration](#my-bash-shell-configuration)
        * [.bashrc](#bashrc)
        * [.bashrc__just](#bashrc__just)
    + [$HOME the .justfile Convention](#home-the-justfile-convention)
- [The Just List aka Help/Usage Output](#the-just-list-aka-helpusage-output)
- [Process](#process)
    + [Example Input File:  `main.just`](#example-input-file--mainjust)
    + [Example Output File: `justfile`](#example-output-file-justfile)
        * [Error Messages from `just`](#error-messages-from-just)
- [Path to a File to be Included](#path-to-a-file-to-be-included)
    + [Examples Using Shell Variables in path-to-include-file](#examples-using-shell-variables-in-path-to-include-file)
- [Limitations](#limitations)
- [Error Messages](#error-messages)
    + [From `justprep`](#from-justprep)
    + [From `just`](#from-just)
    + [Example of a `just` Error](#example-of-a-just-error)
- [Testing](#testing)
* [Organization](#organization)
- [Ruby Gem Version](#ruby-gem-version)
- [Crystal Version](#crystal-version-1)
* [Fake Module Convention](#fake-module-convention)
    + [Example without `justprep`](#example-without-justprep)
    + [Example using `justprep`](#example-using-justprep)

<!-- /MarkdownTOC -->


## System Environment Variables

`justprep` in both its Ruby Gem form and its binary executable via Crystal is controlled by the following environment variables.


### JUSTPREP_KEYWORDS

THis is a string of one or more keywords to use to designate a file to be included into the output file passed on to `just`

The default is 'include import require with' where each keyword is a designation in the input file for an inclusionary action on a designated file path.  You do not have to use all or any.  Personnally I've pretty much standardized on "with" as my perfered keyword.  You may use whatever makes you happy.  Nor do you have to use the suggested ones in my list.  Make up you own if you like.

Why does just prep support more than one inclusionary keyword marker?  Well, each computer language has its own syntax flavor.  The examples above or consistent with Ruby, Java-ish, Ada, Perl and others.  Use what feels right to you.


### JUSTPREP_MODULE_KEYWORD

The default is "module" however you can use whatever seems right to you.  Do not use the same keyword as any of the inclusionary keywords defined in JUSTPREP_KEYWORDS.  That would cause problems.

TODO: generate an error if JUSTPREP_MODULE_KEYWORD value is included in the value for JUSTPREP_KEYWORDS.

This keyword provides different functionality than the inclusionary keywords defined by the JUSTPREP_KEYWORDS system environment variable.  The `justprep` utility implements a convention that involves the use of specific variable names and generated recipes to implement a "fake module" system.  This is a stop-gap functionality created to explore how modules could be used.

More detail on the Fake Module Convention is TBD.


### JUSTPREP_FILENAME_IN

This specifies the name of the file that is to be used as input into `justprep` to be processed into the output file that goes to `just`.

The default value is "main.just" but you can use whatenver filename you want.

Remember this is a filename and not a path.


### JUSTPREP_FILENAME_OUT

This is the name of the file that is created by `justprep` which is passed on to `just`

The default is "justfile" because that is the default that `just` uses.  Its possible to use other file names but you have to tell `just` via its `--justfile` command line option the name of the file.

Remember this also is a file name and not a path.  It will be the name of the file that is created by `justprep` in the same directory where the `JUSTPREP_FILENAME_IN` is located.


## Install

First you need `just` which is easy enough to install (unless you are not on a Mac or other great platform) using the `brew` package manager:

```bash
$ brew install just

```

There are a few different options for you to get `justprep`

### RubyGem

`justprep` is available as a Ruby Gem.  To install the gem do:

```bash
$ gem install justprep

```

### Crystal version

Also notice that in this repository there is a version of `justprep` implemented in Crystal.


#### With Homebrew

There is a preliminary version packaged with `homebrew` you can install this by running:

```bash
$ brew install lutostag/brews/justprep

```

#### Precompiled binaries

Binary releases are available at https://github.com/MadBomber/justprep/releases/latest they are currently compiled for macos and linux (on the x86_64 architecture).

You should be able to download the binaries and use them directly.

```bash
# Download the matching binary from https://github.com/MadBomber/justprep/releases/latest
$ chmod a+x justprep-*
$ mv justprep-* ~/.bin/justprep # or other appropriate directory
```

#### From Source

To use the Crystal executable instead of the Ruby Gem version you will need to do a few more things.

```bash
$ brew install crystal
$ git clone http://github.com/MadBomber/justprep
$ cd justprep 
$ export RR=`pwd`
$ just install /usr/local/bin  # you can install to a different directory if you wish

```

## Shell Configuration and My Conventions
### Simple Configuration
In your favorite shell, setup the system environment variables and an alias that invokes `justprep` before `just`

```bash
alias jj='justprep && just'

# These values are the defaults.  Replace with your choice or if
# you like the defaults, you do not need the setup the shell variables.

export JUSTPREP_KEYWORDS='include import require with'
export JUSTPREP_FILENAME_IN=main.just 
export JUSTPREP_FILENAME_OUT=justfile

```

### My BASH Shell Configuration

This is my configuration.  If you are using the `just` and thinking about `justprep`, you are more than capable of coming up with your own conventions for configuring shell tools.

#### .bashrc

In my `.bashrc` file I source all files in my home directory that have the pattern `.bashrc__*` 

```bash
# ... <snip>

########################################################
## Setup additional Plugins/Packages

for file in  ~/.bashrc__*   ; do
    if [ -f $file ]; then
        echo -n "Loading $file ... "
        source $file
        echo "done."
    fi
done

# ... <snip>
```

#### .bashrc__just

so what I did is create a file `.bashrc__just` that holds my configuration for `justprep` and `just` - Here is what it looks like:

```bash
# ~/.bashrc_just
# brew install just
# gem install justprep or its crystal version

# Use the crystal version of justprep
alias jj='~/bin/justprep && just'

export JUSTPREP_KEYWORDS='include import require with'
export JUSTPREP_FILENAME_IN=main.just 
export JUSTPREP_FILENAME_OUT=justfile

```

### $HOME the .justfile Convention

In my home directory I have a file named `.justfile` which has the following content:

```bash
# ~/.justfile

set positional-arguments := true

# List available recipes
@list:
  echo
  echo "Available Recipes at"
  echo `pwd`
  echo "are:"
  echo
  just -l --list-prefix 'jj ' --list-heading ''
  echo

```

Now in every `main.just` file in all my projects I have it start like this to take advantage of the standardized recipe list format:

```bash
# ~/**/main.just

with ~/,justfile

# ... other inclusionary directives

# ... project-specific recipes, etc.

```

## The Just List aka Help/Usage Output

I keep going back and fornth over naming the first recipe (the default recipe) in my justfiles.  The `just` command line option that is used in my default recipe is called list.  I then to think of it as help.  As the default recipe it is the one that is executed whenever `just` is invoked without specifying a recipe.

Here is what shows up in my terminal when I execute `just` in this repository's root directory:
```bash
$ just

Available Recipes at
/Users/dewayne/sandbox/git_repos/madbomber/justprep
are:

just build       # Build both Ruby Gem and Crystal versions
just bump level  # Bump version level: major.minor.patch
just help        # Displays this list of available recipes
just install     # Install both Ruby Gem and Crystal versions
just set version # Set the version to major.minor.patch
just test        # Test both the Ruby Gem and the Crystal Executable
just version     # Show current source version

```

There are more recipes than this in the repository root ($RR) than just these.  The others are hidden.  Any `just` recipe that begins with the underscore character '+' is defined as a hidden recipe and will not be included in the `just -l` command.

## Process

`justprep` reads the `$JUSTPREP_FILENAME_IN` file from the current working directory.  If there is not one there, it then goes up the directory hierarchy until it finds one or until there is no more directory places to look.

Once the input file is found, `justprep` reads its entire contents into memory.  It then starts looking for any `$JUSTPREP_KEYWORDS` in the contents.  For each one it finds it takes the stuff after the keyword to the end of line as a path to a file that is to have its contents included.  That content is insert into the same place as the keyword line.

As part of that insert a header and a footer line are added to the imported file's contents as a way to signal from where the content came.

Once the entire input file has been processed, its contents with its recently inclued content from other files, is written out to the `$JUSTPREP_FILENAME_OUT` file.

### Example Input File:  `main.just`
```bash
# ~/sandbox/git_repos/madbomber/main.just

with ~/.justfile

@hello:
  echo "Hello World"

```

### Example Output File: `justfile`
```bash
# ~/sandbox/git_repos/madbomber/main.just


# >>> /Users/dewayne/.justfile
# ~/.justfile
# brew install just
# gem install justprep
# alias jj='justprep && just'

set positional-arguments := true

# List available recipes
@list:
  echo
  echo "Available Recipes at"
  echo `pwd`
  echo "are:"
  echo
  just -l --list-prefix 'jj ' --list-heading ''
  echo

# <<< /Users/dewayne/.justfile


@hello:
  echo "Hello World"
```

#### Error Messages from `just`

If there are any errors detected by the `just` utility, they will show and reference the exact line number in the output file.  Its easy enought to find the source of the error even if it is in one of the included files due to the header and footer banners placed before and after the inclued file content.


## Path to a File to be Included

The path to the file to be included, imported, required or with'ed etc. follows the inclusionary keyword.  
```bash
<keyword> <space> <path-to-file-to-be-included>

```
It can be an absolute path (begins with a '/' character) or relative.  If relative, then "Relative to what?" is a good question.  A good answer is "Relative to the location of the `$JUSTPREP_FILENAME_IN` file."  That is the file location that just included the relative file.

The path to the file to be included can make use of system environment variables in either the $VAR form or ${VAR} form.  Also the tilde character `~` if present as the first character of the file path is taken as a shortcut to the user's home directory.

### Examples Using Shell Variables in path-to-include-file
```bash
with    ~/.justfile
include $HOME/.justfile
import  /Users/dewayne/.justfile
require ../${PROJECT}_common_tasks/${ENVIRONMENT}_tasks.just
```

Noticed I used multiple spaces after the keyword.  There only needs to be one; but, I like using extra spaces to align the file paths becuase it makes it easier for me to see what is intended.

## Limitations

* filenames may not contain `just` variables
* the keyword must start in column 1 and be followed by at least one space
* included files may not contain inclusionary keywords - only single-level inclusions are allowed - you cannot include a file that also includes another file
* the file must be present and not a directory otherwise an error message is sent to STDERR and the exit code is set to 1

## Error Messages

### From `justprep`

When a filename does not exist, an ERROR message will be written to STDERR.  The exit code will be set to 1.

There is also a WARNING message that comes to STDERR when `justprep` does not find a JUSTPREP_FILENAME_IN file it the current directory hierarchy.  The exit code is still set to zero which allows the `just` program to execute.

### From `just`

Any errors in syntax, duplication of recipes etc. from just will will relative to the output file from `justprep` which may be found in the included files.  Review the outfile file at the line number provided.  If it is in an inclued file, you can easily find out which file requires the fix by looking at the header/foot banners that surround the included file content.

### Example of a `just` Error

Here is the error:
```bash
$ jj
error: Expected character `=`
   |
10 | !output: 'Hello world'
   |  ^
```
... and here is the output file which generated the error:
```bash
$ cat -n justfile
     1
     2  # >>> /Users/dewayne/Documents/sandbox/git_repos/madbomber/error.just
     3
     4  world: hello
     5    echo 'world'
     6
     7  hello:
     8    echo -n 'hello '
     9
    10  !output: 'Hello world'
    11
    12  # <<< /Users/dewayne/Documents/sandbox/git_repos/madbomber/error.just
    13
    14  doit: world
```
You can see that line 10 is clearly within the banners giving the absolute path to the file which was included that contains the error noted by the `just` tool.

## Testing

From the repository root directory use `just test` to execute the tests for both the Ruby Gem version and the Crystal version.  Here is the output that I get:

```bash
jj test
crystal build --no-debug --release -p -o bin/justprep justprep.cr version.cr
justprep 1.0.1 built to pkg/justprep-1.0.1.gem.
justprep (1.0.1) installed.
Tests PASSED
```

In the `justprep/test` there is a file named `expected.txt` that contains the expected results of the various test scripts.  It is compared via `diff` to the file `results.txt` that is generated from the test scripts.  If there is any difference the test has failed.  On failure the difference between results.txt and expected.txt will be echo'ed to the terminal.

# Organization

This repository contains two versions of the `justprep` pre-processor.  One is implemented as a Ruby Gem.  The other is implemented in Crystal.  While Crystal shares some of the syntax as Ruby, not all Ruby code is directly usable by Crystal which is too bad; but, they are close enough to be fun.

## Ruby Gem Version

TODO: Put stuff about the Ruby Gem here ...
`gem install justprep`

The file crystal_methods.rb aliases Ruby methods for various classes to match the method names that are in the Crystal library.  This allows for the Ruby and Crystal implementations to share common code files.

## Crystal Version

TODO: Put stuff about the Crystal Version here ...


# Fake Module Convention

This is a convention which is usable in plain justfiles that does not require the use of justpre; however, justprep implements the convention in a why that simplifies its useage.

In a nutshell any `just` recipe can invoke the `just` utility with the `-f` option to execute against a different justfile along with recipes located in that `justfile`.

### Example without `justprep`

You could have a recipe that looks like this:

```bash
aaa recipe='':
  just -f path/to/module/aaa/justfile {{recipe}}
```

Treating `aaa` like a module name you can then invoke the other recipe like this:
`just aaa xyzzy`

### Example using `justprep`

What `justprep` does is allow you to have lines in your `main.just` file that look like this:

```bash
module aaa path/to/module/aaa/justfile
module bbb /path/to/modules/bbb.just
```

`justprep` will replace this "module" line with a variable definition that is assigned the value of the path to the module's `justfile`.  It then appends to the end of the `main.just` file the methods for each of the modules defined.  These new methods are one per module defined.  They invoke the `just -f {{module_justfile_path}} {{recipe}}`

A useful recipe to add to your `main.just` is a `list_all` method to list all of the recipes that are in the existing `main.just` file and of the modules that have been defined.

TODO: Reorganize this README.md file into a github wiki
