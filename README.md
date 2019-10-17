# xccov2lcov

**Warning** This is a work in progress. Use at your own risk.

A utility to convert data from Xcode 11's code coverage facility into the `lcov` file format, intended for upload to Coveralls.io.

```
Usage:

    $ xccov2lcov <inputFilename>

Arguments:

    inputFilename - Input filename (output of `xccov view --report --json file.xcresult`)

Options:
    --trim-path [default: ] - Path to trim from start of paths in input file
    --include-targets [default: []] - Targets to include in output (default: all targets)
```
