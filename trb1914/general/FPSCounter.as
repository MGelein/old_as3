package trb1914.general
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.utils.getTimer;

    public class FPSCounter extends Sprite
	{
        private var last:uint = getTimer();
        private var ticks:uint = 0;
        private var tf:TextField;
		private var fps:Number = 0;
		/**
		 * creates a new FPSCounter instance. Call update every frame, or 
		 * give it an Enterframe listener by calling the autoUpdate() method
		 * @param	xPos			the x-coordinate of the topleft of the textfield
		 * @param	yPos			the y-coordinate of the topleft of the textfield
		 * @param	color			the color of the text in the textfield
		 * @param	fillBackground	should the background be filled with a solid color
		 * @param	backgroundColor	the fill color of the background
		 */
        public function FPSCounter(xPos:int=0, yPos:int=0, color:uint=0xffffff, fillBackground:Boolean=false, backgroundColor:uint=0x000000) {
            x = xPos;
            y = yPos;
            tf = new TextField();
            tf.textColor = color;
			tf.multiline = true;
            tf.text = "----- fps";
            tf.selectable = false;
            tf.background = fillBackground;
            tf.backgroundColor = backgroundColor;
            tf.autoSize = TextFieldAutoSize.LEFT;
            addChild(tf);
            width = tf.textWidth;
            height = tf.textHeight;
        }
		/**
		 * call this method with the default parameter true, to start 
		 * an auto update process. To stop the process, call this method
		 * with the parameter false
		 */
		public function autoUpdate(value:Boolean = true):void
		{
			if (value) {
				if (!hasEventListener(Event.ENTER_FRAME)) addEventListener(Event.ENTER_FRAME, EF);
			}else {
				removeEventListener(Event.ENTER_FRAME, EF);
			}
		}
		/**
		 * called internally to auto update the fpsCounter
		 * @param	e
		 */
		private function EF(e:Event):void 
		{
			update();
		}
		/**
		 * should be called every frame. FPS counter times between all the frames
		 * and averages.
		 */
        public function update():void {
            ticks++;
            var now:uint = getTimer();
            var delta:uint = now - last;
			tf.text = fps.toFixed(1) + " fps";
            if (delta >= 1000) {
                fps = ticks / delta * 1000;
                tf.text = fps.toFixed(1) + " fps";
                ticks = 0;
                last = now;
            }
        }
		/**
		 * used to add more info to the fps textfield
		 */
		public function addLine(text:String):void
		{
			tf.appendText("\n" + text);
		}
    }
}