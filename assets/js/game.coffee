#= require_tree support
#= require_tree components
#= require_tree scenes
#= require_tree models
#= require_tree controllers
#= require_tree views
#= require router

window.startGame = ->
    engine = Game.engine = Crafty.e 'Engine'
    Crafty.init engine.mapHeight * engine.tileSize, engine.mapHeight * engine.tileSize
    Crafty.background '#000'
    Crafty.viewport.init engine.viewportWidth, engine.viewportHeight
    Crafty.viewport.clampToEntities = false
    Crafty.sprite("images/insect-64x64.png", {Creature1: [0,0,engine.tileSize,engine.tileSize]})
    Crafty.sprite("images/lure-64x64.png", {PC: [0,0,engine.tileSize,engine.tileSize]})

    Crafty.scene 'Main'
