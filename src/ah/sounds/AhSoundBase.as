package ah.sounds
{
    import flash.events.EventDispatcher;

    /**
     * サウンドのベースクラス
     */
    [Event(name = "active", type = "ah.sounds.AhSoundEvent")]
    [Event(name = "activeCount", type = "ah.sounds.AhSoundEvent")]
    [Event(name = "complete", type = "flash.events.Event")]
    public class AhSoundBase extends EventDispatcher
    {
        protected var _activityLevel:Number = 0;

        protected var _running:Boolean = false;

        private var _activityThreshold:Number = 25;
        private var _delay:Number = 100;

        private var _delayCnt:Number = 0;
        private var _prevActivityLevel:Number = 0;

        private var _voiceName:String;

        public function AhSoundBase(voiceName:String = "")
        {
            _voiceName = voiceName;
        }

        public function get activityLevel():Number
        {
            return _activityLevel;
        }

        public function get activityThreshold():Number
        {
            return _activityThreshold;
        }

        public function set activityThreshold(value:Number):void
        {
            if (value < 0)
                value = 0;
            else if (value > 100)
                value = 100;

            _activityThreshold = value;
        }

        public function get running():Boolean
        {
            return _running;
        }

        public function start():void
        {
        }

        public function stop():void
        {
        }

        public function get voiceName():String
        {
            return _voiceName;
        }

        public function set voiceName(value:String):void
        {
            _voiceName = value;
        }

        protected function sampleData():void
        {
            _prevActivityLevel = _activityLevel;
            setActivityLevel();

            if (activityLevel > activityThreshold) {
                dispatchEvent(new AhSoundEvent(AhSoundEvent.ACTIVE));

                if (_activityLevel - _prevActivityLevel > _activityThreshold) {
                    dispatchEvent(new AhSoundEvent(AhSoundEvent.ACTIVE_COUNT));
                }
            }
        }

        protected function setActivityLevel():void
        {
        }
    }
}