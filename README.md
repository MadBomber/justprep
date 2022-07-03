# `justprep`

Just a CLI pre-processor tool for task runners like "just" my current favorite.

`justprep` is implemented as a Ruby gem and as a Crystal binary.  A large part of the code base is shared between Ruby and Crystal.  These common files have the file extension \*.crb to indicate that they are both Crystal and Ruby.

There is no specific speed benchmark between the two implementations.  I can't perceive any specific speed of processing differences between the two implementations with the small sets of task files that I use.  Its really a matter of your project workflow.  If your projects are primarily Ruby, then install the Ruby gem version.  If you do not primarily use Ruby (why not?  Its a GREAT language!) then install the Crystal version.

### Installation for the Ruby version

    gem install justprep

### Installation for the Crystal version

    brew install --build-from-source MadBomber/tap/justprep

### Documentation

Since this capability is implemented in both Ruby and Crystal there is only one set of documentation.  Both implementations act the same way.  See the [repository's Wiki](https://github.com/MadBomber/justprep/wiki) for details.

#### CLI Task Runners Supported
* [just](https://github.com/casey/just)

### Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/justprep.

If you have a different CLI task runner than what justprep currently supports, let me know so we can add it to the support list.

## License

justprep is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
