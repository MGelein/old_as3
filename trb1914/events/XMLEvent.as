package trb1914.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author trb1914
	 */
	public class XMLEvent extends Event 
	{
		public static const COMPLETE:String = "complete";
		private var _xml:XML;
		public function XMLEvent(xml:XML, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(COMPLETE, bubbles, cancelable);
			_xml = xml;
		}
		/**
		 * contains the xml data that was loaded
		 */
		public function get xml():XML 
		{
			return _xml;
		}
		/**
		 * contains the xml data that was loaded
		 */
		public function set xml(value:XML):void 
		{
			_xml = value;
		}
	}

}