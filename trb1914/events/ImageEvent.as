package trb1914.events 
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author trb1914
	 */
	public class ImageEvent extends Event 
	{
		public static const COMPLETE:String = "complete";
		private var _image:Bitmap;
		public function ImageEvent(img:Bitmap, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(COMPLETE, bubbles, cancelable);
			_image = img;
		}
		/**
		 * contains the loaded image
		 */
		public function get image():Bitmap 
		{
			return _image;
		}
		/**
		 * contains the loaded image
		 */
		public function set image(value:Bitmap):void 
		{
			_image = value;
		}
		
	}

}