Crafty.c 'Die',
  die: (sides) ->
    @die = [0..5].map (i) ->
      if sides[i] then sides[i] else "blank"
    this

  roll: ->
    _.sample @die
