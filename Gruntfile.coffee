#global module:false

"use strict"

module.exports = (grunt) ->
  # Load all grunt tasks matching the ['grunt-*', '@*/grunt-*'] patterns
  require('load-grunt-tasks') grunt              

  path = require('path')
  # Initializing the configuration object
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')    # For Banner Display
    builder:
      app: 'app'      # Not in use
      site: '_site'
    ###
    grunt-build-control
    Publish into github pages
    ###
    buildcontrol:
        options:
          dir: '_site'
          commit: true
          push: true
          message: 'Built %sourceName% from commit %sourceCommit% on branch %sourceBranch%'
        ghpages: options:
          remote: 'https://github.com/codeadoodle/jekyll-d3.git' 
          branch: 'gh-pages'
    ###
    grunt-jekyll
    Compile jekyll files into _site using either dev or prod config
    ###
    jekyll:
      # Create Dev Version with EmptyBaseURL for Local Testing
      development: options:
        config: '_config.yml'
        raw: 'baseurl: '
        incremental: true
      # Create Production Version with Proper BaseURL for Hosting @ GitHub Pages
      production: options: 
        config: '_config.yml'
      # Run jekyll doctor function  
      check: options: doctor: true
    ###
    grunt-contrib-watch
    Watch file changes and perform rebuild task
    ###
    watch:
      source:
        files: [
          "_includes/**/*"
          "_layouts/**/*"
          "_posts/**/*"
          "_pages/**/*"
          "css/**/*"
          "js/**/*"
          "_config.yml"
          "*.html"
          "*.md"
          "**/*.scss"
          "_data/**/*"
        ]
        tasks: [
         # "sass"
          "jekyll:development"
        ]
        options:
          livereload: 35732
    ###
    grunt-contrib-connect
    Setup Livereload Server to read _site folder
    ###
    connect:
      server:
        options:
          port: 4009
          hostname: '*'
          base: '_site'
          livereload: 35732
  # Task definition
  grunt.registerTask "build", [
    "jekyll:development"
  ]
  grunt.registerTask "serve", [
    "build"
    "connect:server"
    "watch:source"
  ]
  grunt.registerTask "default", [
    "serve"
  ]
  # Recompile production version 
  grunt.registerTask "prod", [
    "jekyll:production"
  ]
  # Recompile production version and deploy to GitHub Pages
  grunt.registerTask "deploy", [
    "jekyll:production"
    "buildcontrol:ghpages"
  ]
  # Recompile production version and deploy to GitHub Pages
  grunt.registerTask "push", [
    "buildcontrol:ghpages"
  ]
