Crafty.scene 'Main', ->
  Game.map = Crafty.e('Map').map(grassland[Game.engine.tileSize.toString()])
  Game.map.getEntitiesInLayer('Obstacles').forEach (o) ->
    o.addComponent('Solid')

  Game.pc = Crafty.e 'Player'
  Game.pc.attr({x: Game.engine.tileSize * (Math.floor Game.engine.mapWidth / 2), y: Game.engine.tileSize * (Math.floor Game.engine.mapHeight / 2), z: 100})
  Game.engine.queue.append Game.pc

  #window.monster = Crafty.e 'NPC'
  #monster.attr({x: Game.pc.x - (Game.engine.tileSize * 3), y: Game.pc.y - (Game.engine.tileSize * 2)})
  #Game.engine.queue.append monster

  biome = Crafty.e 'Biome'
  biome.fill()
  biome.creatures.forEach (c) ->
    allNodes = _.flatten c.pathfindingGrid().nodes
    availableTiles = allNodes.filter((n) -> n.walkable)
    start = _.sample availableTiles
    c.x = Game.map.tilesToPixels start.x
    c.y = Game.map.tilesToPixels start.y
    Game.engine.queue.append c

  window.pet = Crafty.e 'Hoppy'
  pet.x = Game.map.tilesToPixels(Game.pc.location().x - 2)
  pet.y = Game.map.tilesToPixels(Game.pc.location().y - 2)
  Game.engine.queue.append pet

  Game.pc.act()

  Game.sidebar = Crafty.e 'Sidebar'

  Crafty.viewport.follow Game.pc, 0, 0

  Game.logger = Game.Logger.create()

  Game.Router.router.transitionTo '/start'

  Game.logger.info 'Welcome to the game!'
