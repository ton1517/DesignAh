package ah.sounds
{
    import flash.events.Event;
    import flash.events.SampleDataEvent;
    import flash.events.StatusEvent;
    import flash.media.Microphone;

    /**
     * マイク
     */
    public class AhMicrophone extends AhSoundBase
    {
        private var _microphone:Microphone;

        public function AhMicrophone()
        {
            super("YOUR VOICE");

            _microphone = Microphone.getMicrophone();
            _microphone.addEventListener(StatusEvent.STATUS, micStatus);
            _microphone.setSilenceLevel(0);
            start();
            stop();

        }

        public function get microphone():Microphone
        {
            return _microphone;
        }

        public function get muted():Boolean
        {
            return _microphone.muted;
        }

        override public function start():void
        {
            if (_running)
                return;

            _running = true;
            _microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
        }

        override public function stop():void
        {
            if (!_running)
                return;

            _running = false;
            _microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
        }

        override protected function setActivityLevel():void
        {
            _activityLevel = _microphone.activityLevel;
        }

        private function micStatus(e:StatusEvent):void
        {
            switch (e.code) {
                case "Microphone.Muted":
                    dispatchEvent(new Event(Event.CANCEL));
                    break;
                case "Microphone.Unmuted":
                    dispatchEvent(new Event(Event.COMPLETE));
                    break;
            }
        }

        private function onSampleData(e:SampleDataEvent):void
        {
            sampleData();
        }
    }
}
