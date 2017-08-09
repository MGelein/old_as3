package trb1914.general 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import trb1914.events.XMLEvent;
	/**
	 * a simple class to load xml files
	 * @author trb1914
	 */
	public class XMLReader extends EventDispatcher
	{
		/**
		 * creates a new xml reader instance
		 * @param	url		the url of the xml file
		 */
		private var _url:String;
		private var _xml:XML;
		public function XMLReader(url:String) 
		{
			_url = url;
			var l:URLLoader = new URLLoader();
			l.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			l.addEventListener(Event.COMPLETE, onComplete);
			l.load(new URLRequest(url));
		}
		
		private function onComplete(e:Event):void 
		{
			_xml = new XML(e.target.data);
			dispatchEvent(new XMLEvent(_xml));
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			throw new Error("The specified file could not be found: " + _url);			
		}
		/**
		 * contains the loaded xml file when loading is done
		 */
		public function get xml():XML 
		{
			return _xml;
		}
		/**
		 * contains the loaded xml file when loading is done
		 */
		public function set xml(value:XML):void 
		{
			_xml = value;
		}
		
	}

}