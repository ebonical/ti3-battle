class Dice
  @roll: (count = 1) ->
    while count-- > 0
      Math.floor(Math.random() * 10) + 1
