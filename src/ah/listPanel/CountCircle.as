package ah.listPanel
{
    import flash.display.Shape;

    /**
     * ActiveCountPanelの丸
     */
    internal class CountCircle extends Shape
    {
        public static const SIZE:Number = 8;

        private const ACTIVE_COLOR:uint = 0xffffff;
        private const DEACTIVE_COLOR:uint = 0x555555;

        public function CountCircle()
        {
            deactive();
        }

        public function active():void
        {
            drawCircle(ACTIVE_COLOR);
        }

        public function deactive():void
        {
            drawCircle(DEACTIVE_COLOR);
        }

        private function drawCircle(color:uint):void
        {
            graphics.clear();
            graphics.beginFill(color);
            graphics.drawCircle(0, 0, SIZE);
            graphics.endFill();
        }
    }
}
