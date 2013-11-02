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

exports.di = (ctx, fn) ->
  # Regex stolen from Angular.js =0
  R_FN_ARGS = /^function\s*[^\(]*\(\s*([^\)]*)\)/m;

  fn_str  = Function.prototype.toString.call fn
  fn_args = fn_str.match(R_FN_ARGS)[1].split ','

  ctx.$provider =
    register: (name, module) -> ctx[name] = module

  args = []
  for arg in fn_args
    arg = arg.replace /\s*/, ''
    throw new Error "\"#{arg}\" is not in the DI Context" unless ctx[arg]?
    args.push ctx[arg]

  fn.apply(null, args)

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