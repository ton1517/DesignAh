package ah.sounds
{
    import flash.events.Event;
    
    import ah.utils.ClientMP3Loader;

    /**
     * ローカルサウンド
     */
    [Event(name = "cancel", type = "flash.events.Event")]
    public class AhSoundLocal extends AhSound
    {
        private var _mp3:ClientMP3Loader;

        public function AhSoundLocal()
        {
            super(null, "");

            _mp3 = new ClientMP3Loader();
            _mp3.addEventListener(Event.COMPLETE, onComplete);
            _mp3.addEventListener(Event.CANCEL, onCancel);
            _mp3.load();
        }

        private function onCancel(e:Event):void
        {
            dispatchEvent(e);
        }

        private function onComplete(e:Event):void
        {
            _sound = _mp3.sound;
            voiceName = _mp3.file.name.replace(".mp3", "");
            dispatchEvent(e);
        }
    }
}
