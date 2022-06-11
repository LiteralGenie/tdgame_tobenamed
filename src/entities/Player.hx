package entities;


class Player {
    public var knights: Array<Knight>;

    public function new() {
        this.knights = [for(_ in 0...5) new Knight()];
        for(ent in this.knights) {
            Game.mvMgr.registerSelectable(ent);
        }
    }

    public function update(dt: Float) {
        for (ent in this.knights) {
            ent.update(dt);
        }
    }
}