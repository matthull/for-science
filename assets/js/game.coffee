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
    Crafty.canvas.init()
    Crafty.viewport.init engine.viewportWidth, engine.viewportHeight
    Crafty.viewport.clampToEntities = false
    Crafty.sprite("images/stinger.png", {StingerSprite: [0,0,engine.tileSize,engine.tileSize]})

    Crafty.sprite("images/hentacle.png", {HentacleSprite: [0,0,engine.tileSize,engine.tileSize]})
    Crafty.sprite("images/lure-64x64.png", {PlayerSprite: [0,0,engine.tileSize,engine.tileSize]})

    Crafty.sprite 64, "images/bug/head/1.png", bugHead1: [0,0]
    Crafty.sprite 64, "images/bug/body/1.png", bugBody1: [0,0]
    Crafty.sprite 64, "images/bug/tail/1.png", bugTail1: [0,0]
    Crafty.sprite 64, "images/bug/legs/1.png", bugLegs1: [0,0]

    Crafty.scene 'Main'
