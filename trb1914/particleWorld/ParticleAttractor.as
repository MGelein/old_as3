package trb1914.particleWorld 
{
	/**
	 * a class containing an attractor
	 * @author Mees Gelein
	 */
	public class ParticleAttractor
	{
		private var _x:Number;
		private var _y:Number;
		private var _strength:Number;
		private var _next:ParticleAttractor = null;
		private var _last:ParticleAttractor = null;
		/**
		 * creates a new instance of the ParticleAttractor class
		 * @param	x				the x position on-screen
		 * @param	y				the y position on-screen
		 * @param	strength		the strenght of the attractor, think of this as a
		 * 							spring constant. Usually a number below 1 and above 0
		 */
		public function ParticleAttractor(x:Number,y:Number,strength:Number = .4) 
		{
			_strength = strength;
			_y = y / PixelWorld.zoom;
			_x = x / PixelWorld.zoom;
		}
		/**
		 * sets the attractor to follow the mouse. 
		 * If set to false, the attractor will stop following the mouse 
		 * @param	value		the boolean flag
		 */
		public function setFollowMouse(value:Boolean = true):void
		{
			if (value) PixelWorld.followAttractor = this;
			else {
				if (PixelWorld.followAttractor == this) {
					PixelWorld.followAttractor = null;
				}
			}
		}
		/**
		 * returns the attractor in a saveable format, in a string
		 * @return		the save format
		 */
		public function getSaveFormat():String
		{
			return String("a:" + x * PixelWorld.zoom + ":" + y * PixelWorld.zoom + ":" + _strength + "\n");
		}
		/**
		 * makes a Attractor from a attractor saved format
		 * @param	frmt			the format
		 * @return		the attractor that is made
		 */
		public static function getAttractorFromFormat(frmt:String):ParticleAttractor
		{
			var i:int = 0;
			i++;
			var lines:Array = frmt.split(":");
			var tx:int = parseInt(lines[i++] as String);
			var ty:int = parseInt(lines[i++] as String);
			var str:Number = parseFloat(lines[i++] as String);
			return new ParticleAttractor(tx, ty, str);			
		}
		
		/////////////////////////////////
		//	GETTERS AND SETTERS
		/////////////////////////////////	
		
		/**
		 * the x-coordinate in the world. Be careful when setting this. 
		 * The zoom amount in the world determines the actual on screen position.
		 * For example: if you want the source to be on screen at x=100 pixels
		 * and the world zoom is 2. You need to set this to 50;
		 */
		public function get x():Number 
		{
			return _x;
		}
		/**
		 * the x-coordinate in the world. Be careful when setting this. 
		 * The zoom amount in the world determines the actual on screen position.
		 * For example: if you want the source to be on screen at x=100 pixels
		 * and the world zoom is 2. You need to set this to 50;
		 */
		public function set x(value:Number):void 
		{
			_x = value;
		}
		/**
		 * the y-coordinate in the world. Be careful when setting this. 
		 * The zoom amount in the world determines the actual on screen position.
		 * For example: if you want the source to be on screen at y=100 pixels
		 * and the world zoom is 2. You need to set this to 50;
		 */
		public function get y():Number 
		{
			return _y;
		}
		/**
		 * the y-coordinate in the world. Be careful when setting this. 
		 * The zoom amount in the world determines the actual on screen position.
		 * For example: if you want the source to be on screen at y=100 pixels
		 * and the world zoom is 2. You need to set this to 50;
		 */
		public function set y(value:Number):void 
		{
			_y = value;
		}
		/**
		 * determines the power of the source. Think of this as a spring constant.
		 * Usually a number between 0 and 1.
		 */
		public function get strength():Number 
		{
			return _strength;
		}
		/**
		 * determines the power of the source. Think of this as a spring constant.
		 * Usually a number between 0 and 1.
		 */
		public function set strength(value:Number):void 
		{
			_strength = value;
		}
		/**
		 * the next particleAttractor in the linked list.
		 * If this is null, that indicates the end of the list
		 */
		internal function get next():ParticleAttractor 
		{
			return _next;
		}
		/**
		 * the next particleAttractor in the linked list.
		 * If this is null, that indicates the end of the list
		 */
		internal function set next(value:ParticleAttractor):void 
		{
			_next = value;
		}
		/**
		 * the last particleAttractor in the linked list.
		 * If this is null, that indicates the end of the list
		 */
		internal function get last():ParticleAttractor 
		{
			return _last;
		}
		/**
		 * the last particleAttractor in the linked list.
		 * If this is null, that indicates the end of the list
		 */
		internal function set last(value:ParticleAttractor):void 
		{
			_last = value;
		}
		
	}

}