skim
===

**skim** command for unix environments.

- Non-unix way to do unix.
- Breadth-first search.
- Simplified find.
- Sensible output.
- When you don't have Sublime open.

## Installation

You will need `Node.js` version at least 0.6.x

Copy the file `skim` to your preferred `bin` folder.

Install `commander`.js to your `bin` folder (either with `npm install commander` or by copying from here).

## Examples

```bash
$ skim looking_for.txt
```

```bash
$ skim where/ looking_for.txt
```

Note the `/` at the end of folder name is important.

```bash
$ skim ".*\.js"
```

```bash
$ skim -d "\w+_\w+\"
```

```bash
$ skim -m 3 -n 1 fast.coffee
```

## Documentation

```bash
$ skim --help

  Usage: skim [options] [where] <regexp ...>

  Options:

    -h, --help          output usage information
    -V, --version       output the version number
    -w, --where <path>  Path to start search in
    -m, --max <n>       Maximum depth to search into, 1 is minimum
    -n, --number <n>    Return the first n results and stops
    -t, --top           Return the first result and all results at that depth
    -d, --dir           Look for directories only
    -f, --file          Look for files only

By default, tries to find all results. Search location
can also be specified in the first argument, but named
folders must end with '/' or '\'.
```
