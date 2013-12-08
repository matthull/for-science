Crafty.c 'Creature',
  creature: (attributes) ->
    this.attributes = Game.Attributes.create attributes

  rollAgainst: (die, attribute) ->
    count = @attributes[attribute].current
    results = []

    _(count).times ->
      results.push _.sample(die)

    results
