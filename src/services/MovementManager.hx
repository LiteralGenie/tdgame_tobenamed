package services;

import utils.Misc;

/**
    Notes:
        - Mixing methods that handle user input and more pure methods is kinda gross to read.
          Is there a way to split these out?
**/

/**
 * Handles...
 *  - User selection and movement of units
 *  - Pathfinding for in-transit units
 */
class MovementManager {
    static var MIN_DRAG_DISTANCE = 10;

    var dragContext: Null<DragContext>;
    var ixnMoveSelected: h2d.Interactive;
    var selectable: Array<SelectableEntity> = [];

    public function new() {
        this.registerMapClickListeners();
    }

    public function move(ent: MoveableEntity, pos: Point2D) {
        
    }

    /**
     * Allow the user to move an entity
     * @param ent
     */
    public function registerSelectable(ent: SelectableEntity) {
        this.selectable.push(ent);

        var ixnSelect = new h2d.Interactive(ent.size.x, ent.size.y, ent.sprite);
        ixnSelect.onClick = function(ev) {
            for(ent in this.selectable) ent.selected = false;
            ent.selected = true;
        }

        // @todo return deregister function
    }

    /**
     * Determine whether a click was intended for selecting multiple units (drag) or issuing a movement order (single click)
     */
    function registerMapClickListeners() {
        var s2d = Game.instance.s2d;
        this.ixnMoveSelected = new h2d.Interactive(s2d.width, s2d.height, s2d);
        
        // Track position of mousedowns
        ixnMoveSelected.onPush = function(ev) {
            this.dragContext = {
                start: new Point2D(ev.relX, ev.relY)
            };
        };

        // Check if mouseup triggered a drag or single-click
        ixnMoveSelected.onRelease = function(ev) {
            // Calculate drag distance
            var dragDistance = 0.0;
            var clickLoc = new Point2D(ev.relX, ev.relY);
            if(this.dragContext != null) {
                var dist = clickLoc.sub(this.dragContext.start);
                dragDistance = Math.sqrt(Math.pow(dist.x, 2) + Math.pow(dist.y, 2));
            }

            // Check if distance qualifies as an intentional drag
            if(dragDistance > MIN_DRAG_DISTANCE) {
                this.selectUnits(this.dragContext.start, clickLoc);
            } else {
                this.moveSelected(ev);
            }
        }
    }
    /**
     * Mark units inside the input region as selected
     * @param start 
     * @param end 
     */
    function selectUnits(a: Point2D, b: Point2D): Void {
        // Select units that lie in input region
        // @todo sort selected for efficiency
        for(ent in this.selectable) {
            ent.selected = ent.pos.isBounded(a,b);
        }
    }
    function moveSelected(ev: hxd.Event): Void {
        for(ent in this.selectable) {
            if(!ent.selected) continue;

            ent.pos.x = ev.relX;
            ent.pos.y = ev.relY;
        }
    }
}

typedef DragContext = {
    start: Point2D
}

typedef MoveableEntity = {
    var pos: Point2D;
    var speed: Float;
    var size: Point2D;
    var sprite: h2d.Bitmap;
}

typedef SelectableEntity = {
    > MoveableEntity,
    selected: Bool
}