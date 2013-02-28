#!/usr/bin/env coffee

fs = require 'fs'
path = require 'path'
exec = require('child_process').exec
util = require 'util'
program = require 'commander'

isDirectory = (filePath) ->
  fileStats = fs.statSync filePath
  fileStats.isDirectory()

isDirString = (filePath) ->
  isDirectory(filePath) &&
  (
    filePath[filePath.length - 1] in ['/', '\\'] ||
    path.basename(filePath) in ['.', '..']
  )

doesExist = (filePath) ->
  if fs.existsSync?
    fs.existsSync filePath
  else if path.existsSync?
    path.existsSync filePath
  else
    throw "Node.js missing either path or fs existsSync"

program
  .version('0.1.0')
  .usage('[options] [where] <regexp ...>')
  .option('-w, --where <path>', 'Path to start search in')
  .option('-m, --max <n>', 
    'Maximum depth to search into, 1 is minimum', parseInt)
  .option('-n, --number <n>',
    'Return the first n results and stops', parseInt)
  .option('-t, --top', 
    'Return the first result and all results at that depth')
  .option('-d, --dir', 'Look for directories only')
  .option('-f, --file', 'Look for files only')

program.on '--help', ->
  console.log """By default, tries to find all results. Search location
              can also be specified in the first argument, but named
              folders must end with '/' or '\\'."""

program.parse(process.argv);

program.max ?= Infinity

if !program.where? && program.args.length > 1 && isDirString program.args[0]
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
  isDirectory(filePath) && !filePath.match(/(\.git|\.svn)$/)?

numFound = 0

correctType = (filePath) ->
  if program.dir || program.file
    isDir = isDirectory filePath
    return program.dir && isDir || program.file && !isDir
  return true

compare = (filename, filePath) ->
  for pattern in patterns
    if filename.match(pattern)?
      return unless correctType filePath
      console.log filePath
      numFound++
      if program.number? && numFound == program.number
        process.exit 0
      return

currentDepth = 1
currentLevel = 1
nextLevel = 0
locations = []


searchLocation = (dir) ->
  for loc in fs.readdirSync dir
    filePath = path.join dir, loc
    continue unless doesExist filePath
    compare loc, filePath
    if isSearchable filePath
      locations.push filePath
      nextLevel++
  currentLevel--
  if currentLevel == 0
    currentLevel = nextLevel
    nextLevel = 0
    currentDepth++
    if numFound > 0 && program.top
      process.exit 0
  if currentDepth > program.max || locations.length == 0
    return
  searchLocation locations.shift()

if !isDirectory program.where
  console.error "Given search location is not a directory"
  process.exit 1

searchLocation program.where



