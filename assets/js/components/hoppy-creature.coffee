Crafty.c 'Hoppy',
  init: ->
    this.requires 'NPC'
    this.requires '2D'
    this.requires 'Canvas'
    this.requires 'Sprite'
    this.requires 'SpriteAnimation'
    this.requires 'bugBody1'

    this.reel "bounce", 1000, 0, 0, 3
    this.animate "bounce", -1

    ['bugLegs1', 'bugTail1', 'bugHead1'].forEach (part) =>
      e = Crafty.e('Canvas, 2D, Sprite, SpriteAnimation, ' + part)
      this.attach e
      e.reel "bounce", 1000, 0, 0, 3
      e.animate "bounce", -1

    @mood = 'indifferent'
    @biomeWeight = 200
