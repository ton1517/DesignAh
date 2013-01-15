package ah
{
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.events.ProgressEvent;
    import flash.geom.Rectangle;
    import flash.system.Capabilities;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.ui.Keyboard;
    
    import ah.animation.DisplayPanel;
    import ah.animation.FlyingCircle;
    import ah.animation.Mosaic;
    import ah.animation.Outline;
    import ah.animation.Spring;
    import ah.animation.ThemeOfAh;
    import ah.animation.TypeWriterAnimation;
    import ah.listPanel.ListPanel;
    import ah.sounds.AhMicrophone;
    import ah.sounds.AhSound;
    import ah.sounds.AhSoundBase;
    import ah.sounds.AhSoundEvent;
    import ah.sounds.AhSoundLocal;
    import ah.ui.DrawingPanel;
    import ah.ui.NavigationButton;
    import ah.utils.Line;
    
    import caurina.transitions.Tweener;
    
    import frocessing.color.ColorHSV;

    /**
     * デザインあ
     */
    [SWF(width = 465, height = 465, backgroundColor = 0x0, frameRate = 30)]
    public class DesignAh extends Sprite
    {
        private namespace en;
        private namespace ja;

        public static const FONT_NAME:String = "_sans";

        private const CANCEL:int = 2;
        private const DESCRIPTION1:int = 0;
        private const ENJOY:int = 5;
        private const FONT_SIZE:int = 24;
        private const MIC:int = 9;
        private const NEXT:int = 6;
        private const OK:int = 3;
        private const READY:int = 1;
        private const SELECT_MUSIC:int = 7;
        private const SOUND:int = 10;
        private const THANKS:int = 4;
        private const THEME_LEFT:int = 11;
        private const THEME_RIGHT:int = 12;
        private const WELCOME:int = 8;

        private var _bg:Shape;

        private var _cancelButton:NavigationButton;
        private var _centerDrawingPanel:Sprite;
        private var _color:ColorHSV = new ColorHSV(0, 0.7);

        private var _defaultSound:AhSound;

        private var _descriptionTxt:TextField;
        private var _displayLines:int;

        private var _drawingPanel:DrawingPanel;

        private var _extendMode:Boolean;
        private var _lang:Namespace;
        private var _listPanel:ListPanel;
        private var _loadCount:int = 0;
        private var _loadedDefaultSound:Boolean = false;

        private var _maxLines:int;
        private var _maxSounds:int;
        private var _micButton:NavigationButton;
        private var _nextButton:NavigationButton;
        private var _okButton:NavigationButton;

        private var _panelClasses:Vector.<Class>;
        private var _panels:Vector.<DisplayPanel>;

        private var _soundButton:NavigationButton;

        private var _sounds:Vector.<AhSoundBase>;

        private var _texts:Array /*String*/ = [];

        public function DesignAh()
        {
            stage.align = StageAlign.TOP;
            stage.scaleMode = StageScaleMode.SHOW_ALL;

            _bg = new Shape();
            _bg.graphics.beginFill(0);
            _bg.graphics.drawRect(-465, 0, 465 * 3, 465);
            _bg.graphics.endFill();
            addChild(_bg);

            checkLanguage();
            _lang::init();
            initDescriptionTxt();
            initDrawingPanel();
            initButton();
            initPanelClasses();
            initDefaultSound();
            extendKey();
            maskStage();

            _sounds = new Vector.<AhSoundBase>();

            startWelcomMessage();

        }

        ja function init():void
        {
            _texts[DESCRIPTION1] = "画面に「あ」と書いてください。";
            _texts[READY] = "これでいいですか？";
            _texts[CANCEL] = "書きなおす";
            _texts[OK] = "はい";
            _texts[THANKS] = "ありがとうございました。\n\n\n\n\n\n\n\n\n\n";
            _texts[ENJOY] = "それではどうぞお楽しみください。";
            _texts[NEXT] = "次へ";
            _texts[SELECT_MUSIC] = "再生したい音楽を選んでください。\n\n\n\n\n\n\n\n\n\n";
            _texts[WELCOME] = "「あ」のうたへ ようこそ。\n\n\n\n\n\n\n\n\n\n";
            _texts[MIC] = "マイク";
            _texts[SOUND] = "サウンド";
            _texts[THEME_LEFT] = "「";
            _texts[THEME_RIGHT] = "」のテーマ";

            _maxLines = 3;
            _displayLines = 3;
        }

        en function init():void
        {
            _texts[DESCRIPTION1] = "please write 'A' on the screen.";
            _texts[READY] = "are you ready?";
            _texts[CANCEL] = "try again";
            _texts[OK] = "ok";
            _texts[THANKS] = "thank you.\n\n\n\n\n\n\n\n\n\n";
            _texts[ENJOY] = "let's enjoy.";
            _texts[NEXT] = "next";
            _texts[SELECT_MUSIC] = "please select the music to play.\n\n\n\n\n\n\n\n\n\n";
            _texts[WELCOME] = "welcome to the song of 'Ah'.\n\n\n\n\n\n\n\n\n\n";
            _texts[MIC] = "Microphone";
            _texts[SOUND] = "Sound";
            _texts[THEME_LEFT] = "Theme of '";
            _texts[THEME_RIGHT] = "'";

            _maxLines = 3;
            _displayLines = 2;
        }

        private function addDrawPanelButton():void
        {
            _cancelButton.alpha = _okButton.alpha = 0;
            addChild(_cancelButton);
            addChild(_okButton);

            Tweener.addTween(_cancelButton, {alpha: 1, time: 1, transition: "easeOutCubic"});
            Tweener.addTween(_okButton, {alpha: 1, time: 1, transition: "easeOutCubic"});
        }

        private function checkLanguage():void
        {
            _lang = Capabilities.language == "ja" ? ja : en;
        }

        private function extendActiveCount(e:AhSoundEvent):void
        {
            if (_listPanel && _listPanel.running) {
                for (var i:int = 0; i < _panels.length; i++) {
                    var panel:DisplayPanel = _panels[i];
                    _color.h = Math.random() * 360;
                    panel.color = _color.value;
                }
            }

        }

        private function extendKey():void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
                if (e.keyCode == Keyboard.SHIFT)
                    _extendMode = true;
            });

            stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent):void {
                if (e.keyCode == Keyboard.SHIFT)
                    _extendMode = false;
            });
        }

        private function initButton():void
        {
            var offsetX:int = 10;
            var offsetY:int = 20;

            _soundButton = new NavigationButton(_texts[SOUND], FONT_SIZE, false);
            _soundButton.x = stage.stageWidth / 2 - _soundButton.width / 2;
            _soundButton.y = stage.stageHeight / 2 - _soundButton.height / 2 + offsetY;
            _soundButton.addEventListener(MouseEvent.CLICK, onSoundSet);

            _micButton = new NavigationButton(_texts[MIC], FONT_SIZE, false);
            _micButton.x = stage.stageWidth / 2 - _micButton.width / 2;
            _micButton.y = _soundButton.y - _micButton.height - 20 - offsetY;
            _micButton.addEventListener(MouseEvent.CLICK, onMicSet);

            _nextButton = new NavigationButton(_texts[NEXT], FONT_SIZE, false);
            _nextButton.x = stage.stageWidth - _nextButton.width - offsetX;
            _nextButton.y = stage.stageHeight - _nextButton.height - offsetY;
            _nextButton.addEventListener(MouseEvent.CLICK, onNext);

            _cancelButton = new NavigationButton(_texts[CANCEL], FONT_SIZE, true);
            _cancelButton.x = offsetX;
            _cancelButton.y = stage.stageHeight - _cancelButton.height - offsetY;
            _cancelButton.addEventListener(MouseEvent.CLICK, onDrawCancel);

            _okButton = new NavigationButton(_texts[OK], FONT_SIZE, false);
            _okButton.x = stage.stageWidth - _okButton.width - offsetX;
            _okButton.y = stage.stageHeight - _okButton.height - offsetY;
            _okButton.addEventListener(MouseEvent.CLICK, onDrawOK);
        }

        private function initDefaultSound():void
        {
            _defaultSound = new AhSound("http://www.takasumi-nagai.com/soundfiles/sound001.mp3", "SOUND");
            _defaultSound.addEventListener(Event.COMPLETE, onCompleteDefaultSound);
            _defaultSound.addEventListener(IOErrorEvent.IO_ERROR, onDefaultSoundIOError);
        }

        private function initDescriptionTxt():void
        {
            _descriptionTxt = new TextField();
            _descriptionTxt.autoSize = TextFieldAutoSize.CENTER;
            _descriptionTxt.selectable = false;

            _descriptionTxt.defaultTextFormat = new TextFormat(FONT_NAME, FONT_SIZE, 0xffffff);
            _descriptionTxt.text = " ";
            _descriptionTxt.y = stage.stageHeight / 2 - _descriptionTxt.height;
            _descriptionTxt.x = stage.stageWidth / 2 - _descriptionTxt.width / 2;
            addChild(_descriptionTxt);
        }

        private function initDrawingPanel():void
        {
            _drawingPanel = new DrawingPanel(stage, 3);
            _drawingPanel.x = -_drawingPanel.width / 2;
            _drawingPanel.y = -_drawingPanel.height / 2;

            _centerDrawingPanel = new Sprite();
            _centerDrawingPanel.addChild(_drawingPanel);
            _centerDrawingPanel.x = stage.stageWidth / 2;
            _centerDrawingPanel.y = stage.stageHeight / 2;
        }

        private function initPanelClasses():void
        {
            _panelClasses = new Vector.<Class>();
            _panelClasses.push(Spring);
            _panelClasses.push(FlyingCircle);
            _panelClasses.push(Outline);
            _panelClasses.push(Mosaic);

            _maxSounds = _panelClasses.length;
        }

        private function maskStage():void
        {
            var m:Shape = new Shape();
            m.graphics.beginFill(0x0, 0);
            m.graphics.drawRect(-stage.stageWidth, 0, stage.stageWidth * 3, stage.stageHeight);
            m.graphics.endFill();
            addChild(m);
            mask = m;
        }

        private function onCompleteDefaultSound(e:Event):void
        {
            _loadedDefaultSound = true;
        }

        private function onDefaultSoundIOError(e:IOErrorEvent):void
        {
            _loadedDefaultSound = true;
        }

        private function onDrawCancel(e:MouseEvent):void
        {
            _drawingPanel.init();
            _drawingPanel.start();
            removeDrawPanelButton();
            TypeWriterAnimation.startAnimation(_descriptionTxt, _texts[DESCRIPTION1], 100);
        }

        private function onDrawOK(e:MouseEvent):void
        {
            _drawingPanel.stop();
            removeDrawPanelButton();
            ready();
        }

        private function onDrawProgress(e:ProgressEvent):void
        {
            if (_drawingPanel.lineLength == _displayLines) {
                addDrawPanelButton();

                TypeWriterAnimation.startAnimation(_descriptionTxt, _texts[READY], 100);
            }
        }

        private function onMicSet(e:MouseEvent):void
        {
            _micButton.removeEventListener(MouseEvent.CLICK, onMicSet);
            removeChild(_micButton);
            var s:AhMicrophone = new AhMicrophone();
            s.addEventListener(Event.COMPLETE, onSoundComplete);

            if (_extendMode) {
                s.addEventListener(AhSoundEvent.ACTIVE_COUNT, extendActiveCount);
            }
        }

        private function onNext(e:MouseEvent):void
        {
            _nextButton.removeEventListener(MouseEvent.CLICK, onNext);

            if (_loadCount == 0)
                _sounds.push(_defaultSound);

            if (contains(_soundButton))
                removeChild(_soundButton);
            if (contains(_micButton))
                removeChild(_micButton);
            removeChild(_nextButton);

            _descriptionTxt.text = " ";
            _descriptionTxt.y = stage.stageHeight / 2 - _descriptionTxt.height;
            startDrawMessage();
        }

        private function onSoundComplete(e:Event):void
        {
            var sound:AhSoundBase = e.currentTarget as AhSoundBase;
            _sounds.push(sound);
            _loadCount++;
            if (_loadCount == _maxSounds) {
                removeChild(_soundButton);
                if (contains(_micButton))
                    removeChild(_micButton);
            }
        }

        private function onSoundSet(e:MouseEvent):void
        {
            var s:AhSoundLocal = new AhSoundLocal();
            s.addEventListener(Event.COMPLETE, onSoundComplete);
        }


        private function ready():void
        {
            _centerDrawingPanel.removeChild(_drawingPanel);
            removeChild(_descriptionTxt);

            _descriptionTxt.y = stage.stageHeight / 2 - _descriptionTxt.height;
            Tweener.addTween(_descriptionTxt, {time: 1, onComplete: function():void {
                TypeWriterAnimation.startAnimation(_descriptionTxt, _texts[THANKS], 100, function():void {
                    TypeWriterAnimation.startAnimation(_descriptionTxt, _texts[ENJOY], 100, function():void {
                        Tweener.addTween(_descriptionTxt, {delay: 1, time: 2, alpha: 0, onComplete: function():void {
                            removeChild(_descriptionTxt);
                            startDrawingAnimation();
                        }});
                    });
                });
                addChild(_descriptionTxt);
            }});

        }

        private function removeDrawPanelButton():void
        {
            _cancelButton.alpha = _okButton.alpha = 0;
            removeChild(_cancelButton);
            removeChild(_okButton);

        }

        private function startDrawMessage():void
        {
            TypeWriterAnimation.startAnimation(_descriptionTxt, _texts[DESCRIPTION1], 100, nextAnimation);

            function nextAnimation():void {
                Tweener.addTween(_descriptionTxt, {y: 20, time: 1, delay: 1, transition: "easeOutCubic"});

                _centerDrawingPanel.alpha = 0;
                _centerDrawingPanel.scaleX = _centerDrawingPanel.scaleY = 0;
                addChild(_centerDrawingPanel);

                Tweener.addTween(_centerDrawingPanel, {alpha: 1, scaleX: 1, scaleY: 1, time: 1, delay: 1, transition: "easeOutCubic", onComplete: function():void {
                    _drawingPanel.start();
                    _drawingPanel.addEventListener(ProgressEvent.PROGRESS, onDrawProgress);
                }});
            }
        }

        private function startDrawingAnimation():void
        {
            _panels = new Vector.<DisplayPanel>();
            _listPanel = new ListPanel(stage, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
            _listPanel.x = stage.stageWidth * 2;

            var lines:Vector.<Line> = _drawingPanel.lines;

            _listPanel.addFirst(new ThemeOfAh(Line.cloneLines(lines), _texts[THEME_LEFT], _texts[THEME_RIGHT]));

            for (var j:int = 0; j < _panelClasses.length; j++) {
                var PanelClass:Class = _panelClasses[j];
                var panel:DisplayPanel = new PanelClass(stage, Line.cloneLines(lines), _sounds[j % _sounds.length]);
                _panels.push(panel);
                _listPanel.add(panel);
            }

            if (_loadedDefaultSound) {
                start();
            } else {
                addEventListener(Event.ENTER_FRAME, function(e:Event):void {
                    if (_loadedDefaultSound) {
                        e.currentTarget.removeEventListener(e.type, arguments.callee);
                        start();
                    }
                });
            }

            function start():void {
                addChild(_listPanel);
                Tweener.addTween(_listPanel, {x: 0, time: 2, transition: "easeOutQuint", onComplete: function():void {
                    for (var i:int = 0; i < _sounds.length; i++)
                        _sounds[i].start();
                    _listPanel.start();
                }});
            }
        }

        private function startWelcomMessage():void
        {
            TypeWriterAnimation.startAnimation(_descriptionTxt, _texts[WELCOME], 100, function():void {
                TypeWriterAnimation.startAnimation(_descriptionTxt, _texts[SELECT_MUSIC], 100, nextAnimation);
            });

            function nextAnimation():void {
                Tweener.addTween(_descriptionTxt, {y: 30, time: 1, transition: "easeOutCubic"});

                var toX:Number = _soundButton.x;
                _soundButton.x = stage.stageWidth * 2;
                Tweener.addTween(_soundButton, {x: toX, time: 0.5, transition: "easeOutCubic"});
                addChild(_soundButton);

                toX = _micButton.x;
                _micButton.x = stage.stageWidth * 2;
                Tweener.addTween(_micButton, {x: toX, time: 0.5, delay: 0.1, transition: "easeOutCubic"});
                addChild(_micButton);

                toX = _nextButton.x;
                _nextButton.x = -stage.stageWidth * 2 - _nextButton.width;
                Tweener.addTween(_nextButton, {x: toX, time: 0.5, delay: 0.2, transition: "easeOutCubic"});
                addChild(_nextButton);
            }
        }
    }
}
