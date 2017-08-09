package trb1914.geom 
{
	/**
	 * a class with just two coordinates and some properties
	 * @author trb1914
	 */
	public class xy2D 
	{
		private var _x:Number;
		private var _y:Number;
		private var _length:Number;
		private var _angle:Number;
		/**
		 * creates a new x,y coordinate in 2D space with the given parameters
		 * @param	x		the x-coord
		 * @param	y		the y-coord
		 */
		public function xy2D(x:Number = 0, y:Number = 0) 
		{
			_x = x; _y = y;
			_length = getLength();
			_angle = getAngle();
		}
		/**
		 * used internally to match length and angle after changing any
		 * component of the vector
		 */
		private function recalculate():void 
		{
			_length = getLength();
			_angle = getAngle();
		}
		/**
		 * used internally to grab the angle when needs to be changed
		 * @return
		 */
		private function getAngle():Number
		{
			return Math.atan2(_y, _x);
		}
		/**
		 * used internally to grab the length when needs to be changed
		 * @return
		 */
		private function getLength():Number
		{
			return Math.sqrt(_x * _x + _y * _y);
		}
		/**
		 * sets the length of the vector to 1. A process called normalizing.
		 * Though you can also specify another length
		 * @param	length		the lenght to make the new vector
		 */
		public function normalize(length:Number = 1):void
		{
			this.length = length;
		}
		/**
		 * adds the specified xy2D instance to this one.
		 * @param	toAdd		the xy2D to add
		 */
		public function add(toAdd:xy2D):void
		{
			_x += toAdd.x;
			_y += toAdd.y;
		}
		/**
		 * substracts the specified xy2D instance from this one.
		 * @param	toAdd		the xy2D to substract
		 */
		public function substr(toSubstr:xy2D):void
		{
			_x -= toSubstr.x;
			_y -= toSubstr.y;
		}
		/**
		 * multiplies both the x and the y coordinate with
		 * the specified number
		 * @param	num		the number to multiply by
		 */
		public function multiply(num:Number):void
		{
			_x *= num;
			_y *= num;
		}
		/**
		 * returns a new xy2D instance with the exact same
		 * length and coords.
		 * @return		the cloned xy2D instance
		 */
		public function clone():xy2D
		{
			return new xy2D(_x, _y);
		}
		/**
		 * divides both the x and the y coordinate by
		 * the specified number
		 * @param	num		the number to divide by
		 */
		public function divide(num:Number):void
		{
			_x /= num;
			_y /= num;
		}
		
		//////////////////////////
		//	GETTERS AND SETTERS	//
		//////////////////////////
		
		/**
		 * the x part of the vector
		 */
		public function get x():Number 
		{
			return _x;
		}
		/**
		 * the x part of the vector
		 */
		public function set x(value:Number):void 
		{
			_x = value;
			recalculate();
		}
		/**
		 * the y part of the vector
		 */
		public function get y():Number 
		{
			return _y;
		}
		/**
		 * the y part of the vector
		 */
		public function set y(value:Number):void 
		{
			_y = value;
			recalculate();
		}		
		/**
		 * the length of the vector
		 */
		public function set length(value:Number):void
		{
			var ratio:Number = value / _length;
			_x *= ratio;
			_y *= ratio;
			_length = value;
		}
		/**
		 * the length of the vector
		 */
		public function get length():Number
		{
			return _length;
		}
		/**
		 * the angle of the vector, measured in radians
		 */
		public function get angle():Number 
		{
			return _angle;
		}
		/**
		 * the angle of the vector, measured in radians
		 */
		public function set angle(value:Number):void 
		{
			var l:Number = _length;
			_x = Math.cos(value) * l;
			_y = Math.sin(value) * l;
			_angle = value;
			recalculate();
		}
		
	}

}