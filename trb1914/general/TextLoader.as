package trb1914.general 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * a class that loads textfiles
	 * @author Mees Gelein
	 */
	public class TextLoader 
	{
		static private var _loader:URLLoader;
		static private var _totalBytes:int;
		static private var _url:String;
		static private var _toCall:Function;
		static private var _text:String = "";
		static private var _progress:Function;
		static private var _onError:Function;
		/**
		 * loads a textfile and fires the optional onCompletion function when it is done loading
		 * @param	url						the url of the file
		 * @param   onIOError				the error handler
		 * @param	onCompletion			the optional onComplete function
		 * @param 	onProgression			the optional onProgress function, a function with.
		 */
		static public function load(url:String, onIOError:Function, onCompletion:Function = null, onProgression:Function = null):void
		{
			var urlRequest:URLRequest = new URLRequest(url);
			_url = url;
			_onError = onIOError;
			_progress = onProgression;
			_toCall = onCompletion;
			_loader = new URLLoader();
			_loader.load(urlRequest);
			_loader.addEventListener(Event.COMPLETE, onComplete);
			_loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		static private function onError(e:IOErrorEvent):void 
		{
			_onError();
		}
		
		static private function onProgress(e:ProgressEvent):void 
		{
			var percent:int = (e.bytesLoaded / e.bytesTotal) * 100;
			//trace(_url + " :: " + percent + " percent loaded");
			if (_progress != null)_progress(percent);
		}
		
		static private function onComplete(e:Event):void 
		{
			_text = _loader.data;
			_toCall();
		}
		/**
		 * the complete text in the text file, if nothing is loaded the string is empty
		 */
		static public function get text():String 
		{
			return _text;
		}
		/**
		 * returns an array of lines, with each line being on a individual index
		 * @return
		 */
		static public function parseLines():Array
		{
			return _text.split("\n");		
		}
	}

}