package trb1914.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author trb1914
	 */
	public class FileCheckEvent extends Event 
	{
		public static const COMPLETE:String = "complete";
		private var _fileExists:Boolean;
		public function FileCheckEvent(exists:Boolean, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(COMPLETE, bubbles, cancelable);
			_fileExists = exists;
		}
		/**
		 * contains a boolean based on the existance of the file
		 */
		public function get fileExists():Boolean 
		{
			return _fileExists;
		}
		/**
		 * contains a boolean based on the existance of the file
		 */
		public function set fileExists(value:Boolean):void 
		{
			_fileExists = value;
		}
		
	}

}