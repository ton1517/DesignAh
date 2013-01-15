package ah.sounds
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SampleDataEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.net.URLRequest;

    /**
     * サウンド
     */
    [Event(name = "ioError", type = "flash.events.IOErrorEvent")]
    [Event(name = "progress", type = "flash.events.ProgressEvent")]
    public class AhSound extends AhSoundBase
    {
        protected var _sound:Sound;
        private var _channel:SoundChannel;

        private var _dummy:Sprite;

        public function AhSound(url:String, voiceName:String)
        {
            super(voiceName);

            if (url) {
                _sound = new Sound(new URLRequest(url));
                _sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
                _sound.addEventListener(ProgressEvent.PROGRESS, onProgress);
                _sound.addEventListener(Event.COMPLETE, onComplete);
            }

            _dummy = new Sprite();
        }

        override public function start():void
        {
            if (_running)
                return;

            _running = true;

            _channel = _sound.play((_channel ? _channel.position : 0));
            _channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
            _sound.addEventListener(SampleDataEvent.SAMPLE_DATA, sampleData);
            _dummy.addEventListener(Event.ENTER_FRAME, onUpdate);
        }

        override public function stop():void
        {
            if (!_running)
                return;

            _running = false;

            _channel.stop();
            _channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
            _sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, sampleData);
            _dummy.removeEventListener(Event.ENTER_FRAME, onUpdate);
        }

        override protected function setActivityLevel():void
        {
            _activityLevel = _channel ? Math.max(_channel.rightPeak, _channel.leftPeak) * 100 : 0;
        }

        private function onComplete(e:Event):void
        {
            dispatchEvent(e);
        }

        private function onIOError(e:IOErrorEvent):void
        {
            dispatchEvent(e);
        }

        private function onProgress(e:ProgressEvent):void
        {
            dispatchEvent(e);
        }


        private function onSoundComplete(e:Event):void
        {
            stop();
            _channel = null;
            start();
        }

        private function onUpdate(e:Event):void
        {
            sampleData();

        }
    }
}
