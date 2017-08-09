package trb1914.geom 
{
	/**
	 * a class with some basic functionality for math in it
	 * @author trb1914
	 */
	public class MathUtils 
	{
		//multiply an angle in radians by this number to get the angle in degrees
		public static const TO_DEGREES:Number = Math.PI / 180;
		//multiply an angle in degrees by this number to get the angle in radians
		public static const TO_RADIANS:Number = 180 / Math.PI;
		/**
		 * returns the angle in radians that an imaginary line would make
		 * if that would be drawn between the points
		 * @param	pt1		the first point
		 * @param	pt2		the second point
		 * @return
		 */
		public static function getAngle(pt1:xy2D, pt2:xy2D):Number
		{
			var dx:Number = pt2.x - pt1.x;
			var dy:Number = pt1.y - pt2.y;
			return Math.atan2(dy, dx);
		}		
		/**
		 * MathUtils can never be instantiated directly. It is an abstract class
		 * If you try to instantiate it, a fatal error will occur
		 */
		public function MathUtils():void
		{
			throw new Error("Math Utils can never be instantiated directly. It is an abstract class");
		}
	}
}