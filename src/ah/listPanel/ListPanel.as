package ah.listPanel
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    
    import ah.animation.DisplayPanel;
    
    import caurina.transitions.Tweener;

    /**
     * パネルを並べて表示するクラス
     */
    public class ListPanel extends Sprite
    {
        private var _drag:Boolean = false;

        private var _first:Boolean = true;
        private var _prevEnterMouseX:Number = 0;
        private var _prevMouseX:Number = 0;
        private var _region:Rectangle;
        private var _running:Boolean = false;

        private var _stage:Stage;

        private var _themePanel:DisplayPanel;

        private var _topPos:Number;
        private var _tweenObj:Object = new Object();

        private var _wrapPanels:Vector.<WrapPanel>;

        public function ListPanel(stage:Stage, region:Rectangle)
        {
            _stage = stage;
            _region = region;

            _topPos = region.width;

            _wrapPanels = new Vector.<WrapPanel>();

            buttonMode = true;
            useHandCursor = true;

            graphics.beginFill(0, 0);
            graphics.drawRect(-_region.width, 0, _region.width * 3, _region.height);
            graphics.endFill();
        }

        public function add(panel:DisplayPanel):void
        {
            var wp:WrapPanel = new WrapPanel(panel, _region);
            wp.x = _topPos + _region.width * _wrapPanels.length;
            addChild(wp);
            _wrapPanels.push(wp);
        }

        public function addFirst(themePanel:DisplayPanel):void
        {
            _themePanel = themePanel;
            _themePanel.x = _region.width / 2 - _themePanel.width / 2;
            _themePanel.y = _region.height / 2 - _themePanel.height / 2;
            addChild(_themePanel);
        }

        public function get running():Boolean
        {
            return _running;
        }

        public function start():void
        {
            if (_running)
                return;

            _running = true;
            _stage.addEventListener(Event.ENTER_FRAME, onUpdate);
            _stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            _stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            _stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

            for (var i:int = 0; i < _wrapPanels.length; i++) {
                _wrapPanels[i].displayPanel.start();
            }
        }

        public function stop():void
        {
            if (!_running)
                return;

            _running = false;
            _stage.removeEventListener(Event.ENTER_FRAME, onUpdate);
            _stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            _stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            _stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

            for (var i:int = 0; i < _wrapPanels.length; i++) {
                _wrapPanels[i].displayPanel.stop();
            }
        }

        private function move(dx:Number):void
        {
            if (dx < 0) {
                //左
                if (_topPos < -_region.width * 2) {
                    if (_first) {
                        _first = false;
                        removeChild(_themePanel);
                    }

                    var e1:WrapPanel = _wrapPanels.shift();
                    _wrapPanels.push(e1);
                    _topPos = _wrapPanels[0].x;
                }
            } else if (!_first) {
                //右
                if (_topPos >= -_region.width) {
                    _topPos = _wrapPanels[0].x - _region.width;
                    var e2:WrapPanel = _wrapPanels.pop();
                    _wrapPanels.unshift(e2);
                }
            }

            _topPos += dx;

            if (_first)
                _themePanel.x += dx;

            for (var i:int = 0; i < _wrapPanels.length; i++) {
                var panel:WrapPanel = _wrapPanels[i];
                panel.x = _topPos + _region.width * i;

                if (panel.x >= -_region.width * 2 && panel.x <= _region.width * 2) {
                    panel.displayPanel.start();
                } else {
                    panel.displayPanel.stop();
                }
            }
        }

        private function onMouseDown(e:MouseEvent):void
        {
            _drag = true;
        }

        private function onMouseMove(e:MouseEvent):void
        {
            if (_drag)
                move(mouseX - _prevMouseX);

            _prevMouseX = mouseX;
        }

        private function onMouseUp(e:MouseEvent):void
        {
            _drag = false;

            _tweenObj.x = (mouseX - _prevEnterMouseX);
            Tweener.addTween(_tweenObj, {x: 0, time: 0.5, transition: "easeOutQuint", onUpdate: function():void {
                move(_tweenObj.x);
            }});
        }

        private function onUpdate(e:Event):void
        {
            if (!_drag)
                move(-3);
            _prevEnterMouseX = mouseX;
        }
    }
}
