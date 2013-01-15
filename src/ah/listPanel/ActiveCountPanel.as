package ah.listPanel
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.utils.getTimer;
    
    import ah.DesignAh;
    import ah.sounds.AhMicrophone;
    import ah.sounds.AhSoundBase;
    import ah.sounds.AhSoundEvent;
    
    import caurina.transitions.Tweener;

    /**
     * 音に反応した回数をカウントするパネル
     */
    internal class ActiveCountPanel extends Sprite
    {
        private var _circles:Array /*CountCircle*/ = [];

        private var _count:int = -1;

        private var _delay:int = 100;
        private var _delayCnt:int = 0;

        private var _indicator:Indicator;
        private var _initY:Number;

        private var _isMic:Boolean;

        private var _sound:AhSoundBase;
        private var _text:String;
        private var _txt:TextField;

        private var first:Boolean = true;

        public function ActiveCountPanel(sound:AhSoundBase, text:String = "VOICE")
        {
            _sound = sound;
            _text = text;
            _sound.addEventListener(AhSoundEvent.ACTIVE_COUNT, onCount);

            for (var i:int = 0; i < 5; i++) {
                var circle:CountCircle = new CountCircle();
                circle.x = i * (CountCircle.SIZE * 3) + CountCircle.SIZE;
                circle.y = CountCircle.SIZE / 2;
                addChild(circle);

                _circles[i] = circle;
            }

            _txt = new TextField();
            _txt.selectable = false;
            _txt.autoSize = TextFieldAutoSize.LEFT;
            _txt.defaultTextFormat = new TextFormat(DesignAh.FONT_NAME, 16, 0xffffff, true);
            _txt.mouseEnabled = false;
            _txt.x = -1;
            _txt.y = CountCircle.SIZE + 5;
            addChild(_txt);
            setText(_count);

            _indicator = new Indicator();
            _indicator.y = _txt.y + _txt.height + 3;
            addChild(_indicator);

            _isMic = sound is AhMicrophone ? true : false;
        }

        override public function get y():Number
        {
            return super.y;
        }

        override public function set y(value:Number):void
        {
            if (first) {
                _initY = value;
                first = false;
            }
            super.y = value;
        }

        private function activeCircles():void
        {
            var l:int = _count % 6;
            if (l != _circles.length) {
                _circles[l].active();
            } else {
                for (var i:int = 0; i < _circles.length; i++)
                    _circles[i].deactive();
            }
        }

        private function onCount(e:AhSoundEvent):void
        {
            _count++;
            activeCircles();
            setText(_count);

            _delayCnt = getTimer();
            _indicator.active();

            if (_isMic) {
                Tweener.addTween(this, {y: this.y - 10, time: 0.2, transition: "easeOutCubic", onComplete: function():void {
                    Tweener.addTween(this, {y: _initY, time: 0.4, transition: "easeOutBounce"});
                }});
            }
        }

        private function setText(count:int):void
        {
            _txt.text = "SONG OF DESIGN AH ! \n" + _text + " : " + (count + 1) + " HITS";
        }
    }
}
