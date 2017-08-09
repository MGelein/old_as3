package trb1914.general 
{
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Mees Gelein
	 */
	public class StopWatch 
	{
		private static var startTime:int;
		private static var recTime:int;
		/**
		 * starts the stopwatch timer
		 */
		public static function start():void 
		{ 
			startTime = getTimer();
		}
		/**
		 * stops the stopwatch timer and saves the 
		 * recorded time
		 */
		public static function stop():void
		{ 
			recTime = getTimer() - startTime;
		}
		/**
		 * returns the last interval start and stop were called
		 * @return		the amount of miliseconds in a string
		 */
		public static function recordedTime():String 
		{ 
			var message:String = recTime.toString() + " ms";
			return message;
		}
	}

}