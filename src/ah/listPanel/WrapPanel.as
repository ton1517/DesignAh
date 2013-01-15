package ah.listPanel
{
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    
    import ah.animation.DisplayPanel;

    internal class WrapPanel extends Sprite
    {
        private var _acp:ActiveCountPanel;

        private var _panel:DisplayPanel;
        private var _region:Rectangle;

        public function WrapPanel(panel:DisplayPanel, region:Rectangle)
        {
            _panel = panel;
            _region = region;

            graphics.beginFill(0x0, 0);
            graphics.drawRect(0, 0, _region.width, _region.height);
            graphics.endFill();

            panel.x = _region.width / 2 - panel.width / 2;
            panel.y = _region.height / 2 - panel.height / 2;
            addChild(panel);

            _acp = new ActiveCountPanel(panel.sound, panel.sound.voiceName);
            _acp.x = 10;
            _acp.y = _region.height - _acp.height - 10;
            addChild(_acp);
        }

        public function get activeCountPanel():ActiveCountPanel
        {
            return _acp;
        }

        public function get displayPanel():DisplayPanel
        {
            return _panel;
        }
    }
}
