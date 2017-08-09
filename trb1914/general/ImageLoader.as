package trb1914.general 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import trb1914.events.ImageEvent;
	
	/**
	 * ...
	 * @author trb1914
	 */
	public class ImageLoader extends EventDispatcher 
	{
		private var _url:String;
		private var _img:Bitmap;
		private var _l:Loader;
		private var _total:int;
		private var _percentLoaded:int = 0;
		private var _x:Number;
		private var _y:Number;
		private var _a:Number;
		/**
		 * creates a new instance of ImageLoader and 
		 * tries to load the image specified by the url
		 * @param	url			the url of the image
		 * @param	x			the x-coordinate of the image when it is loaded
		 * @param	y			the y-coordinate of the image when it is loaded
		 * @param	alpha		the alpha value of the image when it is loaded
		 */
		public function ImageLoader(url:String, x:Number = 0, y:Number = 0, alpha:Number = 1) 
		{
			_x = x; _y = y; _a = alpha;
			_url = url;
			_l = new Loader();
			_l.load(new URLRequest(url));
			_l.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_l.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_total = _l.contentLoaderInfo.bytesTotal;
		}
		
		private function onProgress(e:ProgressEvent):void 
		{
			_percentLoaded = (e.bytesLoaded / _total) * 100;
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			throw new Error("the specified file could not be found: " + _url);
		}
		
		private function onComplete(e:Event):void 
		{
			_img = Bitmap(_l.content);
			_img.x = _x; _img.y = _y; _img.alpha = _a;
			dispatchEvent(new ImageEvent(img));
		}
		/**
		 * contains the loaded image after the 
		 * loading is done.
		 */
		public function get img():Bitmap 
		{
			return _img;
		}
		/**
		 * contains the loaded image after the 
		 * loading is done.
		 */
		public function set img(value:Bitmap):void 
		{
			_img = value;
		}
		/**
		 * the percentage of the image that's loaded
		 */
		public function get percentLoaded():int 
		{
			return _percentLoaded;
		}
		/**
		 * the percentage of the image that's loaded
		 */
		public function set percentLoaded(value:int):void 
		{
			_percentLoaded = value;
		}
		
	}

}