package ah.sounds
{
    import flash.events.Event;

    /**
     * サウンド用のイベント
     */
    public class AhSoundEvent extends Event
    {
        public static const ACTIVE:String = "active";
        public static const ACTIVE_COUNT:String = "activeCount";

        public function AhSoundEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
        }
    }
}
