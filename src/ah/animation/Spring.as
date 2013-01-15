package ah.animation
{
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    import ah.sounds.AhSoundBase;
    import ah.utils.Line;

    /**
     * バネの動きをするアニメーション
     */
    public class Spring extends DisplayPanel
    {

        private const D:Number = 13;
        private var mouseDown:Boolean = false;

        private var springs:Vector.<SpringBall>;
        private var turn:Boolean = false;

        public function Spring(container:Stage, lines:Vector.<Line>, sound:AhSoundBase)
        {
            super(container, lines, sound);

            var drawLines:Vector.<Line> = new Vector.<Line>();
            var springLines:Vector.<Line> = new Vector.<Line>();
            drawLines = new Vector.<Line>();

            var i:int;
            var j:int;

            for (i = 0; i < lines.length; i++) {
                lines[i].optimize();

                var springLine:Line = new Line(lines[i].region);
                springLines.push(springLine);
                var drawLine:Line = new Line(lines[i].region);
                drawLines.push(drawLine);

                var p1:Point;
                var p2:Point;
                var np:Point;
                var length:int = lines[i].length - 1;

                for (j = 0; j < length; j++) {
                    p1 = lines[i].get(j);
                    p2 = lines[i].get(j + 1);

                    np = calcPoint(p1, p2, Math.PI / 2);
                    springLine.add(np);
                    drawLine.add(np);

                    np = calcPoint(p1, p2, -Math.PI / 2);
                    drawLine.add(np);
                }

                length = drawLine.length - 1;
                for (j = length; j >= 0; j -= 2) {
                    np = drawLine.get(j);
                    springLine.add(np);
                }
            }

            springs = new Vector.<SpringBall>();
            var s:SpringBall;
            for (i = 0; i < drawLines.length; i++) {
                var l:Line = drawLines[i];

                for (j = 0; j < l.length; j++) {
                    s = new SpringBall(l.get(j));
                    springs.push(s);
                }
            }

            this.lines = drawLines;

            addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            update();
        }

        override public function activeCount():void
        {
            addSpring(Math.random() * RECT_SIZE, Math.random() * RECT_SIZE, turn);

            updateDraw();
        }

        override public function update():void
        {
            if (mouseDown)
                addSpring(mouseX, mouseY, turn);

            for (var i:int = 0; i < springs.length; i++) {
                var s:SpringBall = springs[i];
                s.x += Math.random() * 2 - 1;
                s.y += Math.random() * 2 - 1;

                s.startingX = s.initX;
                s.startingY = s.initY;

                s.update();
            }

            updateDraw();
        }

        private function addSpring(x:Number, y:Number, attract:Boolean):void
        {
            var c:int = attract ? 1 : -1;

            for (var i:int = 0; i < springs.length; i++) {
                var s:SpringBall = springs[i];

                var dx:Number = x - s.x;
                var dy:Number = y - s.y;
                var d:Number = Math.sqrt(dx * dx + dy * dy);

                var f:Number = 30 / d;
                f = f > 10 ? 10 : f;

                s.startingX = s.x + c * dx * f;
                s.startingY = s.y + c * dy * f;
                if (f > 1) {
                    s.vx *= 1.5;
                    s.vy *= 1.5;
                }
                s.update();
            }
        }

        private function calcPoint(p1:Point, p2:Point, rotateAngle:Number = Math.PI / 2):Point
        {
            var dx:Number = p1.x - p2.x;
            var dy:Number = p1.y - p2.y;
            var centerP:Point = new Point((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);

            var angle:Number = Math.atan2(dy, dx);
            angle += rotateAngle;

            centerP.x += D * Math.cos(angle);
            centerP.y += D * Math.sin(angle);

            return centerP;
        }

        private function lineTo(p:Point):void
        {
            graphics.lineTo(p.x, p.y);
        }

        private function moveTo(p:Point):void
        {
            graphics.moveTo(p.x, p.y);
        }

        private function onMouseDown(e:MouseEvent):void
        {
            mouseDown = true;
            turn = !turn;
        }

        private function onMouseUp(e:MouseEvent):void
        {
            mouseDown = false;
        }

        private function updateDraw():void
        {
            graphics.clear();

            for (var i:int = 0; i < lines.length; i++) {
                var l:Line = lines[i];

                for (var j:int = 0; j < lines[i].length; j += 2) {
                    if (j + 3 <= lines[i].length) {
                        graphics.beginFill(color);
                        moveTo(l.get(j));
                        lineTo(l.get(j + 1));
                        lineTo(l.get(j + 3));
                        lineTo(l.get(j + 2));
                    }
                }
            }
            graphics.endFill();
        }
    }
}

import flash.geom.Point;

class SpringBall
{
    private static const FRICTION:Number = 0.8;

    private static const SPRING:Number = 0.3;

    public var initX:Number;
    public var initY:Number;

    public var startingX:Number;
    public var startingY:Number;

    public var vx:Number = 0;
    public var vy:Number = 0;

    public var x:Number;
    public var y:Number;

    private var _ball:Point;
    private var _handles:Vector.<Point>;

    public function SpringBall(ball:Point)
    {
        _ball = ball;
        initX = _ball.x;
        initY = _ball.y;

        startingX = initX;
        startingY = initY;

        x = ball.x;
        y = ball.y;
    }

    public function get ball():Point
    {
        return _ball;
    }

    public function update():void
    {
        var dx:Number = startingX - x;
        var dy:Number = startingY - y;

        vx += dx * SPRING;
        vy += dy * SPRING;

        vx *= FRICTION;
        vy *= FRICTION;

        _ball.x += vx;
        _ball.y += vy;

        x = _ball.x;
        y = _ball.y;
    }
}
