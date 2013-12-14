Crafty.c 'Biome',
  init: ->
    @incumbentSpecies = ['Stinger', 'Hoppy', 'Hentacle']
    @creatures = []
    @extent = Game.map.height() * Game.map.width()
    @extentFilled = 0

  filled: ->
    @extentFilled > @extent

  fill: ->
    this.addSpecies() until this.filled()

  addSpecies: ->
    species = _.sample @incumbentSpecies
    creature = Crafty.e species
    @creatures.push creature
    throw 'Biome weight must be defined for creatures!' unless creature.biomeWeight
    @extentFilled += creature.biomeWeight
