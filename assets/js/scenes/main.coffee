Crafty.scene 'Main', ->
  Game.map = Crafty.e('Map').map(grassland[Game.engine.tileSize.toString()])
  Game.map.getEntitiesInLayer('Obstacles').forEach (o) ->
    o.addComponent('Solid')

  Game.pc = Crafty.e 'Player'
  Game.pc.attr({x: Game.engine.tileSize * (Math.floor Game.engine.mapWidth / 2), y: Game.engine.tileSize * (Math.floor Game.engine.mapHeight / 2), z: 100})
  Game.engine.queue.append Game.pc

  window.monster = Crafty.e 'NPC'
  monster.attr({x: Game.pc.x - (Game.engine.tileSize * 3), y: Game.pc.y - (Game.engine.tileSize * 2)})
  Game.engine.queue.append monster

  Game.pc.act()

  Crafty.viewport.follow Game.pc, 0, 0
