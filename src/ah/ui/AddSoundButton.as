package ah.ui
{
    import flash.display.CapsStyle;
    import flash.display.LineScaleMode;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    
    import ah.DesignAh;

    /**
     * サウンドを追加するときのボタン
     */
    public class AddSoundButton extends Button
    {

        public function AddSoundButton(label:String, size:int)
        {
            upState = createState(label, 0xffffff, size, 0xffffff, 0x0);
            overState = upState;
            downState = createState(label, 0x0, size, 0x0, 0xffffff);
            hitTestState = createState(label, 0xffffff, size, 0xffffff, 0x0);
        }

        private function createState(label:String, textColor:uint, textSize:int, lineColor:uint, bgColor:uint):Sprite
        {
            var s:Sprite = new Sprite();
            var tf:TextField = new TextField();
            tf.selectable = false;
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.mouseEnabled = false;
            tf.defaultTextFormat = new TextFormat(DesignAh.FONT_NAME, textSize, textColor);
            tf.text = label;
            tf.x = 4;
            tf.y = 2;
            s.addChild(tf);
            s.graphics.beginFill(bgColor);
            s.graphics.lineStyle(4, lineColor, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE);
            s.graphics.drawRect(0, 0, tf.width + 8, tf.height + 4);
            s.graphics.endFill();

            return s;
        }
    }
}
