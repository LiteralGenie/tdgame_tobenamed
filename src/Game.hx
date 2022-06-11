import services.MovementManager;
import entities.Player;

class Game extends hxd.App {
    public static var instance: Game;
    public static var mvMgr: MovementManager;

    var player: Player;

    override function init() {
        Game.mvMgr = new MovementManager();
        this.player = new Player();
    }
    override function update(dt: Float) {
        this.player.update(dt);
    }
    static function main() {
        Game.instance = new Game();
    }
}