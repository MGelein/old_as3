package  trb1914.general
{
	/**
	 * ...
	 * @author Mees
	 */
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.display.MovieClip;
	 
	public class MovieLoader extends MovieClip
	{
		
		public function MovieLoader(mainDoc:DisplayObject)
		{
			mainDoc.loaderInfo.addEventListener(Event.COMPLETE, initApplication);
            mainDoc.loaderInfo.addEventListener(ProgressEvent.PROGRESS, showProgress);
		}
		
		private function showProgress(theProgress:ProgressEvent):void {
            var percent:Number = Math.round((theProgress.bytesLoaded / theProgress.bytesTotal )*100 );
            trace(percent + " %");
            //do your thing! :P
        }
		
		public function initApplication(myEvent:Event):void {
            trace("Loaded!");
        }
		
	}

}