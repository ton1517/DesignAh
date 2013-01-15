package ah.animation
{
    import flash.display.BitmapData;
    import flash.display.CapsStyle;
    import flash.display.DisplayObject;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Stage;
    
    import ah.sounds.AhSoundBase;
    import ah.utils.Line;

    /**
     * モザイクのような「あ」
     */
    public class Mosaic extends DisplayPanel
    {
        private var increment:int = 1;
        private var index:int = 0;

        private var mosaics:Vector.<Vector.<MosaicCircle>>;

        public function Mosaic(container:Stage, lines:Vector.<Line>, sound:AhSoundBase)
        {
            super(container, lines, sound);

            for (var i:int = 0; i < lines.length; i++) {
                var l:Line = lines[i];
                graphics.lineStyle(20, 0xffffff, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.BEVEL);
                graphics.moveTo(l.get(0).x, l.get(0).y);
                for (var j:int = 1; j < lines[i].length; j++) {
                    graphics.lineTo(l.get(j).x, l.get(j).y);
                }
            }

            mosaics = new Vector.<Vector.<MosaicCircle>>();

            for (i = 1; i <= 64; i += i)
                mosaics.push(createMosaic(this, i));

            graphics.clear();
        }

        override public function activeCount():void
        {
            graphics.clear();
            graphics.beginFill(color);

            index += increment;

            for (var i:int = 0; i < mosaics[index].length; i++) {
                var c:MosaicCircle = mosaics[index][i];
                graphics.drawCircle(c.x, c.y, c.radius);
            }

            if (index == 0 || index == mosaics.length - 1) {
                increment *= -1;
            }
        }

        private function createMosaic(canvas:DisplayObject, partitions:int):Vector.<MosaicCircle>
        {
            var points:Vector.<MosaicCircle> = new Vector.<MosaicCircle>();
            var bmd:BitmapData = new BitmapData(canvas.width, canvas.height, false, 0x00);
            bmd.draw(canvas);

            for (var i:int = 0; i < partitions; i++) {
                var ws:int = i * canvas.width / partitions;
                var we:int = (i + 1) * canvas.width / partitions;

                for (var j:int = 0; j < partitions; j++) {
                    var hs:int = j * canvas.height / partitions;
                    var he:int = (j + 1) * canvas.height / partitions;

                    var count:int = 0;
                    for (var width:int = ws; width < we; width++) {
                        for (var height:int = hs; height < he; height++) {
                            var color:uint = bmd.getPixel(width, height);
                            if (color >= 0xffffff)
                                count++;
                        }
                    }

                    var total:int = (we - ws) * (he - hs);

                    if (count / total >= 0.05) {
                        var c:MosaicCircle = new MosaicCircle((ws + we) / 2, (hs + he) / 2, (we - ws) / 2 - 1);
                        points.push(c);
                    }

                }
            }

            return points;
        }
    }
}

class MosaicCircle
{
    private var _radius:Number;

    private var _x:Number;
    private var _y:Number;

    public function MosaicCircle(x:Number, y:Number, radius:Number)
    {
        _x = x;
        _y = y;
        _radius = radius;
    }

    public function get radius():Number
    {
        return _radius;
    }

    public function get x():Number
    {
        return _x;
    }

    public function get y():Number
    {
        return _y;
    }
}
