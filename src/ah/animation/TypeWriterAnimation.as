package ah.animation
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.TimerEvent;
    import flash.text.TextField;
    import flash.utils.Dictionary;
    import flash.utils.Timer;

    /**
     * カタカタ文字を打っているようなアニメーション
     */
    [Event(name = "complete", type = "flash.events.Event")]
    public class TypeWriterAnimation extends EventDispatcher
    {
        private static var taDic:Dictionary = new Dictionary();

        private var _interval:Number;

        private var _textField:TextField;
        private var _texts:Array /*String*/;

        private var _timer:Timer;

        public static function startAnimation(textField:TextField, text:String, interval:Number, onComplete:Function = null):TypeWriterAnimation
        {
            if (taDic[textField]) {
                taDic[textField].stop();
            }

            var ta:TypeWriterAnimation = new TypeWriterAnimation(textField, text, interval);
            taDic[textField] = ta;
            ta.addEventListener(Event.COMPLETE, function(e:Event):void {
                delete taDic[textField];
                if (onComplete != null)
                    onComplete();
            });
            ta.start();

            return ta;
        }

        public function TypeWriterAnimation(textField:TextField, text:String, interval:Number)
        {
            this._textField = textField;
            this._textField.text = "";

            this._texts = text.split("");
            this._interval = interval;

            _timer = new Timer(interval, text.length);
            _timer.addEventListener(TimerEvent.TIMER, onTick);
            _timer.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
        }

        public function get running():Boolean
        {
            return _timer.running;
        }

        public function start():void
        {
            _timer.start();
        }

        public function stop():void
        {
            _timer.stop();
        }

        private function onComplete(e:TimerEvent):void
        {
            dispatchEvent(new Event(Event.COMPLETE, false, false));
        }

        private function onTick(e:TimerEvent):void
        {
            _textField.appendText(_texts[_timer.currentCount - 1]);
        }
    }
}
