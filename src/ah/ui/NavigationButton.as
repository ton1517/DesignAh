package ah.ui
{
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.system.Capabilities;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    
    import ah.DesignAh;

    /**
     * ナビゲーションボタン
     */
    public class NavigationButton extends Button
    {

        private const BUTTON_OFFSET:int = 3;
        private const OVER_COLOR:uint = 0xffffff;

        private const UP_COLOR:uint = 0x888888;
        private var _left:Boolean;
        private var _size:int;

        private var _text:String;

        public function NavigationButton(text:String, size:int, left:Boolean = true)
        {
            this._text = text;
            this._size = size;
            this._left = left;

            upState = createState(UP_COLOR);
            overState = createState(OVER_COLOR);
            downState = overState;
            hitTestState = createHitState();
        }

        private function createHitState():Sprite
        {
            var state:Sprite = createState(UP_COLOR);
            var rect:Rectangle = state.getBounds(this);

            var hitState:Sprite = new Sprite();
            hitState.graphics.beginFill(0);
            hitState.graphics.drawRect(0, 0, rect.width, rect.height);
            hitState.graphics.endFill();

            return hitState;
        }

        private function createState(color:uint):Sprite
        {
            var state:Sprite = new Sprite();

            var txt:TextField = new TextField();
            txt.autoSize = TextFieldAutoSize.LEFT;
            txt.selectable = false;
            txt.defaultTextFormat = new TextFormat(DesignAh.FONT_NAME, _size, color);
            txt.text = _text;
            txt.y = -2;

            if (Capabilities.os.indexOf("Mac") != -1)
                txt.y += 4;

            state.addChild(txt);

            var mark:ButtonMark = new ButtonMark(color);
            mark.y = txt.height / 2;
            state.addChild(mark);

            if (_left) {
                mark.x = mark.width / 2;
                txt.x = mark.width + BUTTON_OFFSET;
            } else {
                mark.scaleX = -1;
                mark.x = txt.width + BUTTON_OFFSET + mark.width / 2;
            }

            return state;
        }
    }
}

import flash.display.CapsStyle;
import flash.display.LineScaleMode;
import flash.display.Shape;

/**
 * ボタンの丸
 */
class ButtonMark extends Shape
{

    public function ButtonMark(color:uint)
    {
        graphics.beginFill(color);
        graphics.drawCircle(0, 0, 18);
        graphics.endFill();

        graphics.lineStyle(3.5, 0, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE);
        graphics.moveTo(2, -7);
        graphics.lineTo(-5, 0);
        graphics.lineTo(2, 7);
        graphics.endFill();
    }
}
