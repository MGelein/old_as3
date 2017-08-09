package trb1914.general 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import trb1914.events.FileCheckEvent;
	/**
	 * ...
	 * @author trb1914
	 */
	public class FileChecker extends EventDispatcher
	{
		private var uStream:URLStream;
		private var _exists:Boolean;
		/**
		 * checks if the file at the specified url exists.
		 * The function returns a boolean based on the result.
		 * true means it exists. false means it doesn't.
		 * @param	url		the url of the file to check
		 * @return
		 */
		public function FileChecker(url:String)
		{
			uStream = new URLStream();
			uStream.addEventListener(Event.OPEN, handler);
			uStream.addEventListener(IOErrorEvent.IO_ERROR, handler);
			uStream.load(new URLRequest(url));
		}
		
		private function handler(e:Event):void 
		{
			uStream.close();
			_exists = (e.type == Event.OPEN);
			dispatchEvent(new FileCheckEvent(_exists));
		}
		/**
		 * contains a boolean based on the existance of the file
		 */
		public function get exists():Boolean 
		{
			return _exists;
		}
		/**
		 * contains a boolean based on the existance of the file
		 */
		public function set exists(value:Boolean):void 
		{
			_exists = value;
		}
	}

}