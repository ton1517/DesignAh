package ah.animation
{
    import flash.display.Stage;
    import flash.geom.Point;
    
    import ah.sounds.AhSoundBase;
    import ah.utils.Line;

    /**
     * 「あ」の輪郭がゆれるアニメーションのパネル
     */
    public class Outline extends DisplayPanel
    {
        private const D:Number = 13;

        public function Outline(container:Stage, lines:Vector.<Line>, sound:AhSoundBase)
        {
            super(container, lines, sound);

            var newLines:Vector.<Line> = new Vector.<Line>();

            for (var i:int = 0; i < lines.length; i++) {
                lines[i].optimize(4);

                var line:Line = new Line(lines[i].region);
                newLines.push(line);

                var j:int;
                var p1:Point;
                var p2:Point;
                var np:Point;

                for (j = 0; j < lines[i].length - 1; j++) {
                    p1 = lines[i].get(j);
                    p2 = lines[i].get(j + 1);

                    np = calcPoint(p1, p2, Math.PI / 2);
                    line.add(np);
                }
                for (j = lines[i].length - 1; j > 0; j--) {
                    p1 = lines[i].get(j);
                    p2 = lines[i].get(j - 1);

                    np = calcPoint(p1, p2, Math.PI / 2);

                    line.add(np);
                }
            }
            this.lines = newLines;
        }

        override public function update():void
        {
            graphics.clear();

            var level:Number = sound.activityLevel / 100 * 80 + 2;
            var lineW:Number = sound.activityLevel / 100 * 8;
            for (var i:int = 0; i < lines.length; i++) {
                graphics.lineStyle(lineW, color);

                var first:Point = new Point(lines[i].get(0).x + Math.random() * level - level / 2, lines[i].get(0).y + Math.random() * level - level / 2);
                graphics.moveTo(first.x, first.y);

                for (var j:int = 1; j < lines[i].length; j++) {
                    graphics.lineTo(lines[i].get(j).x + Math.random() * level - level / 2, lines[i].get(j).y + Math.random() * level - level / 2);
                }

                graphics.lineTo(first.x, first.y);
            }
        }

        private function calcPoint(p1:Point, p2:Point, rotateAngle:Number = Math.PI / 2):Point
        {
            var dx:Number = p1.x - p2.x;
            var dy:Number = p1.y - p2.y;
            var centerP:Point = new Point((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);

            var angle:Number = Math.atan2(dy, dx);
            angle += rotateAngle;

            centerP.x += D * Math.cos(angle);
            centerP.y += D * Math.sin(angle);

            return centerP;
        }
    }
}
