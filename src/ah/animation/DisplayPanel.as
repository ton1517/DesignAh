package ah.animation
{
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    
    import ah.sounds.AhSoundBase;
    import ah.sounds.AhSoundEvent;
    import ah.utils.Line;

    /**
     * 「あ」をアニメーションさせるパネルのベース
     */
    public class DisplayPanel extends Sprite
    {

        public const RECT_SIZE:int = 300;
        protected var container:Stage;

        protected var lines:Vector.<Line>;
        private var _color:uint = 0xffffff;
        private var _running:Boolean = false;

        private var _sound:AhSoundBase;

        private var dummy:Shape;

        public function DisplayPanel(container:Stage, lines:Vector.<Line>, sound:AhSoundBase)
        {
            this.lines = lines;
            this.container = container;

            _sound = sound;

            dummy = new Shape();
            dummy.graphics.beginFill(0x0, 0);
            dummy.graphics.drawRect(0, 0, RECT_SIZE, RECT_SIZE);
            dummy.graphics.endFill();
            addChild(dummy);
        }

        public function active():void
        {
        }

        public function activeCount():void
        {
        }

        public function get color():uint
        {
            return _color;
        }

        public function set color(value:uint):void
        {
            _color = value;
        }

        public function get running():Boolean
        {
            return _running;
        }

        public function get sound():AhSoundBase
        {
            return _sound;
        }

        public function start():void
        {
            if (_running)
                return;

            _running = true;
            addEventListener(Event.ENTER_FRAME, onUpdate);
            sound.addEventListener(AhSoundEvent.ACTIVE, onActive);
            sound.addEventListener(AhSoundEvent.ACTIVE_COUNT, onActiveCount);
        }

        public function stop():void
        {
            if (!_running)
                return;

            _running = false;
            removeEventListener(Event.ENTER_FRAME, onUpdate);
            sound.removeEventListener(AhSoundEvent.ACTIVE, onActive);
            sound.removeEventListener(AhSoundEvent.ACTIVE_COUNT, onActiveCount);
        }

        public function update():void
        {
        }

        private function onActive(e:AhSoundEvent):void
        {
            active();
        }

        private function onActiveCount(e:AhSoundEvent):void
        {
            activeCount();
        }

        private function onUpdate(e:Event):void
        {
            update();
        }
    }
}
