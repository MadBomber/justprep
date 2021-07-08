# justprep
A pre-processor for the "just" command line utility.
https://github.com/casey/just

Casey's `just` utility is such a useful tool; but, it has one thing that bothered me - the inability to inherently include recipies from other files.  For those of us who work on many projects in parallel the ability to share recipes (effective code reuse / modularization) is an important feature.  Its advantages are:

* provides for smaller more easily maintained files
* more cohesive file content
* shared recipes between projects

Allowing this flexibility also opens up some use cases which are not supported by the `just` utility - the ability to over-ride a recipe, for example.  Duplicate recipes (and aliases) are treated by `just` as errors.  Allowing the inclusion of multiple files into a single project specific `justfile` can lead to having duplicate recipes.  These are easily found and can be dealt with manually.


## System Environment Variables

`justprep` in both its Ruby Gem form and its binary executable via Crystal is controlled by the following environment variables.


### JUSTPREP_KEYWORDS

THis is a string of one or more keywords to use to designate a file to be included into the output file passed on to `just`

The default is 'include import require with' where each keyword is a designation in the input file for an inclusionary action on a designated file path.  You do not have to use all or any.  Personnally I've pretty much standardized on "with" as my perfered keyword.  You may use whatever makes you happy.


### JUSTPREP_FILENAME_IN

This specifies the name of the file that is to be used as input into `justprep` to be processed into the output file that goes to `just`.

The default value is "main.just" but you can use whatenver filename you want.

Remember this is a filename and not a path.


### JUSTPREP_FILENAME_OUT

This is the name of the file that is created by `justprep` which is passed on to `just`

The default is "justfile" because that is the default that `just` uses.  Its possible to use other file names but you have to tell `just` via its `--justfile` command line option the name of the file.

Remember this also is just a file name and not a path.  It will be the name of the file that is created by `justprep` in the same directory where the `JUSTPREP_FILENAME_IN` is located.


## Install

First you need `just` which is easy enough to install (unless you are not on a Mac or other great platform) using the `brew` package manager:

```bash
$ brew install just

```

`justprep` is available as a Ruby Gem.  To install the gem do:

```bash
$ gem install justprep

```

Also notice that in this repository there is a version of `justprep` implemented in Crystal.  I've used Crystal version 1.0.0 to compile it for my use.

To use the Crystal executable instead of the Ruby Gem version you will need to do a few more things.  First have Crystal installed.

```bash
$ brew install crystal
$ git clone http://github.com/MadBomber/justprep
$ cd justprep 
$ just install

```

The `install` recipe will compile and then move the executable to the default location `/usr/local/bin`

If you do not have `/usr/local/bin` as part of your $PATH, or you just want the executable installed in a different directory that is in your $PATH you can do this:

```bash
$ just install ~/bin

```

`~/bin` is just where I put mine.  You can put yours wherever you want.

See what other recipes are in this `justfile` by doing this:

```bash
$ just
```

## Usage

In my `.bashrc` file I source all files in my home directory that have the pattern `.bashrc__*` so what I did is create a file `.bashrc__just` that holds my configuration for `justprep` and `just` - Here is what it looks like:

```bash
# ~/.bashrc_just
# brew install just
# gem install justprep or its crystal version

# Use the crystal version of justprep
alias jj='~/bin/justprep && just --no-dotenv'

export JUSTPREP_KEYWORDS='include import require with'
export JUSTPREP_FILENAME_IN=main.just 
export JUSTPREP_FILENAME_OUT=justfile

```

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
  just -l --list-prefix 'just ' --list-heading ''
  echo

```

Now in every `main.just` file in all my projects I have it start like this to take advantage of the standardized recipe list:

```bash
# ~/**/main.just

with ~/,justfile

# ... other inclusionary directives

# ... project-specific recipes, etc.

```

## Process

`justprep` reads the `$JUSTPREP_FILENAME_IN` file from the current working directory.  If there is not one there, it then goes up the directory hierarchy until it finds one or until there is no more directory place to look.

Once the input file is found, `justprep` reads its entire contents into memory.  It then starts looking for any `$JUSTPREP_KEYWORDS` in the contents.  For each one it finds it takes the stuff after the keyword to the end of line as a path to a file that is to have its contents included.  That content is insert into the same place as the keyword line.

As part of that insert a header and a footer line are added to the imported file's contents as a way to signal from where the content came.

Once the entire input file has been processed, its contents with its recently inclued content from other files, is written out to the `$JUSTPREP_FILENAME_OUT` file.


## Path to a File to be Included

The path to the file to be included, imported, required or with'ed etc. follows the inclusionary keyword.  It can be an absolute path or relative.  If relative, then "Relative to what?" is a good question.  A good answer is "Relative to the location of the `$JUSTPREP_FILENAME_IN` file."

The path to the file to be included can make use of system environment variables in either the $VAR form or ${VAR} form.  Also the tildi character `~` if present as the first character of the file path is taken as a shortcut to the user's home directory.


## Limitations

* filenames may not contain `just` variables
* the keyword must start in column 1 and be followed by at least one space
* included files may not contain inclusionary keywords - only single-level inclusions are allowed
* does not check for duplicatione recipes, alias etc. so when duplicates exist the just utility will issue an error message
* the file must be preset and not a directory


## Error Messages

When a filename does not exist, an ERROR message will be written to STDERR.  The exit code will be set to 1.

