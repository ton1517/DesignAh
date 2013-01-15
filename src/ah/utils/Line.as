package ah.utils
{
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * 描いた線の情報を保持するクラス
     */
    public class Line
    {
        private var _normalized:Boolean = false;

        private var _points:Vector.<Point>;
        private var _region:Rectangle;

        public static function cloneLines(lines:Vector.<Line>):Vector.<Line>
        {
            var nl:Vector.<Line> = new Vector.<Line>();
            for (var i:int = 0; i < lines.length; i++) {
                nl.push(lines[i].clone());
            }

            return nl;
        }

        public function Line(region:Rectangle)
        {
            _region = region;
            _points = new Vector.<Point>();
        }

        public function add(p:Point):void
        {
            _points.push(p);
        }

        public function clone():Line
        {
            var line:Line = new Line(new Rectangle(region.x, region.y, region.width, region.height));

            for (var i:int = 0; i < this.length; i++) {
                var p:Point = this.get(i);
                line.add(new Point(p.x, p.y));
            }

            return line;
        }

        public function denormalize(region:Rectangle):void
        {
            if (!normalized)
                return;

            _normalized = false;

            _region = region;

            for (var i:int = 0; i < _points.length; i++) {
                var p:Point = _points[i];
                p.x *= region.width;
                p.y *= region.height;
            }
        }

        public function get(index:int):Point
        {
            return _points[index];
        }

        public function get length():int
        {
            return _points.length;
        }

        public function normalize():void
        {
            if (normalized)
                return;

            _normalized = true;

            for (var i:int = 0; i < _points.length; i++) {
                var p:Point = _points[i];
                p.x /= region.width;
                p.y /= region.height;
            }
        }

        public function get normalized():Boolean
        {
            return _normalized;
        }

        public function optimize(d:int = 3):void
        {

            var newPoints:Vector.<Point> = new Vector.<Point>();

            newPoints.push(_points[0]);
            for (var j:int = d; j < _points.length - 1; j += d) {
                newPoints.push(_points[j]);
            }
            newPoints.push(_points[_points.length - 1]);

            _points = newPoints;
        }

        public function get region():Rectangle
        {
            return _region;
        }
    }
}
