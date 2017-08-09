package trb1914.particleWorld 
{
	import flash.geom.Rectangle;
	/**
	 * A Lightweight alternative for Rectangle. Holding only data values. Contains no methods.
	 * @author trb1914
	 */
	public class ParticleBounds 
	{
		private var _x:int;
		private var _y:int;
		private var _h:int;
		private var _w:int;
		private var _l:int;
		private var _r:int;
		private var _b:int;
		private var _t:int;
		/**
		 * creates a bounds class. Replacing the Rectangle class with a lightweight alternative
		 * @param	x			the x-coordinate of the top left
		 * @param	y			the y-coordinate of the top left
		 * @param	height		the height of the rectangle
		 * @param	width		the width of the rectangle
		 */
		public function ParticleBounds(x:int, y:int, width:int, height:int) 
		{
			_x = x; _y = y; _h = height; _w = width;
			_l = _x; _r = _l + _w; _t = _y; _b = _t + _h;
			
		}
		/**
		 * Returns a Rectangle instance
		 * @return
		 */
		public function getRect():Rectangle 
		{
			return new Rectangle(_x, _y, _w, _h);
		}
		/**
		 * sets/gets x
		 */
		public function get x():int 
		{
			return _x;
		}
		/**
		 * sets/gets x
		 */
		public function set x(value:int):void 
		{
			_x = value;
		}
		/**
		 * sets/gets y
		 */
		public function get y():int 
		{
			return _y;
		}
		/**
		 * sets/gets y
		 */
		public function set y(value:int):void 
		{
			_y = value;
		}
		/**
		 * sets/gets height
		 */
		public function get h():int 
		{
			return _h;
		}
		/**
		 * sets/gets height
		 */
		public function set h(value:int):void 
		{
			_h = value;
			_b = _t + _h;
		}
		/**
		 * sets/gets width
		 */
		public function get w():int 
		{
			return _w;
		}
		/**
		 * sets/gets width
		 */
		public function set w(value:int):void 
		{
			_w = value;
			_r = _l + _w;
		}
		/**
		 * sets/gets left
		 */
		public function get l():int 
		{
			return _l;
		}
		/**
		 * sets/gets left
		 */
		public function set l(value:int):void 
		{
			_l = value;
		}
		/**
		 * sets/gets right
		 */
		public function get r():int 
		{
			return _r;
		}
		/**
		 * sets/gets right
		 */
		public function set r(value:int):void 
		{
			_r = value;
		}
		/**
		 * sets/gets bottom
		 */
		public function get b():int 
		{
			return _b;
		}
		/**
		 * sets/gets bottom
		 */
		public function set b(value:int):void 
		{
			_b = value;
		}
		/**
		 * sets/gets top
		 */
		public function get t():int 
		{
			return _t;
		}
		/**
		 * sets/gets top
		 */
		public function set t(value:int):void 
		{
			_t = value;
		}
		
	}

}