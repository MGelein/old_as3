package trb1914.verlet 
{
	import flash.geom.Rectangle;
	/**
	 * a class containing a verlet point, which is essentially a ball with 
	 * a radius of 0
	 * @author Mees Gelein
	 */
	public class VPoint extends VObject 
	{
		private var _radius:Number = 0;
		private var _ox:Number;
		private var _oy:Number;
		private var PI_TIMES_RADIUS:Number = 0;
		
		public function VPoint(x:Number, y:Number) 
		{
			super(x, y, VObject.CIRCLE);
			setPos(x, y);
		}
		/**
		 * override of update function, takes care of moving this obj,
		 * Note: a VPoint has no gravity, because it has no mass, and 
		 * it can't collide with other points
		 */
		override public function update():void 
		{
			var tx:Number = x + (x - _ox) * world.friction;
			var ty:Number = y + (y - _oy) * world.friction;
			_ox = x;
			_oy = y;
			x = tx;
			y = ty;
			rotation += (vx / (PI_TIMES_RADIUS)) * 360;
			super.update();
		}
		/**
		 * sets the position of the current point and erases all previous forces
		 * @param	x			the x-coordinate the obj moves to
		 * @param	y			the y-coordinate the obj moves to
		 */
		public function setPos(x:Number, y:Number):void 
		{
			this.x = _ox = x;
			this.y = _oy = y;
		}
		/**
		 * keeps the point in this rectangle, with the radius considered
		 * @param	rect		the rect to keep it in
		 */
		override public function constrain(rect:Rectangle):void
		{
			if (x > rect.right - _radius) {
				x = rect.right - _radius;
				_ox = x - (x - _ox) * world.bounce;
			}else if (x < rect.left + _radius) {
				x = rect.left + _radius;
				_ox = x - (x - _ox) * world.bounce;
			}
			if (y > rect.bottom - _radius) {
				y = rect.bottom - _radius;
				_oy = y - (y - _oy) * world.bounce;
			}else if (y < rect.top + _radius) {
				y = rect.top + _radius;
				_oy = y - (y - _oy) * world.bounce;
			}
		}
		/**
		 * doesn't really exist, but useful for other stuff
		 */
		public function get vx():Number
		{
			return x - _ox;
		}
		/**
		 * the previous x-coordinate of this VPoint
		 */
		public function get ox():Number 
		{
			return _ox;
		}		
		public function set ox(value:Number):void 
		{
			_ox = value;
		}
		/**
		 * the previous y-coordinate of this VPoint
		 */
		public function get oy():Number 
		{
			return _oy;
		}		
		public function set oy(value:Number):void 
		{
			_oy = value;
		}
		/**
		 * the radius of the point, measured in pixels.
		 */
		public function get radius():Number 
		{
			return _radius;
		}		
		public function set radius(value:Number):void 
		{
			_radius = value;
			PI_TIMES_RADIUS = Math.PI * _radius;
		}
		
	}

}