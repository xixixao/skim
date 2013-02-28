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
$ skim "\w+_\w+\.\w+"
```

```bash
$ skim -d 3 -f fast.coffee
```

## Documentation

```bash
$ skim --help
```
