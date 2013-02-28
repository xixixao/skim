#!/usr/bin/env coffee

fs = require 'fs'
path = require 'path'
exec = require('child_process').exec
util = require 'util'
program = require 'commander'

isDirectory = (filePath) ->
  fileStats = fs.statSync filePath
  fileStats.isDirectory() &&
  (
    filePath[filePath.length - 1] in ['/', '\\'] ||
    path.basename(filePath) in ['.', '..']
  )

program
  .version('0.1.0')
  .usage('[options] [where] <regexp ...>')
  .option('-w, --where <path>', 'Path to start search in')
  .option('-d, --depth <n>', 
    'Maximum depth to search into, 1 is minimum', parseInt)
  .option('-f, --first', 'Return the first result and stop')
  .option('-t, --top', 
    'Return the first result and all results at that depth')
  .parse(process.argv);

program.on '--help', ->
  console.log "By default, tries to find all results. Search location" +
              "can also be specified in the first argument, but named" +
              "folders must end with '/' or '\\'."

program.depth ?= Infinity

if !program.where? && program.args.length > 1 && isDirectory program.args[0]
  program.where = program.args.shift()

program.where ?= '.'

patterns = for given in program.args
  try
    new RegExp "^#{given}$"
  catch e
    console.error "Error using: #{given}"
    console.error e.message
    process.exit 1


isSearchable = (filePath) ->
  fileStats = fs.statSync filePath
  fileStats.isDirectory() && !filePath.match(/(\.git|\.svn)$/)?

success = false

compare = (filename, filePath) ->
  for pattern in patterns
    if filename.match(pattern)?
      console.log filePath
      success = true
      if program.first
        process.exit 0
      return

currentDepth = 1
currentLevel = 1
nextLevel = 0
locations = []


searchLocation = (dir) ->
  for loc in fs.readdirSync dir
    filePath = path.join dir, loc
    compare loc, filePath
    if isSearchable filePath
      locations.push filePath
      nextLevel++
  currentLevel--
  if currentLevel == 0
    currentLevel = nextLevel
    nextLevel = 0
    currentDepth++
    if success && program.top
      process.exit 0
  if currentDepth > program.depth || locations.length == 0
    return
  searchLocation locations.shift()

if !isDirectory program.where
  console.error "Given search location is not a directory"
  process.exit 1

searchLocation program.where



