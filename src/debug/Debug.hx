package debug;

import h2d.Scene;
import utils.Misc.Point2D;

function randomSprite(scene: Scene) {
    var tile = h2d.Tile.fromColor(Std.random(255*255*255), 100, 100);
    var sprite = new h2d.Bitmap(tile, scene);
    return sprite;
}

function randomPos(x=0, y=0): Point2D {
    return new Point2D(
        x == 0 ? Std.random(1000) : x,
        y == 0 ? Std.random(1000) : y
    );
}