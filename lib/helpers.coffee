colors = require 'colors'

# Theme
colors.setTheme
  error: 'red'
  info:  'green'
  warn:  'yellow'

exports.print = (type, msg) ->
  [type, msg] = [msg, type] unless msg?
  
  if type?
    msg = ("[#{type.toUpperCase()}] #{msg}")[type]
  console.log msg

exports.def = (fn) ->
  return ->
    ret  = {}
    fn.call(this, arguments..., ret)
    return ret

predicate = ->
  [predicates..., fn] = arguments

  isObject = fn.constructor is Object

  return ->
    args    = arguments
    isValid = true
    isValid = isValid and p(arguments...) for p in predicates

    if isObject
      if isValid
        return if fn.yep? then fn.yep.apply(this, args) else true
      else
        return if fn.nope? then fn.nope.apply(this, args) else false
    else
      return if isValid then fn.apply(this, args) else false
predicate.not = (fn) ->
  return -> not (fn arguments...)
    
exports.predicate = predicate