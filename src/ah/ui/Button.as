package ah.ui
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    /**
     * ボタンのベースクラス
     */
    public class Button extends Sprite
    {

        private var _downState:Sprite;
        private var _hitTestState:Sprite;
        private var _overState:Sprite;

        private var _upState:Sprite;

        public function Button()
        {
            buttonMode = true;
            useHandCursor = true;

            addEventListener(MouseEvent.MOUSE_OVER, onOver);
            addEventListener(MouseEvent.MOUSE_OUT, onOut);
            addEventListener(MouseEvent.MOUSE_UP, onUp);
            addEventListener(MouseEvent.MOUSE_DOWN, onDown);
            addEventListener(Event.ADDED, onAdded);
        }

        protected function get downState():Sprite
        {
            return _downState;
        }

        protected function set downState(value:Sprite):void
        {
            add(value);
            _downState = value;
        }

        protected function get hitTestState():Sprite
        {
            return _hitTestState;
        }

        protected function set hitTestState(value:Sprite):void
        {
            add(value);
            _hitTestState = value;
            _hitTestState.alpha = 0;
        }

        protected function get overState():Sprite
        {
            return _overState;
        }

        protected function set overState(value:Sprite):void
        {
            add(value);
            _overState = value;
        }

        protected function get upState():Sprite
        {
            return _upState;
        }

        protected function set upState(value:Sprite):void
        {
            add(value);
            _upState = value;
        }

        private function add(state:DisplayObject):void
        {
            if (state)
                addChild(state);
            if (_hitTestState)
                addChild(_hitTestState);
        }

        private function onAdded(e:Event):void
        {
            add(_upState);
        }

        private function onDown(e:MouseEvent):void
        {
            add(_downState);
        }

        private function onOut(e:MouseEvent):void
        {
            add(_upState);
        }

        private function onOver(e:MouseEvent):void
        {
            add(_overState);
        }

        private function onUp(e:MouseEvent):void
        {
            add(_upState);
        }
    }
}
