class ti3.Dice
  @roll: (count = 1) ->
    while count-- > 0
      _.random 1, 10
