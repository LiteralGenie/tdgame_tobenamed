package services;

import utils.Misc;


/**
 * Handles...
 *  - User selection and movement of units
 *  - Pathfinding for in-transit units
 */
class MovementManager {
    var ixnMoveSelected: h2d.Interactive;

    public function new() {
        var s2d = Game.instance.s2d;
        
        this.ixnMoveSelected = new h2d.Interactive(s2d.width, s2d.height, s2d);
        ixnMoveSelected.onPush = this.onMapClickDown;
        ixnMoveSelected.onRelease = this.onMapClickUp;
    }

    var selectable: Array<SelectableEntity> = [];
    var dragContext: Null<DragContext>;
    static var MIN_DRAG_DISTANCE = 10;

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
     * Move selected units
     * @param ev 
     */
    function moveSelected(ev: hxd.Event): Void {
        for(ent in this.selectable) {
            if(!ent.selected) continue;

            ent.pos.x = ev.relX;
            ent.pos.y = ev.relY;
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

    function onMapClickDown(ev: hxd.Event): Void {
        this.dragContext = {
            start: new Point2D(ev.relX, ev.relY)
        };
    }

    /**
     * Determine whether a click was intended for selecting multiple units (end of a drag) or issuing a movement order (single click)
     * @param ev 
     */
    function onMapClickUp(ev: hxd.Event): Void {
        // Check if distance constitutes a drag
        var dragDistance = 0.0;
        var clickLoc = new Point2D(ev.relX, ev.relY);
        if(this.dragContext != null) {
            var dist = clickLoc.sub(this.dragContext.start);
            dragDistance = Math.sqrt(Math.pow(dist.x, 2) + Math.pow(dist.y, 2));
        }
        if(dragDistance > MIN_DRAG_DISTANCE) {
            this.selectUnits(this.dragContext.start, clickLoc);
        } else {
            this.moveSelected(ev);
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