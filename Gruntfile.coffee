module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    mochaTest:
      test:
        options:
          require: 'coffee-script'
        src: ['test/**/*.coffee']

  grunt.loadNpmTasks 'grunt-mocha-test'

  grunt.registerTask 'test', ['mochaTest']
  grunt.registerTask 'default', ['test']