LIB_DIR = "#{__dirname}/../lib"

require 'should'
{def, predicate} = require "#{LIB_DIR}/helpers.coffee"

# Predefined functions
greetAndGoodbye = def (name, ret) ->
  ret.greeting = "Hello, #{name}!"
  ret.goodbye  = "Goodbye, cruel #{name}!"
calc = def (x, y, ret) ->
  ret.mul = x * y
  ret.add = x + y


describe 'Utility Helpers', ->

  describe '#def() - allows multi-value returns', ->
    it 'should return multi-values', ->
      # Init
      {greeting, goodbye} = greetAndGoodbye 'World'
      # Asserts
      greeting.should.eql 'Hello, World!'
      goodbye.should.eql 'Goodbye, cruel World!'
    it 'should not collide with other multi-value functions', ->
      # Init
      {greeting, goodbye} = greetAndGoodbye 'World'
      {mul, add} = calc 10, 12
      # Asserts
      greeting.should.eql 'Hello, World!'
      goodbye.should.eql 'Goodbye, cruel World!'
      mul.should.eql 120
      add.should.eql 22

  describe '#predicate() - predicate function helper', ->
    it 'should call target function if predicates return true', ->
      isFriend  = (name) -> name is 'Bacon'
      isMorning = -> yes

      greet = predicate isMorning, isFriend, (name) -> "I love you, #{name}!"

      (greet 'Bacon').should.eql 'I love you, Bacon!'

    it 'should call either "true" or "false" function if last arg is object', ->
      hours = (new Date).getHours()
      isEvening = -> hours >= 18

      greet = predicate isEvening,
        yep: (name) -> "Good evening, #{name}!"
        nope:  (name) -> "Good morning, #{name}!"

      greetingMessage = greet 'Artur'

      if isEvening()
        greetingMessage.should.eql 'Good evening, Artur!'
      else
        greetingMessage.should.eql 'Good morning, Artur!'

    it 'should return false if failed predicates not handled', ->
      isBacon = (name) -> name is 'Bacon'

      greet    = predicate isBacon, -> 'Wazzup, Bacon?!'
      greetObj = predicate isBacon,
        yep: -> 'Bacon is awesome!'

      (greet 'Salt').should.be.false
      (greetObj 'Pepper').should.be.false

    it '#predicate.not() should require false value to satisfy predicate', ->
      isAllowed = (name) -> name is 'Kevin'

      # Reference to Takedown (2000) film :)
      systemAccess = predicate (predicate.not isAllowed),
        nope:  -> "MASTER, I AM HERE TO SERVE YOU"

      (systemAccess 'Tsutomu').should.be.true
      (systemAccess 'Kevin').should.eql "MASTER, I AM HERE TO SERVE YOU"

