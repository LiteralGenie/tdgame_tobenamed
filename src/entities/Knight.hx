package entities;

import debug.Debug.randomSprite;
import debug.Debug.randomPos;
import utils.Misc;

class Knight {
    public var isSelected: Bool = false;
    public var pos: Point2D;
    public var size: Point2D;
    public var speed: Float;
    public var sprite: h2d.Bitmap;

    public function new() {
        this.pos = randomPos();
        this.sprite = randomSprite(Game.instance.s2d);
        this.size = new Point2D(100, 100);
        this.speed = 10;
    }

    public function update(dt: Float) {
        this.updateView(dt);
    }

    function updateView(dt: Float) {
        this.sprite.x = this.pos.x;
        this.sprite.y = this.pos.y;
    }
}