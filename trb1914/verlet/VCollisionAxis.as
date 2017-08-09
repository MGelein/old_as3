package trb1914.verlet 
{
	/**
	 * a class containing an axis with minimum movement, used for SAT
	 * @author Mees Gelein
	 */
	public class VCollisionAxis 
	{
		private var _dx:Number;
		private var _dy:Number;
		private var _length:Number;
		private var _angle:Number;
		/**
		 * creates a new collision axis, with a length and angle property
		 * @param	dx			the difference on the x-axis
		 * @param	dy			the difference on the y-axis
		 */
		public function VCollisionAxis(dx:Number, dy:Number) 
		{
			_dy = dy;
			_dx = dx;
			_length = Math.sqrt(_dx * _dx + _dy * _dy);
			_angle = Math.atan2(_dy, _dx);
		}
		/**
		 * the difference on the x-axis
		 */
		public function get dx():Number 
		{
			return _dx;
		}
		/**
		 * the difference on the x-axis
		 */
		public function set dx(value:Number):void 
		{
			_dx = value;
		}
		/**
		 * the difference on the y-axis
		 */
		public function get dy():Number 
		{
			return _dy;
		}
		/**
		 * the difference on the y-axis
		 */
		public function set dy(value:Number):void 
		{
			_dy = value;
		}
		/**
		 * the length of the axis, can be set. When set, it automatically changes 
		 * dx and dy to match the length and keep the old angle
		 */
		public function get length():Number 
		{
			return _length;
		}
		/**
		 * the length of the axis, can be set. When set, it automatically changes 
		 * dx and dy to match the length and keep the old angle
		 */
		public function set length(value:Number):void 
		{
			var ratio:Number = value / _length;
			_dx *= ratio;
			_dy *= ratio;
			_length = value;
		}
		/**
		 * the angle of the axis in radians. Can be changed but doesn't affect length
		 * dx or dy.
		 */
		public function get angle():Number 
		{
			return _angle;
		}
		/**
		 * the angle of the axis in radians. Can be changed but doesn't affect length
		 * dx or dy.
		 */
		public function set angle(value:Number):void 
		{
			_angle = value;
		}
		
	}

}