package utils;

class Point2D {
    public var x: Float;
    public var y: Float;
    public function new(x: Float, y: Float) {
        this.x = x;
        this.y = y;
    }

    public function sub(other: Point2D): Point2D {
        return new Point2D(
            this.x - other.x,
            this.y - other.y
        );
    }

    public function isBounded(a: Point2D, b: Point2D): Bool {
        function _isBounded(val: Float, a: Float, b: Float): Bool {
            var result = compareFloats(val, a) + compareFloats(val, b);
            return result == 0;
        }
    
        return _isBounded(this.x, a.x, b.x) && _isBounded(this.y, a.y, b.y);
    }
}

function compareFloats(a: Float, b: Float): Int {
    if(a < b) return -1;
    else if(a == b) return 0;
    else return 1;            
}