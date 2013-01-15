package ah.animation
{
    import flash.display.CapsStyle;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Shape;
    import flash.geom.Rectangle;
    import flash.system.Capabilities;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    
    import ah.DesignAh;
    import ah.utils.Line;

    /**
     * 最初に流れる 「あ」のテーマ の文字
     */
    public class ThemeOfAh extends DisplayPanel
    {
        private const AH_SIZE:int = 80;

        private const FONT_SIZE:int = 50;

        public function ThemeOfAh(lines:Vector.<Line>, leftText:String, rightText:String)
        {
            super(null, lines, null);

            var lt:TextField = new TextField();
            lt.autoSize = TextFieldAutoSize.LEFT;
            lt.selectable = false;
            lt.defaultTextFormat = new TextFormat(DesignAh.FONT_NAME, FONT_SIZE, 0xffffff);
            lt.text = leftText;
            lt.y = this.height / 2 - lt.height / 2;
            addChild(lt);

            var a:Shape = new Shape();
            for (var i:int = 0; i < lines.length; i++) {
                var l:Line = lines[i];
                l.normalize();
                l.denormalize(new Rectangle(0, 0, AH_SIZE, AH_SIZE));

                a.graphics.lineStyle(5, 0xffffff, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.BEVEL);
                a.graphics.moveTo(l.get(0).x, l.get(0).y);
                for (var j:int = 0; j < l.length; j++) {
                    a.graphics.lineTo(l.get(j).x, l.get(j).y);
                }
            }
            a.x = lt.x + lt.width;
            a.y = this.height / 2 - a.height / 2;
            addChild(a);

            var rt:TextField = new TextField();
            rt.autoSize = TextFieldAutoSize.LEFT;
            rt.selectable = false;
            rt.defaultTextFormat = new TextFormat(DesignAh.FONT_NAME, FONT_SIZE, 0xffffff);
            rt.text = rightText;
            rt.x = a.x + AH_SIZE;
            rt.y = this.height / 2 - rt.height / 2;
            addChild(rt);

            if (Capabilities.os.indexOf("Mac") != -1) {
                lt.y += 4;
                rt.y += 4;
            }
        }
    }
}
