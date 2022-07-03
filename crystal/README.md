# `justprep`

Just a CLI pre-processor tool for task runners like "just" my current favorite.

This directory is the codebase for the Crystal version; however, a large number of files used in this implementation are also used by the Ruby gem version.  They are kept in the [common directory](https://github.com/MadBomber/justprep/tree/main/ruby/lib/justprep/common) using the file extension \*.crb meaning that the file is usable by both Crystal and Ruby.

### Installation for the Ruby version

    gem install justprep

### Installation for the Crystal version

    brew install --build-from-source MadBomber/tap/justprep

### Building from this directory

```bash
just build
```

The `justfile` provides the following tasks:

```bash
just build                          # Builds the crystal version of justprep
just compile                        # alias for `build`
just help                           # List available recipes
just install where="/usr/local/bin" # Install the justprep executable in ~/bin
just install_shards                 # Run `shards install`
```

The only shard used is `minitest` however, the units tests for this implementation are currently disabled.

### Documentation

Since this capability is implemented in both Ruby and Crystal there is only one set of documentation.  Both implementations act the same way.  See the [repository's Wiki](https://github.com/MadBomber/justprep/wiki) for details.


### Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/justprep.

If you have a different CLI task runner than what justprep currently supports, let me know so we can add it to the support list.

## License

justprep is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
