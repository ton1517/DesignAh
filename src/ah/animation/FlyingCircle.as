package ah.animation
{
    import flash.display.Stage;
    import flash.geom.Point;
    
    import ah.sounds.AhSoundBase;
    import ah.utils.Line;
    
    import caurina.transitions.Tweener;

    /**
     * 円がランダムで飛んでいくアニメーションのパネル
     */
    public class FlyingCircle extends DisplayPanel
    {

        private const RANDOM_DIST:Number = 4;

        private var _circles:Vector.<Circle>;

        public function FlyingCircle(container:Stage, lines:Vector.<Line>, sound:AhSoundBase)
        {
            super(container, lines, sound);

            _circles = new Vector.<Circle>();

            for (var i:int = 0; i < lines.length; i++) {
                lines[i].optimize();
                for (var j:int = 0; j < lines[i].length; j++) {
                    var p:Point = lines[i].get(j);
                    var circle:Circle = new Circle(p.x, p.y, 3 + Math.random() * 8, Math.random() * 2 * Math.PI, this.graphics);
                    _circles.push(circle);
                }
            }

        }

        override public function activeCount():void
        {
            graphics.clear();
            graphics.beginFill(color);

            var circle:Circle;

            for (var j:int = 0; j < _circles.length; j++) {
                circle = _circles[j];

                Tweener.addTween(circle, {x: circle.initX, y: circle.initY, size: circle.size + circle.initSize * 0.5, time: 0.3, transition: "easeOutExpo"});

                circle.update();
            }
        }

        override public function update():void
        {
            graphics.clear();
            graphics.beginFill(color);

            var circle:Circle;

            for (var i:int = 0; i < _circles.length; i++) {
                circle = _circles[i];

                if (!Tweener.isTweening(circle)) {
                    circle.angle += Math.random() * 2 - 1;
                    circle.x += Math.random() * RANDOM_DIST * Math.sin(circle.angle);
                    circle.y += Math.random() * RANDOM_DIST * Math.cos(circle.angle);
                    circle.size -= (circle.size - circle.initSize) / 10;
                }

                circle.update();
            }
        }
    }
}

import flash.display.Graphics;

/**
 * 円
 */
class Circle
{
    public var angle:Number;
    public var initSize:Number;

    public var initX:Number;
    public var initY:Number;
    public var size:Number;

    public var x:Number;
    public var y:Number;

    private var canvas:Graphics;

    public function Circle(x:Number, y:Number, size:Number, angle:Number, canvas:Graphics)
    {
        this.initX = x;
        this.initY = y;
        this.initSize = size;

        this.x = x;
        this.y = y;
        this.size = size;
        this.angle = angle;
        this.canvas = canvas;
    }

    public function update():void
    {
        canvas.drawCircle(x, y, size);
    }
}
