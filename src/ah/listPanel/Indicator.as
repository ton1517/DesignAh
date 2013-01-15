package ah.listPanel
{
    import flash.display.Shape;
    import flash.display.Sprite;
    
    import caurina.transitions.Tweener;

    /**
     * ActiveCountPanelの下のゲージ
     */
    internal class Indicator extends Sprite
    {
        public static const HEIGHT:Number = 30;
        public static const NUM:int = 10;

        public static const WIDTH:Number = 5;

        private var _bar:Shape;
        private var _maskBar:Shape;
        private var _maskBar2:Shape;

        public function Indicator()
        {
            _bar = createBar();

            _maskBar = createMaskBar();
            _maskBar2 = createMaskBar();

            addChild(_maskBar);
            _bar.mask = _maskBar;

            addChild(_maskBar2);
            addChild(_bar);
        }

        public function active():void
        {
            Tweener.removeTweens(_bar);
            Tweener.addTween(_bar, {scaleX: 1, time: 0.1, onComplete: function():void {
                Tweener.addTween(_bar, {scaleX: 0, time: 0.3, transition: "easeOutCubic"});
            }});
        }

        private function createBar():Shape
        {
            var bar:Shape = new Shape();
            bar.graphics.beginFill(0xffffff);
            bar.graphics.drawRect(0, 0, WIDTH * NUM * 2 - WIDTH, HEIGHT);
            bar.graphics.endFill();
            bar.scaleX = 0;
            return bar;
        }

        private function createMaskBar():Shape
        {
            var maskBar:Shape = new Shape();
            maskBar.graphics.beginFill(0x555555);
            for (var i:int = 0; i < NUM; i++) {
                maskBar.graphics.drawRect(i * WIDTH * 2, 0, WIDTH, HEIGHT);
            }
            maskBar.graphics.endFill();
            return maskBar;
        }
    }
}
