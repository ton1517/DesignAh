package ah.ui
{
    import flash.display.CapsStyle;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.ProgressEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import ah.animation.Spring;
    import ah.utils.Line;

    /**
     * 「あ」の文字を描く時のパネル
     */
    public class DrawingPanel extends Sprite
    {

        private const COLOR:uint = 0xffffff;
        private const LINE_SIZE:int = 7;
        private const RECT_OFFSET:int = 3;

        private const RECT_SIZE:int = 300;
        private const SPACES:int = 20;
        private var _canvas:Shape;

        private var _canvases:Vector.<Shape>;

        private var _drawCount:int;
        private var _line:Line;
        private var _lines:Vector.<Line>;
        private var _maxLines:int;

        private var _resultPanel:Spring;

        private var _stage:Stage;

        public function DrawingPanel(stage:Stage, maxLines:int)
        {
            this._stage = stage;
            this._maxLines = maxLines;

            drawBaseLine();
            init();
        }

        public function init():void
        {
            if (_canvases) {
                for (var i:int = 0; i < _canvases.length; i++) {
                    if (contains(_canvases[i]))
                        removeChild(_canvases[i]);
                }
            }
            _canvases = new Vector.<Shape>();

            if (_resultPanel) {
                removeChild(_resultPanel);
                _resultPanel.removeEventListener(Event.ENTER_FRAME, resultUpdate);
            }

            _lines = new Vector.<Line>();
            _drawCount = 0;

        }

        public function get lineLength():int
        {
            return lines.length;
        }

        public function get lines():Vector.<Line>
        {
            return _lines;
        }

        public function start():void
        {
            _stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        }

        public function stop():void
        {
            _stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        }

        private function drawBaseLine():void
        {
            graphics.lineStyle(1, COLOR);
            graphics.beginFill(COLOR, 0.01);
            graphics.drawRect(0, 0, RECT_SIZE, RECT_SIZE);

            graphics.moveTo(0, RECT_SIZE / 2);
            graphics.lineTo(RECT_SIZE, RECT_SIZE / 2);

            graphics.moveTo(RECT_SIZE / 2, 0);
            graphics.lineTo(RECT_SIZE / 2, RECT_SIZE);

            graphics.lineStyle(0, COLOR, 0.2);
            var dist:Number = RECT_SIZE / 20;
            var i:int;

            for (i = dist; i < RECT_SIZE; i += dist) {
                graphics.moveTo(i, 0);
                graphics.lineTo(i, RECT_SIZE);
            }

            for (i = dist; i < RECT_SIZE; i += dist) {
                graphics.moveTo(0, i);
                graphics.lineTo(RECT_SIZE, i);
            }

            graphics.endFill();
        }


        private function onMouseDown(e:MouseEvent):void
        {
            var x:Number = mouseX;
            var y:Number = mouseY;
            if (x >= RECT_OFFSET && x <= RECT_SIZE - RECT_OFFSET && y >= RECT_OFFSET && y <= RECT_SIZE - RECT_OFFSET) {
                _stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
                _stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                _line = new Line(new Rectangle(0, 0, RECT_SIZE, RECT_SIZE));

                _canvas = new Shape();
                addChild(_canvas);
                _canvas.graphics.lineStyle(LINE_SIZE, COLOR, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.BEVEL);
                _canvas.graphics.moveTo(x, y);
            }
        }

        private function onMouseMove(e:MouseEvent):void
        {
            var x:Number = mouseX;
            var y:Number = mouseY;

            if (x < RECT_OFFSET) {
                x = RECT_OFFSET;
            } else if (x > RECT_SIZE - RECT_OFFSET) {
                x = RECT_SIZE - RECT_OFFSET;
            }

            if (y < RECT_OFFSET) {
                y = RECT_OFFSET;
            } else if (y > RECT_SIZE - RECT_OFFSET) {
                y = RECT_SIZE - RECT_OFFSET;
            }

            _line.add(new Point(x, y));
            _canvas.graphics.lineTo(x, y);
        }

        private function onMouseUp(e:MouseEvent):void
        {
            _stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            _stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

            var length:int = _line.length;

            if (length > 10 && length < 400) {
                _canvases.push(_canvas);
                _lines.push(_line);

                dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, lineLength, _maxLines));

                _drawCount++;
                if (_drawCount == _maxLines) {
                    for (var i:int = 0; i < _canvases.length; i++) {
                        if (contains(_canvases[i]))
                            removeChild(_canvases[i]);
                    }

                    _resultPanel = new Spring(_stage, Line.cloneLines(_lines), null);
                    _resultPanel.addEventListener(Event.ENTER_FRAME, resultUpdate);
                    addChild(_resultPanel);

                    stop();
                    dispatchEvent(new Event(Event.COMPLETE, false, false));
                }
            } else {
                removeChild(_canvas);
            }
        }

        private function resultUpdate(e:Event):void
        {
            _resultPanel.update();
        }
    }
}
