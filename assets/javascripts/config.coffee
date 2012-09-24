_.templateSettings =
  interpolate : /\{\{(.+?)\}\}/g

_.mixin
  pluralize: (count, singular, plural) ->
    plural ?= singular + "s"
    if count is 1 then singular else plural

String.prototype.pluralize = (count, plural) ->
  _.pluralize(count, @toString(), plural)
